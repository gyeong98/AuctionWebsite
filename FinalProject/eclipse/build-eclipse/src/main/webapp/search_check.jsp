<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Check Search</title>
</head>
<body>
	<a href="search_page.jsp">Return to Search Box</a>
	<hr>
		<%
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection(); 
			Statement stmt = con.createStatement(); 
			String search = request.getParameter("search"); 
			String str = "SELECT * FROM Auctions A, Items I"+
					" WHERE A.item_id = I.item_id AND I.model_Name = '"+ search +"'";
			ResultSet accounts = stmt.executeQuery(str);
			
			out.print("<h1>");
			if (!accounts.next()) { 
            	
            	out.println("The item does not exist"); 
            	
            }
			else if ((accounts.getString("model_Name").equals(search))){
				
				session.setAttribute("searchcomplete", search);
				response.sendRedirect("item_detail.jsp"); 
				
				
			}
			else{
				out.println("The item does not exist");
			}
			out.print("</h1>");
			//close the connection.
			con.close();

		} 
		
		catch (Exception e) {
            out.print(e);
		} %>
	        
</body>
</html>