<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
	<title>Sales Report</title>
</head>
<body>
	<h1>Sales Report</h1>
	<% 
		try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection salesCon = db.getConnection();	
		
			
			/******************get total sales on site******************/
			Statement totalSales = salesCon.createStatement();
			String totalQuery = "SELECT SUM(a.highest_current_bid) AS total_sales FROM auctions a WHERE winner <> '';";
			ResultSet tsq = totalSales.executeQuery(totalQuery);
			
			tsq.next();
			Double totalSalesNum = tsq.getDouble("total_sales");
			
			out.print("<b>total sales on site: $</b>");
			out.print(totalSalesNum);
			out.print("<br><br>");			
			tsq.close();
			totalSales.close();
			
			
			
			/*****************get total sales per item id/name**************/
			Statement salesPerId = salesCon.createStatement();
			String perIdQuery = "SELECT a.item_id, i.model_name, SUM(highest_current_bid) AS total_sales FROM auctions a JOIN items i ON i.item_id = a.item_id WHERE a.winner<>'' GROUP BY a.item_id;";
			ResultSet piqSet = salesPerId.executeQuery(perIdQuery);
			
			out.print("<b>Sales per unique item</b><br>");
			out.print("<b>itemid  :  model name  :  total sales</b><br>");
			while(piqSet.next()){
				int id = piqSet.getInt("a.item_id");
				String name = piqSet.getString("i.model_name");
				double itemSales = piqSet.getDouble("total_sales");
				
				out.print(id + " : " + name + " : " + "$" + itemSales);
				out.print("<br>");
			}
			
			piqSet.close();
			salesPerId.close();
			out.print("<br><br>");
			
			
			
			
			/*****************get total sales figures per item type**************/
			//total electric
			Statement totalElecSales = salesCon.createStatement();
			String totalElecQuery = "SELECT SUM(highest_current_bid) AS el_sales FROM auctions a JOIN items i ON i.item_id = a.item_id WHERE winner <> '' AND a.item_id IN (SELECT item_id FROM electric_guitar)";
			ResultSet teq = totalElecSales.executeQuery(totalElecQuery);
			
			teq.next();
			Double totalElecNum = teq.getDouble("el_sales");
			
			out.print("<b>Sum electric sales on site: </b>");
			out.print("$" + totalElecNum);
			out.print("<br>");
					
			teq.close();
			totalElecSales.close();
			
			//total acoustic
			Statement totalAcousSales = salesCon.createStatement();
			String totalAcousQuery = "SELECT SUM(highest_current_bid) AS ac_sales FROM auctions a JOIN items i ON i.item_id = a.item_id WHERE winner <> '' AND a.item_id IN (SELECT item_id FROM acoustic_guitar)";
			ResultSet taq = totalAcousSales.executeQuery(totalAcousQuery);
			
			taq.next();
			Double totalAcousNum = taq.getDouble("ac_sales");
			
			out.print("<b>Sum acoustic sales on site: </b>");
			out.print("$" + totalAcousNum);
			out.print("<br>");
					
			taq.close();
			totalAcousSales.close();
			
			//total acoustic-electric
			Statement totalAESales = salesCon.createStatement();
			String totalAEQuery = "SELECT SUM(highest_current_bid) AS acel_sales FROM auctions a JOIN items i ON i.item_id = a.item_id WHERE winner <> '' AND a.item_id IN (SELECT item_id FROM acoustic_electric_guitar)";
			ResultSet taeq = totalAESales.executeQuery(totalAEQuery);
			
			taeq.next();
			Double totalAENum = taeq.getDouble("acel_sales");
			
			out.print("<b>Sum acoustic_electric sales on site: </b>");
			out.print("$" + totalAENum);
			out.print("<br>");
					
			taeq.close();
			totalAESales.close();
			
			out.print("<br><br>");	
			
			
			
			
			/*****************get num items sold by each seller**************/
			Statement itemsSoldByUser = salesCon.createStatement();
			String isbuQuery = "SELECT a.seller_id AS salesman, COUNT(*) as itemsSold FROM auctions a JOIN items i ON i.item_id = a.item_id WHERE a.winner <> '' GROUP BY a.seller_id ORDER BY itemsSold DESC";
			ResultSet isbu = itemsSoldByUser.executeQuery(isbuQuery);
			
			out.print("<b>Num Items Sold By User: </b><br>");
			out.print("<b>seller :  # items sold</b><br>");
			while(isbu.next()){
				
				String isbuSeller = isbu.getString("salesman");
				int numItemsSold = isbu.getInt("itemsSold");
				
				out.print(isbuSeller + " : " + numItemsSold);	
				out.print("<br>");
				
			}
			
					
			isbu.close();
			itemsSoldByUser.close();
			
			out.print("<br><br>");	
			
			
			/*****************get best selling items (by num items sold)**************/
			Statement bestSellingItems = salesCon.createStatement();
			String bsiQuery = "SELECT i.model_name, COUNT(*) AS num_sold FROM auctions a JOIN items i ON i.item_id = a.item_id WHERE winner <> '' GROUP BY i.model_name ORDER BY num_sold DESC";
			ResultSet bsi = bestSellingItems.executeQuery(bsiQuery);
			
			out.print("<b>Top 5 Best Selling Items</b><br>");
			out.print("<b>model_name  :  total_sales</b><br>");
			
			int counter = 0;
			while(bsi.next() && counter < 5){
				//int id = bsi.getInt("item_id");
				String name = bsi.getString("model_name");
				int itemSales = bsi.getInt("num_sold");
				
				out.print(name + " : " + "" + itemSales + " sold");
				out.print("<br>");
				counter++;
			}
			
			bsi.close();
			bestSellingItems.close();
			out.print("<br><br>");
			
			
			
			/*****************get top 3 best buyers based on num items bought**************/
			Statement getBestBuyers = salesCon.createStatement();
			String gbbQuery = "SELECT a.winner as buyer, COUNT(*) as num_items_bought FROM auctions a JOIN items i ON i.item_id = a.item_id WHERE a.winner <> '' GROUP BY a.winner ORDER BY num_items_bought DESC";
			ResultSet gbb = getBestBuyers.executeQuery(gbbQuery);
			
			counter = 0; //reuse this counter variable
			out.print("<b>Top 3 Best Buyers: </b><br>");
			while(gbb.next() && counter < 3){
				String gbbBuyer = gbb.getString("buyer");
				int numItemsBought = gbb.getInt("num_items_bought");
				
				out.print((counter+1) + ". ");
				out.print(gbbBuyer + " : " + numItemsBought);
				
				if(numItemsBought == 1){
					out.print(" purchase");
				}else{
					out.print(" purchases");
				}
				
				out.print("<br>");
				counter++;
			}
			
					
			gbb.close();
			getBestBuyers.close();
			
			out.print("<br><br>");	
			
			
			
			salesCon.close();
		}catch (Exception e) {
            out.print(e);
		}
	
	
	
	
	
	
	
	%>


</body>
</html>