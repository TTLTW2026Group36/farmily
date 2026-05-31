package group36.model;

import java.util.Collections;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public enum UserRole {

    ADMIN(99),
    MANAGER(50),
    STAFF_ORDER(30),
    STAFF_CONTENT(20),
    USER(1);

    private final int level;

    public static final Set<UserRole> ALL_STAFF = Collections.unmodifiableSet(
            EnumSet.of(ADMIN, MANAGER, STAFF_ORDER, STAFF_CONTENT));

    private static final Map<String, UserRole> ALIASES;

    static {
        Map<String, UserRole> m = new HashMap<>();
        m.put("customer", USER);
        m.put("user", USER);
        m.put("admin", ADMIN);
        m.put("manager", MANAGER);
        m.put("staff_order", STAFF_ORDER);
        m.put("staff_content", STAFF_CONTENT);
        ALIASES = Collections.unmodifiableMap(m);
    }

    UserRole(int level) {
        this.level = level;
    }

    public int getLevel() {
        return level;
    }

    public boolean canAccessAdmin() {
        return ALL_STAFF.contains(this);
    }

    public boolean isStaff() {
        return this != USER;
    }

    public static UserRole fromString(String role) {
        if (role == null || role.trim().isEmpty()) {
            return USER;
        }
        
        String upper = role.trim().toUpperCase();
        try {
            return valueOf(upper);
        } catch (IllegalArgumentException ignored) {
        }
        
        UserRole alias = ALIASES.get(role.trim().toLowerCase());
        return alias != null ? alias : USER;
    }
}
