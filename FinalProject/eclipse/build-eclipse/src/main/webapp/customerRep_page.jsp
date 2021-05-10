<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">

<title> Customer Representative functions </title>


</head>

<body>
	 <h1>Customer Representative View</h1>
	 <a href="home.jsp">Home</a><br>
	<a href="profile.jsp">profile</a>
	<br><br>
	<a href='logout.jsp'>Logout</a>
	<hr><br>
	

	<b>Respond to help requests</b>	
	<form method = "post" action = "getHelpTickets.jsp"> <!---Get/view help tickets and requests--->
	<input type = "submit" value = "get tickets">
	</form>
	
	
	<br>
	<br>
	
	
	<b>Change a user's username</b>	
	<form method = "post" action = "updateUsername.jsp"> <!---change a user's username--->
		<table>
		<tr>
		<td>Original username: </td> <td><input type="text" name="originalUsername"></td>
		</tr>
		
		<tr>
		<td>New Username: </td> <td><input type="text" name="newUsername"></td>
		</tr>
		</table>
	<input type = "submit" value = "update username">
	</form>
	
	<br>
	
	<b>Change a user's password</b>	
	<form method = "post" action = "updatePassword.jsp"> <!---change a user's password--->
		<table>
		<tr>
		<td>Target user: </td> <td><input type="text" name="user_changePW"></td>
		</tr>
		
		<tr>
		<td>New/temp password: </td> <td><input type="text" name="newPassword"></td>
		</tr>
		</table>
	<input type = "submit" value = "update password">
	</form>
	
	
	
	<br>
	<br>
	
	
	
	<b>Delete Auction</b>
	<form method = "post" action = "deleteItem.jsp"><!---Delete an illegal/disallowed auction--->
		<table>
		<tr>
		<td>seller name:</td><td><input type="text" name="del_auction_seller"></td>
		</tr>
		
		<tr>
		<td>Auction ID:</td><td><input type="text" name="del_auction_ID"></td>
		</tr>
		</table>
	<input type = "submit" value = "Delete Auction">
	</form>
	
	
	<br>
	<br>
	
	<b>Delete A Particular Bid</b>
	<form method = "post" action = "deleteBid.jsp"><!---Delete a bid--->
		<table>
		<tr>
			<td>bidder name: </td><td><input type="text" name="bidder"></td>
		</tr>
		<tr>
			<td>auction id: </td><td><input type="text" name="auction_ID_b"></td>
		</tr>
		<tr>
			<td>timestamp (datetime, CaSE SeNSiTiVe): </td><td><input type="text" name="bid_timestamp"></td>
		</tr>
		</table>
	<input type = "submit" value = "Delete a particular bid">
	</form>
	<p><b>Datetime format:</b>   YYYY-MM-DD HH:MM:SS</p>
	
	
	<br>
	<br>
	
	
	<b>Delete/Ban user</b>
	<form method = "post" action = "banUser.jsp"><!---Delete a bid--->
		<table>
		<tr>
			<td>Username: </td><td><input type="text" name="targetUsername"></td>
		</tr>
		<tr>
			<td>Retype username: </td><td><input type="text" name="retypedUsername"></td>
		</tr>
		<tr>
			<td>YOUR username: </td><td><input type="text" name="rep_name"></td>
		</tr>
		<tr>
			<td>YOUR password: </td><td><input type="text" name="rep_pw"></td>
		</tr>
		</table>
	<input type = "submit" value = "Delete/ban user">
	</form>	
	
	
	
	
	
</body>
</html>