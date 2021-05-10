<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Ban User</title>
	
</head>
<body>
	<h1>Ban user</h1>
	<%
	try{
	
		ApplicationDB db = new ApplicationDB();
		Connection conn = db.getConnection();
		PreparedStatement setBan = conn.prepareStatement("UPDATE USERS SET deleted = TRUE WHERE username = ?");
	
		
		//get form info
		String banUser = request.getParameter("targetUsername");
		if(banUser.length() > 63){
			banUser = banUser.substring(0,62);
		}
		
		String banUserRetyped = request.getParameter("retypedUsername");
		if(banUserRetyped.length() > 63){
			banUserRetyped = banUserRetyped.substring(0,62);
		}
		
		
		//get representative info
		String rName = request.getParameter("rep_name");
		String rPassword = request.getParameter("rep_pw");
		String privileges = (String) session.getAttribute("priv");
		boolean isStaff = privileges.equals("customer_rep");
		
		
		String griString = "SELECT * FROM users WHERE username ='" + rName + "' AND password = '" + rPassword + "';";
		Statement getRepInfo = conn.createStatement();
		
		ResultSet griTest = getRepInfo.executeQuery(griString);
		
		
		
		if( !banUser.equals(banUserRetyped) ){
			
			out.print("usernames do not match");
			
		}else if(!griTest.isBeforeFirst() || isStaff == false ){
			
			out.print("Improper account info");
			
			
			
		}else{
			
			setBan.setString(1, banUser);	
			setBan.executeUpdate();
			
			out.print(banUser + " has been banned.");
			
			
			
		}
		
		
		griTest.close();
		conn.close();
	
	} catch (Exception e) {
            out.print(e);
	}


	%>


</body>
</html>