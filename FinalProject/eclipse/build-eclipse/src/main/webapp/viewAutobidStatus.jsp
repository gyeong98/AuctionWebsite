<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Your Automatic Bidding Status</title>
<%@ include file="autobidprogram.jsp" %>
<%@ include file="check-winners.jsp" %>
</head>
<body>
<h1><a href='autobidRequest.jsp'> Start an Autobid!</a></h1>
<br> 
<%
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	String user = (String) session.getAttribute("user");
%>
<h1>Your Autobid Auctions</h1>
	
	<table style="width:100vw; ">
		<tr style="text-align: left">
			<th>Auction</th>
			<th>Seller</th>
			<th>Item</th>
			<th>Top Bid</th>
			<th>Winner</th>
			<th>Alert</th>
		</tr>
<%
//list of auction the user set autobid with
	try {
		Statement st = con.createStatement();
		String abqry = "SELECT a.auction_id, i.model_name, a.seller_id, "+ 
				"a.highest_current_bid, a.winner, b.bid "+
				"FROM items i, auctions a, makes_bid b " +
				"WHERE i.item_id = a.item_id " +
				"AND a.auction_id = b.auction_id " +
				"AND b.buyer_id = '" + user + "' " +
				"AND b.is_auto_bid = true " +
				"AND b.bid_time = (SELECT MAX(b2.bid_time) "+
					"FROM makes_bid b2 "+
                    "WHERE b2.buyer_id = '" + user + "' "+
                    "AND b2.auction_id = b.auction_id) ";
		
		ResultSet r = st.executeQuery(abqry);

		while (r.next()) {
			out.print("<tr>");
			
			int aid = r.getInt("auction_id");
			String modelName = r.getString("model_name");
			String seller = r.getString("seller_id");
			Float topbid = r.getFloat("highest_current_bid");
			//user id who won the auction, if null then it is not ended 
			String aStatus = r.getString("winner");
			//alert message for this buyer if someone bid higher than their upper limit
			String alert = "None"; 
			
			// if winner is "f" then auction is ended with no winner
			if (aStatus.equals("f")) { 
				aStatus = "No winner"; 
			}else if (aStatus.equals("") || aStatus == null){
				aStatus = "Ongoing";  //no winners yet
				if (r.getFloat("bid") != topbid){ 
					alert = "Someone bids more than your upper limit!";
				}
			}else if (!aStatus.equals(user)){
				
			}
			out.print(	"<td>"+aid+"</td>"+
						"<td>"+seller+"</td>"+
						"<td>"+modelName+"</td>"+
						"<td>"+topbid+"</td>"+
						"<td>"+aStatus+"</td>"+
						"<td>"+alert+"</td>");
			out.print("</tr>");
		}
		st.close();
		
	}catch (Exception e) {
		e.printStackTrace();
	}
%>
<% db.closeConnection(con); %>
</table>
<a href='profile.jsp'> Back to Profile</a>
</body>
</html>