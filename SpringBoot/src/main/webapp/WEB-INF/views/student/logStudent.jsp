<%--
  Created by IntelliJ IDEA.
  User: CYTech Student
  Date: 11/28/2024
  Time: 11:45 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/StudentStyle.css">
</head>
<body>
<div class="page">
    <header class="banner">
        <a href="<%= request.getContextPath() %>/">
            <img src="<%= request.getContextPath() %>/image/logoBlue.png" alt="Logo" class="banner-image">
        </a>
    </header>
    <main class="content">
        <h1>Login</h1>

        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
        <p style="color: red; text-align: center;"><%= errorMessage %></p>
        <%
            }
        %>

        <form action="<%= request.getContextPath() %>/login" method="post" id="log">
                <label for="username">Username :</label>
                <input type="text" name="username" id="username" required>
                <label for="password">Password :</label>
                <input type="password" name="password" id="password" required>
            <input type="hidden" name="role" value="student">
            <button type="submit" class="login-button">Login</button>
        </form>
    </main>
</div>
</body>
</html>


