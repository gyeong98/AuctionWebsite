DROP DATABASE IF EXISTS auction;
CREATE DATABASE auction;
USE auction;

SET NAMES utf8 ;
SET character_set_client = utf8mb4 ;

CREATE TABLE IF NOT EXISTS Users(
	user_id int not null auto_increment,
    username varchar(63) not null,
    password varchar(63) not null,
    
    birth_date date,
    
    constraint primary key(user_id)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Customer_Rep(
	user_id int not null auto_increment,

	constraint primary key(user_id),
    constraint foreign key(user_id) references Users(user_id)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Admin_Staff(
	user_id int not null auto_increment,
    
    constraint primary key(user_id),
    constraint foreign key(user_id) references Users(user_id)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Sellers(
	user_id int not null auto_increment,
    
    constraint primary key(user_id),
    constraint foreign key(user_id) references Users(user_id)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Buyers(
	user_id int not null auto_increment,
    
    constraint primary key(user_id),
    constraint foreign key(user_id) references Users(user_id)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Items(
	user_id int not null,
    item_id int not null,
    
    name varchar(127) not null,
    category varchar(63),
    price_start decimal(7,2) not null, # 00000.00
    price_buyout decimal(7,2),
    min_increment float,
    curr_top_bid decimal(7,2),
    expire_time time,
    expire_date date,
    
    constraint primary key(user_id, item_id),
    constraint foreign key(user_id) references Sellers(user_id)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Buyer_Bids_Item(
	buyer_id int not null,
    seller_id int not null,
    item_id int not null,
    
    is_auto_bid bool,
    bid decimal(7,2),
    bid_max decimal(7,2),
    
    constraint primary key(buyer_id, seller_id, item_id),
    constraint foreign key(buyer_id) references Buyers(user_id),
    constraint foreign key(seller_id, item_id) references Items(user_id, item_id)
) engine=innodb;

CREATE TABLE IF NOT EXISTS Buyer_hasAlertOf_Item(
	buyer_id int not null,
    seller_id int not null,
    item_id int not null,
    
    constraint primary key(buyer_id, seller_id, item_id),
    constraint foreign key(buyer_id) references Buyers(user_id),
    constraint foreign key(seller_id, item_id) references Items(user_id, item_id)
) engine=innodb;

CREATE TABLE IF NOT EXISTS User_reqHelpFrom_Rep(
	user_id int not null,
    rep_id int not null,
    
    ticket_no int,
    detail varchar(255),
    
    constraint primary key(user_id, rep_id),
    constraint foreign key(user_id) references Users(user_id),
    constraint foreign key(rep_id) references Customer_Rep(user_id)
) engine=innodb;
