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
	
	Boolean failed = false;
	String user = (String) session.getAttribute("user");
	int auctionID = (Integer) session.getAttribute("tempAucID");
	%>
	
</head>



<body style='font-family: sans-serif'>

	<a href='make-bid.jsp'>Back</a>
	<hr><br>
	
	<%
	/* GOAL: Parse bid info and insert into makes_bid table */
	String strBid = request.getParameter("newBid");
	
	if (strBid.equals("")) {
		failed = true;
		session.setAttribute("bidFail", true);
	}
	else {
		float bid = Float.parseFloat(strBid);
		
		/*	
			1 buyer_id (vchar)
			2 auction_id (int)
			3 bid_time (datetime)
			4 bid (float)
			5 is_auto_bid (bool)
			6 bid_max (float)
			7 auto_bid_increment (float)
			8 
		*/
		String qry = "INSERT INTO makes_bid VALUES (?,?,?,?,?,?,?)";
		PreparedStatement stmt = con.prepareStatement(qry);
		
		// First get info on previous bids. Since this is manual, we need to know auto information
		String qryAuto = 	"SELECT * "+
							"FROM makes_bid m "+
							"WHERE buyer_id = '"+user+"' "+
							"AND auction_id = "+auctionID+" "+
							"ORDER BY bid_time DESC LIMIT 1";
		Statement stmtAuto = con.createStatement();
		ResultSet resAuto = stmtAuto.executeQuery(qryAuto);
		
		// If exists, copy info. Otherwise set manual bid defaults
		Boolean isAuto = false;
		float bidMax = 0;
		float autoIncr = 0;
		
		if (resAuto.next()) {
			isAuto = resAuto.getBoolean("is_auto_bid");
			if (isAuto) {
				bidMax = resAuto.getFloat("bid_max");
				autoIncr = resAuto.getFloat("auto_bid_increment");
			}
		}
		
		// Make user a buyer because the DB is horribly built
		Statement check = con.createStatement();
		String check_qry = "SELECT * FROM buyers b WHERE b.buyer_id = '"+user+"'";
		ResultSet check_rs = check.executeQuery(check_qry);
		if (!check_rs.next()) {
			check_qry = "INSERT INTO buyers VALUES ('"+user+"')";
			check.executeUpdate(check_qry);
		}
		check.close();
				
		// Now, let's start inserting values!
		// 1) buyer_id (vchar)
		stmt.setString(1, user);
		
		// 2) auction_id (int)
		stmt.setInt(2, auctionID);
		
		// 3) bid_time (datetime)
		java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
		stmt.setTimestamp(3, now);
		
		// 4) bid (float)
		stmt.setFloat(4, bid);
		
		// 5) is_auto_bid (bool)
		stmt.setBoolean(5, isAuto);
		
		// 6) bid_max (float)
		stmt.setFloat(6, bidMax);
		
		// 7) auto_bid_increment (float)
		stmt.setFloat(7, autoIncr);
		
		// Execute update
		stmt.executeUpdate();
		
		session.setAttribute("bidSuccess", true);
	}
	
	response.sendRedirect("make-bid-details.jsp");
	%>
	
<% db.closeConnection(con); %>
</body>
</html>











