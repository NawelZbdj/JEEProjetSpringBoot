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
    <title>Professor log</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/ProfessorStyle.css">
</head>
<body>
<div class="page">
    <header class="banner">
        <a href="<%= request.getContextPath() %>/">
            <img src="<%= request.getContextPath() %>/image/logoBG.png" alt="Logo" class="banner-image">
        </a>
    </header>
    <main class="content">
        <h1>Log in</h1>

        <%
            if (request.getAttribute("errorMessage") != null) {
        %>
        <p style="color: red; text-align: center;"><%= request.getAttribute("errorMessage") %></p>
        <%
            }
        %>

        <form action="<%=request.getContextPath()%>/login" method="post" id="log">
            <label>Username :</label>
            <input type="text" name="username" id="username" required><br>
            <label>Password :</label>
            <input type="password" name="password" id="password" required><br>
            <input type="hidden" name="role" value="professor">
            <button type="submit">Connect</button>
        </form>

    </main>
</div>
</body>
</html>
