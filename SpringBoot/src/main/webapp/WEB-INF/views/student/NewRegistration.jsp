<%@ page import="com.jeeproject.Model.Registration" %>
<%@ page import="java.util.List" %>
<%@ page import="com.jeeproject.Model.Course" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.jeeproject.Model.Student" %><%--
  Created by IntelliJ IDEA.
  User: CYTech Student
  Date: 11/27/2024
  Time: 1:40 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student - Register for a course</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/css/StudentStyle.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/css/registrationStyle.css">
</head>
<body>

<%
    Student account = null;
    try {
        account = (Student)session.getAttribute("user");
    }
    catch(Exception e){
        account = null;
    }
    if (account==null || !"student".equals(session.getAttribute("role"))){
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
        <img src="<%=request.getContextPath()%>/views/image/logoBlue.png" alt="Logo" class="banner-image">
        <button class="logout-button" onclick="logout()">Log out</button>
    </header>
    <script>
        function logout() {
            window.location.href = '<%= request.getContextPath() %>/views/logout.jsp';
        }
    </script>
    <nav class="menu-bar">
        <ul class="menu">
            <li><a href="<%=request.getContextPath()%>/views/student/GradesDisplay.jsp">My results</a></li>
            <li><a href="<%=request.getContextPath()%>/views/student/RegistrationManagement.jsp">My courses</a></li>
        </ul>
    </nav>
    <main class="content">
<h2>Register for a New Course</h2>

<%
    List<Registration> registrationsList = (List<Registration>) request.getAttribute("registrations");
    List<Course> allCourses = (List<Course>) request.getAttribute("courses");

    List<Integer> registeredCoursesIds = new ArrayList();
    if(registrationsList != null) {
        for (Registration registration : registrationsList) {
            registeredCoursesIds.add(registration.getCourse().getId());
        }
    }

    Map<String,List<Course>> coursesBySpecialities = new HashMap<>();
    for(Course course : allCourses){
        if(!coursesBySpecialities.containsKey(course.getSpeciality())){
            coursesBySpecialities.put(course.getSpeciality(),new ArrayList<>());
        }
        coursesBySpecialities.get(course.getSpeciality()).add(course);
    }

    for(Map.Entry<String,List<Course>> coursesBySpeciality : coursesBySpecialities.entrySet()){
        String speciality = coursesBySpeciality.getKey();
        List<Course> specialityCourses = coursesBySpeciality.getValue();

%>
    <h3><%=speciality%></h3>
    <table>
        <tr class="me">
            <th>Course</th>
            <th>Description</th>
            <th>Credit</th>
            <th>Action</th>
        </tr>
        <%
            for(Course course : specialityCourses){
        %>
        <tr>
            <td><%=course.getTitle()%></td>
            <td><%=course.getDescription()%></td>
            <td><%=course.getCredit()%></td>
            <%
                if(registeredCoursesIds.contains(course.getId())){
            %>
              <td>Already registered</td>

            <%
                }else{
            %>
                <td><a  class="link-button" href="<%= request.getContextPath() %>/RegistrationController?action=add&courseId=<%=course.getId()%>"
                onclick="return confirm('Are you sure you want to register for <%=course.getTitle()%> ?')">Register</a></td>
            <%
                }
            %>
        </tr>
        <%
            }
        %>
    </table>
<%
    }
%>
    </main>
</div>
</body>
</html>
