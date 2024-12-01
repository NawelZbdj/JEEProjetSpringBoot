<%@ page import="com.jeeproject.Model.Course" %>
<%@ page import="java.util.List" %>
<%@ page import="com.jeeproject.Model.Professor" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Professor Courses</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/css/ProfessorStyle.css">

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
    window.location.href = "<%= request.getContextPath() %>/views/menu.jsp";
</script>
<%
        return;
    }
%>


<div class="page">
    <header class="banner">
        <img src="<%=request.getContextPath()%>/views/image/logoBG.png" alt="Logo" class="banner-image">
        <button class="logout-button" onclick="logout()">Log out</button>
    </header>
    <script>
        function logout() {
            window.location.href = '<%= request.getContextPath() %>/views/logout.jsp';
        }
    </script>
    <nav class="menu-bar">
        <ul class="menu">
            <li><a href="<%=request.getContextPath()%>/views/professor/CoursesDisplay.jsp">My Courses</a></li>
            <li><a href="<%=request.getContextPath()%>/CourseController?action=listByProfessor">Grades management</a></li>
        </ul>
    </nav>
    <main class="content">



<h2>Courses List</h2>

<ul>
    <%

        List<com.jeeproject.Model.Course> courses = (List<Course>) request.getAttribute("coursesList");

        if (courses != null && !courses.isEmpty()) {

            for (com.jeeproject.Model.Course course : courses) {
    %>
    <li>
        <form action="<%= request.getContextPath() %>/StudentController" method="POST">
            <input type="hidden" name="action" value="listByCourses">
            <input type="hidden" name="courseId" value="<%= course.getId() %>">
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
