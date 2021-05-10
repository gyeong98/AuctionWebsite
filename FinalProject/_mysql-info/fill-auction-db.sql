USE auction;

DELETE FROM users
WHERE user_id > 0;

ALTER TABLE users AUTO_INCREMENT = 1;

INSERT INTO users (username, password) VALUES ('forename', 'surname');
INSERT INTO users (username, password) VALUES ('username', 'password');
INSERT INTO users (username, password) VALUES ('jakobs', 'b0rderl2nds3');
INSERT INTO users (username, password) VALUES ('pink', 'floyd');
INSERT INTO users (username, password) VALUES ('m2m2', 'asdflkjh');
INSERT INTO users (username, password) VALUES ('justa', 'normalperson');
INSERT INTO users (username, password, birth_date) VALUES ('ash', 'toby!@#$%', '1999-12-25');
INSERT INTO users (username, password, birth_date) VALUES ('toby', 'ash!@#$%', '2000-02-28');
INSERT INTO users (username, password) VALUES ('fake', 'user');
INSERT INTO users (username, password) VALUES ('notafake', 'user');
INSERT INTO users (username, password) VALUES ('not a real person', 'password');
INSERT INTO users (username, password) VALUES ('also not real', 'password');
INSERT INTO users (username, password) VALUES ('heyihavethesame', 'password');
INSERT INTO users (username, password) VALUES ('mynameismypassword', 'mynameismypassword');


INSERT INTO users (username, password) VALUES ('rep1', 'reppw');
INSERT INTO customer_rep VALUES ((SELECT u.user_id FROM users u WHERE username = 'rep1'));


INSERT INTO users (username, password) VALUES ('admin1', 'adminpw');
INSERT INTO admin_staff VALUES ((SELECT u.user_id FROM users u WHERE username = 'admin1'));