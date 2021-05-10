<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Help Forum</title>
</head>
<body>
	<a href='home.jsp'>Home</a><br>
	<a href='profile.jsp'>Profile</a><br>
	<a href='logout.jsp'>Logout</a>
	
	<hr>
	<br><h1>Customer Support Forum</h1>
	<hr>
	
	
	<h2>Customer Support Question Search</h2>
	
	<b>Search questions by keywords</b>
	<form method="post" action="questionSearch.jsp">
					keyword 1: <input type="text" name="kw1"><br>
					keyword 2: <input type="text" name="kw2"><br>
					keyword 3: <input type="text" name="kw3"><br><br>
					<input type="submit" value="Search">
	</form>
	
	<br><br>
	<h2>Browse Answered Customer Support Questions</h2>
	
	<%
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
			
			ResultSet questions = stmt.executeQuery("SELECT * FROM customer_support WHERE answer <> '';"); //get all answered questions
			
			
			if(questions.isBeforeFirst() == false){
				
				out.print("<p>Strange, there are no questions here</p>");
			
			}else{
				
				String question = "";
				String answer = "";
				String asker = "";
				String ticketNum = "";
				String title = "";
				
				while(questions.next() ){
					
					ticketNum = "" + questions.getInt("ticket_no");
					question = questions.getString("question");
					
					if(question.length() > 50){
						
						title = question.substring(0, 49) + "...";
					
					}else{
					
						title = question;
						
					}
					
					answer = questions.getString("answer");
					asker = questions.getString("end_user");
					
					
					out.print("<b>Post #" + ticketNum + " | </b>" + "<b>" + title + "   | </b>" + " by: " + asker);
					
					%>
					<form method="post" action="questionPage.jsp">
						<input type="Hidden" name="ticketNumber" value="<%=ticketNum%>">
						<input type="Hidden" name="quest" value="<%=question%>">
						<input type="Hidden" name="user" value="<%=asker%>">
						<input type="Hidden" name="ans" value="<%=answer%>">
						<input type="submit" value="View thread">
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

