USE auction;

/*DELETE FROM users WHERE username NOT NULL;*/

/*ALTER TABLE users AUTO_INCREMENT = 1;*/

/*Users*/
INSERT INTO users (username, password, email) VALUES 
('username', 'password', 'user@email.com'),
('user','pass','up@fmail.com'),
('me','myself','i@gmail.com'),
('fakeperson','abc123','badpass@mail.com'),
('iNeedHelp', 'helphelphelp', 'helpme@gmail.com');

/*  Buyers  */
INSERT INTO users (username, password, email) VALUES ('thief', 'thiefPW', 'thief@gmail.com');
INSERT INTO buyers (buyer_id) VALUES ('thief');

INSERT INTO users (username, password, email) VALUES ('Slash', 'notGNR', 'sh@gmail.com');
INSERT INTO buyers (buyer_id) VALUES ('Slash');

INSERT INTO users (username, password, email) VALUES ('NotCameron','AlsoNotCameron', 'cch@gmail.com');
INSERT INTO buyers (buyer_ID) VALUES ('NotCameron');

INSERT INTO users(username, password, email) VALUES ('yui', 'httc', 'yuihttc@gmail.com');
INSERT INTO buyers (buyer_ID) VALUES ('yui');

INSERT INTO users(username, password, email) VALUES ('asuza', '1969mustang', 'asuzakon@gmail.com');
INSERT INTO buyers (buyer_ID) VALUES ('asuza');


/*	sellers	*/
INSERT INTO users(username, password, email) VALUES ('jerryCantrell', 'nutshellInABox', 'jc@gmail.com');
INSERT INTO sellers (seller_id) VALUES('jerryCantrell');

INSERT INTO users(username, password, email) VALUES ('joeperry', 'livinOnTheEdge', 'jp@gmail.com');
INSERT INTO sellers (seller_id) VALUES('joeperry');

INSERT INTO sellers(seller_id) VALUES('NotCameron');
INSERT INTO sellers (seller_id) VALUES ('thief');


/*Administrators and representatives*/
INSERT INTO users (username, password, email) VALUES ('rep1', 'reppw', 'rep1@gmail.com');
INSERT INTO Customer_Rep (rep_name) VALUES ((SELECT u.username FROM users u WHERE username = 'rep1'));

INSERT INTO users (username, password, email) VALUES ('secretHackerman', 'secretHackerman', 'noteliot@gmail.com');
INSERT INTO Customer_Rep (rep_name) VALUES ((SELECT u.username FROM users u WHERE username = 'secretHackerman'));

INSERT INTO users (username, password, email) VALUES ('admin1', 'adminpw', 'allpowerfuladmin@gmail.com');
INSERT INTO Admin_Staff (admin_name) VALUES ((SELECT u.username FROM users u WHERE username = 'admin1'));

INSERT INTO users (username, password, email) VALUES ('CameronsAdminPower', 'ImMorePowerfulThanAdmin1', 'cch1234@gmail.com');
INSERT INTO Admin_Staff (admin_name) VALUES ((SELECT u.username FROM users u WHERE username = 'CameronsAdminPower'));


/*    Items    */
INSERT INTO Items (item_id, model_name, manufacturer, num_strings) VALUES 
(null, 'Fender Squier 70s Classic Vibe', 'Fender', 6),			# 1 <= 310970
(null, 'Kenny Hickey Signature', 'Schecter', 6),				# 2 <= 32010
(null, '1959 Les Paul', 'Gibson', 6),							# 3 <= 191959
(null, 'Marty Friedman Signature', 'Jackson', 6),				# 4 <= 132018
(null, 'RGA742FM', 'Ibanez', 7),								# 5 <= 742019
(null, 'APX600', 'Yamaha', 6),									# 6 <= 11600
(null, 'JF30', 'Guild', 6),										# 7 <= 101996
(null, 'AWN100', 'Giannini', 6),								# 8 <= 100827
(null, 'D50', 'Guild', 6),										# 9 <= 111996
(null, 'Omen-4 Bass', 'Schecter', 4),							# 10 <= 209000
(null, 'Johnny Christ 5 Bass', 'Schecter', 5),					# 11 <= 107600
(null, 'Frank Bello J-4', 'ESP', 4);							# 12 <= 720042


/*    Electric guitars and basses   */
INSERT INTO Electric_Guitar(item_id, pickup_config) VALUES 
(1, 'SSS'),				# Fender Squier 70s Classic Vibe+
(2, 'HH'),				# Kenny Hickey Signature
(3, 'HH'),				# 1959 Les Paul
(4, 'HH'),				# Marty Friedman Signature
(5, 'HH'),				# RGA742FM
(10, 'HH'),				# Omen-4 Bass
(11, 'HS'),				# Johnny Christ 5 Bass
(12, 'HS');				# Frank Bello J-4


/*     Acoustics    */
INSERT INTO Acoustic_Guitar(item_id, is_classical) VALUES 
(7, 0), 				# JF30
(8, 0),					# D50
(9, 1);					# AWN100


/*     Acoustic electrics    */
INSERT INTO Acoustic_Electric_Guitar(item_id, pickup_type, includes_tuner) VALUES 
(6, 'SRT Piezo', 0);	# APX600


