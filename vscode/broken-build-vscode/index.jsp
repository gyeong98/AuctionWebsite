<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Auction: Login</title>
</head>
	
<body>
	
	<a href="..">Back</a>
	
	<hr><br>

	<div class="login-widget" style="font-family: sans-serif; padding-left: 10px; border-left: 5px solid blue;">
		<h2>Login</h2>
		<form method="POST" action="login.jsp">
			<table>
				<tr>
					<td><b>Username:</b></td>
					<td><input type="text" name="id"></td>
				</tr>
				<tr>
					<td><b>Password:</b></td>
					<td><input type="password" name="pw"></td>
				</tr>
			</table>
			<input type="submit" value="Sign in">
		</form>
		<br>
		<a href="register-page.jsp">Don't have an account? Register</a>
	</div>

	<br>
	
</body>
</html>