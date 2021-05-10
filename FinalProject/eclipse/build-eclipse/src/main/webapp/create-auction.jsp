<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
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
		// Connect to DB
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		String qry;
		
		// Get session info
		String uid = (String) session.getAttribute("user");
		
		/* Details necessary to set an auction */
		/* Fields: seller_id, item_id, 
			start_time, expire, 
			start_price, hidden_price (minimum bid threshold), buy_now_price, 
			min_incr, highest_curr_bid, 
			winner 
		*/
		out.print("<form method='POST' action='create-auction-parse.jsp'>");
		out.print("<table>");
		
		
		// List of all items
		out.print("<tr>");
		
		qry = "SELECT * FROM items";
		ResultSet items = stmt.executeQuery(qry);
		
		out.print("<td style='text-align:right'><label for='items'>Item</label></td>");
		
		out.print("<td><select name='item'>");
		
		out.print("<option value=''></option>");
		while (items.next()) {
			String itemName = items.getString("model_name");
			String itemID = items.getString("item_id");
			
			out.print("<option value='"+itemID+"'>"+itemName+"</option>");
		}
		out.print("</select></td>");
				
		Object strItemFail = session.getAttribute("itemFail");
		Boolean itemFail = (Boolean) strItemFail;
		if (itemFail) { out.print("<td><p style='color:red;'>*Item is required.</p></td>"); }
		
		out.print("</tr>");

		out.print("<tr><td></td><td><a href='add-item.jsp'>Item not here? Add one.</a></td></tr>");
		
		// Set time limit
		out.print("<tr>");
		
		out.print("<td style='text-align:right'><label for='expires'>Expires</label></td>");
		out.print("<td><input type='date' name='exp_date'/><input type='time' name='exp_time'></td>");
		
		Object strExpFail = session.getAttribute("expFail"); 
		Boolean expFail = (Boolean) strExpFail;
		if (expFail) { out.print("<td><p style='color:red;'>*Expiration date (not time) is required.</p></td>"); }

		out.print("</tr>");
		
		// Set starting price
		out.print("<tr>");
		
		out.print("<td style='text-align:right'><label for='start-price'>Base price $</label></td>");
		out.print("<td><input type='number' name='start_price' placeholder='0'/></td>");
		
		out.print("</tr>");
		
		
		// Set (hidden) minimum threshold for auction
		out.print("<tr>");
		
		out.print("<td style='text-align:right'><label for='hidden-price'>Minimum bid threshold (hidden) $</label></td>");
		out.print("<td><input type='number' name='hidden_price' placeholder='0'/></td>");
		
		out.print("</tr>");
		
		
		// Set buyout price
		out.print("<tr>");
		
		out.print("<td style='text-align:right'><label for='buyout-price'>Buyout price $</label></td>");
		out.print("<td><input type='number' name='buyout_price' placeholder='0'/></td>");
		
		out.print("</tr>");
		
		
		// Set minimum increment
		out.print("<tr>");
		
		out.print("<td style='text-align:right'><label for='min-incr'>Minimum increment $</label></td>");
		out.print("<td><input type='number' name='min_incr' placeholder='0'/></td>");
		
		out.print("</tr>");
		
		
		// Submit
		out.print("<tr><td></td><td><input type='submit' value='Create auction'</td></tr>");
		
		out.print("</form>");
		
		//set attributes for pages related to this page
		session.setAttribute("itemAdded", false); 			//item added to db
		
    	session.setAttribute("modelNameFail", false);		//modelname is empty
    	session.setAttribute("manufacturerFail", false);	//manufacturer is empty
    	session.setAttribute("numStringsFail", false);		//numstrings is empty
    	
    	session.setAttribute("elPickupConfigFail", false);	//acoustic fail
    	session.setAttribute("acelPickupTypeFail", false);//acoustic-electric fail

		
		db.closeConnection(con);
	%>
</body>

</html>