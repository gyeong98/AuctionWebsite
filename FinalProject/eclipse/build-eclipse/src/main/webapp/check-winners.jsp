<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>

<%
// Connect to thisDB
ApplicationDB thisDB = new ApplicationDB();	
Connection thisCon = thisDB.getConnection();

// Get session info
String thisUser = (String) session.getAttribute("user");
%>

<%
/* Check for auction updates each time this page is loaded */

// Retrieve auctions that do not have winners already
// Retrieve top bid for each auction and bidder info
Statement thisStmt = thisCon.createStatement();
String thisQry =	"SELECT a.auction_id, m.buyer_id, m.bid, a.expires, a.hidden_price, a.buy_now_price "+
					"FROM auctions a "+
					"LEFT OUTER JOIN ( "+
					"	SELECT m.buyer_id, m.auction_id, m.bid "+
					"	FROM makes_bid m "+
					"	INNER JOIN ( "+
					"		SELECT m.auction_id, max(m.bid) top_bid "+
					"		FROM makes_bid m "+
					"		GROUP BY m.auction_id "+
					"	) mm ON m.auction_id = mm.auction_id AND m.bid = mm.top_bid "+
					") m ON m.auction_id = a.auction_id "+
					"WHERE winner IS NULL "+
					"OR winner = '' ";
ResultSet thisRes = thisStmt.executeQuery(thisQry);

// Check for auction end condition
while (thisRes.next()) {
	// Get details
	int auctionID 				= thisRes.getInt("auction_id");
	String buyerID				= thisRes.getString("buyer_id");
	float bid 					= thisRes.getFloat("bid");
	java.sql.Timestamp expires 	= thisRes.getTimestamp("expires");
	float hiddenPrice			= thisRes.getFloat("hidden_price");
	float buyoutPrice			= thisRes.getFloat("buy_now_price");
	
	//out.print(hiddenPrice + " " + buyoutPrice + "<br>");
	
	// Prepare update query
	String updateQry = 	"UPDATE auctions a ";
	String setQry =		"SET a.winner = ";
	String whereQry =	"WHERE a.auction_id = "+auctionID+" ";
	String endQry = 	"";
	
	Statement updateStmt = thisCon.createStatement();
	
	// Check if buyout/expire time has been met
	if (buyoutPrice > 0 && bid >= buyoutPrice) {
		setQry += "'"+buyerID+"' ";
		
		endQry = updateQry + setQry + whereQry;
		updateStmt.executeUpdate(endQry);
	}
	else if (expires.getTime() - new java.sql.Timestamp(System.currentTimeMillis()).getTime() < 0) {
		// if less than hidden price, no winner
		if (bid == 0 || bid < hiddenPrice) { setQry += "'f' "; }
		else { setQry += "'"+buyerID+"' "; }
		
		endQry = updateQry + setQry + whereQry;
		updateStmt.executeUpdate(endQry);
	}
	
	// because of bad schema setup
	thisCon.createStatement().executeUpdate("UPDATE auctions a SET a.highest_current_bid = "+bid+" WHERE a.auction_id = "+auctionID);
}

thisDB.closeConnection(thisCon);
%>
