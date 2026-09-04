package com.tl.web.bjts.shzs.service;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Component
public class RedisLock {

    private static final Logger logger = LoggerFactory.getLogger(RedisLock.class);

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    private final String REDIS_LOCK = "zt:yj:lock:";
    private final ThreadLocal<Map<String, String>> threadLocal = new ThreadLocal<>();

    /**
     * 加锁
     * @param key 锁key
     * @param expireTime 超时时间，单位秒
     * @return true-加锁成功，false-加锁失败
     */
    public boolean lock(String key, Long expireTime) {
        try {
            logger.info("锁定标志->{}", key);
            key = REDIS_LOCK + key;
            String uuid = UUID.randomUUID().toString();

            // Spring Boot 1.x 写法：使用 Lua 脚本保证 SET NX EX 原子性
            String script = "if redis.call('SET', KEYS[1], ARGV[1], 'NX', 'EX', ARGV[2]) " +
                    "then return 1 " +
                    "else return 0 end";
            DefaultRedisScript<Long> redisScript = new DefaultRedisScript<>(script, Long.class);
            Long result = stringRedisTemplate.execute(
                    redisScript,
                    Collections.singletonList(key),
                    uuid,
                    String.valueOf(expireTime)
            );

            if (result != null && result == 1) {
                // 防止非当前线程解锁线程锁
                Map<String, String> map = threadLocal.get();
                if (map == null) {
                    map = new HashMap<>();
                    threadLocal.set(map);
                }
                map.put(key, uuid);
                logger.info("锁定成功->{}", key);
                return true;
            } else {
                logger.info("锁定失败->{}", key);
                return false;
            }
        } catch (Exception e) {
            logger.error("redisLock -> lock:fail, key:{} errStr:{}", key, e.getMessage(), e);
        }
        return false;
    }

    /**
     * 解锁
     * @param key
     */
    public void unlock(String key) {
        key = REDIS_LOCK + key;
        try {
            // 从 ThreadLocal 获取当前线程持有的 UUID
            Map<String, String> map = threadLocal.get();
            if (map == null) {
                logger.warn("解锁失败，ThreadLocal中无锁信息->{}", key);
                return;
            }
            String uuid = map.get(key);
            if (StringUtils.isBlank(uuid)) {
                logger.warn("解锁失败，未找到对应的UUID->{}", key);
                return;
            }

            // 使用 Lua 脚本保证 get + delete 原子性
            String script = "if redis.call('get', KEYS[1]) == ARGV[1] " +
                    "then return redis.call('del', KEYS[1]) " +
                    "else return 0 end";
            DefaultRedisScript<Long> redisScript = new DefaultRedisScript<>(script, Long.class);
            Long result = stringRedisTemplate.execute(redisScript, Collections.singletonList(key), uuid);

            if (result != null && result == 1) {
                logger.info("解锁成功->{}", key);
            } else {
                logger.warn("解锁失败，锁已被他人持有或已过期->{}", key);
            }

            // 清理 ThreadLocal
            map.remove(key);
        } catch (Exception e) {
            logger.error("redisLock -> unlock:fail, key:{} errStr:{}", key, e.getMessage(), e);
        }
    }
}