<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>CS 336: Profile</title>
</head>
<body>
	<a href='logout.jsp'>Logout</a>
	<hr><br>
	
	<%
	try {
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		String username = (String) session.getAttribute("user");
		String privileges = (String) session.getAttribute("priv");
				
		out.print("<h1>Welcome, " + username + "</h1>");
		
		boolean isStaff = privileges.equals("end_user");
		if (!isStaff) {
			out.print("<h3>You have ");
		}
		
		if (privileges.equals("admin_staff")) {
			out.print("<em><a href='adminFunctions_page.jsp'>administrator</a></em> ");
		} 
		else if (privileges.equals("customer_rep")) {
			out.print("<em><a href='customerRep_page.jsp'>customer representative</a></em> ");
		}
		
		if (!isStaff) {	out.print("privileges.</h3>");
		}
		
		db.closeConnection(con);
	}
	catch (Exception e) {
		out.print(e);
	}
	%>

	<a href='search_page.jsp'> Search for auctions </a>
	<br>
	<a href='my-auctions.jsp'>Your auctions</a>
	<br>
	<a href='viewAutobidStatus.jsp'> View My Autobid</a>
	<br>
	<br><br><br><br><a href='customerSupport_page.jsp'>Need help? Contact customer support</a>
</body>
</html>
