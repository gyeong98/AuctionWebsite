<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Automatic Bidding DB Setup</title>
</head>
<body>
<br> 
<% 
	try {
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
			//get the user_id, auction_id
			int aid = Integer.parseInt(request.getParameter ("auctions"));
			out.println("<br>Auction ID: " + aid);
			String uid = (String)session.getAttribute("user");
			out.println("<br>Your ID: " + uid);
			
			//retrieve upperlimit
			float uplim = Float.parseFloat(request.getParameter("upperlimit"));
			out.println("<br>Your secret upper limit: " + uplim);
			
			//retrieve bid_increment
			float increment = Float.parseFloat(request.getParameter("bid_increment"));
			out.println("<br>Increse by:" + increment);
			
			//get date and time
			java.util.Date date = new java.util.Date();
			java.sql.Timestamp sqldate = new java.sql.Timestamp(date.getTime()); 
			SimpleDateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			out.println("<br>Date: " + dateformat.format(sqldate));
			
			Statement stmt = con.createStatement();
			
			//pull info from auction: "min_increment", "starting_price", "highest_current_bid", "buy_now_price"
			String qry = "SELECT min_increment, buy_now_price, highest_current_bid, starting_price " +
					" FROM auctions " +
					" WHERE auction_id = " + aid;
			ResultSet res = stmt.executeQuery(qry);
			float curr_bid = 0; //store values for later calculation
			float buynowPrice = 0;
			float startp = 0;
			boolean badinput = false;
					
			if (res.next()){
				curr_bid = res.getFloat("highest_current_bid"); //store highest current bid from the auction
				//check whether increment and Upperlimit is valid
				if (increment < res.getFloat("min_increment")){
					out.print("<br><br> The minimum increment is " + res.getFloat("min_increment"));
					out.println("<br>Your automatic increment value is less than minimum increment, Please enter a valid input.");
					badinput = true;
				} 
				if (uplim < res.getFloat("starting_price")){
					out.print("<br><br> The starting price is " + res.getFloat("starting_price"));
					out.print("<br> Your uppper limit is less than the starting price set by the seller. Please enter a valid number.");
					badinput = true;
				} 
				if (uplim <= curr_bid){
					out.print("<br><br> The highest current bid is " + curr_bid);
					out.print("<br> Your uppper limit must be higher than the highest current bid. Please enter a valid number.");
					badinput = true;
				}
				if (badinput){
					out.print("<br> <a href = autobidRequest.jsp>Try again</a>");
				}
				buynowPrice = res.getFloat("buy_now_price");
				startp = res.getFloat("starting_price");
				//
			}
			
			if (!badinput){
				boolean update_auction_table = false;
				
				if (curr_bid < startp){ //nobody makes a bid on this auction yet. So autoamtically bid with starting price.
					curr_bid  = startp;
					update_auction_table =true; 
				}else {
					//get the most recent bid on this auction made by this user
					qry = "SELECT * FROM makes_bid WHERE buyer_id = '"+ uid + "' " + 
						"AND auction_id = " + aid + " " + 
						"AND bid_time = (SELECT MAX(b.bid_time) FROM makes_bid b WHERE b.buyer_id = '"+ uid +"' AND b.auction_id = auction_id)" ;

					res = stmt.executeQuery(qry);
					
					//if the user has not bid on this auction before 
					//or the highest bid is not made by the user
					//make new bid while insertion and update the highest current bid

					if (!res.next() || !(curr_bid == res.getFloat("bid"))){
						//calculate new bid according to the increment
						curr_bid += increment;  
						update_auction_table =true; 
						
						if (curr_bid > uplim){
							curr_bid = uplim; //if reach the upper limit then set to upperlimit
						}
					}
				}
				
				
				//insert the autobid to makes_bid
				//(buyer_id, auction_id, bid_time, bid, is auto bid, bid max, auto_bid_increment)
				qry = "INSERT INTO makes_bid VALUES (?,?,?,?,?,?,?)";
				PreparedStatement prst = con.prepareStatement(qry);
				prst.setString(1,uid);//buyer_id
				prst.setInt(2,aid);//auction_id
				prst.setTimestamp(3,sqldate); //bid_time
				prst.setFloat(4,curr_bid); //bid
				prst.setBoolean(5, true);//is auto bid
				prst.setFloat(6,uplim);//bid max
				prst.setFloat(7,increment);//auto_bid_increment
				prst.executeUpdate();
				
				//update Auction table
				if (update_auction_table){
					qry = "UPDATE auctions SET highest_current_bid = " + curr_bid + " WHERE auction_id = "+ aid;
					stmt.executeUpdate(qry);
					
				}
				String bidqry = "SELECT * FROM makes_bid WHERE buyer_id = '"+ uid + "' " + 
						"AND auction_id = " + aid + " " + 
						"AND bid_time = (SELECT MAX(b.bid_time) FROM makes_bid b WHERE b.buyer_id = buyer_id AND b.auction_id = auction_id)" ;
				res = stmt.executeQuery(bidqry);
				
				if (res.next()){
					out.print("<br> A bid of " + res.getFloat("bid") + " is just made.");
					out.print("<br>Now you have the highest bid. ");
				}
				
				out.println("<br>You're all set!");
				
				out.println("<br><a href='my-auctions.jsp'>View All My Auctions</a>");
				out.println("<br><a href='viewAutobidStatus.jsp'>View Autobids only</a>");
				out.println("<br><a href='profile.jsp'>Back to My Profile</a>");
			}
			
			stmt.close();
			db.closeConnection(con);
			} catch (Exception e) {
				e.printStackTrace();
		}
%>
</body>
</html>