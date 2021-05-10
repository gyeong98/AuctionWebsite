<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.*"%>
<%@ page import="javax.servlet.*"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="ISO-8859-1">
<title>CS 336: Create Auction</title>
</head>

<body style='font-family: sans-serif'>
	<a href='my-auctions.jsp'>Back</a>
	<hr><br>
	
	<%
		try {
			
		// Connect to DB
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		PreparedStatement aucInfo = null;
	
		
		/* Parse and validate data */
			
		// item (model_name), exp_date, start_price, hidden_price, buyout_price, min_incr
		String strItemID	= request.getParameter("item");				// mandatory
		String expDate		= request.getParameter("exp_date");			// mandatory
		String expTime 		= request.getParameter("exp_time");			// optional
		String startPrice 	= request.getParameter("start_price");		// optional
		String hiddenPrice 	= request.getParameter("hidden_price");		// optional
		String buyoutPrice 	= request.getParameter("buyout_price");		// optional
		String minIncrement = request.getParameter("min_incr");			// optional
				
		boolean failed = false;
		session.setAttribute("expFail", false);
		session.setAttribute("itemFail", false);
		
		// AUCTION_INFO ORDER: 
		// auction_id (null) <- auto, seller_id (varchar), item_id (int),
		// starts (datetime) <- current_timestamp, expires (datetime), 
		// startPrice (float), hiddenPrice (float), buyout (float), minIncr (float), 
		// highestBid (float) <- calculated, winner (varchar) <- calculated
		String qry_aucInfo = "INSERT INTO auctions VALUES (?,?,?,?,?,?,?,?,?,?,?)";
		aucInfo = con.prepareStatement(qry_aucInfo);

		//1 auction_id -> auto incremented int
		aucInfo.setNull(1, java.sql.Types.INTEGER);
		
		//2 seller_id -> user_id
		String username = (String) session.getAttribute("user_id");
		aucInfo.setString(2, username);
		
		//3 item_id -> itemname into item_id
		int itemID = -1;
		if (strItemID.equals("")) {
			session.setAttribute("itemFail", true);
			failed = true;
		} else {
			itemID = Integer.parseInt(strItemID);
			aucInfo.setInt(3, itemID);
		}
		
		//4 starts -> always current datetime
		java.util.Date date = new java.util.Date();
		java.sql.Timestamp sql_now = new java.sql.Timestamp(date.getTime());
		aucInfo.setTimestamp(4, sql_now);
		
		//5.1 expDate		: "" fail! no expiration date selected
		//5.2 expTime		: "" ok.   default 00:00:00
		java.sql.Timestamp sql_expDate = new Timestamp(0);
		
		DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm"); // date parser
		java.util.Date d = new java.util.Date(); // temp date
		
		String exp = expDate + " ";
		if (expDate.equals("")) {
			session.setAttribute("expFail", true);
			failed = true;
		} else {
			if (expTime.equals("")) { exp += "00:00"; }
			else { exp += expTime; }
			//out.print("exp: "+exp);
			
			d = df.parse(exp);
			sql_expDate.setTime(d.getTime());
			//out.print("expdatesql: "+sql_expDate);
			
			aucInfo.setTimestamp(5, sql_expDate);
		}
		
		//6 "start_price"	: "" ok.   default 0
		float sp = 0;
		if (!startPrice.equals("")) { sp = Float.parseFloat(startPrice); }
		aucInfo.setFloat(6, sp);
		
		//7 "hidden_price"	: "" ok.   default nil
		float hp = -1;
		if (hiddenPrice.equals("")) { aucInfo.setNull(7, Types.FLOAT); }
		else {
			hp = Float.parseFloat(hiddenPrice);
			aucInfo.setFloat(7, hp);
		}
		
		//8 "buyout_price"	: "" ok.   default nil
		float bp = -1;
		if (buyoutPrice.equals("")) { aucInfo.setNull(8, java.sql.Types.FLOAT); }
		else {
			bp = Float.parseFloat(buyoutPrice);
			aucInfo.setFloat(8, bp);
		}
		
		//9 "min_incr"		: "" ok.   default 1
		float mi = 1;
		if (!minIncrement.equals("")) { mi = Float.parseFloat(minIncrement); }
		aucInfo.setFloat(9, mi);
		
		//10 highestBid -> null float
		aucInfo.setNull(10, java.sql.Types.FLOAT);
		
		//11 winner -> null varchar
		aucInfo.setNull(11, java.sql.Types.VARCHAR);
		
		/*
		out.print("<h2>"+strItemID+
				" | "+expDate+
				" | "+expTime+
				" | "+startPrice+
				" | "+hiddenPrice+
				" | "+buyoutPrice+
				" | "+minIncrement+
				"</h2>");
		
		out.print("<h2>"+username+
				" | "+itemID+
				" | "+sql_now+
				" | "+sql_expDate+
				" | "+sp+
				" | "+hp+
				" | "+bp+
				" | "+mi+
				"</h2>");
		*/
		
		// if failed, return.
		if (failed) { response.sendRedirect("create-auction.jsp"); }
		
		// check if user is a seller; if not, insert.
		Statement check = con.createStatement();
		String check_qry = "SELECT * FROM sellers s WHERE s.seller_id = '"+username+"'";
		ResultSet check_rs = check.executeQuery(check_qry);
		if (!check_rs.next()) {
			check_qry = "INSERT INTO sellers VALUES ('"+username+"')";
			check.executeUpdate(check_qry);
		}
		check.close();

		aucInfo.executeUpdate();
		
		out.print("<h1>Auction has been created!</h1><a href='my-auctions.jsp'>Go back to My Auctions</a>");
		
	} catch (Exception e) {
		out.print(e);
	}
	%>
</body>
</html>