<%@ page import="com.jeeproject.Model.Student" %>
<%@ page import="com.jeeproject.Model.Course" %>
<%@ page import="java.util.*" %>
<%@ page import="com.jeeproject.Model.Professor" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Course Students</title>
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
<%

    Course course = (Course) request.getAttribute("course");
    String courseTitle = course != null ? course.getTitle() : "Unknown Course";
%>

<h1>Students in <%= courseTitle %></h1>

<%

    List<Student> students = (List<Student>) request.getAttribute("students");
%>

<%
    if (students != null && !students.isEmpty()) {
%>
<h2>List of Students:</h2>

    <%

        for (Student student : students) {
    %>
        <form action="<%= request.getContextPath() %>/ResultController" method="POST">
            <input type="hidden" name="action" value="viewGrades">
            <input type="hidden" name="studentId" value="<%= student.getId() %>">
            <input type="hidden" name="courseId" value="<%= course.getId() %>">
            <button type="submit">
                <%= student.getFirstName() %> <%= student.getLastName() %>
            </button>
        </form>

    <%
        }
    %>

<%
} else {
%>
<p>No students are enrolled in this course.</p>
<%
    }
%>

<br><a href="CourseController?action=listByProfessor">Back to Courses</a>

    </main>
</div>
</body>
</html>
