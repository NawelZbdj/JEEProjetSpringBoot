<%@ page import="com.jeeproject.Model.Administrator" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Admin Management</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/views/css/AdminStyle.css">

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
    window.location.href = "<%= request.getContextPath() %>/views/menu.jsp";
</script>
<%
        return;
    }
%>

<div class="page">
    <header class="banner">
        <img src="<%= request.getContextPath() %>/views/image/logoGreen.png" alt="Logo" class="banner-image">
        <button class="logout-button" onclick="logout()">Log out</button>
    </header>
    <script>
        function logout() {
            window.location.href = '<%= request.getContextPath() %>/views/logout.jsp';
        }
    </script>
    <nav class="menu-bar">
        <ul class="menu">
            <li><a href="<%=request.getContextPath()%>/views/admin/AdminManagement.jsp">Administrators</a></li>
            <li><a href="<%=request.getContextPath()%>/views/admin/StudentsManagement.jsp">Students</a></li>
            <li><a href="<%=request.getContextPath()%>/views/admin/ProfessorsManagement.jsp">Professors</a></li>
            <li><a href="<%=request.getContextPath()%>/views/admin/CoursesManagementMenu.jsp">Courses</a></li>
        </ul>
    </nav>
    <main class="content">
        <h1>Admin Management </h1>

<form method="get" action="<%=request.getContextPath()%>/AdminController" class="formAff">
    <input type="hidden" name="action" value="search">
    <label for="keyword">Search:</label>
    <input type="text" name="keyword" id="keyword" placeholder="Name or email">
    <label for="pos">Position:</label>
    <select name="position" id="pos">
        <option value="">All</option>
        <option value="Manager">Manager</option>
        <option value="Developer">Developer</option>
    </select>
    <button type="submit">Search</button>
</form>

<a class="link-button" href="<%=request.getContextPath()%>/AdminController?action=add">Add New Administrator</a>



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
            <a class="link-button" href="AdminController?action=update&id=<%= admin.getId() %>">Edit</a> |
            <a class="link-button" href="AdminController?action=delete&id=<%= admin.getId() %>" onclick="return confirm('Are you sure?')">Delete</a>
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