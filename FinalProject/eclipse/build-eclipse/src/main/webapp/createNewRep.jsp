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
	<a href="register.jsp">Return to register</a>
	<hr><br>
	<%
		try {

			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
			//Create a SQL statement
			Statement stmt = con.createStatement(); 
			String id = request.getParameter("NewRepUsername"); 
            String pw = request.getParameter("newRepPassword");
            String email = request.getParameter("email");
            
			String str = "SELECT * FROM users WHERE username = '"+ id +"'";
            String str2 = "SELECT * FROM Customer_Rep WHERE rep_name = '"+ id +"'";
			
			ResultSet accounts = stmt.executeQuery(str);
            
            out.print("<h1>");
            
            //if no accounts are found with that username then make new user account and insert into users and customer_rep
            if (!accounts.next()) {
            	String newAcc = "INSERT INTO users (username, password, email) VALUES ('"+ id +"','"+ pw +"','"+ email +"');";
            	String newRep = "INSERT INTO Customer_Rep (rep_name) VALUES('" + id + "');";
            	stmt.executeUpdate(newAcc);
            	stmt.executeUpdate(newRep);
            	
            	out.println("Representative account registered!");
           
            //account already exists in users table
            }else {
            	
            	//check if they're already a customer rep
            	accounts = stmt.executeQuery(str2);
            	
            	//if not in customer rep table (result set empty)
            	if(!accounts.isBeforeFirst()){
            	
            		String newRep = "INSERT INTO Customer_Rep (rep_name) VALUES('" + id + "');";
            		stmt.executeUpdate(newRep);
            	
            		out.println("Representative account registered!");
            		
            	//else they're already a rep
            	}else{
            		
            		out.println("Representative account already exists.");
            		
            	}
            	
            }
            
            out.print("</h1>");
            
			//close the connection.
			con.close();

		} catch (Exception e) {
            out.print(e);
		}
	%>
</body>
</html>