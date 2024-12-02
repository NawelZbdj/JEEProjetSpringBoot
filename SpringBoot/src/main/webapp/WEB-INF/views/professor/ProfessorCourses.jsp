<%@ page import="com.jeeprojet.springboot.Model.Course" %>
<%@ page import="java.util.List" %>
<%@ page import="com.jeeprojet.springboot.Model.Professor" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Professor Courses</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/ProfessorStyle.css">

</head>
<body>

<%
    Professor account = null;
    try {
        account = (Professor) session.getAttribute("user");
    }
    catch(Exception e){
        account = null;
    }
    if (account==null || !"professor".equals(session.getAttribute("role"))){
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
        <img src="<%=request.getContextPath()%>/image/logoBG.png" alt="Logo" class="banner-image">
        <button class="logout-button" onclick="logout()">Log out</button>
    </header>
    <script>
        function logout() {
            window.location.href = '<%= request.getContextPath() %>/logout';
        }
    </script>
    <nav class="menu-bar">
        <ul class="menu">
            <li><a href="<%=request.getContextPath()%>/professor/CoursesDisplay.jsp">My Courses</a></li>
            <li><a href="<%=request.getContextPath()%>/course/listByProfessor/<%=account.getId()%>">Grades management</a></li>
        </ul>
    </nav>
    <main class="content">



<h2>Courses List</h2>

<ul>
    <%

        List<Course> courses = (List<Course>) request.getAttribute("coursesList");

        if (courses != null && !courses.isEmpty()) {

            for (Course course : courses) {
    %>
    <li>
        <form action="<%= request.getContextPath() %>/student/listByCourses" method="POST">
            <input type="hidden" name="courseId" value="<%= course.getId() %>">
            <input type="hidden" name="professorId" value="<%= account.getId() %>">
            <button type="submit" class="link-button">
                <%= course.getTitle() %>
            </button>
        </form>
    </li>
    <%
        }
    } else {
    %>
    <li>No courses.</li>
    <%
        }
    %>
</ul>


        
    </main>
</div>
</body>
</html>
