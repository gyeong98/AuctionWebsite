<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Send ticket response</title>
</head>
<body>
	<a href="customerRep_page.jsp">Return to representative page</a><br><br>
	<a href="getHelpTickets.jsp">Return to support requests</a>
	<h2>Response status</h2>
	<hr><br>
	
	<%
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection supportCon = db.getConnection();	
			
			String ticketNum = request.getParameter("ticketNumber");
			String questionRetr = request.getParameter("quest");
			String rep_response = request.getParameter("rep_response");
			
			//out.print(rep_response);
			
			
            Statement getTickets = supportCon.createStatement();
            String ticketQuery = "UPDATE Customer_Support SET answer = '" + rep_response +"' WHERE ticket_no = '" + ticketNum + "';";
          	int ticketSet = getTickets.executeUpdate(ticketQuery);
			
          	
          	
          	if(ticketSet == 1){
          		
          		out.print("<b>Responded to help ticket #" + ticketNum + " </b>");
          		out.print("<p><b>User question: </b>" + questionRetr  + "</p><br>"  );
          		out.print("<p><b>Customer support response: </b>" + rep_response  + "</p>"  );
          	}else{
          		
          		out.print("<b>error while posting response</br>");
          		
          	}
          
			
			//close the connection.
			supportCon.close();
			
		} catch (Exception e) {
            out.print(e);
		}
	%>
</body>
</html>