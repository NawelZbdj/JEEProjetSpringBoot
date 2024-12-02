<%@ page import="com.jeeprojet.springboot.Model.Course" %>
<%@ page import="com.jeeprojet.springboot.Model.Administrator" %><%--
  Created by IntelliJ IDEA.
  User: CYTech Student
  Date: 11/23/2024
  Time: 12:09 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin - Edit Course</title>
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
    <%
      Course course = (Course) request.getAttribute("course");
    %>
    <h2>Edit a Course</h2>
    <form action="<%=request.getContextPath()%>/course/update" method="post" class="formAff">
      <label>Title : </label>
      <input type="text" id="title" name="title" value="<%=course.getTitle()%>" required><br><br>

      <label>Description : </label>
      <input type="text" id="description" name="description" value="<%=course.getDescription()%>" required><br><br>

      <label>Credit : </label>
      <input type="text" id="credit" name="credit" value="<%=course.getCredit()%>" required><br><br>

      <label>Speciality : </label>
      <input type="text" id="speciality" name="speciality" value="<%=course.getSpeciality()%>" required><br><br>

      <input type="hidden" name="id" value="<%=course.getId()%>" required>

      <button type="submit">Save Changes</button>

    </form>
    </main>
</div>
</body>
</html>
