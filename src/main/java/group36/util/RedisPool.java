package group36.util;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class RedisPool {

    private static volatile JedisPool pool;

    public static Jedis getConnection() {
        if (pool == null) {
            synchronized (RedisPool.class) {
                if (pool == null) {
                    pool = buildPool();
                }
            }
        }
        return pool.getResource();
    }

    private static JedisPool buildPool() {
        Properties props = new Properties();
        try (InputStream in = RedisPool.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (in == null) {
                throw new IllegalStateException("config.properties not found");
            }
            props.load(in);
        } catch (IOException e) {
            throw new IllegalStateException("Failed to load config.properties", e);
        }

        String host = props.getProperty("redis.host", "localhost");
        int port = Integer.parseInt(props.getProperty("redis.port", "6379"));
        String password = props.getProperty("redis.password", "");

        JedisPoolConfig config = new JedisPoolConfig();
        config.setMaxTotal(20);
        config.setMaxIdle(5);
        config.setMinIdle(1);
        config.setTestOnBorrow(true);

        if (password == null || password.trim().isEmpty()) {
            return new JedisPool(config, host, port);
        }
        return new JedisPool(config, host, port, 2000, password);
    }
}
