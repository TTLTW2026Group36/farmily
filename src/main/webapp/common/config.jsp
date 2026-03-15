<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <script>
            window.contextPath = '${pageContext.request.contextPath}';
            window.isLoggedIn = ${not empty sessionScope.auth ? 'true' : 'false' };
        </script>