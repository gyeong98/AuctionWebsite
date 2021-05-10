<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>CS 336: Register</title>
</head>
<body>
	<h1>User purchase history: </h1>
	<hr><br>
	<%
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection gup_con = db.getConnection();	
			
			PreparedStatement totalPurchases = gup_con.prepareStatement("SELECT SUM(highest_current_bid) AS total_purchases FROM auctions a JOIN items i ON i.item_id = a.item_id WHERE winner = ?");
			
			String targetUser = request.getParameter("userPurchasesName");
			targetUser = targetUser.replaceAll(" ", "");
			totalPurchases.setString(1, targetUser);
			
			ResultSet gup = totalPurchases.executeQuery();
			
			if( !gup.isBeforeFirst() ){
				
				out.print("No purchase data for specified user");
				//do not bother getting purchase history if it reaches this part
						
						
			}else{
				
				gup.next();
				double totalSpent = gup.getDouble("total_purchases");
				out.print(targetUser + " has spent a total of : $" + totalSpent + "<br><br>");
				
				
				/*get purchase history*/
				PreparedStatement purchaseHistory = gup_con.prepareStatement("SELECT a.seller_id, a.item_id, i.model_name, a.highest_current_bid AS price FROM auctions a JOIN items i ON i.item_id = a.item_id WHERE winner = ?");
				purchaseHistory.setString(1, targetUser);
				
				ResultSet ph = purchaseHistory.executeQuery();
				
				out.print("<b>Purchase history: </b><br>");
				out.print("<b>Seller | item id | model | amount paid</b><br>");
				while(ph.next()){
					
					String sellerName = ph.getString("seller_id");
					int itemID = ph.getInt("item_id");
					String modelName = ph.getString("i.model_name");
					double amount = ph.getDouble("price");
			
					
					out.print(sellerName + " : " +  itemID + " : " + modelName + " : $" + amount + "<br>");
					
				}
				out.print("<br>");
				
				ph.close();
				
				
			}
			gup.close();
			
			
			//close the connection.
			gup_con.close();

		} catch (Exception e) {
            out.print(e);
		}
	%>
</body>
</html>