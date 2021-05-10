<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Update user account info</title>
	
</head>
<body>
	<h1>Change password</h1>
	<%
	try{
	
		ApplicationDB db = new ApplicationDB();
		Connection conn = db.getConnection();
		PreparedStatement setPassword = conn.prepareStatement("UPDATE USERS SET password = ? WHERE username = ?");
	
		
		//get form info
		String origName = request.getParameter("user_changePW");
		if(origName.length() > 63){
			origName = origName.substring(0,62);
		}
		
		String newPassword = request.getParameter("newPassword");
		if(newPassword.length() > 64){
			newPassword = newPassword.substring(0,63);
		}
		
		
		
		setPassword.setString(2, origName);	
		setPassword.setString(1, newPassword);	
		
		int result = setPassword.executeUpdate();
		
		if(result == 1){
			
			out.print("Changed " + origName + "'s password to " + newPassword);
			
		}else if (result==0){
			
			out.print("No account with that username");
			
		}else{
			
			out.print("If you are seeing this message, then there is a super huge problem in the database");
			out.print("Somehow, two or more users have the same username, even though it shouldn't be allowed");
			out.print("And now all of their passwords are the same");
			out.print("It's a good thing this is only a project for a CS class");
		}
		
		
		
		conn.close();
	
	} catch (Exception e) {
            out.print(e);
	}


	%>


</body>
</html>