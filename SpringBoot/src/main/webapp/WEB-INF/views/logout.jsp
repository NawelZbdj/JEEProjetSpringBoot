<%--
  Created by IntelliJ IDEA.
  User: CYTech Student
  Date: 11/29/2024
  Time: 5:39 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>log out</title>
</head>
<body>
<%
  session.invalidate();
  response.sendRedirect("menu.jsp");
%>
</body>
</html>
