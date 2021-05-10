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
	<h1>Change username</h1>
	<%
	try{
	
		ApplicationDB db = new ApplicationDB();
		Connection conn = db.getConnection();
		PreparedStatement setName = conn.prepareStatement("UPDATE USERS SET username = ? WHERE username = ?");
	
		
		//get form info
		String origName = request.getParameter("originalUsername");
		if(origName.length() > 63){
			origName = origName.substring(0,62);
		}
		
		String newName = request.getParameter("newUsername");
		if(newName.length() > 63){
			newName = newName.substring(0,62);
		}
		
		
		Statement checkNewName = conn.createStatement();
		ResultSet newNameCheck = checkNewName.executeQuery("SELECT username FROM users WHERE username= '" + newName + "';");
		
		
		if( newName.equals(origName) ){
			
			out.print("New username is the same");
			
		}else if(newNameCheck.isBeforeFirst() == true){
			
			out.print("New username already taken");
			
		}else{
			
			setName.setString(1, origName);	
			setName.setString(1, newName);	
			setName.executeUpdate();
			
			out.print("Changed " + origName + "'s username to " + newName);
			
			
			
		}
		
		newNameCheck.close();
		conn.close();
	
	} catch (Exception e) {
            out.print(e);
	}


	%>


</body>
</html>