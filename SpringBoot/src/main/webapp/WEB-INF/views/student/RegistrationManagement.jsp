<%@ page import="java.util.List" %>
<%@ page import="com.jeeproject.Model.Course" %>
<%@ page import="com.jeeproject.Model.Registration" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.jeeproject.Model.Student" %><%--
  Created by IntelliJ IDEA.
  User: CYTech Student
  Date: 11/25/2024
  Time: 4:55 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student - Registration Management</title>
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
<h2>My courses</h2>

<%
    if(request.getAttribute("registrations") == null) {
        response.sendRedirect(request.getContextPath() + "/RegistrationController?action=listByStudent&destination=/views/student/RegistrationManagement.jsp");
    }


    if(request.getAttribute("registrations")!=null){
    List<Registration> registrationList = (List<Registration>) request.getAttribute("registrations");

    if(registrationList.isEmpty()){
 %>
       <p>No registrations.</p>
 <%
    }
    else{

    //Organize by specialities
    Map<String,List<Registration>> coursesBySpecialities = new HashMap<>();
    for(Registration registration : registrationList){
        String speciality = registration.getCourse().getSpeciality();
        if(!coursesBySpecialities.containsKey(speciality)){
            coursesBySpecialities.put(speciality,new ArrayList<>());
        }
        coursesBySpecialities.get(speciality).add(registration);
    }

%>
    <table>
        <tr class="reg">
            <th class="left">Course</th>
            <th>Description</th>
            <th>Credit</th>
            <th class="right">Professor</th>
        </tr>
    </table>
    <%
        for(Map.Entry<String, List<Registration>> coursesBySpeciality : coursesBySpecialities.entrySet()){
            List<Registration> specialityCourses = coursesBySpeciality.getValue();
    %>
    <h3><%=coursesBySpeciality.getKey()%></h3>
        <%
            for(Registration registration : specialityCourses){
                Course currentCourse = registration.getCourse();
        %>
    <table>
        <tr>
            <td class="left"><%=currentCourse.getTitle()%></td>
            <td><%=currentCourse.getDescription()%></td>
            <td><%=currentCourse.getCredit()%></td>
            <%
                if(registration.getProfessor()==null){
            %>
            <td>pending</td>
            <td class="right"><a class="link-button" href="<%=request.getContextPath()%>/RegistrationController?action=delete&id=<%=registration.getId()%>" onclick="return confirm('Are you sure you want to cancel this registration?');">cancel registration </a></td>
            <%
                }
                else{
            %>
            <td class="right"><%=registration.getProfessor().getFirstName()%> <%=registration.getProfessor().getLastName()%></td>
            <%
                }
            %>
        <tr></tr>

    </table>
    <%
            }
        }
        }
        }
    %>
    <a href="<%=request.getContextPath()%>/RegistrationController?action=listByStudentWithCourses&destination=views/student/NewRegistration.jsp" class="link-button">Register for a new course</a>
    </main>
</div>
</body>
</html>
