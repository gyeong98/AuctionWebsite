<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>User support Request</title>
</head>
<body>
	<a href='profile.jsp'>Profile</a>
	<br><h1>Unanswered Customer Support Requests</h1>
	<hr><br>
	
	<%
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
			
			ResultSet questions = stmt.executeQuery("SELECT * FROM customer_support WHERE answer = '';"); //get all unanswered questions
			
			
			if(questions.isBeforeFirst() == false){
				
				out.print("<p>Strange, there are no questions here</p>");
			
			}else{
				
				String question = "";
				String asker = "";
				String ticketNum = "";
				
				while(questions.next() ){
					
					ticketNum = "" + questions.getInt("ticket_no");
					question = questions.getString("question");
					asker = questions.getString("end_user");
					
					
					out.print("<b>Post #" + ticketNum + ": </b>" + "<b>" + question + " </b>" + " by: " + asker);
					
					%>
					<form method="post" action="viewHelpTicket.jsp">
						<input type="Hidden" name="ticketNumber" value="<%=ticketNum%>">
						<input type="Hidden" name="quest" value="<%=question%>">
						<input type="Hidden" name="user" value="<%=asker%>">
						<input type="submit" value="View request">
					</form>
					<%
					
					
					out.print("<br><br>");
				
					
				}
						
				
			}
			
			out.print("<br><a href='customerSupport_page.jsp'>Need help? Contact customer support</a>");
			
			questions.close();
			con.close();
		}
		catch (Exception e) {
			out.print(e);
		}
	%>
</body>
</html>