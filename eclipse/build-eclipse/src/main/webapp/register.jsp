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

	<div class="register-widget" style="font-family: sans-serif; padding-left: 10px; border-left: 5px solid blue;">
		<h2>Register</h2>
		<form method="POST" action="register-check.jsp">
			<table>
				<tr>
					<td><label for='username'><b>Username:</b></label></td>
					<td><input type="text" name="username"></td>
				</tr>
				<tr>
					<td><label for='password'><b>Password:</b></label></td>
					<td><input type="password" name="password"></td>
				</tr>
				<tr>
					<td><label for='email'><b>Email:</b></label></td>
					<td><input type="text" name="email"></td>
				</tr>
			</table>
			<input type="submit" value="Register account">
		</form>
		<br>
		<a href="login.jsp">Already have an account? Login</a>
	</div>

	<br>
	
</body>
</html>