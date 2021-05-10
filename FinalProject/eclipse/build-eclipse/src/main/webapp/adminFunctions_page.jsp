<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">

<title> Admin functions </title>


<!---
TODO: sales reports by:
	user
	item
	item type
	best selling users
	best selling items
--->

</head>

<body>
	<a href="home.jsp">Home</a>
	<br><br>
	<a href="profile.jsp">Profile</a>
	<br><br>
	<a href='logout.jsp'>Logout</a>
	<h1> Admin Only Functions</h1>
	<hr><br>
	
	<b>Create New Representative Account</b>
	<form method = "post" action = "createNewRep.jsp"> <!---Create representative account--->
		<table>
			<tr>
				<td>Create Rep Username:</td><td><input type="text" name="NewRepUsername"></td>
			</tr>
			
			<tr>
				<td>Create Rep Password:</td><td><input type="password" name="newRepPassword"></td>
			</tr>
			<tr>
				<td>Rep Email:</td><td><input type="text" name="email"></td>
			</tr>
		</table>
	<input type = "submit" value = "Create Account">
	</form>
	<br>
	<b>WARNING: Typing in just a username that already exists will promote that user to Customer Representative</b><br>
	<b>ONLY DO THAT IF ABSOLUTELY NECESSARY</b>
	
	<br>
	<br>
	<br>
	<br>
	
	<b>Generate sales reports:</b>
	<form method='POST' action='salesReport.jsp'>
	<input type="submit" value="Generate Sales Report"></form> <!---Get total sales--->
	
	<br>
	<br>

	<b>Get Total of Purchases of User</b>
	<form method = "post" action = "getUserPurchases.jsp"> <!---get purchases of specific user--->
		<table>
			<tr>
				<td>Username: </td><td><input type="text" name="userPurchasesName"></td>
			</tr>
		</table>
	<input type = "submit" value = "get purchase history">
	</form>

	<br>
	<br>
	
	<b>Get Total of Sales of User</b>
	<form method = "post" action = "getUserSales.jsp"> <!---get sales of specific user--->
		<table>
			<tr>
				<td>Username: </td><td><input type="text" name="userSalesName"></td>
			</tr>
		</table>
	<input type = "submit" value = "get sale history">
	</form>
	
	<br>
	<br>
	
	<br>
	<br>
	
</body>
</html>