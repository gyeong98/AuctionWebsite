<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Customer Support Forum</title>
</head>
<body>
	<a href='home.jsp'>Home</a><br>
	<a href='profile.jsp'>Profile</a><br>
	<a href='helpForum.jsp'>Return to Help Forum</a><br><br>
	<a href='logout.jsp'>Logout</a>
	
	<hr><br>
	
	<%
	try {
		
		/*sApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();*/
		
		String ticketString = (String)request.getParameter("ticketNumber");
		String questionRetr = (String)request.getParameter("quest");
		String ansRetr = (String)request.getParameter("ans");
		String askerRetr = (String)request.getParameter("user");
		//out.print("test: "  + ticketString);
		
		out.print("<h1> Help Request #" + ticketString + "</h1>");
		out.print("<b>" + askerRetr + ": </b>" + questionRetr + "<br><br>");
		out.print("<b>Moderator Response: </b>" + ansRetr);
		
		
		
	
		out.print("<br><br><br><br> <a href='customerSupport_page.jsp'>Need help? Contact customer support</a>");
		
	}
	catch (Exception e) {
		out.print(e);
	}
	%>
	
	
</body>
</html>