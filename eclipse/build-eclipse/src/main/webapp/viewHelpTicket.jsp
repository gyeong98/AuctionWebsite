<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>View Help Ticket</title>
</head>
<body>
	
	<a href='profile.jsp'>Profile</a><br>
	<a href='getHelpTickets.jsp'>Return to help requests</a>
	<br><br>
	<a href='logout.jsp'>Logout</a>
	
	<hr><br>
	
	<%
	try {
		
		/*sApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();*/
		
		String ticketString = (String)request.getParameter("ticketNumber");
		String questionRetr = (String)request.getParameter("quest");
		String askerRetr = (String)request.getParameter("user");
		
		
		out.print("<h1> Help Request #" + ticketString + "</h1>");
		out.print("<b>" + askerRetr + ": </b>" + questionRetr + "<br><br>");
		
		
		%>
		
			<form method = "post" action = "respondToTicket.jsp" id="helpForm"> <!---send help ticket--->
				<input type="Hidden" name="ticketNumber" value="<%=ticketString%>">
				<input type="Hidden" name="quest" value="<%=questionRetr%>">
				<input type="Hidden" name="user" value="<%=askerRetr%>">
				<textarea rows="5" cols="51" name="rep_response" form="helpForm">
				</textarea>
				<br>
				<br>
				<input type = "submit" value = "Send response">
			</form>
		
		
		<%
		
		
		
	
		out.print("<br><br><br><br> <a href='customerSupport_page.jsp'>Need help? Contact customer support</a>");
		
	}
	catch (Exception e) {
		out.print(e);
	}
	%>
	
	
</body>
</html>