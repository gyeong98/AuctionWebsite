<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Alerts</title>
</head>
<body>
<a href="profile.jsp">Back</a>
<hr><br>
<a href="profile.jsp"><button onclick="demo()">Alarm Has Been Set. Click To Redirect To Home</button></a>
<% 
String id = request.getParameter("alert"); 
String user = (String) session.getAttribute("user");  
%>

<script>
function demo() {
alert("Thank You For Your Interest!");
}
</script>

</body>
</html>