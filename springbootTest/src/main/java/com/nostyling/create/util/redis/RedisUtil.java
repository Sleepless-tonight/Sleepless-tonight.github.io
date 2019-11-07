package com.nostyling.create.util.redis;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.HashOperations;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.concurrent.TimeUnit;

/**
 * @author shili
 * @ outhor: by com.nostyling.create.util
 * @date 2018/8/30 1:32
 * @ 类的描述： 本类 用于升级 Jedis 方法到 RedisTemplate 方法
 * redisTemplate.opsForValue();//操作字符串
 * <p>
 * redisTemplate.opsForHash();//操作hash
 * <p>
 * redisTemplate.opsForList();//操作list
 * <p>
 * redisTemplate.opsForSet();//操作set
 * <p>
 * redisTemplate.opsForZSet();//操作有序set
 */
@Component
public class RedisUtil {

    @Autowired
    private RedisTemplate redisTemplate;
    //@Autowired
    //private JedisClient jedisClient;
    /**
     * Redis info
     * @return
     */
    public Properties info() {

        return redisTemplate.getConnectionFactory().getConnection().info();

    }

    /**
     * multi
     *
     */
    private void multi() {
         redisTemplate.multi();
    }

    /**
     * exec
     *
     */
    private void exec() {
         redisTemplate.exec();
    }

