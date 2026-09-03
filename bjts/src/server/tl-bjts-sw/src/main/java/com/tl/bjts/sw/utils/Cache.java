package com.tl.bjts.sw.utils;

import com.google.common.cache.CacheBuilder;

import java.util.concurrent.TimeUnit;



public class Cache {

    private static String LOCALMODE ="local";

    private static Cache cache = null ;

    private static Object obj = new Object();

    //存储模式 默认使用本地缓存
    private static String mode = LOCALMODE;
    //本地缓存 用于存储身份令牌
    private com.google.common.cache.Cache localCache = null;

    private Cache(){
        localCache = CacheBuilder.newBuilder().
                expireAfterWrite(30, TimeUnit.MINUTES).
                maximumSize(10000).
                build();
    }

    public static Cache instance(){
        if(cache == null){
            synchronized (obj){
                if (cache == null){
                    cache = new Cache();
                }
            }
        }
        return cache;
    }

    public void put(String key,Object value){

        localCache.put(key,value);

    }

    public Object get(String key){

        return localCache.getIfPresent(key);

    }

    public void remove(String key){
        localCache.invalidate(key);
    }
}
