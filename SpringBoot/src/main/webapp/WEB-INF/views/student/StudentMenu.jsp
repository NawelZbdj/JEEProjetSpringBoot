<%@ page import="com.jeeprojet.springboot.Model.Student" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student menu</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/StudentStyle.css">
</head>

<body>

<%
    Student account = (Student) session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    if (account == null || !"student".equals(role)) {
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
            <li><a href="<%=request.getContextPath()%>/result/student/<%=account.getId()%>">My results</a></li>
            <li><a href="<%= request.getContextPath() %>/registration/listByStudent/<%=account.getId()%>">My courses</a></li>
        </ul>
    </nav>

    <main class="content">
        <% if (account != null) { %>
        <p>Welcome, <%= account.getFirstName() %> <%= account.getLastName() %>.</p>
        <% } %>
        <h2>Menu</h2>

        <table>
            <tr>
                <td><a class="redirect" href="<%=request.getContextPath()%>/result/student/<%=account.getId()%>">My Results</a></td>
            </tr>
            <tr>
                <td><a class="redirect" href="<%= request.getContextPath() %>/registration/listByStudent/<%=account.getId()%>">My Courses</a></td>
            </tr>
        </table>

    </main>
</div>
</body>
</html>
