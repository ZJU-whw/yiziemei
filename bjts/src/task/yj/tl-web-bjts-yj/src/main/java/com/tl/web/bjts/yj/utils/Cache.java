package com.tl.web.bjts.yj.utils;

import com.google.common.cache.CacheBuilder;
import com.tl.redis.redis.RedisCacheManager;
import com.tl.web.bjts.yj.conf.MyAppConfig;


import java.util.concurrent.TimeUnit;

/**
 * 说明：缓存工具类 可根据条件配置使用本地缓存或分布式缓存
 * 作者：王兆阳
 * 日期：2017-08-18
 **/

public class Cache {

    private static String LOCALMODE ="local";
    private static String REDISMODE = "redis";

    private static Cache cache = null ;

    private static Object obj = new Object();

    //存储模式 默认使用本地缓存
    private static String mode = LOCALMODE;
    //本地缓存 用于存储身份令牌
    private com.google.common.cache.Cache localCache = null;

    //分布式缓存
    private   org.apache.shiro.cache.Cache<String,Object> redisCache;

    private Cache(){
        mode = MyAppConfig.tokenMode;
        if (LOCALMODE.equals(mode)){//本地模式
            localCache = CacheBuilder.newBuilder().
                    expireAfterWrite(MyAppConfig.cacheTimeOut, TimeUnit.MINUTES).
                    maximumSize(10000).
                    build();
        }else{
            redisCache =  RedisCacheManager.intance().getCache("cache",MyAppConfig.cacheTimeOut*60);
        }
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
        if (LOCALMODE.equals(mode)){//本地模式
            localCache.put(key,value);
        }else{
            redisCache.put(key,value);
        }
    }

    public Object get(String key){
        if (LOCALMODE.equals(mode)){//本地模式
            return localCache.getIfPresent(key);
        }else{
            return redisCache.get(key);
        }
    }

    public void remove(String key){

        if (LOCALMODE.equals(mode)){//本地模式
            localCache.invalidate(key);
        }else{
            redisCache.remove(key);
        }
    }
}
