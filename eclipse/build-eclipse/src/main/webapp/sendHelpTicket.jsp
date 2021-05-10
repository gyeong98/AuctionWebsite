<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

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

	<%
	
		try{
			ApplicationDB db = new ApplicationDB();
			Connection helpConn = db.getConnection();
			PreparedStatement sendHelp = helpConn.prepareStatement("INSERT INTO customer_support(end_user, question, answer) VALUES (?,?,'');");
		
			//session.getAttribute("user_id");
		
			//get the info from the help ticket fields
			String usernameInput = request.getParameter("username");
			String reasonInput = request.getParameter("reason");
			
			
			
			sendHelp.setString(1, usernameInput); //user
			sendHelp.setString(2, reasonInput); // detail or question for request
			sendHelp.executeUpdate();
			
			
			
			helpConn.close();
			
			out.print("help request sent: ");
			out.print("username:" + usernameInput);
			out.print("question/request: " + reasonInput);
			
		}catch(Exception e){
			out.print(e);
			out.print("Exception while sending help ticket");
		}
	
	%>
</body>
</html>