    /**
     * 写入缓存
     *
     * @param key
     * @param value
     * @return
     */
    public boolean set(final String key, Object value) {
        boolean result = false;
        try {
            ValueOperations <Serializable, Object> operations = redisTemplate.opsForValue();
            operations.set(key, value);
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }


    /**
     * 写入缓存
     *
     * @param key
     * @param value
     * @return
     */
    public boolean set(byte[] key, Object value) {
        boolean result = false;
        try {
            ValueOperations <Serializable, Object> operations = redisTemplate.opsForValue();
            operations.set(key, value);
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 写入缓存设置时效时间
     *
     * @param key
     * @param value
     * @return
     */
    public boolean set(final String key, Object value, Long expireTime) {
        boolean result = false;
        try {
            ValueOperations <Serializable, Object> operations = redisTemplate.opsForValue();
            operations.set(key, value);
            redisTemplate.expire(key, expireTime, TimeUnit.SECONDS);
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }


    /**
     * 设置时效时间
     *
     * @param key
     * @return
     */
    public boolean expire(final String key, Long expireTime) {
        boolean result = false;
        try {
            ValueOperations <Serializable, Object> operations = redisTemplate.opsForValue();
            redisTemplate.expire(key, expireTime, TimeUnit.SECONDS);
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 设置时效时间
     *
     * @param key
     * @return
     */
    public boolean persist(final String key) {
        boolean result = false;
        try {
            ValueOperations <Serializable, Object> operations = redisTemplate.opsForValue();
            redisTemplate.persist(key);
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 批量删除对应的 value
     *
     * @param values
     */
    public void del(final String... values) {
        for (String value : values) {
            del(value);
        }
    }

    /**
     * 批量删除key
     *
     * @param pattern
     */
    public void removePattern(final String pattern) {
        Set <Serializable> keys = redisTemplate.keys(pattern);
        if (keys.size() > 0) {
            redisTemplate.delete(keys);
        }
    }

    /**
     * 删除对应的 value
     *
     * @param value
     */
    public void del(final String value) {
        if (exists(value)) {
            redisTemplate.delete(value);
        }
    }


    /**
     * 判断缓存中是否有对应的value
     *
     * @param key
     * @return
     */
    public boolean exists(final String key) {
        return redisTemplate.hasKey(key);
    }

    /**
     * 读取缓存
     *
     * @param key
     * @return
     */
    public Object get(final Object key) {
        Object result = null;
        ValueOperations <Serializable, Object> operations = redisTemplate.opsForValue();
        result = operations.get(key);
        return result;
    }

    /**
     * 读取缓存
     *
     * @param key
     * @return
     */
    public byte[] get(final byte[] key) {
        byte[] result = null;
        ValueOperations <Serializable, byte[]> operations = redisTemplate.opsForValue();
        result = operations.get(key);
        return result;
    }

    /**
     * setnx
     *
     * @param key
     * @return
     */
    public Boolean setnx(Object key, Object v, long timeout, TimeUnit unit) {
        Boolean result = false;
        ValueOperations <Object, Object> operations = redisTemplate.opsForValue();
        //result = operations.setIfAbsent(key, v, timeout, unit);
        result = operations.setIfAbsent(key, v);
        redisTemplate.expire(key, timeout, unit);

        return result;
    }

    /**
     * 哈希 添加 Map
     *
     * @param key
     * @param value
     */
    public void hmset(String key, Map value) {
        HashOperations <String, Object, Object> hash = redisTemplate.opsForHash();
        hash.putAll(key, value);
    }

    /**
     * 哈希 添加
     *
     * @param key
     * @param hashKey
     * @param value
     */
    public void hset(String key, Object hashKey, Object value) {
        HashOperations <String, Object, Object> hash = redisTemplate.opsForHash();
        hash.put(key, hashKey, value);
    }

    /**
     * 哈希获取数据
     *
     * @param key
     * @param hashKey
     * @return
     */
    public Object hget(String key, Object hashKey) {
        HashOperations <String, Object, Object> hash = redisTemplate.opsForHash();
        return hash.get(key, hashKey);
    }
    /**
     * 哈希获取数据
     *
     * @param key
     * @return
     */
    public Map hgetAll(String key) {
        HashOperations <String, Object, Object> hash = redisTemplate.opsForHash();
        return hash.entries(key);
    }

    /**
     * 哈希获取 value
     *
     * @param key
     * @return
     */
    public List hvals(String key) {
        HashOperations <String, Object, Object> hash = redisTemplate.opsForHash();
        return hash.values(key);
    }

    /**
     * 哈希获取 value
     *
     * @param key
     * @return
     */
    public Set keys(String key) {
        HashOperations <String, Object, Object> hash = redisTemplate.opsForHash();
        return hash.keys(key);
    }

    /**
     * 列表添加 Right
     *
     * @param k
     * @param v
     */
    public void rPush(String k, Object v) {
        ListOperations <String, Object> list = redisTemplate.opsForList();
        list.rightPush(k, v);
    }

    /**
     * 列表添加 Left
     *
     * @param k
     * @param v
     */
    public void lpush(String k, Object v) {
        ListOperations <String, Object> list = redisTemplate.opsForList();
        list.leftPush(k, v);
    }

    /**
     * 列表获取
     *
     * @param k
     * @param l
     * @param l1
     * @return
     */
    public List lrange(String k, long l, long l1) {
        ListOperations <String, Object> list = redisTemplate.opsForList();
        return list.range(k, l, l1);
    }

    /**
     * 列表删除
     *
     * @param k
     * @param count count > 0：删除等于value从头到尾移动的元素。
     *              count < 0：删除等于value从尾部移动到头部的元素。
     *              count = 0：删除所有等于的元素value。
     * @param v
     * @return
     */
    public Long lrem(String k, long count, Object v) {
        ListOperations <String, Object> list = redisTemplate.opsForList();
        return list.remove(k, count, v);
    }

    /**
     * Get the size of list stored at {@code key}.
     *
     * @param k
     * @return
     */
    public Long llen(String k) {
        ListOperations <String, Object> list = redisTemplate.opsForList();
        return list.size(k);
    }

    /**
     * 集合添加
     *
     * @param key
     * @param value
     */
    public void sadd(String key, Object value) {
        SetOperations <String, Object> set = redisTemplate.opsForSet();
        set.add(key, value);
    }

    /**
     * 集合获取
     *
     * @param key
     * @return
     */
    public Long srem(String key, Object... values) {
        SetOperations <String, Object> set = redisTemplate.opsForSet();
        return set.remove(key, values);
    }

    /**
     * 集合获取
     *
     * @param key
     * @return
     */
    public Set smembers(String key) {
        SetOperations <String, Object> set = redisTemplate.opsForSet();
        return set.members(key);
    }
    /**
     * scard
     *
     * @param key
     * @return
     */
    public Long scard(String key) {
        SetOperations <String, Object> set = redisTemplate.opsForSet();
        return set.size(key);
    }

    /**
     * zadd
     *
     * @param key
     * @param value
     * @param scoure
     */
    public void zadd(String key, Object value, double scoure) {
        ZSetOperations <String, Object> zset = redisTemplate.opsForZSet();
        zset.add(key, value, scoure);
    }

    /**
     * zadd
     *
     * @param key
     * @param value
     * @param scoure
     */
    public void zadd(String key, Object value, String scoure) {
        ZSetOperations <String, Object> zset = redisTemplate.opsForZSet();
        zset.add(key, value, Double.valueOf(scoure));
    }
    /**
     * 有序集合获取
     *
     * @param key
     * @param scoure
     * @param scoure1
     * @return
     */
    public Set rangeByScore(String key, double scoure, double scoure1) {
        ZSetOperations <String, Object> zset = redisTemplate.opsForZSet();
        return zset.rangeByScore(key, scoure, scoure1);
    }

    /**
     * zscore
     *
     * @param key
     * @param scoure
     * @return
     */
    public Double zscore(String key, Object scoure) {
        ZSetOperations <String, Object> zset = redisTemplate.opsForZSet();
        return zset.score(key, scoure);
    }

    /**
     * zrange
     *
     * @param key
     * @param scoure
     * @param scoure1
     * @return
     */
    public Set zrange(String key, Long scoure, Long scoure1) {
        ZSetOperations <String, Object> zset = redisTemplate.opsForZSet();
        return zset.range(key, scoure, scoure1);
    }
}
