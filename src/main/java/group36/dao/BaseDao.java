package group36.dao;

import org.jdbi.v3.core.Jdbi;

public abstract class BaseDao {

    protected Jdbi get() {
        return JdbiProvider.getInstance();
    }

}
