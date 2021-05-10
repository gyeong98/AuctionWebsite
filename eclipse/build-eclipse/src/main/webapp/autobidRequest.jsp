<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Set Up Automatic Bidding</title>
</head>
<body>
	<a href='profile.jsp'>Back To Profile</a>
	<br>WElCOME TO AUTOBID PAGE
	<form method = "post" action="autobidSetup.jsp">
		<table>
			<tr>
			<td><label for='auctions'>Select auction</label></td>				
				<td><select name='auctions' onchange='itemCheck(this);'>
					<option value=''></option>
					<%
					// Connect to DB
					ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();

					String user = (String) session.getAttribute("user");
					
					Statement stmt = con.createStatement();
					String qry = "SELECT a.auction_id, a.seller_id, i.model_name, a.min_increment," +
								"a.starting_price, a.highest_current_bid " +
								"FROM auctions a, items i " + 
								"WHERE a.item_id = i.item_id " +
								"AND a.seller_id != '" + user + "' " +
								"AND a.winner = '' ";
					
					ResultSet r = stmt.executeQuery(qry);

					
					// List auctions
					while (r.next()) {
						int aid  = r.getInt("auction_id");
						String seller = r.getString("seller_id");
						String modelName = r.getString("model_name");
						float min_inc = r.getFloat("min_increment");	
						float starting_price = r.getFloat("starting_price");
						float highest_current_bid = r.getFloat("highest_current_bid");
						
						
						out.print("<option value='"+aid+"'>"+ modelName +" by "+seller+
								"  Starting At $" + starting_price + "  Current At: "+ 
								highest_current_bid + "  Minimum Increcement: " + min_inc + "</option>");
					}	
					%>
				</select></td>
			<tr> 
			<td>Enter Your Secret Upper Limit: </td><td><input type="text" name="upperlimit"></td>
			</tr>
			<tr>
			<td>How much you want to increase automatically?</td>
			<td><input type="text" name="bid_increment"></td>
			</tr>
		</table>
		<input type="submit" value="submit">
	</form>
	If you have manually made bid on the selected auction and are on lead, autobid will not make a new bid according to your setting. 
	<%
	stmt.close();
	con.close(); %>
</body>
</html>