<%@ page import="com.jeeproject.Model.Professor" %>
<%@ page import="java.util.List" %>
<%@ page import="com.jeeproject.Model.Administrator" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Professor Management</title>
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
<h1>Professor Management</h1>

<form method="get" action="<%=request.getContextPath()%>/ProfessorController" class="formAff">
    <input type="hidden" name="action" value="search">
    <label for="keyword">Search:</label>
    <input type="text" name="keyword" id="keyword" placeholder="Name or email">
    <label for="specialty">Specialty:</label>
    <select name="specialty" id="specialty">
        <option value="">All</option>
        <option value="computerScience">Computer Science</option>
        <option value="Art">Art</option>
    </select>
    <button type="submit">Search</button>
</form>

<a class="link-button" href="<%=request.getContextPath()%>/ProfessorController?action=add">Add New Professor</a>



<table border="1">
    <thead>
    <tr>
        <th>ID</th>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Email</th>
        <th>Specialty</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        if(request.getAttribute("professors") == null) {
            response.sendRedirect(request.getContextPath() + "/ProfessorController?action=list");
        }
        else{
        List<Professor> professors = (List<Professor>) request.getAttribute("professors");

        if (professors != null && !professors.isEmpty()) {
            for (Professor professor : professors) {
    %>
    <tr>
        <td><%= professor.getId() %></td>
        <td><%= professor.getFirstName() %></td>
        <td><%= professor.getLastName() %></td>
        <td><%= professor.getEmail() %></td>
        <td><%= professor.getSpecialty() %></td>
        <td>
            <a class="link-button" href="<%=request.getContextPath()%>/ProfessorController?action=update&id=<%= professor.getId() %>&destination=/views/admin/UpdateProfessor.jsp">Edit</a> |
            <a class="link-button" href="ProfessorController?action=delete&id=<%= professor.getId() %>" onclick="return confirm('Are you sure?')">Delete</a>
        </td>
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td colspan="6">No professors found.</td>
    </tr>
    <%
        }
        }
    %>
    </tbody>
</table>
    </main>
</div>
</body>
</html>