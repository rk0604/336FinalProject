<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
  <c:when test="${ok}">Welcome, ${username}!</c:when>
  <c:otherwise>Login failed.</c:otherwise>
</c:choose>
