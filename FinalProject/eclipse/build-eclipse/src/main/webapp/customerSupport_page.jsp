<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">

<title> Customer Support </title>


</head>

<body>
	<a href="profile.jsp">profile</a>
	<br><br>
	<a href='logout.jsp'>Logout</a>
	<h1>Customer Support</h1>
	
	<a href='helpForum.jsp'>Check to see if your question was already answered</a>
	<hr><br>
	
	<p>Need help? Contact customer support</p>
	
	<form method = "post" action = "sendHelpTicket.jsp" id="helpForm"> <!---send help ticket--->
		<table>
		<tr>
		<td>Your Username: </td><td><input type="text" name="username"></td>
		</tr>
		</table>
		
		<br>
		<textarea rows="5" cols="51" name="reason" form="helpForm">
		</textarea>
		<br>
		<br>
	<input type = "submit" value = "Send">
	</form>
	
	
</body>
</html>