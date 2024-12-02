<%@ page import="com.jeeprojet.springboot.Model.Administrator" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Admin Management</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/AdminStyle.css">

</head>
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
        <h1>Admin Management </h1>

<form method="get" action="<%=request.getContextPath()%>/admin/search" class="formAff">
    <label for="keyword">Search:</label>
    <input type="text" name="keyword" id="keyword" placeholder="Firstname or Lastname">
    <label for="pos">Position:</label>
    <select name="position" id="pos">
        <option value="">All</option>
        <option value="Manager">Manager</option>
        <option value="Developer">Developer</option>
    </select>
    <button type="submit">Search</button>
</form>

<a class="link-button" href="<%=request.getContextPath()%>/admin/add">Add New Administrator</a>



<table border="1">
    <thead>
    <tr>
        <th>ID</th>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Email</th>
        <th>Position</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        List<Administrator> administrators = (List<Administrator>) request.getAttribute("administrators");

        if (administrators != null && !administrators.isEmpty()) {
            for (Administrator admin : administrators) {
    %>
    <tr>
        <td><%= admin.getId() %></td>
        <td><%= admin.getFirstName() %></td>
        <td><%= admin.getLastName() %></td>
        <td><%= admin.getEmail() %></td>
        <td><%= admin.getPosition() %></td>
        <td>
            <a class="link-button" href="<%=request.getContextPath()%>/admin/update/<%= admin.getId() %>">Edit</a> |
            <a class="link-button" href="admin/delete/<%= admin.getId() %>" onclick="return confirm('Are you sure?')">Delete</a>
        </td>
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td colspan="6">No administrators found.</td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
    </main>
</div>
</body>
</html>