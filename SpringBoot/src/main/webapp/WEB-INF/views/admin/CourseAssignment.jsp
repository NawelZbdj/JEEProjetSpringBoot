<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.jeeproject.Model.Registration" %>
<%@ page import="com.jeeproject.Model.Course" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.jeeproject.Model.Professor" %>
<%@ page import="com.jeeproject.Model.Administrator" %>
<%--
  Created by IntelliJ IDEA.
  User: CYTech Student
  Date: 11/23/2024
  Time: 4:26 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin - Course Assignment</title>
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
    <main class="content"><h2>Courses to assign</h2>
<%
    List<Professor> professorsList = (List<Professor>) request.getAttribute("professors");

    List<Registration> allRegistrations = (List<Registration>) request.getAttribute("registrations");

    if (professorsList == null || allRegistrations == null) {
%>
<p>No Courses to assign</p>
<%}

    List<Registration> unassignedRegistrations = new ArrayList<>();
    List<Registration> assignedRegistrations = new ArrayList<>();

    for(Registration registration : allRegistrations) {
        if (registration.getProfessor() == null) {
            unassignedRegistrations.add(registration);
        } else {
            assignedRegistrations.add(registration);
        }
    }


    //Sort unassigned registration by course
    Map<Course,List<List<Registration>>> unassignedRegistrationsByCourse = new HashMap<>();
    for(Registration unassigned : unassignedRegistrations) {
        if (!unassignedRegistrationsByCourse.containsKey(unassigned.getCourse())) {
            unassignedRegistrationsByCourse.put(unassigned.getCourse(), new ArrayList<>());
            unassignedRegistrationsByCourse.get(unassigned.getCourse()).add(new ArrayList<>());
        }

        //choose in which sublist we will add the new Registration
        List<List<Registration>> courseRegistrationLists = unassignedRegistrationsByCourse.get(unassigned.getCourse());
        List<Registration> currentList = courseRegistrationLists.get(courseRegistrationLists.size() - 1);

        //set the threshold
        if (currentList.size() < 5) {
            currentList.add(unassigned);
        } else {
            List<Registration> newList = new ArrayList<>();
            newList.add(unassigned);
            courseRegistrationLists.add(newList);
        }
    }

    //Sort professors by speciality
    Map<String, List<Professor>> professorBySpeciality = new HashMap<>();
    for (Professor professor : professorsList) {
        if (!professorBySpeciality.containsKey(professor.getSpecialty())) {
           professorBySpeciality.put(professor.getSpecialty(), new ArrayList<>());
        }
        professorBySpeciality.get(professor.getSpecialty()).add(professor);
    }
%>
        <table>
        <%
    //List all registrations by courses and by threshold
    for(Map.Entry<Course, List<List<Registration>>> RegistrationsByCourse : unassignedRegistrationsByCourse.entrySet()){
        List<List<Registration>> CourseRegistrations = RegistrationsByCourse.getValue();
        Course currentCourse = RegistrationsByCourse.getKey();
        String currentSpeciality = currentCourse.getSpeciality();

        //List<Professor> professorsOfCurrentSpeciality = professorBySpeciality.get(currentSpeciality);

        for(List<Registration> registrationList : CourseRegistrations){
%>
        <tr>
            <td><%= currentSpeciality %></td>
            <td><%= currentCourse.getTitle()%></td>
            <td><%= registrationList.size()%></td>
            <!--Select a professor-->

            <form action="<%= request.getContextPath() + "/RegistrationController?action=multiupdate" %>" method="post">
            <td>
                <select name="idProfessor">
                    <option value="">Select a professor</option>
                    <%
                        List<Professor> professorsOfCurrentSpeciality = professorBySpeciality.get(currentSpeciality);
                        if (professorsOfCurrentSpeciality != null) {
                            for(Professor professor : professorsOfCurrentSpeciality) {
                    %>
                        <option value="<%=professor.getId()%>"><%= professor.getFirstName()%> <%=professor.getLastName()%></option>
                    <%}
                        }
                    %>
                </select>
            </td>
                <% for(Registration reg : registrationList){ %>
                        <input type="hidden" name="registrationsList" value="<%=reg.getId()%>"/>
                <%
                    }
                %>
            <td><button type="submit">Assign Professor</button></td>
            </form>

        </tr>
<%      }
    }
%>
        </table>



<h2>Completed registrations</h2>

<table>
    <%
        for(Registration registration : assignedRegistrations){
            Professor currentProfessor = registration.getProfessor();
    %>
    <tr>
        <td><%=registration.getStudent().getFirstName()%> <%=registration.getStudent().getLastName()%></td>
        <td><%=registration.getCourse().getTitle()%></td>
        <td><%=registration.getCourse().getSpeciality()%></td>
        <form action="<%= request.getContextPath() + "/RegistrationController" %>" method="post">
        <td>
                <select name="idProfessor">
                    <option value="<%=currentProfessor.getId()%>"><%=currentProfessor.getFirstName()%> <%=currentProfessor.getLastName()%></option>
                    <%
                        List<Professor> professorsOfCurrentSpeciality = professorBySpeciality.get(registration.getCourse().getSpeciality());
                        if(professorsOfCurrentSpeciality != null){
                            for(Professor professor : professorsOfCurrentSpeciality){
                                if(professor.getId()!=currentProfessor.getId()){
                    %>
                    <option value="<%=professor.getId()%>"><%=professor.getFirstName()%> <%=professor.getLastName()%></option>
                    <%          }
                            }
                        }
                    %>
                </select>
        </td>
                <input type="hidden" name="registrationId" value="<%=registration.getId()%>"/>
                <input type="hidden" name="destination" value="editAssign"/>
                <input type="hidden" name="action" value="update"/>



            <td><button type="submit">Edit</button></td>
            </form>
    </tr>
    <%
        }
    %>
</table>
    </main>
</div>
</body>
</html>
