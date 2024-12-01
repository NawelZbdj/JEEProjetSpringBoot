<%@ page import="com.jeeproject.Model.Registration" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="com.jeeproject.Model.Professor" %><%--
  Created by IntelliJ IDEA.
  User: CYTech Student
  Date: 11/29/2024
  Time: 3:23 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Professor - Courses display</title>
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
  if(request.getAttribute("registration") == null){
    response.sendRedirect(request.getContextPath() + "/RegistrationController?action=listByProfessor&destination=/views/professor/CoursesDisplay.jsp");
  }
  else{
    List<Registration> registrationList = (List<Registration>) request.getAttribute("registration");
    if(registrationList.isEmpty()){
 %>
  <p>No courses assigned yet</p>
<%
    }else{
      Set<String> courses = new HashSet<>();
      for (Registration registration : registrationList) {
        courses.add(registration.getCourse().getTitle());
      }
%>
<h2>Courses :</h2>
<table>

  <%
    for (String course : courses) {
  %>
  <tr>
  <td><%= course %></td>
  </tr>
  <%
    }
  }
}
%>
</table>
  </main>
</div>
</body>
</html>