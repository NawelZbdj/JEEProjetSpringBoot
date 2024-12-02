<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jeeprojet.springboot.Model.Professor" %>
<%@ page import="com.jeeprojet.springboot.Model.Administrator" %>
<%
    Professor professor = (Professor) request.getAttribute("professor");
%>
<html>
<head>
    <title>Edit Professor</title>
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
        <h1>Edit Professor</h1>
        <form method="post" action="<%=request.getContextPath()%>/professor/edit/<%=professor.getId()%>" class="formAff">
            <input type="hidden" name="id" value="<%= professor.getId() %>">

            <label for="firstName">First Name:</label>
            <input type="text" id="firstName" name="firstName" value="<%= professor.getFirstName() %>" required><br>

            <label for="lastName">Last Name:</label>
            <input type="text" id="lastName" name="lastName" value="<%= professor.getLastName() %>" required><br>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<%= professor.getEmail() %>" required><br>

            <label for="specialty">Specialty:</label>
            <input type="text" id="specialty" name="specialty" value="<%= professor.getSpecialty() %>" required><br>

            <label for="birthDate">Birth Date:</label>
            <input type="date" id="birthDate" name="birthDate" value="<%=
               new java.text.SimpleDateFormat("yyyy-MM-dd").format(professor.getBirthDate()) %>" required><br><br>

            <button type="submit">Save Changes</button>
        </form>
    </main>
</div>
</body>
</html>
