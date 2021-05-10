<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<%
// Connect to DB
ApplicationDB newDB = new ApplicationDB();	
Connection newcon = newDB.getConnection();

//date and time
java.util.Date date = new java.util.Date();
java.sql.Timestamp time = new java.sql.Timestamp(date.getTime()); 
%>
<%!
//functions
public float checkUpperLimit (float uplimit, float bid){
	if (bid > uplimit){
		return uplimit;
	}
	return bid;
}
%>

<% 
try {
	
	Statement newst = newcon.createStatement();
	
	//query string used to retrive info 
	String qry = "";
	//prepared update qry for updates
	String updateqry = "UPDATE auctions SET highest_current_bid = ? WHERE auction_id = ?";
	//query for insertion 
	String insert_qry = "INSERT INTO makes_bid VALUES (?,?,?,?,?,?,?)";	
			
	PreparedStatement pst = newcon.prepareStatement(qry);
			
	//retrieve list of auctions id that has autobid set up
	qry = "SELECT DISTINCT a.auction_id "+
			"FROM auctions a, makes_bid b "+
			"WHERE (a.winner = '' OR a.winner IS NULL) "+
			"AND a.auction_id = b.auction_id "+
			"AND b.is_auto_bid = true "+
			"GROUP BY a.auction_id";
	ResultSet r = newst.executeQuery(qry);
	
	//list of auction with users have autobid
	List<Integer> aidlist = new ArrayList<Integer>();
	while (r.next()){
		aidlist.add(r.getInt("auction_id"));
	}

	for (int i = 0; i < aidlist.size(); i++){
		int aid = aidlist.get(i);
		//list setting info of autobid users 
		//(exclude any one who has upperlimit less than highest currernt bid) 
		qry = "SELECT b.buyer_id, b.auto_bid_increment, b.bid_max, a.highest_current_bid, b.bid "+
				"FROM makes_bid b, auctions a "+
				"WHERE b.auction_id = "+ aid +
				" AND a.auction_id = "+ aid +
				" AND is_auto_bid = true " +
				"AND a.highest_current_bid < b.bid_max "+
				"AND b.bid_time = (SELECT MAX(b2.bid_time) FROM makes_bid b2 " +
						" WHERE b2.buyer_id = b.buyer_id AND b2.auction_id = " + aid +" )";
		r = newst.executeQuery(qry);
		
		
		float inc = 0; 
		float max = 0; 
		float finalbid = 0;
		int c = 0; //counter
		String uid = ""; //whose autobid is activated
		boolean update = false;
		
		while (r.next()){
			c++;
			float bid = r.getFloat("bid"); 
			float tempmax = r.getFloat("bid_max"); //current user in loop
			float tempinc = r.getFloat ("auto_bid_increment"); 
			
			if (c == 1){//first user in list
				//or if there is only one who set autobid
				float curr = r.getFloat("highest_current_bid");
				if (bid < curr){//curr not made by the user
					finalbid = curr + tempinc; 
					finalbid = checkUpperLimit(tempmax, finalbid); //(upperlimit, bid)
					inc = tempinc; 
					max = tempmax;
					uid = r.getString("buyer_id");
					update = true;
				}
			}else {
				//more than 1 user
				//compare the upperlimits with previous user, 
				//the one who has higher upperlimit will be stored
				
				if (tempmax > max){ //current user has higher upperlimit
					//new bid is the lesser upperlimit + auto increment from current user
					finalbid = max + tempinc; 
					finalbid = checkUpperLimit(tempmax, finalbid); //check if it reaches the upperlimit
					max = tempmax;//update to current user's
					inc = tempinc; 
					uid = r.getString("buyer_id");
					update = true;
				}else { //if current user has less upperlimit than previous user
					//the bid is updated to (current user's upperlimit + previous user's increment)
					finalbid = tempmax + inc; 
					finalbid = checkUpperLimit(max, finalbid);
				}
				
			}
		}
		
		if (update){
			pst = newcon.prepareStatement(insert_qry);
			pst.setString(1,uid);//buyer_id
			pst.setInt(2,aid);//auction_id
			pst.setTimestamp(3,time); //bid_time
			pst.setFloat(4,finalbid); //bid
			pst.setBoolean(5, true);//is auto bid
			pst.setFloat(6,max);//bid max
			pst.setFloat(7,inc);//auto_bid_increment
			pst.executeUpdate();
			
			pst = newcon.prepareStatement(updateqry);
			pst.setFloat(1,finalbid);//highest_current_bid
			pst.setInt(2, aid);
			pst.executeUpdate();
		}
	}
	
	newDB.closeConnection(newcon);
	
}catch (Exception e) {
		e.printStackTrace();
	}

%>
