<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>

	<meta charset="UTF-8">
	<title>CS 336: Make bid</title>
	
	<%
	// Connect to DB
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	%>

	
</head>



<body style='font-family: sans-serif'>

	<a href='make-bid.jsp'>Back</a>
	<hr><br>
	
	<%
	/* Pull required auction & item info */
	// Retrieve selected auction
	String strAuctionID = request.getParameter("auctions");
	int tempAucID = (Integer) session.getAttribute("tempAucID");
	
	Boolean failed = false;
	if (tempAucID == -1 && strAuctionID.equals("")) { 
		failed = true; 
		session.setAttribute("selectFail", true);
		response.sendRedirect("make-bid.jsp");
	}
	else {
		int auctionID;
		if (tempAucID == -1) { 
			auctionID = Integer.parseInt(strAuctionID); 
			session.setAttribute("tempAucID", auctionID); 
		}
		else { auctionID = tempAucID; }
		
		// Retrieve all info on auction
		Statement stmt = con.createStatement();
		String qry_fragment = 	"SELECT a.seller_id, a.expires, a.starting_price, a.buy_now_price, a.min_increment, highest_current_bid, "+
									"i.model_name as 'Model name', i.manufacturer as 'Manufacturer', i.num_Strings as 'No. of strings', "+
									"g.* "+
								"FROM auctions a "+
								"INNER JOIN items i ON a.item_id = i.item_id ";
		String qry_this =	"WHERE a.auction_id = "+auctionID;
		
		// Retrieved info of isa based on item in auction
		String qry_eg =	"INNER JOIN electric_guitar g ON a.item_id = g.item_id ";
		ResultSet res = stmt.executeQuery(qry_fragment + qry_eg + qry_this);
		if (!res.next()) {
			String qry_ag = "INNER JOIN acoustic_guitar g ON a.item_id = g.item_id ";
			res = stmt.executeQuery(qry_fragment + qry_ag + qry_this);
			if (!res.next()) {
				String qry_aeg = "INNER JOIN acoustic_electric_guitar g ON a.item_id = g.item_id ";
				res = stmt.executeQuery(qry_fragment + qry_aeg + qry_this);
				res.next();
			}
		}
		
		// List info of auction
		String itemName = res.getString("Model name");
		String manufacturer = res.getString("Manufacturer");
		out.print("<h1 style='line-height:2px;'>"+manufacturer+" "+itemName+"</h1>");							// Item name
		
		String sellerName = res.getString("seller_id");
		out.print("<h3>Auctioned by: "+sellerName+"</h3>");			// By seller
		
		
		out.print("<table>");
		
		out.print("<tr><td><b>Auction details:</b></td></tr>");
		
		java.sql.Timestamp expires = res.getTimestamp("expires");	// Auction expiration date
		out.print("<tr><td>Auction expires on: </td><td>"+expires+"</td></tr>");
		
		float startPrice = res.getFloat("starting_price");
		out.print("<tr><td>Starting price: </td><td>$ "+startPrice+"</td></tr>");
		
		float buyoutPrice = res.getFloat("buy_now_price");
		out.print("<tr><td>Buyout price: </td><td>$ "+buyoutPrice+"</td></tr>");
		
		// current highest bid is a little special because it is actually a calculated attribute
		float topBid = 0;
		String qryHighest = "SELECT max(m.bid) top_bid "+
							"FROM makes_bid m "+
							"WHERE m.auction_id = "+auctionID+" "+
							"GROUP BY m.buyer_id "+
							"ORDER BY top_bid desc "+
							"LIMIT 1 ";
		Statement stmtHighest = con.createStatement();
		ResultSet resHighest = stmtHighest.executeQuery(qryHighest);
		if (resHighest.next()) { topBid = resHighest.getFloat("top_bid"); }
		out.print("<tr><td>Current highest bid: </td><td>$ "+topBid+"</td></tr>");
		
		//float topBid1 = res.getFloat("highest_current_bid");
		//out.print("<tr><td>Current highest bid: </td><td>$ "+topBid1+"</td></tr>");
		
		float minIncr = res.getFloat("min_increment");
		out.print("<tr><td>Minimum increment: </td><td>$ "+minIncr+"</td></tr>");
		
		// Extra details from isa
		out.print("<tr><td><b>Other details:<b></td></tr>");
		
		int arbDataCount = 7; // Arbitrary data after 6th column
		int arbDataBound = res.getMetaData().getColumnCount();
		for (; arbDataCount <= arbDataBound; arbDataCount++) {
			String colName = res.getMetaData().getColumnLabel(arbDataCount);
			String colVal = res.getString(arbDataCount);
			
			if (colName.equals("item_id")) { continue; }
			out.print("<tr><td>"+colName+": </td><td>"+colVal+"</td></tr>");
		}
		
		out.print("</table>");
	
	%>
	
	<br>
	<form method="POST" action="make-bid-parse.jsp">
		<table>
			<%
			/* Display user's current bid */
			// If user has no bid, display nothing
			// If user has bid, display under
			
			// Get resultset from makes_bid table
			String user = (String) session.getAttribute("user");
			
			Statement stmtBidCheck = con.createStatement();
			String qryBidCheck = 	"SELECT max(bid) top_bid "+
									"FROM makes_bid m "+
									"WHERE buyer_id = '"+user+"' "+
									"AND auction_id = "+auctionID;
			ResultSet resBidCheck = stmtBidCheck.executeQuery(qryBidCheck);
			
			// If bid, show. Else, say none
			out.print(	"<tr>"+
						"<td>Your current bid: </td>"+
						"<td>");
			
			if (resBidCheck.next()) { 
				float topBidCheck = resBidCheck.getFloat("top_bid");
				out.print("$ "+topBidCheck);
			}
			else { out.print("No bid"); }
			
			out.print("</td></tr>");
			%>
			<tr>
				<td>Place a bid: $</td>
				<td><input type='number' name='newBid' placeholder='0'/></td>
				<%
				// Check if failure
				Boolean bidFail = (Boolean) session.getAttribute("bidFail");
				if (bidFail) { out.print("<td><p style='color:red;'>*Invalid bid</p></td>"); }
				session.setAttribute("bidFail", false);
				
				//Check if success
				Boolean bidSuccess = (Boolean) session.getAttribute("bidSuccess");
				if (bidSuccess) { out.print("<td><p style='color:green;'>Bid successfully placed!</p></td>"); }
				session.setAttribute("bidSuccess", false);
				%>
			</tr>
			<tr>
				<td></td>
				<td><input type='submit' value='Bid' style='width:100%' /></td>
			</tr>
		</table>
	</form>
	
	<% } db.closeConnection(con); %>
</body>
</html>