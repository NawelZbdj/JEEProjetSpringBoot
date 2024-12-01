<%@ page import="java.util.List" %>
<%@ page import="com.jeeproject.Model.Course" %>
<%@ page import="com.jeeproject.Model.Result" %>
<%@ page import="com.jeeproject.Model.Student" %>
<%@ page import="com.jeeproject.Model.Professor" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<html>
<head>
  <title>Student Grades</title>
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
  Student student = (Student) request.getAttribute("student");
  List<Result> results = (List<Result>) request.getAttribute("results");
  Course course = (Course) request.getAttribute("course");
%>

<h1>Grades for <%= student.getFirstName() %> <%= student.getLastName() %> in <%= course.getTitle() %></h1>

<%
  if (results != null && !results.isEmpty()) {
%>

<form action="<%= request.getContextPath() %>/ResultController?action=saveGrades" method="POST">
  <input type="hidden" name="studentId" value="<%= student.getId() %>" />
  <input type="hidden" name="courseId" value="<%= course.getId() %>" />
  <table border="1">
    <thead>
    <tr>
      <th>Result Id</th>
      <th>Grade</th>
      <th>Coefficient</th>
    </tr>
    </thead>
    <tbody>
    <%
      for (Result result : results) {
        Course resultCourse = result.getRegistration().getCourse();
    %>
    <tr>
      <td><%= result.getId() %></td>
      <td>
        <input type="hidden" name="resultIds" value="<%= result.getId() %>" />
        <input type="number" step="0.01" name="grades" value="<%= result.getGrade() %>" />
      </td>
      <td>
        <input type="number" step="0.01" name="coefficients" value="<%= result.getCoefficient() %>" />
      </td>
    </tr>
    <%
      }
    %>
    </tbody>
  </table>
  <button type="submit">Save Changes</button>
</form>
<%
} else {
%>
<p>No grades found for this student in this course.</p>
<%
  }
%>


<form action="<%= request.getContextPath() %>/ResultController" method="POST">
  <input type="hidden" name="action" value="addGrade">
  <input type="hidden" name="studentId" value="<%= student.getId() %>" />
  <input type="hidden" name="courseId" value="<%= course.getId() %>" />
  <button type="submit">Add New Grade</button>
</form>



<form action="<%= request.getContextPath() %>/StudentController" method="POST">
  <input type="hidden" name="action" value="listByCourses">
  <input type="hidden" name="courseId" value="<%= course.getId() %>" />
  <button type="submit">Back to Course Details</button>
</form>

  </main>
</div>
</body>
</html>
