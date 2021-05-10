<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="ISO-8859-1">
<title>CS 336: Add item parse</title>
</head>

<body>
<%
try {
	
	// Connect to DB
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	
	/*
		items:						acoustic_guitar:			electric_guitar:			acoustic_electric_guitar:
			item_id (int, auto),		item_id (int),				item_id (int),				item_id (int),
			model_name (varchar),		pickup_config (varchar)		is_classical (bool, 0/1)	pickup_type (varchar),
			manufacturer (varchar),																includes_tuner (bool, 0/1)
			num_Strings	(int)		
	*/
	
	/* First, create item */

	// Prepare query
	PreparedStatement stmt = null;
	String qry = "INSERT INTO items VALUES (?,?,?,?)";
	stmt = con.prepareStatement(qry, Statement.RETURN_GENERATED_KEYS);
	boolean failed = false;

	//1 item_id (R)		-> int null
	stmt.setNull(1, Types.INTEGER);
	
	//2 model_name (R)	-> request from previous page
	String qry_modelName = request.getParameter("input_modelName");
	session.setAttribute("modelNameFail", false);
	
	if (qry_modelName.equals("")) {
		failed = true;
		session.setAttribute("modelNameFail", true);
	}
	
	stmt.setString(2, qry_modelName);
	
	//3 manufacturer (R)-> request from previous page
	String qry_manufacturer = request.getParameter("input_manufacturer");
	session.setAttribute("manufacturerFail", false);
	
	if (qry_manufacturer.equals("")) {
		failed = true;
		session.setAttribute("manufacturerFail", true);
	}
	
	stmt.setString(3, qry_manufacturer);

	//4 num_Strings (R)	-> request from previous page
	String qry_numStrings = request.getParameter("input_numStrings");
	session.setAttribute("numStringsFail", false);
	
	if (qry_numStrings.equals("")) {
		failed = true;
		session.setAttribute("numStringsFail", true);
	}
	
	stmt.setString(4, qry_numStrings);
	
	
	// Check if correct format
	out.print(qry+"|"+null+","+qry_modelName+","+qry_manufacturer+","+qry_numStrings+"<br>");
	
	/* Second, determine isa */
	Statement stmt2 = con.createStatement();

	String qryInsert = "INSERT INTO ";
	String qryTable  = "";
	String qryValues = " VALUES (";
	int qryKey;
	String qryParams = ",";
	
	String el = request.getParameter("submit_el");		out.print(el+"<br>");
	String ac = request.getParameter("submit_ac");		out.print(ac+"<br>");
	String acel = request.getParameter("submit_acel");	out.print(acel+"<br>");
	
	session.setAttribute("elPickupConfigFail", false);
	session.setAttribute("acelPickupTypeFail", false);

	if (el != null) { // Parse electric if so
		out.print("here1");
		qryTable += "electric_guitar";
		
		String pickupConfig = request.getParameter("input_elPickupConfig");
		if (pickupConfig.equals("")) {
			failed = true;
			session.setAttribute("elPickupConfigFail", true);
		}
		
		qryParams += "'"+pickupConfig+"'";
		out.print("leaving1");
	} //out.print("if1");
	
	else if (ac != null) { // Parse acoustic if so
		out.print("here2");
		qryTable += "acoustic_guitar";
		
		String strIsClassical = request.getParameter("input_acIsClassical"); //out.print(strIsClassical+"classical?");
		Boolean isClassical = true;
		if (strIsClassical == null) { isClassical = false; }
		
		qryParams += ""+isClassical;
		out.print("leaving2");
	} //out.print("if2");
	
	else if (acel != null) { // Parse acoustic-electric if so
		out.print("here3");
		qryTable += "acoustic_electric_guitar";

		String pickupType = request.getParameter("input_acelPickupType");
		if (pickupType.equals("")) {
			failed = true;
			session.setAttribute("acelPickupTypeFail", true);
		}

		qryParams += "'"+pickupType+"',";

		String strIncludesTuner = request.getParameter("input_acelIncTuner");
		Boolean includesTuner = true;
		if (strIncludesTuner == null) { includesTuner = false; }
		
		qryParams += includesTuner;
		out.print("leaving3");
	} //out.print("if3");
	
	// Otherwise directly fail
	else { response.sendRedirect("add-item.jsp"); }
	
	qryParams += ")";
	out.print("out1");
	
	// Check for failure
	if (failed) { response.sendRedirect("add-item.jsp"); }
	else {
		
		/* Confirmed success, begin insertion */
		stmt.executeUpdate();
		
		ResultSet tableKeys = stmt.getGeneratedKeys();
		tableKeys.next();
		qryKey = tableKeys.getInt(1);
		out.print(qryKey);
		
		String qry2 = qryInsert + qryTable + qryValues + qryKey + qryParams; out.print("<br>"+qry2);
		stmt2.executeUpdate(qry2);
		
		out.print(qry + "| " + qryKey + qry_modelName + qry_manufacturer + qry_numStrings);
		out.print(qry2);
		
		session.setAttribute("itemAdded", true);
	}
	
	response.sendRedirect("add-item.jsp");
	
	// Close DB connection for stability
	db.closeConnection(con);
} 
catch (Exception e) {
	e.printStackTrace();
}
%>
</body>
</html>