<%@ page import="com.jeeproject.Model.Student" %>
<%@ page import="java.util.List" %>
<%@ page import="com.jeeproject.Model.Administrator" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Student Management</title>
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
        <h1>Student Management</h1>

<form method="get" action="<%=request.getContextPath()%>/StudentController" class="formAff">
    <input type="hidden" name="action" value="search">
    <label for="keyword">Search:</label>
    <input type="text" name="keyword" id="keyword" placeholder="Name or email">
    <button type="submit">Search</button>
</form>

<a class="link-button" href="<%=request.getContextPath()%>/StudentController?action=add">Add New Student</a>



<table border="1">
    <thead>
    <tr>
        <th>ID</th>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Email</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        if(request.getAttribute("students") == null) {
            response.sendRedirect(request.getContextPath() + "/StudentController?action=list");
        }
        else{
            List<Student> students = (List<Student>) request.getAttribute("students");

            if (students != null && !students.isEmpty()) {
                for (Student student : students) {
    %>
    <tr>
        <td><%= student.getId() %></td>
        <td><%= student.getFirstName() %></td>
        <td><%= student.getLastName() %></td>
        <td><%= student.getEmail() %></td>
        <td>
            <a class="link-button" href="<%=request.getContextPath()%>/StudentController?action=update&id=<%= student.getId() %>&destination=/views/admin/UpdateStudent.jsp">Edit</a> |
            <a class="link-button" href="<%=request.getContextPath()%>/StudentController?action=delete&id=<%= student.getId() %>" onclick="return confirm('Are you sure?')">Delete</a>
        </td>
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td colspan="6">No students found.</td>
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