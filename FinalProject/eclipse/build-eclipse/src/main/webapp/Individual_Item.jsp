<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
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
<title>Individual Item</title>
</head>
<body>
<a href='users_history.jsp'>Back</a>
	<hr><br><% 
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection(); 
			Statement stmt = con.createStatement(); 
			String key = request.getParameter("items"); 
			String str = "SELECT M.buyer_id, M.bid_time, M.bid " +
						"FROM Auctions A, Makes_Bid M " +
						"WHERE A.auction_id = M.auction_id AND A.auction_id = '" +key+"'"; 
			ResultSet accounts = stmt.executeQuery(str);  %>
			<h1> The History of Auction ID #<% out.println(key); %>'s Auction </h1>
				
			<table id = myTable>
			<tr><th> <% out.println("Buyer's Name"); %> </th>
			<th> <% out.println("Bid Amount"); %> </th>
			<th> <% out.println("Bid Time"); %></th>
			</tr>
		
			<% 
		
		while (accounts.next()) {
			String modelNUM = accounts.getString("buyer_id");
			String auctionid	= accounts.getString("bid_time");
			String time  =  accounts.getString("bid"); 
			
			%>
			<tr>
			<td> <%out.print(modelNUM); %> </td>
			<td> <%out.print(time); %> </td>
			<td> <%out.print(auctionid); }%> </td>
		
			</tr>

		   
			
			</table>

</body>
</html>