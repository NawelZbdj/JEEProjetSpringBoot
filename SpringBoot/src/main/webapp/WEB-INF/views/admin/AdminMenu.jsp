<%@ page import="com.jeeprojet.springboot.Model.Administrator" %>
<%--
  Created by IntelliJ IDEA.
  User: CYTech Student
  Date: 11/18/2024
  Time: 1:21 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin - Courses Management Menu</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/AdminStyle.css">

</head>
<body>
<div class="page">
    <header class="banner">
        <img src="<%= request.getContextPath() %>/image/logoGreen.png" alt="Logo" class="banner-image">
        <button class="logout-button" onclick="logout()">Log out</button>
    </header>
    <script>
        function logout() {
            window.location.href = '<%= request.getContextPath() %>/logout';
        }
    </script>
    <nav class="menu-bar">
        <ul class="menu">
            <li><a href="<%=request.getContextPath()%>/admin">Administrators</a></li>
            <li><a href="<%=request.getContextPath()%>/student/list">Students</a></li>
            <li><a href="<%=request.getContextPath()%>/professor">Professors</a></li>
            <li><a href="<%=request.getContextPath()%>/registration/menu">Courses</a></li>
        </ul>
    </nav>
    <main class="content">
<body>

    <%
    Administrator account = null;
    try {
        account = (Administrator) session.getAttribute("user");
    }
    catch(Exception e){
        account = null;
    }
    if (account==null || !"admin".equals(session.getAttribute("role"))){
        session.invalidate();
%>
<script>
    alert("An issue occurred with the connection.");
    window.location.href = "<%= request.getContextPath() %>/";
</script>
    <%
        return;
    }
%>

<h2>Menu</h2>

    <table>
        <tr>
            <td><a class="redirect" href="<%=request.getContextPath()%>/admin">Administrators</a></td>
        </tr>
        <tr>
            <td><a href="<%=request.getContextPath()%>/student/list" class="redirect">Students </a></td>
        </tr>
        <tr>
            <td><a href="<%=request.getContextPath()%>/professor" class="redirect">Professors</a></td>
        </tr>
        <tr>
            <td><a class="redirect" href="<%=request.getContextPath()%>/registration/menu">
                Courses
            </a>
            </td>
        </tr>
    </table>
    </main>
</div>
</body>
</html>