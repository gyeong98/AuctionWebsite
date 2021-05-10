DROP DATABASE IF EXISTS auction;
CREATE DATABASE auction;
USE auction;

SET NAMES utf8 ;
SET character_set_client = utf8mb4 ;

CREATE TABLE IF NOT EXISTS Users(
	
    username varchar(63) not null,
    password varchar(64) not null,
    email varchar(100) not null,
    deleted bool DEFAULT false,
    
    constraint primary key(username)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Customer_Rep(
	rep_name varchar(63) not null, 

	constraint primary key(rep_name),
    constraint foreign key(rep_name) references Users(username)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Admin_Staff(
	admin_name varchar(63) not null,
    
    constraint primary key(admin_name),
    constraint foreign key(admin_name) references Users(username)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Sellers(
	seller_id varchar(63) not null,
    
    constraint primary key(seller_id),
    constraint foreign key(seller_id) references Users(username)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Buyers(
	buyer_id varchar(63) not null,
    
    constraint primary key(buyer_id),
    constraint foreign key(buyer_id) references Users(username)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Items(
    item_id int not null auto_increment,
    model_name varchar(127) not null,
    manufacturer varchar(20) not null,
	num_Strings int not null,
    
    constraint primary key(item_id)
) engine=innodb;


CREATE TABLE IF NOT EXISTS Electric_Guitar(
	item_id int not null,
	pickup_config varchar(8) not null,  
	/*Pickup configurations are usually like: SSS, SSH, HH, SS, HSH,
	S = single coil pickup, H = humbucking pickup
    SSS means that there are 3 single coil pickups, SSH means 2 single coil and one humbucking, etc.*/
	
	constraint primary key(item_id),
	constraint foreign key(item_id) references Items(item_id)
) engine=innodb;


CREATE TABLE IF NOT EXISTS Acoustic_Guitar(
	item_id int not null,
	is_classical bool not null,

	constraint primary key(item_id),
	constraint foreign key(item_id) references Items(item_id)
) engine=innodb;


CREATE TABLE IF NOT EXISTS Acoustic_Electric_Guitar(
	item_id int not null,
	pickup_type varchar(32) not null,  
	includes_tuner bool not null,
	
	constraint primary key(item_id),
	constraint foreign key(item_id) references Items(item_id)
) engine=innodb;


/*
Datetime format:   YYYY-MM-DD HH:MM:SS
the time section is in military time, to write 2:30pm, you write 14:30:00
Example:  2021-09-21 15:30:00    =  3:30pm and 0 seconds, on september 21st, 2021 
*/

/*
CREATE TABLE IF NOT EXISTS Auction_Info(
	auction_id int not null auto_increment,

	start_time datetime not null,
	expires datetime not null,
	
    starting_price float,
    hidden_price float,
	buy_now_price float,
	
	min_increment float,
	highest_current_bid float,
	
	winner varchar(63),
    
    constraint primary key(auction_id)
) engine=innodb;
*/

CREATE TABLE IF NOT EXISTS Auctions(
	auction_id int not null auto_increment,
    
    seller_id varchar(63) not null,
    item_id int not null,

	start_time datetime not null,
	expires datetime not null,
	
    starting_price float,
    hidden_price float,
	buy_now_price float,
	
	min_increment float,
	highest_current_bid float,
	
	winner varchar(63),
    
    constraint primary key(auction_id),
    constraint foreign key(seller_id) references sellers(seller_id),
    constraint foreign key(item_id) references Items(item_id)
) engine=innodb;


CREATE TABLE IF NOT EXISTS Makes_Bid(
	buyer_id varchar(63) not null,
    auction_id int not null,
    bid_time datetime not null,
    
	bid float,
    
    is_auto_bid bool,
    bid_max float,
	auto_bid_increment float,
    
    constraint primary key(buyer_id, auction_id, bid_time),
    constraint foreign key(buyer_id) references Buyers(buyer_id),
    constraint foreign key(auction_id) references Auctions(auction_id)
) engine=innodb;


CREATE TABLE IF NOT EXISTS Buyer_Alert(
	buyer_id varchar(63) not null,
    item_id int not null,
    
    constraint primary key(buyer_id, item_id),
    constraint foreign key(buyer_id) references Buyers(buyer_id),
    constraint foreign key(item_id) references Items(item_id)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Customer_Support(
    ticket_no int not null auto_increment,
    
    end_user varchar(63),
    question varchar(500),
	answer varchar(500),
    
    constraint primary key(ticket_no)
) engine=innodb;
