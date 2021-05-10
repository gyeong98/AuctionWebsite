<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<style>
#myTable {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#myTable td, #myTable th {
  border: 1px solid #ddd;
  padding: 8px;
}

#myTable tr:nth-child(even){background-color: #f2f2f2;}

#myTable tr:hover {background-color: #ddd;}

#myTable th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: #4CAF50;
  color: white;
}
</style>
<meta charset="UTF-8">
<title>One Month Later</title>

</head>
<body>
	<a href='users_history.jsp'>Back</a>
	<hr><br><% 
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection(); 
			Statement stmt = con.createStatement(); 
			String month = request.getParameter("month"); 
			String str = "SELECT auction_id, seller_id, start_time, expires " +
						"FROM Auctions " +
						"WHERE auction_id = '" + month+"'"; 
			ResultSet accounts = stmt.executeQuery(str);  %>
			<h1> More Than One Month Ago History of <% out.println(month); %> </h1>
			
					
			<table id = myTable>
			<tr><th> <% out.println("Auction ID"); %> </th>
			<th> <% out.println("Seller"); %> </th>
			<th> <% out.println("Start Day"); %></th>
			<th> <% out.println("Expiration Date"); %></th>
			</tr>
			<tr>
			<% 
		
		while (accounts.next()) {
			String modelNUM = accounts.getString("auction_id");
			String auctionid	= accounts.getString("seller_id");
			String time  =  accounts.getString("start_time"); 
			String times  =  accounts.getString("expires"); 
			
			%>
			<td> <%out.print(modelNUM); %> </td>
			<td> <%out.print(auctionid); %> </td>
			<td> <%out.print(time); %> </td>
			<td> <%out.print(times); }%> </td>
		
			</tr>

		   
			
			</table>

</body>
</html>