package group36.dao;

import com.mysql.cj.jdbc.MysqlDataSource;
import org.jdbi.v3.core.Jdbi;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.SQLException;

public class JdbiProvider {
    static {
        java.util.TimeZone.setDefault(java.util.TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
    }

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
        try {
            Context ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/farmily");
            System.out.println("[JdbiProvider] Using JNDI DataSource (Tomcat Connection Pool)");
            return Jdbi.create(ds);
        } catch (Exception e) {
            System.out
                    .println("[JdbiProvider] JNDI not available, falling back to direct connection: " + e.getMessage());
        }

        MysqlDataSource ds = new MysqlDataSource();
        ds.setURL("jdbc:mysql://" + DBProperties.host + ":" + DBProperties.port + "/" + DBProperties.dbname
                + "?useUnicode=true&characterEncoding=UTF-8&allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=Asia/Ho_Chi_Minh");
        ds.setUser(DBProperties.username);
        ds.setPassword(DBProperties.password);
        try {
            ds.setUseCompression(true);
            ds.setAutoReconnect(true);
        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        }
        return Jdbi.create(ds);
    }
}
