package group36.dao;

import com.mysql.cj.jdbc.MysqlDataSource;
import org.jdbi.v3.core.Jdbi;

import java.sql.SQLException;

public class JdbiProvider {
    private static volatile Jdbi instance;

    public static Jdbi getInstance() {
        if (instance == null) {
            synchronized (JdbiProvider.class) {
                if (instance == null) {
                    instance = createJdbi();
                }
            }
        }
        return instance;
    }

    private static Jdbi createJdbi() {
        MysqlDataSource ds = new MysqlDataSource();
        ds.setURL("jdbc:mysql://" + DBProperties.host + ":" + DBProperties.port + "/" + DBProperties.dbname);
        ds.setUser(DBProperties.username);
        ds.setPassword(DBProperties.password);
        try {
            ds.setUseCompression(true);
            ds.setAutoReconnect(true);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return Jdbi.create(ds);
    }
}
