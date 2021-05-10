<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Login Check</title>
</head>
<body>
	<%
		List<String> list = new ArrayList<String>();

		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
			//Create a SQL statement
			Statement stmt = con.createStatement(); 
			String id = request.getParameter("id"); 
            String pw = request.getParameter("pw"); 
            out.print("Made it here at least1");
			String str = "SELECT * FROM users WHERE username = '" + id + "'";
            out.print("Made it here at least2");
			ResultSet accounts = stmt.executeQuery(str);
            out.print("Made it here at least3");

            if (accounts == null) { out.print("<h1>No such account</h1>"); }

            out.println(accounts.getString("username") + " " + accounts.getString("password"));

			//close the connection.
			con.close();

		} catch (Exception e) {
            out.print(e);
		}
	%>
    <p>Test</p>
</body>
</html>