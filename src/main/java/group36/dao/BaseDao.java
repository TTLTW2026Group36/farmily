package group36.dao;

import com.mysql.cj.jdbc.MysqlDataSource;
import org.jdbi.v3.core.Jdbi;

import java.sql.SQLException;

public abstract class BaseDao {

    Jdbi jdbi;

    protected Jdbi get() {
        if (jdbi == null) {
            connect();
        }
        return jdbi;
    }

    private void connect() {
        MysqlDataSource ds = new MysqlDataSource();
        System.out.println("jdbc:mysql://" + DBProperties.host + ":" + DBProperties.port + "/" + DBProperties.dbname);
        ds.setURL("jdbc:mysql://" + DBProperties.host + ":" + DBProperties.port + "/" + DBProperties.dbname);
        ds.setUser(DBProperties.username);
        ds.setPassword(DBProperties.password);
        try {
            ds.setUseCompression(true);
            ds.setAutoReconnect(true);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        jdbi = Jdbi.create(ds);
    }

    
    
    
    
}
