package group36.dao;

import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.statement.StatementContext;
import group36.model.Product;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;





public class ProductDAO extends BaseDao {

    



    private static class ProductMapper implements RowMapper<Product> {
        @Override
        public Product map(ResultSet rs, StatementContext ctx) throws SQLException {
            Product product = new Product();
            product.setId(rs.getInt("id"));
            product.setCategoryId(rs.getInt("category_id"));
            product.setName(rs.getString("name"));
            product.setAvgRating(rs.getDouble("avg_rating"));
            product.setReviewCount(rs.getInt("review_count"));
            product.setSoldCount(rs.getInt("soild_count")); 
            product.setCreatedAt(rs.getTimestamp("created_at"));
            product.setUpdatedAt(rs.getTimestamp("updated_at"));
            return product;
        }
    }

    




    public List<Product> findAll() {
        String sql = "SELECT * FROM products ORDER BY id DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .map(new ProductMapper())
                .list());
    }

    






    public List<Product> findAllPaginated(int page, int size) {
        int offset = (page - 1) * size;
        String sql = "SELECT * FROM products ORDER BY id DESC LIMIT :size OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("size", size)
                .bind("offset", offset)
                .map(new ProductMapper())
                .list());
    }

    





    public Optional<Product> findById(int id) {
        String sql = "SELECT * FROM products WHERE id = :id";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map(new ProductMapper())
                .findOne());
    }

    





    public List<Product> findByCategoryId(int categoryId) {
        String sql = "SELECT * FROM products WHERE category_id = :categoryId ORDER BY id DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("categoryId", categoryId)
                .map(new ProductMapper())
                .list());
    }

    







    public List<Product> findByCategoryIdPaginated(int categoryId, int page, int size) {
        int offset = (page - 1) * size;
        String sql = "SELECT * FROM products WHERE category_id = :categoryId ORDER BY id DESC LIMIT :size OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("categoryId", categoryId)
                .bind("size", size)
                .bind("offset", offset)
                .map(new ProductMapper())
                .list());
    }

    





    public List<Product> searchByName(String keyword) {
        String sql = "SELECT * FROM products WHERE name LIKE :keyword ORDER BY id DESC";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("keyword", "%" + keyword + "%")
                .map(new ProductMapper())
                .list());
    }

    





    public int insert(Product product) {
        String sql = "INSERT INTO products (category_id, name) VALUES (:categoryId, :name)";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("categoryId", product.getCategoryId())
                .bind("name", product.getName())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one());
    }

    





    public int update(Product product) {
        String sql = "UPDATE products SET category_id = :categoryId, name = :name WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", product.getId())
                .bind("categoryId", product.getCategoryId())
                .bind("name", product.getName())
                .execute());
    }

    







    public int delete(int id) {
        String sql = "DELETE FROM products WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute());
    }

    




    public int count() {
        String sql = "SELECT COUNT(*) FROM products";
        return get().withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }

    





    public int countByCategoryId(int categoryId) {
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = :categoryId";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("categoryId", categoryId)
                .mapTo(Integer.class)
                .one());
    }

    public List<Product> findFiltered(int categoryId, String status, String search, String sort, int page, int size) {
        int offset = (page - 1) * size;
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT p.* FROM products p ");
        if ("instock".equals(status) || "outofstock".equals(status) || "price_asc".equals(sort) || "price_desc".equals(sort)) {
            sql.append("LEFT JOIN (SELECT product_id, COALESCE(SUM(stock), 0) AS total_stock, COALESCE(MIN(price), 0) AS min_price FROM product_variants GROUP BY product_id) pv ON p.id = pv.product_id ");
        }
        sql.append("WHERE 1=1 ");
        if (categoryId > 0) sql.append("AND p.category_id = :categoryId ");
        if (search != null && !search.isEmpty()) sql.append("AND p.name LIKE :search ");
        if ("instock".equals(status)) sql.append("AND pv.total_stock > 0 ");
        if ("outofstock".equals(status)) sql.append("AND (pv.total_stock IS NULL OR pv.total_stock = 0) ");

        switch (sort != null ? sort : "") {
            case "name_asc": sql.append("ORDER BY p.name ASC "); break;
            case "price_asc": sql.append("ORDER BY pv.min_price ASC "); break;
            case "price_desc": sql.append("ORDER BY pv.min_price DESC "); break;
            default: sql.append("ORDER BY p.id DESC "); break;
        }
        sql.append("LIMIT :size OFFSET :offset");

        return get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString())
                    .bind("size", size)
                    .bind("offset", offset);
            if (categoryId > 0) query.bind("categoryId", categoryId);
            if (search != null && !search.isEmpty()) query.bind("search", "%" + search + "%");
            return query.map(new ProductMapper()).list();
        });
    }

    public int countFiltered(int categoryId, String status, String search) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM products p ");
        if ("instock".equals(status) || "outofstock".equals(status)) {
            sql.append("LEFT JOIN (SELECT product_id, COALESCE(SUM(stock), 0) AS total_stock FROM product_variants GROUP BY product_id) pv ON p.id = pv.product_id ");
        }
        sql.append("WHERE 1=1 ");
        if (categoryId > 0) sql.append("AND p.category_id = :categoryId ");
        if (search != null && !search.isEmpty()) sql.append("AND p.name LIKE :search ");
        if ("instock".equals(status)) sql.append("AND pv.total_stock > 0 ");
        if ("outofstock".equals(status)) sql.append("AND (pv.total_stock IS NULL OR pv.total_stock = 0) ");

        return get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (categoryId > 0) query.bind("categoryId", categoryId);
            if (search != null && !search.isEmpty()) query.bind("search", "%" + search + "%");
            return query.mapTo(Integer.class).one();
        });
    }


    






    public int incrementSoldCount(int id, int increment) {
        String sql = "UPDATE products SET soild_count = soild_count + :increment WHERE id = :id";
        return get().withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .bind("increment", increment)
                .execute());
    }

    








    public List<Product> findAllPaginatedSorted(int page, int size, String sortBy, String sortDir) {
        int offset = (page - 1) * size;
        String orderColumn = getSafeOrderColumn(sortBy);
        String orderDir = "DESC".equalsIgnoreCase(sortDir) ? "DESC" : "ASC";

        String sql = "SELECT * FROM products ORDER BY " + orderColumn + " " + orderDir + " LIMIT :size OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("size", size)
                .bind("offset", offset)
                .map(new ProductMapper())
                .list());
    }

    









    public List<Product> findByCategoryIdPaginatedSorted(int categoryId, int page, int size,
            String sortBy, String sortDir) {
        int offset = (page - 1) * size;
        String orderColumn = getSafeOrderColumn(sortBy);
        String orderDir = "DESC".equalsIgnoreCase(sortDir) ? "DESC" : "ASC";

        String sql = "SELECT * FROM products WHERE category_id = :categoryId ORDER BY "
                + orderColumn + " " + orderDir + " LIMIT :size OFFSET :offset";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("categoryId", categoryId)
                .bind("size", size)
                .bind("offset", offset)
                .map(new ProductMapper())
                .list());
    }

    public List<Product> findBestSelling(int limit) {
        String sql = "SELECT * FROM products ORDER BY soild_count DESC, id DESC LIMIT :limit";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("limit", limit)
                .map(new ProductMapper())
                .list());
    }

    public List<Product> findNewest(int limit) {
        String sql = "SELECT * FROM products ORDER BY created_at DESC, id DESC LIMIT :limit";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("limit", limit)
                .map(new ProductMapper())
                .list());
    }

    public List<Product> findByCategoryIdExcluding(int categoryId, int excludeProductId, int limit) {
        String sql = "SELECT * FROM products WHERE category_id = :categoryId AND id != :excludeId ORDER BY soild_count DESC, id DESC LIMIT :limit";
        return get().withHandle(handle -> handle.createQuery(sql)
                .bind("categoryId", categoryId)
                .bind("excludeId", excludeProductId)
                .bind("limit", limit)
                .map(new ProductMapper())
                .list());
    }

    private String getSafeOrderColumn(String sortBy) {
        if (sortBy == null)
            return "id";
        switch (sortBy.toLowerCase()) {
            case "name":
                return "name";
            case "sold_count":
            case "popular":
                return "soild_count"; 
            case "created_at":
            case "newest":
                return "created_at";
            default:
                return "id";
        }
    }
}
