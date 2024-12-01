<%@ page import="com.jeeproject.Model.Course" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.jeeproject.Model.Administrator" %>

<%--
  Created by IntelliJ IDEA.
  User: CYTech Student
  Date: 11/22/2024
  Time: 8:23 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin - Subject Management</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/views/css/AdminStyle.css">

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
    window.location.href = "<%= request.getContextPath() %>/views/menu.jsp";
</script>
<%
        return;
    }
%>

<div class="page">
    <header class="banner">
        <img src="<%= request.getContextPath() %>/views/image/logoGreen.png" alt="Logo" class="banner-image">
        <button class="logout-button" onclick="logout()">Log out</button>
    </header>
    <script>
        function logout() {
            window.location.href = '<%= request.getContextPath() %>/views/logout.jsp';
        }
    </script>
    <nav class="menu-bar">
        <ul class="menu">
            <li><a href="<%=request.getContextPath()%>/views/admin/AdminManagement.jsp">Administrators</a></li>
            <li><a href="<%=request.getContextPath()%>/views/admin/StudentsManagement.jsp">Students</a></li>
            <li><a href="<%=request.getContextPath()%>/views/admin/ProfessorsManagement.jsp">Professors</a></li>
            <li><a href="<%=request.getContextPath()%>/views/admin/CoursesManagementMenu.jsp">Courses</a></li>
        </ul>
    </nav>
    <main class="content"><%
    if(request.getAttribute("courses") == null) {
        response.sendRedirect(request.getContextPath() + "/CourseController?action=list&destination=/views/admin/SubjectManagement.jsp");
    }

            if(request.getAttribute("courses")!=null){
                List<Course> courses = (List<Course>) request.getAttribute("courses");

                //Organize by specialities
                Map<String,List<Course>> coursesBySpecialities = new HashMap<>();
                for(Course course : courses){
                    if(!coursesBySpecialities.containsKey(course.getSpeciality())){
                        coursesBySpecialities.put(course.getSpeciality(),new ArrayList<>());
                    }
                    coursesBySpecialities.get(course.getSpeciality()).add(course);
                }

                for(Map.Entry<String, List<Course>> CoursesBySpeciality : coursesBySpecialities.entrySet()){
                    List<Course> specialityCourses = CoursesBySpeciality.getValue();
%>
    <h2><%=CoursesBySpeciality.getKey()%></h2>
        <table>
        <%        for(Course course : specialityCourses){
        %>

        <tr>
            <td><%= course.getTitle()%></td>
            <td class="desc"><%= course.getDescription()%></td>
            <td><%= course.getCredit()%></td>
            <td class="right"><a class="link-button" href="<%=request.getContextPath()%>/CourseController?action=edit&id=<%= course.getId() %>">edit</a></td>
            <td class="right"><a class="link-button" href="<%=request.getContextPath()%>/CourseController?action=delete&id=<%= course.getId() %>" onclick="return confirm('Are you sure you want to delete this course?');">
                delete</a></td>
        </tr>
            <%
                }
            %>
    </table>

<%
            }
        }
%>
    <br><br>
    <a  class="link-button" href="<%=request.getContextPath()%>/views/admin/AddCourse.jsp">add course</a>
    </main>
</div>
</body>
</html>
