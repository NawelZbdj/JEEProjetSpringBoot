<%@ page import="com.jeeproject.Model.Result" %>
<%@ page import="java.util.List" %>
<%@ page import="com.jeeproject.Model.Course" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.jeeproject.Model.Professor" %>
<%@ page import="com.jeeproject.Model.Student" %><%--
  Created by IntelliJ IDEA.
  User: CYTech Student
  Date: 11/28/2024
  Time: 12:43 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student - Display Grades</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/css/StudentStyle.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/css/GradesDisplay.css">
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
<h2>My Grades</h2>
<%
    if(request.getAttribute("results") == null){
        response.sendRedirect(request.getContextPath() + "/ResultController?action=listByStudent&destination=/views/student/GradesDisplay.jsp");
    }
    else{
    List<Result> results = (List<Result>) request.getAttribute("results");

    if(results.isEmpty()){
 %>
   <p>No results yet.</p>
 <%

    }else{


    Map<String,Map<Course,List<Result>>> formattedResults = new HashMap();

    for(Result result : results){
        String speciality = result.getRegistration().getCourse().getSpeciality();
        Course course = result.getRegistration().getCourse();
        //by speciality
        if(!formattedResults.containsKey(speciality)){
            formattedResults.put(speciality,new HashMap<>());
        }

        //Result by course
        Map<Course,List<Result>> courseMap = formattedResults.get(speciality);

        if(!courseMap.containsKey(course)){
            courseMap.put(course,new ArrayList());
        }
        courseMap.get(course).add(result);
    }

    double totalAvg = 0;

    for(Map.Entry<String,Map<Course,List<Result>>> coursesBySpeciality : formattedResults.entrySet()){
        String speciality = coursesBySpeciality.getKey();
        Map<Course,List<Result>> listByCourses = coursesBySpeciality.getValue();

        double speAvg = 0;
        double speCoef = 0;

%>
<h3><%=speciality%></h3>
<table>
    <%
        //Courses map
        for(Map.Entry<Course,List<Result>> listByCourse : listByCourses.entrySet()){
            Course course = listByCourse.getKey();
            List<Result> resultsList = listByCourse.getValue();
            double courseAvg = 0;
            double courseCoef = 0;
    %>
        <tr class="course">
            <td><b><%=course.getTitle()%></b></td>
            <td><%=course.getCredit()%></td>
            <%
                Professor professor = resultsList.get(1).getRegistration().getProfessor();
                if(professor != null){
            %>
                    <td><%=professor.getFirstName()%> <%=professor.getLastName()%></td>
            <%
                }
            %>
        </tr>
        <tr>
            <td colspan="2">
                <table>
                    <tr class="tablehead">
                        <td>Grade</td>
                        <td>coefficient</td>
                    </tr>
                    <%
                        for(Result result : resultsList){
                            double grade =result.getGrade();
                            double coef = result.getCoefficient();

                    %>
                            <tr>
                                <td><%=grade%></td>
                                <td><%=coef%></td>
                            </tr>
                    <%
                            courseAvg+= (grade*coef);
                            courseCoef+= coef;
                        }

                        courseAvg = courseAvg/(courseCoef);
                        speAvg += (courseAvg * course.getCredit());
                        speCoef += course.getCredit();
                    %>

                </table>
            </td>
            <td><%=String.format("%.2f",courseAvg)%></td>
        </tr>
    <%
        }
        speAvg = speAvg / (speCoef);
        totalAvg += speAvg;
    %>
    <tr>
        <td id="courseAvg" colspan="3"><p><%=String.format("%.2f",speAvg)%>  </p></td>
    </tr>
</table>
<%
    }
        totalAvg=totalAvg/(formattedResults.size());
%>
        <p id="avg">  Average : <b> <%=String.format("%.2f",totalAvg)%></b></p>
<%
    }
    }
%>

    </main>
</div>

</body>
</html>
