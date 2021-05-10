<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Remove Item</title>
	
</head>
<body>
	<h1>Delete Illegal Auction</h1>
	<%
	try{
	
		ApplicationDB db = new ApplicationDB();
		Connection conn = db.getConnection();
		PreparedStatement deleteFromAuct = conn.prepareStatement("DELETE FROM auctions WHERE auction_id = ? AND seller_id=?");
	
		
		//get seller and auction id
		String auctioner_ID = request.getParameter("del_auction_seller");
		
		if(auctioner_ID.length() > 63){
			auctioner_ID = auctioner_ID.substring(0,62);
		}
		
		String illeg_auc_ID = request.getParameter("del_auction_ID");
		int illeg_auc = Integer.parseInt(illeg_auc_ID); //parse item id to integer
		
		
		//DELETE from following tables: auctions, auction_info and bids
		deleteFromAuct.setInt(1, illeg_auc);
		deleteFromAuct.setString(2, auctioner_ID);	
	
		
		////////////////Delete from the bids table BEFORE deleting the auction itself////////////////////////////
		PreparedStatement deleteFromBids = conn.prepareStatement("DELETE FROM makes_bid WHERE auction_id = ?");
		deleteFromBids.setInt(1, illeg_auc);
		
		deleteFromBids.executeUpdate();
		
		//If there are no bids for that auction or if the auction does not exist then this is probably still fine
		/////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		int numDeleted = deleteFromAuct.executeUpdate(); //NOW deletes it from auctions
		
		if(numDeleted < 1){
			
			out.println("No such item with that id and/or by that seller");
			//that item didnt exist in auctions table
			//dont bother with the other tables if it isnt in the auctions table
			
			
		}else{
		
			/*PreparedStatement deleteFromAucInfo = conn.prepareStatement("DELETE FROM auction_info WHERE auction_id = ?");
			deleteFromAucInfo.setInt(1, illeg_auc);
			
			deleteFromAucInfo.executeUpdate();*/
			
			
			
			out.print("Deleted from auctions, makes_bid |      #" + illeg_auc + ", by " + auctioner_ID);
			
		}
		
		conn.close();
	
	} catch (Exception e) {
            out.print(e);
	}


	%>


</body>
</html>