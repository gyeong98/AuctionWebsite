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
			Connection gus_con = db.getConnection();	
			
			PreparedStatement totalSales = gus_con.prepareStatement("SELECT SUM(highest_current_bid) AS total_sales FROM auctions a JOIN items i ON i.item_id = a.item_id WHERE winner <> '' AND seller_id = ?");
			
			String targetUser = request.getParameter("userSalesName");
			targetUser = targetUser.replaceAll(" ", "");
			totalSales.setString(1, targetUser);
			
			ResultSet gus = totalSales.executeQuery();
			
			if( !gus.isBeforeFirst() ){
				
				out.print("No sales data for specified user");
				//do not bother getting purchase history if it reaches this part
						
						
			}else{
				
				gus.next();
				double totalEarned = gus.getDouble("total_sales");
				out.print(targetUser + " has earned a total of : $" + totalEarned + "<br><br>");
				
				
				/*get purchase history*/
				PreparedStatement salesHistory = gus_con.prepareStatement("SELECT a.item_id, i.model_name, a.highest_current_bid AS price FROM auctions a JOIN items i ON i.item_id = a.item_id WHERE winner <> '' AND seller_id = ?");
				salesHistory.setString(1, targetUser);
				
				ResultSet sh = salesHistory.executeQuery();
				
				out.print("<b>Sales history: </b><br>");
				out.print("<b>id | model_name | amount paid</b><br>");
				while(sh.next()){
					
					//String sellerName = sh.getString("seller_id");
					int itemID = sh.getInt("a.item_id");
					String model_name = sh.getString("i.model_name");
					double amount = sh.getDouble("price");
					
					out.print(itemID + ":  " + model_name +  " : $" + amount + "<br>");
					
				}
				out.print("<br>");
				
				sh.close();
				
				
			}
			gus.close();
			
			
			//close the connection.
			gus_con.close();

		} catch (Exception e) {
            out.print(e);
		}
	%>
</body>
</html>