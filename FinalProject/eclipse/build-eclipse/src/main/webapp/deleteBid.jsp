<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Remove bid</title>
	
</head>
<body>
	<h1>Delete a user bid</h1>
	<%
	try{
	
		ApplicationDB db = new ApplicationDB();
		Connection conn = db.getConnection();


		//PreparedStatement testDate = conn.prepareStatement("INSERT INTO Makes_Bid VALUES('')");
		Statement selectFromBids = conn.createStatement();
		//PreparedStatement getItemID = conn.prepareStatement("SELECT FROM Items WHERE model_name=?");
	
		String auction_id_string = request.getParameter("auction_ID_b");
		int auction_id = Integer.parseInt(auction_id_string);
		
		String bidder_id = request.getParameter("bidder");
		//bidder_id = bidder_id.substring(0,62)
		
		String bidtime = request.getParameter("bid_timestamp");
		
		
		
		String selectQuery = "SELECT * FROM Makes_Bid WHERE auction_id =" + auction_id + " AND buyer_id='"+ bidder_id + "' AND bid_time='" + bidtime +"';";
		
		/*deleteFromBids.setInt(1, auction_id);
		deleteFromBids.setString(2, bidder_id);*/
		
		ResultSet retrieved = selectFromBids.executeQuery(selectQuery);
		
		if(!retrieved.isBeforeFirst()){
			
			out.print("No such results when executing this query:");
			out.print(selectQuery);
			
		}else{
			
			String deleteQuery = "DELETE FROM Makes_Bid WHERE auction_id =" + auction_id + " AND buyer_id='"+ bidder_id + "' AND bid_time='" + bidtime +"';";
			
			out.print("Executing following update: <br>");
			out.print(deleteQuery + "<br><br>");
			
			
			retrieved.close();
			
			Statement deleteFromBids = conn.createStatement();
			int deleted = deleteFromBids.executeUpdate(deleteQuery);
			
			out.print("Deleted " + deleted + " bid(s) from: <br>");
			out.print("User: " + bidder_id + "<br>");
			out.print("auction id: " + auction_id + "<br>");
			out.print("timestamp: " + bidtime + "<br>");
			
			/*int item_id = retrieved.getInt("item_id");
			
			//DELETE from following tables: bids
			
			deleteFromBids.setInt(1, item_id);
			deleteFromBids.setInt(2, auction_id);	
			deleteFromBids.setString(3, bidder_id);	
		
			int numDeleted = deleteFromBids.executeUpdate(); //deletes it from makes_auction			
			*/
		}
		
		conn.close();
	
	} catch (Exception e) {
            out.print(e);
	}


	%>


</body>
</html>