/*
AUCTIONS
Datetime format:   YYYY-MM-DD HH:MM:SS
the time section is in military time, to write 2:30pm, you write 14:30:00
Example:  2021-09-21 15:30:00    =  3:30pm and 0 seconds, on september 21st, 2021 

INSERT INTO auction_info VALUES
(null, '2021-01-28 03:03:10', '2021-4-28 14:00:00', 500.00, 450.00, 550.00, 10, 0, ''),
(null, '2021-01-28 03:03:10', '2021-2-28 15:00:00', 50000.00, 45000.00, 55000.00, 100, 55000.00, 'Slash'),
(null, '2021-04-10 03:03:10', '2021-5-28 15:00:00', 1000.00, 950.00, 1200.00, 100, 1100.00, ''),
(null, '2021-3-20 03:01:00', '2021-5-10 15:01:00', 900, 1500, 2000, 50, 1100, ''),
(null, '2021-01-28 03:03:10', '2021-4-28 14:00:00', 200.00, 200.00, 250.00, 10, 260, 'NotCameron'),
(null, '2021-01-28 03:03:10', '2021-4-28 14:00:00', 800.00, 800.00, 1000.00, 10, 900, 'NotCameron'),
(null, '2021-01-28 03:03:10', '2021-4-28 14:00:00', 800.00, 800.00, 1000.00, 10, 900, '');*/

/* (auction_id, start time, end time/expires, starting price, hidden min price, buy now price, min bid increment, highest current bid, winner name(winner name is not foreign key) )  */

# ('jerryCantrell', 9, '2021-01-28 03:03:10', '2021-4-28 14:00:00', 500.00, 450.00, 550.00, 10, 0, ''),
# ('joeperry', 3, '2021-01-28 03:03:10', '2021-2-28 15:00:00', 50000.00, 45000.00, 55000.00, 100, 55000.00, 'Slash'), /*tuple where someone used 'buy now' feature*/
# ('thief', 7, '2021-04-10 03:03:10', '2021-5-28 15:00:00', 1000.00, 950.00, 1200.00, 100, 1100.00, ''),
# ('jerryCantrell', 8, '2021-3-20 03:01:00', '2021-5-10 15:01:00', 900, 850, 940, 50, 1000, '');


INSERT INTO auctions VALUES
(9, 'thief', 3, '2021-01-28 03:03:10', '2021-4-28 14:00:00', 800.00, 800.00, 1000.00, 10, 1100, ''),
(5, 'jerryCantrell', 1, '2021-01-28 03:03:10', '2021-4-28 14:00:00', 200.00, 200.00, 250.00, 10, 260, 'NotCameron'),
(6, 'jerryCantrell', 8, '2021-01-28 03:03:10', '2021-4-28 14:00:00', 800.00, 800.00, 1000.00, 10, 900, 'NotCameron'),
(1, 'jerryCantrell', 9, '2021-01-28 03:03:10', '2021-4-28 14:00:00', 800.00, 800.00, 1000.00, 10, 900, ''),
(2, 'joeperry', 3, '2021-01-28 03:03:10', '2021-2-28 15:00:00', 50000.00, 45000.00, 55000.00, 100, 55000.00, 'Slash'),
(3, 'thief', 7, '2021-3-20 03:01:00', '2021-5-10 15:01:00', 900, 1500, 2000, 50, 900, ''),
(4, 'jerryCantrell', 8, '2021-04-10 03:03:10', '2021-5-28 15:00:00', 1000.00, 950.00, 1200.00, 100, 1100.00, ''),
(8, 'thief', 3, '2021-01-28 03:03:10', '2021-4-28 14:00:00', 800.00, 800.00, 1000.00, 10, 900, '');



/*SET SESSION SQL_MODE='ALLOW_INVALID_DATES';*/
INSERT INTO Makes_Bid VALUES 
('Slash', 9, '2021-02-20 10:00:10', 5000, false, 0, 0),
('NotCameron', 5, '2021-03-31 10:00:10', 260, false, 0, 0),
('NotCameron', 6, '2021-03-31 10:00:10', 900, false, 0, 0),
('Slash', 2, '2021-02-20 10:00:10', 55000, false, 0, 0),
('NotCameron', 3, '2021-04-20 10:00:00', 900, true, 1000, 100),
('NotCameron', 4, '2021-03-20 05:00:00', 1100, true, 1150, 50);
/* (buyer, auction_id, bid time, bid, is_auto_bid, bid max, auto_bid_increment)

SELECT * FROM makes_bid;
SELECT * FROM auctions;*/

SELECT * FROM customer_rep;

INSERT INTO Makes_Bid VALUES 
('NotCameron', 9, '2021-03-20 05:00:00', 1100, true, 1150, 50);



/*Customer support tickets*/
INSERT INTO customer_support(ticket_no, end_user, question, answer) VALUES
(null, 'secretHackerman', 'Thief is selling a stolen acoustic guitar', 'Thank you for the report'),
(null, 'rep1', 'How do i default on a bid', ''),
(null, 'rep1', 'How do I turn autobid off', ''),
(null, 'rep1', 'My auction for my JF30 disappeared', 'I restored the auction. Someone accidentally removed it');
INSERT INTO customer_support(end_user, question, answer) VALUES ('NotCameron', 'There should be an option to differentiate between bass and guitar', 'We will look into implementing this in the future');

SELECT * FROM users;
UPDATE users SET deleted = FALSE WHERE username = 'thief';