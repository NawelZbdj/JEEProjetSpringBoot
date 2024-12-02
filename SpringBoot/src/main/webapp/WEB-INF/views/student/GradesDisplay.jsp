<%@ page import="com.jeeprojet.springboot.Model.Result" %>
<%@ page import="java.util.List" %>
<%@ page import="com.jeeprojet.springboot.Model.Course" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.jeeprojet.springboot.Model.Professor" %>
<%@ page import="com.jeeprojet.springboot.Model.Student" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student - Display Grades</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/StudentStyle.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/GradesDisplay.css">
</head>
<body>

<%
    Student account = null;
    try {
        account = (Student) session.getAttribute("user");
    } catch (Exception e) {
        account = null;
    }
    if (account == null || !"student".equals(session.getAttribute("role"))) {
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
        <img src="<%=request.getContextPath()%>/image/logoBlue.png" alt="Logo" class="banner-image">
        <button class="logout-button" onclick="logout()">Log out</button>
    </header>
    <script>
        function logout() {
            window.location.href = '<%= request.getContextPath() %>/logout';
        }
    </script>
    <nav class="menu-bar">
        <ul class="menu">
            <li><a href="<%=request.getContextPath()%>/result/student/<%=account.getId()%>">My results</a></li>
            <li><a href="<%= request.getContextPath() %>/registration/listByStudent/<%=account.getId()%>">My courses</a></li>
        </ul>
    </nav>
    <main class="content">
        <h2>My Grades</h2>
        <%

            List<Result> results = (List<Result>) request.getAttribute("results");
            if (results == null || results.isEmpty()) {
        %>
        <p>No results yet.</p>
        <%
        } else {
            Map<String, Map<Course, List<Result>>> formattedResults = new HashMap<>();

            for (Result result : results) {
                String speciality = result.getRegistration().getCourse().getSpeciality();
                Course course = result.getRegistration().getCourse();

                formattedResults
                        .computeIfAbsent(speciality, k -> new HashMap<>())
                        .computeIfAbsent(course, k -> new ArrayList<>())
                        .add(result);
            }

            double totalAvg = 0;

            for (Map.Entry<String, Map<Course, List<Result>>> coursesBySpeciality : formattedResults.entrySet()) {
                String speciality = coursesBySpeciality.getKey();
                Map<Course, List<Result>> listByCourses = coursesBySpeciality.getValue();

                double speAvg = 0;
                double speCoef = 0;
        %>
        <h3><%=speciality%></h3>
        <table>
            <%
                for (Map.Entry<Course, List<Result>> listByCourse : listByCourses.entrySet()) {
                    Course course = listByCourse.getKey();
                    List<Result> resultsList = listByCourse.getValue();

                    double courseAvg = 0;
                    double courseCoef = 0;
            %>
            <tr class="course">
                <td><b><%=course.getTitle()%></b></td>
                <td><%=course.getCredit()%></td>
                <%
                    Professor professor = resultsList.get(0).getRegistration().getProfessor();
                    if (professor != null) {
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
                            <td>Coefficient</td>
                        </tr>
                        <%
                            for (Result result : resultsList) {
                                double grade = result.getGrade();
                                double coef = result.getCoefficient();
                        %>
                        <tr>
                            <td><%=grade%></td>
                            <td><%=coef%></td>
                        </tr>
                        <%
                                courseAvg += (grade * coef);
                                courseCoef += coef;
                            }

                            courseAvg = courseAvg / courseCoef;
                            speAvg += (courseAvg * course.getCredit());
                            speCoef += course.getCredit();
                        %>
                    </table>
                </td>
                <td><%=String.format("%.2f", courseAvg)%></td>
            </tr>
            <%
                }
                speAvg = speAvg / speCoef;
                totalAvg += speAvg;
            %>
            <tr>
                <td id="courseAvg" colspan="3"><p><%=String.format("%.2f", speAvg)%></p></td>
            </tr>
        </table>
        <%
            }
            totalAvg = totalAvg / formattedResults.size();
        %>
        <p id="avg">Average: <b><%=String.format("%.2f", totalAvg)%></b></p>
        <%
            }
        %>

    </main>
</div>

</body>
</html>
