<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Search Results</title>
</head>
<body>
	<a href='logout.jsp'>Logout</a>
	<a href='profile.jsp'>Profile</a>
	<a href='helpForum.jsp'>Return to Help Forum</a><br><br>	
	<h1>Question Search Results</h1>
	<hr><br>
	
	
	
	<%
		try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement searchStmt = con.createStatement();
			
			//PreparedStatement searchStmt = con.prepareStatement("SELECT * FROM customer_support WHERE question LIKE '%?%' OR question LIKE '%?%' OR question LIKE '%?%' OR answer LIKE '%?%' OR answer LIKE '%?%' OR answer LIKE '%?%'");
			
			String keyword1 = ((String)request.getParameter("kw1")).replaceAll(" ", "");
			String keyword2 = ((String)request.getParameter("kw2")).replaceAll(" ", "");
			String keyword3 = ((String)request.getParameter("kw3")).replaceAll(" ", "");
			
			
			boolean key1E = keyword1.equals("");
			boolean key2E = keyword2.equals("");
			boolean key3E = keyword3.equals("");
			
			
			/*STRING CONCATENATION NIGHTMARE
			BECAUSE WRITING PREPARED STATEMENTS WITH SQL WILDCARDS IS ANNOYING*/
			String searchQuery = "SELECT * FROM customer_support WHERE question LIKE '%"; 
			
			//check if keyword1 is empty
			if( !key1E ){
				searchQuery = searchQuery + keyword1 + "%' OR answer LIKE '%" + keyword1 + "%' ";
			}
			
			 //kw2 not empty, kw1 not empty
			if( !key2E && !key1E ){
				searchQuery = searchQuery + "OR question LIKE '%"+ keyword2 + "%' OR answer LIKE '%" + keyword2 + "%' ";
			
			}else if( !key2E ){//kw2 not empty, kw1 empty
				
				searchQuery = searchQuery + keyword2 + "%' OR answer LIKE '%" + keyword2 + "%'";
				
			}
			
			
			//kw3 not empty, (kw1 or kw2 not empty)
			if( !key3E && (!key2E || !key1E)){
				searchQuery = searchQuery + "OR question LIKE '%"+ keyword3 + "%' OR answer LIKE '%" + keyword3 + "%' ";
			
			}else if( !key3E ){
				
				searchQuery = searchQuery + keyword3 + "%' OR answer LIKE '%" + keyword3 + "%' ";
				
				
			}
			/*STRING CONCATENATION NIGHTMARE OVER
			In hindsight it was probably easier to do this with just prepared statement
			I also probably could have done multiple queries and multiple result sets
			But I already wrote all of this. it's a good thing that this worked on the first try*/
			
			
			
			ResultSet questions = searchStmt.executeQuery(searchQuery);
			
			
			//printing out the search query to the webpage
			if(questions.isBeforeFirst() == false){
				
				out.print("<p><b>Search returned no results for:</b> " + keyword1 + ", " + keyword2 + ", " + keyword3 + "</p>");
			
			}else{
				
				String question = "";
				String answer = "";
				String asker = "";
				String ticketNum = "";
				
				while(questions.next() ){
					
					ticketNum = "" + questions.getInt("ticket_no");
					question = questions.getString("question");
					answer = questions.getString("answer");
					asker = questions.getString("end_user");
					
					
					out.print("<b>Post #" + ticketNum + ": </b>" + "<b>" + question + " </b>" + " by: " + asker);
					
					%>
					<form method="post" action="questionPage.jsp">
						<input type="Hidden" name="ticketNumber" value="<%=ticketNum%>">
						<input type="Hidden" name="quest" value="<%=question%>">
						<input type="Hidden" name="user" value="<%=asker%>">
						<input type="Hidden" name="ans" value="<%=answer%>">
						<input type="submit" value="View">
					</form>
					<%
					
					
					out.print("<br><br>");
				
					
				}
				
			}
			
			
		
			out.print("<br><br><br><a href='customerSupport_page.jsp'>Need help? Contact customer support</a>");
			
			questions.close();
			con.close();
		}
		catch (Exception e) {
			out.print(e);
		}
	%>
	
	
</body>
</html>