<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>


	<meta charset="UTF-8">
	<title>User History</title>
	
	<%
	session.setAttribute("bidFail", false);
	session.setAttribute("tempAucID", -1);
	session.setAttribute("bidSuccess", false);
	session.setAttribute("selectFail", false);
	%>
	
	<%
	// Connect to DB
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	%>
	
</head>

<body style='font-family: sans-serif'>

	<a href='search_page.jsp'>Back</a>
	<hr><br>
	<h2> History Of A Specific Person </h2>
	<form method="POST" action="history_detail.jsp">
		<table>
			<tr>
				<td><label for='item'>Select Name</label></td>				
				<td><select name='item' onchange='itemCheck(this);'>
					<option value=''></option>
					<%
					/* List all auctions */
					// Username
					
					// Retrieve list of auctions with item info NOT by user
					Statement stmt = con.createStatement();
					String qry = 	"SELECT username "+
									"FROM Users ";
					
					ResultSet res = stmt.executeQuery(qry);
					
					// List auctions
					while (res.next()) {
	
						String username		= res.getString("username");
						
						out.print("<option value='"+username+"'>"+username+"</option>");
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
			<tr>
				<td></td>
				<td><input type="submit" value="Next" style="width:100%;"/></td>
			</tr>
		</table>
	</form>
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	
	<h2> History Of A Specific Auction </h2>
	<form method="POST" action="Individual_Item.jsp">
		<table>
			<tr>
				<td><label for='items'>Select Auction</label></td>				
				<td><select name='items' onchange='itemCheck(this);'>
					<option value=''></option>
					<%
					/* List all auctions */
					// Username
					
					// Retrieve list of auctions with item info NOT by user
				
					String qrys = 	"SELECT A.auction_id, I.model_name  "+
									"FROM Auctions A, Items I "+
									"WHERE A.item_id = I.item_id";
					
					ResultSet ress = stmt.executeQuery(qrys);
					
					// List auctions
					while (ress.next()) {
	
						String itemname		= ress.getString("model_name");
						String itemkey      = ress.getString("auction_id");
						
						out.print("<option value='"+itemkey+"'>"+itemkey+" "+itemname+"</option>");
					}
					%>
				</select></td>
				<%
				Object strSelectFails = session.getAttribute("selectFail");
				Boolean selectFails = (Boolean) strSelectFail;
				if (selectFail) { out.print("<td><p style='color:red;'>*Please select a valid option</p></td>"); }
				session.setAttribute("selectFail", false);
				%>
			</tr>
			<tr>
				<td></td>
				<td><input type="submit" value="Next" style="width:100%;"/></td>
				
			</tr>
		</table>
	</form>
	
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	
	<h2> History Of Item Similar One Month Ago </h2>
	<form method="POST" action="OneMonthLater.jsp">
		<table>
			<tr>
				<td><label for='month'>Select Item</label></td>				
				<td><select name='month' onchange='itemCheck(this);'>
					<option value=''></option>
					<%
					/* List all auctions */
					// Username
					
					// Retrieve list of auctions with item info NOT by user
					
					String qryss = 	"SELECT A.auction_id, I.model_name "+
									"FROM Auctions A, Items I "+
									"WHERE A.item_id = I.item_id";
					
					ResultSet resss = stmt.executeQuery(qryss);
					
					// List auctions
					while (resss.next()) {
	
						String itemnames		= resss.getString("model_name");
						String itemkeys      = resss.getString("auction_id");
						
						out.print("<option value='"+itemkeys+"'>"+itemkeys+" "+itemnames+"</option>");
					}
					%>
				</select></td>
				<%
				Object strSelectFailss = session.getAttribute("selectFail");
				Boolean selectFailss = (Boolean) strSelectFail;
				if (selectFail) { out.print("<td><p style='color:red;'>*Please select a valid option</p></td>"); }
				session.setAttribute("selectFail", false);
				%>
			</tr>
			<tr>
				<td></td>
				<td><input type="submit" value="Next" style="width:100%;"/></td>
	
			</tr>
		</table>
	</form>
	
	
	<br>
	<br>
	<br>
	<br>
	<br>
	<br>
	
	<h2> Setting Up Alerts For Items  </h2>
	<form method="POST" action="Alerts_Users.jsp">
		<table>
			<tr>
				<td><label for='alert'>Select Item</label></td>				
				<td><select name='alert' onchange='itemCheck(this);'>
					<option value=''></option>
					<%
					/* List all auctions */
					// Username
					
					// Retrieve list of auctions with item info NOT by user
					
					String qrysss = 	"SELECT I.model_name "+
									"FROM Items I ";
									
					ResultSet ressss = stmt.executeQuery(qrysss);
					
					// List auctions
					while (ressss.next()) {
	
						String itemnamess		= ressss.getString("model_name");
						
						out.print("<option value='"+itemnamess+"'>"+itemnamess+"</option>");
					}
					%>
				</select></td>
				<%
				Object strSelectFailsss = session.getAttribute("selectFail");
				Boolean selectFailsss = (Boolean) strSelectFail;
				if (selectFail) { out.print("<td><p style='color:red;'>*Please select a valid option</p></td>"); }
				session.setAttribute("selectFail", false);
				%>
			</tr>
			<tr>
				<td></td>
				<td><input type="submit" value="Next" style="width:100%;"/></td>
				<% db.closeConnection(con); %>
			</tr>
		</table>
	</form>


</body>
</html>