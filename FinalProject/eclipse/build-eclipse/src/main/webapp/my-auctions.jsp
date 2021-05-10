<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">
<title>CS 336: My Auctions</title>

<%@ include file="check-winners.jsp" %>

<%
// Connect to DB
ApplicationDB db = new ApplicationDB();	
Connection con = db.getConnection();

// Get session info
String user = (String) session.getAttribute("user");

// Set relevant session info
session.setAttribute("selectFail", false);
%>

<%!
//Functions
public float getHighestBid(Connection con, int auctionID) {
	// current highest bid is a little special because it is actually a calculated attribute
	float topBid = 0;
	
	try {
		String qryHighest = "SELECT max(m.bid) top_bid "+
							"FROM makes_bid m "+
							"WHERE m.auction_id = "+auctionID+" "+
							"GROUP BY m.buyer_id "+
							"ORDER BY top_bid desc "+
							"LIMIT 1 ";
		Statement stmtHighest = con.createStatement();
		ResultSet resHighest = stmtHighest.executeQuery(qryHighest);
		if (resHighest.next()) { topBid = resHighest.getFloat("top_bid"); }
	}
	catch (SQLException e) {
		e.printStackTrace();
	}
	
	return topBid;
}
%>

<%
/* Check for auction updates each time this page is loaded */


%>

</head>

<body style='font-family: sans-serif'>
<a href='profile.jsp'>Back</a>
<hr><br>

	<!-- 
		Goals:
		> List all 'auctions' (not bids) hosted by user
		> Link to each auction
	 -->
	<h1><a href='make-bid.jsp'>Make bid</a></h1>
	
	<table style="width:30vw; ">
		<tr style="text-align: left">
			<th>Auction</th>
			<th>Item</th>
			<th>Your bid</th>
			<th>Top bid</th>
			<th>Status</th>
		</tr>
		<%
		try {
			// Retrieve all auctions that user has made a bid on
			String qry =	"SELECT a.auction_id, i.model_name, max(m.bid) bid, a.highest_current_bid, a.winner "+
							"FROM makes_bid m "+
							"INNER JOIN auctions a ON m.auction_id = a.auction_id "+
							"INNER JOIN items i ON a.item_id = i.item_id "+
							"WHERE buyer_id = '"+user+"' "+
							"GROUP BY a.auction_id ";
			Statement stmt = con.createStatement();
			ResultSet res = stmt.executeQuery(qry);
			
			// List results
			while (res.next()) {
				out.print("<tr>");
				
				int auctionID = res.getInt("auction_id");
				String modelName = res.getString("model_name");
				float bid = res.getFloat("bid");
				
				out.print(	"<td>"+auctionID+"</td>"+
							"<td>"+modelName+"</td>"+
							"<td>"+bid+"</td>");
				
				
				// Green if you are top bid, red if other
				float topBid = getHighestBid(con, auctionID);
				if (bid >= topBid) { out.print("<td style='color:green;'>"); }
				else { out.print("<td style='color:red;'>"); }
				out.print(topBid+"</td>");
				
				// Status of auction: winner, no winner, still auctioning
				String winner = res.getString("winner");
				if (winner == null || winner.equals("")) {
					// Still ongoing
					out.print("<td>Ongoing");
				}
				else if (winner.equals("f") || !winner.equals(user)) {
					// Auction has no winner or user did not win
					out.print("<td style='color:red;'>Lost");
				}
				else {
					// User won the auction
					out.print("<td style='color:green;'>Won");
				}
				out.print("</td>");
				
				out.print("</tr>");
			}
			
			stmt.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		%>
	</table>
	<br>
	
	
	<h1><a href='create-auction.jsp'>Create auction</a></h1>
	
	<table style="width:30vw; ">
		<tr style="text-align: left">
			<th>Your auction</th>
			<th>Item</th>
			<th>Top bid</th>
		</tr>
		
		<%
		try {
			// Retrieve all auctions that user owns
			String qry = 	"SELECT a.auction_id, i.model_name, a.highest_current_bid "+
							"FROM auctions a "+
							"INNER JOIN items i ON a.item_id = i.item_id "+
							"WHERE seller_id = '"+user+"' ";
			Statement stmt = con.createStatement();
			ResultSet res = stmt.executeQuery(qry);
			
			// List results
			while (res.next()) {
				out.print("<tr>");
				
				int auctionID = res.getInt("auction_id");
				String modelName = res.getString("model_name");
				//float topBid = res.getFloat("highest_current_bid");
				float topBid = getHighestBid(con, auctionID);
				
				out.print(	"<td>"+auctionID+"</td>"+
							"<td>"+modelName+"</td>"+
							"<td>"+topBid+"</td>");
				
				out.print("</tr>");
			}
			
			stmt.close();		
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		%>
	</table>
	<br>
	
	<h1>Completed auctions</h1>
	
	<table style="width:30vw; ">
		<tr style="text-align: left">
			<th>Auction</th>
			<th>Seller</th>
			<th>Item</th>
			<th>Winner</th>
		</tr>
		
		<%
		try {
			// Retrieve completed auction info: auction_id, model_name, seller_id, winner
			String qry =	"SELECT a.auction_id, i.model_name, a.seller_id, a.winner "+
							"FROM auctions a "+
							"INNER JOIN items i ON i.item_id = a.item_id "+
							"WHERE a.winner <> '' "+
							"OR a.winner IS NOT NULL ";
			Statement stmt = con.createStatement();
			ResultSet res = stmt.executeQuery(qry);
			
			while (res.next()) {
				out.print("<tr>");
				
				int auctionID = res.getInt("auction_id");
				String modelName = res.getString("model_name");
				String sellerID = res.getString("seller_id");
				String winner = res.getString("winner");
				
				// if winner is "f" then completed auction with no winner
				if (winner.equals("f")) { winner = "No winner"; }
				
				out.print(	"<td>"+auctionID+"</td>"+
							"<td>"+sellerID+"</td>"+
							"<td>"+modelName+"</td>"+
							"<td>"+winner+"</td>");
				
				out.print("</tr>");
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		%>
	</table>

<% db.closeConnection(con); %>
</body>

</html>