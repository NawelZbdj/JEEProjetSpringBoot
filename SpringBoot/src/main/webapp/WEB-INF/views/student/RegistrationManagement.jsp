<%@ page import="java.util.List" %>
<%@ page import="com.jeeprojet.springboot.Model.Course" %>
<%@ page import="com.jeeprojet.springboot.Model.Registration" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.jeeprojet.springboot.Model.Student" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student - Registration Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/StudentStyle.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/registrationStyle.css">
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
    window.location.href = "<%= request.getContextPath() %>/";
</script>
<%
        return;
    }
%>

<div class="page">
    <header class="banner">
        <img src="<%= request.getContextPath() %>/image/logoBlue.png" alt="Logo" class="banner-image">
        <button class="logout-button" onclick="logout()">Log out</button>
    </header>

    <script>
        function logout() {
            window.location.href = '<%= request.getContextPath() %>/logout';
        }
    </script>

    <nav class="menu-bar">
        <ul class="menu">
            <li><a href="<%= request.getContextPath() %>/result/student/<%=account.getId()%>">My results</a></li>
            <li><a href="<%= request.getContextPath() %>/registration/listByStudent/<%=account.getId()%>">My courses</a></li>
        </ul>
    </nav>

    <main class="content">
        <h2>My courses</h2>

        <%
            List<Registration> registrationList = (List<Registration>) request.getAttribute("registrations");

            if(registrationList!=null){
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
                <td class="right"><a class="link-button" href="<%=request.getContextPath()%>/registration/delete/<%=registration.getId()%>/<%=account.getId()%>" onclick="return confirm('Are you sure you want to cancel this registration?');">cancel registration </a></td>
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
        <a href="<%=request.getContextPath()%>/registration/listByStudentWithCourses/<%=account.getId()%>" class="link-button">Register for a new course</a>
    </main>
</div>
</body>
</html>
