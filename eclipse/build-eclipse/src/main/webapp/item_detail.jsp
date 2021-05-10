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
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Item Detail</title>
</head>
<body>
	<a href="search_page.jsp">Return to Search Box</a>
	<hr>

	<%
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		String search = (String) session.getAttribute("searchcomplete");
		out.print("<h1>List(s) for item: " + search + "</h1>");
		
		String qry = "SELECT A.auction_id, A.seller_id, A.highest_current_bid, A.expires, A.buy_now_price "+
				"FROM Items I, Auctions A "+
				"WHERE I.item_id = A.item_id AND CURRENT_TIMESTAMP < A.expires "+
				"AND I.model_Name = '"+search+"'";
		ResultSet res = stmt.executeQuery(qry);
		%>
		Sort By:
		
		<button onclick ="sortTable(0)" >Auction ID</button>
		<button onclick ="sortTable(1)" >Seller ID</button>
		<button onclick ="sortTable(2)" >Highest Bid</button>
		<button onclick ="sortTable(3)" >Expires</button>
		<button onclick ="sortTable(4)" >Buy Now Price</button>
		<br>
		<br>
		<table id = "myTable">
		<tr>

		<th> <% out.print("Auction ID"); %> </th>
		<th> <% out.print("Seller ID"); %> </th>
		<th> <% out.print("Highest Current Bid"); %> </th>
		<th> <% out.print("Expires"); %> </th>
		<th> <% out.print("Buy Now Price"); %> </th>

		</tr>
	
		<% 
		
		while (res.next()) {
			int auctionID 		= res.getInt("auction_id"); 
			String sellerID		= res.getString("seller_id");
			String highest_current_bid 	= res.getString("highest_current_bid"); 
			String expires = res.getString("expires"); 
			String buy_now_price = res.getString("buy_now_price"); 
			%><tr>
			<td> <%out.print(auctionID); %> </td>
			<td> <%out.print(sellerID); %> </td>
			<td> <%out.print(highest_current_bid); %> </td>
			<td> <%out.print(expires); %> </td>
			<td> <%out.print(buy_now_price); %> </td>
			
		<%
		}
		db.closeConnection(con);
	}
	catch (Exception e) {
		out.print(e);
	} %>
			
		</table>
		
		<script>
		function sortTable(c) {
			var table, rows, switching, i, x, y, shouldSwitch;
			table = document.getElementById("myTable");
			switching = true;
			while (switching) {
				switching = false;
				rows = table.rows;
				for (i = 1; i < (rows.length - 1); i++) {
					shouldSwitch = false;
					x = rows[i].getElementsByTagName("TD")[c];
					y = rows[i + 1].getElementsByTagName("TD")[c];
					if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
						shouldSwitch = true;
						break;
						}
					}
				if (shouldSwitch) {
					rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
					switching = true;
					}
				}
			}
			</script>
</body>
</html>