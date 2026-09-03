package com.tl.bjts.sw.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

/**
 * @description: InvoiceQueryTaskService：获取订单待查询发票的任务 <br>
 * @date: 2020-04-27 8:58 <br>
 * @author: 王兆阳 <br>
 **/
@Service
public class RedisDelayService {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /**
     * 消息前缀,防止与其他类型的消息存入redis时冲突
     */
    private static final String PRE_MESSAGE = "DEALY:";


    @Autowired
    StringRedisTemplate redisTemplate;


    /**
     * 将value值放入缓存,设置默认时长为24小时
     * @param key
     * @param value
     */
    public void putKeyValue(String key,String value){
        redisTemplate.opsForValue().set(key,value,24,TimeUnit.HOURS);
    }

    /**
     * 从Redis中根据Key获取缓存
     * @param key
     */
    public String  getValueByKey(String key){
        return redisTemplate.opsForValue().get(key);
    }

    /**
     * 从Redis中移除缓存
     * @param key
     */
    public void removeValueByKey(String key){
        redisTemplate.delete(key);
    }
}
