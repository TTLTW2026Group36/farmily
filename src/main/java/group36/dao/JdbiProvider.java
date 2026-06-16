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
        Jdbi jdbi;
        try {
            Context ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/farmily");
            System.out.println("[JdbiProvider] Using JNDI DataSource (Tomcat Connection Pool)");
            jdbi = Jdbi.create(ds);
        } catch (Exception e) {
            System.out
                    .println("[JdbiProvider] JNDI not available, falling back to direct connection: " + e.getMessage());
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
            jdbi = Jdbi.create(ds);
        }

        try {
            jdbi.useHandle(handle -> {
                handle.execute("ALTER TABLE refund_requests ADD COLUMN transaction_code VARCHAR(100) DEFAULT NULL");
                System.out.println("[JdbiProvider] Added column transaction_code to refund_requests");
            });
        } catch (Exception ex) {
            System.out.println(
                    "[JdbiProvider] Migration check/execution finished (column transaction_code might already exist)");
        }

        try {
            jdbi.useHandle(handle -> {
                handle.execute("ALTER TABLE users ADD COLUMN is_email_verified BOOLEAN DEFAULT FALSE");
                System.out.println("[JdbiProvider] Added column is_email_verified to users");
            });
        } catch (Exception ex) {
            System.out.println(
                    "[JdbiProvider] Migration check/execution finished (column is_email_verified might already exist)");
        }

        try {
            jdbi.useHandle(handle -> {
                handle.execute("CREATE TABLE IF NOT EXISTS email_verification_tokens (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "user_id INT NOT NULL, " +
                        "token VARCHAR(255) NOT NULL UNIQUE, " +
                        "expire_at TIMESTAMP NOT NULL, " +
                        "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE)");
                System.out.println("[JdbiProvider] Created table email_verification_tokens");
            });
        } catch (Exception ex) {
            System.out.println(
                    "[JdbiProvider] Migration check/execution finished (table email_verification_tokens might already exist)");
        }

        try {
            jdbi.useHandle(handle -> {
                handle.execute("ALTER TABLE products ADD COLUMN deleted_at TIMESTAMP NULL DEFAULT NULL");
                System.out.println("[JdbiProvider] Added column deleted_at to products");
            });
        } catch (Exception ex) {
            System.out.println(
                    "[JdbiProvider] Migration check/execution finished (column deleted_at might already exist)");
        }

        try {
            jdbi.useHandle(handle -> {
                handle.execute("CREATE INDEX idx_products_deleted_at ON products (deleted_at)");
                System.out.println("[JdbiProvider] Created index idx_products_deleted_at");
            });
        } catch (Exception ex) {
            System.out.println(
                    "[JdbiProvider] Migration check/execution finished (index idx_products_deleted_at might already exist)");
        }

        try {
            jdbi.useHandle(handle -> {
                handle.execute("ALTER TABLE flash_sales ADD COLUMN max_qty_per_user INT DEFAULT 0");
                System.out.println("[JdbiProvider] Added column max_qty_per_user to flash_sales");
            });
        } catch (Exception ex) {
            System.out.println(
                    "[JdbiProvider] Migration check/execution finished (column max_qty_per_user might already exist)");
        }

        return jdbi;
    }
}
