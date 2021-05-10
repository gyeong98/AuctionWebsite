<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>

	<meta charset="UTF-8">
	<title>CS 336: All auctions</title>
	
	<%
	session.setAttribute("bidFail", false);
	session.setAttribute("tempAucID", -1);
	session.setAttribute("bidSuccess", false);
	%>
	
	<%
	// Connect to DB
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	%>
	
	<!-- 
	<script>
	function itemCheck(item) {
    	var itemDetails = document.getElementById("itemDetails");
    	itemDetails.innerHTML = "";
    	
	    if (item.value != "") {
	    	//itemDetails.insertAdjacentHTML("beforeend", "test -> ");
	    	itemDetails.insertAdjacentHTML("beforeend", item.value);
	    	
	    	itemDetails.style.display = "block";
	    }
	    else {
	        itemDetails.style.display = "none";
	    }
	}
	</script>
	-->
</head>



<body style='font-family: sans-serif'>

	<a href='my-auctions.jsp'>Back</a>
	<hr><br>
	
	<!-- 
	Make bid: List all auctions 
	
	PATH LOGIC:
		hide all input boxes
		
		<select> of all auctions; once selected: 
			list details of auction RELEVANT TO THE BIDDER
			then reveal input boxes
	-->
	
	<form method="POST" action="make-bid-details.jsp">
		<table>
			<tr>
				<td><label for='auctions'>Select auction</label></td>				
				<td><select name='auctions' onchange='itemCheck(this);'>
					<option value=''></option>
					<%
					/* List all auctions */
					// Username
					String user = (String) session.getAttribute("user");
					
					// Retrieve list of auctions with item info NOT by user
					Statement stmt = con.createStatement();
					String qry = 	"SELECT a.auction_id, a.seller_id, i.model_name, a.winner "+
									"FROM auctions a "+
									"INNER JOIN items i ON a.item_id = i.item_id "+
									"WHERE a.seller_id <> '"+user+"' "+
									"AND a.winner IS NULL "+
									"OR winner = '' ";
					ResultSet res = stmt.executeQuery(qry);
					
					// List auctions
					while (res.next()) {
						int auctionID 		= res.getInt("auction_id");
						String sellerID		= res.getString("seller_id");
						String modelName 	= res.getString("model_name");
						
						out.print("<option value='"+auctionID+"'>"+modelName+" by "+sellerID+"</option>");
					}
					%>
				</select></td>
				<%
				Object strSelectFail = session.getAttribute("selectFail");
				Boolean selectFail = (Boolean) strSelectFail;
				if (selectFail) { out.print("<td><p style='color:red;'>*Please select a valid option</p></td>"); }
				session.setAttribute("selectFail", false);
				%>
			</tr>
			<!-- 
			<tr>
				<td></td>
				<td id="itemDetails"></td>
			</tr>
			-->
			<tr>
				<td></td>
				<td><input type="submit" value="Next" style="width:100%;"/></td>
			</tr>
		</table>
	</form>

<% db.closeConnection(con); %>
</body>
</html>