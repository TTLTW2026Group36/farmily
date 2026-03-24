package group36.dao;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class DBProperties {
    private static Properties prop = new Properties();
    static {
        try {
            File f = new File("/db.properties");
            if (f.exists()) {
                prop.load(new FileInputStream(f));
            } else {
                prop.load(DBProperties.class.getClassLoader().getResourceAsStream("db.properties"));
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    public static String host = prop.getProperty("db.host");
    public static String port = prop.getProperty("db.port");
    public static String username = prop.getProperty("db.username");
    public static String password = prop.getProperty("db.password");
    public static String dbname = prop.getProperty("db.name");

    public static void main(String[] args) {
        System.out.println(host);
        System.out.println(port);
        System.out.println(username);
        System.out.println(password);
        System.out.println(dbname);

    }

}
