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
<title>History Detail</title>
</head>
<body>
	<a href='users_history.jsp'>Back</a>
	<hr><br><% 
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection(); 
			Statement stmt = con.createStatement(); 
			String history = request.getParameter("item"); 
			String str = "SELECT M.auction_id, M.bid_time, I.model_name " +
						"FROM Makes_Bid M, Auctions A, Items I " +
						"WHERE I.item_id = A.item_id AND M.auction_id = A.auction_id AND buyer_id = '" + history+"'"; 
			ResultSet accounts = stmt.executeQuery(str);  %>
			<h1> The History of <% out.println(history); %>'s Auction Buyer List </h1>
			
					
			<table id = myTable>
			<tr><th> <% out.println("Item Name"); %> </th>
			<th> <% out.println("Auction ID"); %> </th>
			<th> <% out.println("Bid Time"); %></th>
			</tr>
			<tr>
			<% 
		
		while (accounts.next()) {
			String modelNUM = accounts.getString("model_name");
			int auctionid	= accounts.getInt("auction_id");
			String time  =  accounts.getString("bid_time"); 
			
			%>
			<tr>
			<td> <%out.print(modelNUM); %> </td>
			<td> <%out.print(auctionid); %> </td>
			<td> <%out.print(time); }%> </td>
		
			</tr>

		   
			
			</table>
			
			<br>
			<br>
			<br>
			<br>
			<br>
			<br>
			
			<h1> The History of <% out.println(history); %>'s Auction Selling List</h1>
			<%
			String something = "SELECT I.model_name, A.auction_id, A.start_time, A.expires " +
						"FROM Auctions A, Items I " +
						"WHERE A.item_id = I.item_id AND seller_id = '" + history+"'"; 
			ResultSet account2 = stmt.executeQuery(something);  %>
			
			
			<table id = myTable>
			<tr><th> <% out.println("Item Name"); %>
			<th> <% out.println("Auction ID"); %> </th>
			<th> <% out.println("Start Time"); %></th>
			<th> <% out.println("Expires(d)"); %></th>
			</tr>
			
			<% 
		
		while (account2.next()) {
			String modelNUM = account2.getString("model_name");
			int auctionid	= account2.getInt("auction_id");
			String time  =  account2.getString("start_time"); 
			String times = account2.getString("expires");
			
			%><tr>
			<td> <%out.print(modelNUM); %> </td>
			<td> <%out.print(auctionid); %> </td>
			<td> <%out.print(time); %> </td>
			<td> <%out.print(times); }%> </td>
		
			</tr>

		   
			
			</table>
			

</body>
</html>