
/* User */

INSERT INTO `User` (`username`,`password`,`name`,`surname`,`position`)
VALUES 
("Lenore","DTN33UAZ8KD","Ivan","Moran","worker"),
("Madonna","PYL63HXW6JU","John, Sylvester","Dorsey","worker"),
("Christen","EOX00TTO6TJ","Ayanna, Hedda","Hicks","leader"),
("Jasper","SAE50BQH1FQ","Willa, Blaze","Workman","worker"),
("Jillian","GZL03JER0OB","David, Autumn","Knapp","president"),
("Rahim","KOZ58JYW0QV","Cheryl, Lenore","Salas","worker"),
("Angela","GIZ49IIC8TO","Nora, Oprah","Suarez","worker"),
("Regan","SVJ59PFY3SF","Quinn, Phelan","Cash","leader"),
("Robin","KRX74UHT2VW","Clarke, Reece","Whitaker","vc.president"),
("Isaiah","XJV34EKN5VL","Abel, Grady","Snow","worker"),
("Salvador","JQJ99ILL5ZN","Noble, Emmanuel","Oneil","worker"),
("Jayme","ADX50APF9QS","Regina, Camille","Freeman","worker"),
("Finn", "CVE72YYC0DN",     "Amela, Ray", "Fuller","leader"),
("Lacota","EUI09FHV9JI","Irma, Nero","Kim","worker"),
("Norman","HRJ83MCW7YD","Talon, Ivor","Hoffman","worker"),
("Macon","DOP88TEG2WG","Hermione, Kristen","Tanner","worker"),
("Acton","GEJ67LIN4NE","Maryam, Emi","Rich","worker"),
("Kitra","JAQ47QKZ1YR","Ferdinand, Damon","Ware","worker"),
("Edan","JSF35EDU7YT","Alana, Emerald","Key","worker"),
("Chancellor","WDV65SCV9WR","Cherokee, Cadman","Dillon","leader"),
("Juliet","SHF82XEY5YD","Eleanor","Santos","Mauris"),
("Griffith","ZFT15WWC6WN","Reece, Logan","Tate","Volutpat"),
("Whoopi","ATN44CXK3DZ","Hu, Phelan","Jensen","Institute"),
("Alo", "HRJ93MAB7EH","Rashad, Laura","Harrington",   "Massa"),
("Alo2","XHP50OSL8PS", "Noah, Aquila",   "Delgado","Pharetra"),
("Alo3","NMI85AWR9BP","Robin, Marvin","Gates","Foundation"),
("Alo4","VVQ03JGP0ZS","Carter, Brielle","Heath","Nec"),
("Alo5","QVL01ZRA8XS","Allistair, Curran","Thompson","Corp"),
("Alo6","UEF94TUF4VN","Dylan, Thomas","Levine","Blandit Corporation"),
("Alo7","UEF94TUF4V4","Problem","Alma","Alma Corp");

/* Staff */

INSERT INTO Staff (staff_id) SELECT user_id FROM User ORDER BY user_id ASC LIMIT 20;

/* Business_Partner */

INSERT INTO Business_Partner (partner_id, represents) SELECT user_id, position FROM User ORDER BY user_id DESC LIMIT 10;


/* Team */

INSERT INTO `Team` (`name`,`status`)
VALUES 
("Team1",1),
("Team2",1),
("Team3",1),
("Team4",1),
("Team5",1);

/* Team_In */
INSERT INTO Team_In (team_name, staff_id) 
VALUES
 ("Team1",1), ("Team1",2), ("Team1",3), ("Team1",4),
 ("Team2",5), ("Team2",6), ("Team2",7), ("Team2",8),
 ("Team3",9),("Team3",10),("Team3",11),("Team3",12),
("Team4",13),("Team4",14),("Team4",15),("Team4",16),
("Team5",17),("Team5",18),("Team5",19),("Team5",20);

/* Meeting */

INSERT INTO `Meeting` (`creator_id`,`date`,`end_time`,`start_time`) 
VALUES 
(1,"2018-02-25","06:42:11","14:42:48"),
(5,"2017-09-16","08:28:06","02:44:43"),
(9,"2017-08-24","18:17:56","09:55:37"),
(15,"2017-08-07","08:33:49","18:28:40");

/* Participate */
INSERT INTO Participate (meeting_id, user_id)
VALUES
(1,1),
(1,2),
(1,3),
(1,4),
(1,5),
(1,6),
(2,11),
(2,12),
(2,13),
(2,14),
(2,15),
(2,16),
(2,22),
(3,1),
(3,2),
(3,3),
(3,14),
(3,4),
(3,6),
(3,24),
(3,21),
(4,1),
(4,23);

/* Meeting_Payment */
INSERT INTO Meeting_Payment (meeting_id, team_name, amount, status)
VALUES
(1, "Team1", 120, 0),
(2, "Team2", 150, 1),
(3, "Team3", 140, 1),
(4, "Team4", 110, 0);


/* Available_Resource */

INSERT INTO `Available_Resource` (`room_no`,`capacity`,`address`,`building_name`) 
VALUES 
(1,10,"KTH, E building E1, Stockholm","Sweden"),
(2,10,"KTH, E building E2, Stockholm","Sweden"),
(3,10,"KTH, E building E3, Stockholm","Sweden"),
(4,10,"KTH, E building E4, Stockholm","Sweden"),
(5,10,"KTH, E building E5, Stockholm","Sweden"),
(6,10,"KTH, E building E6, Stockholm","Sweden");
INSERT INTO `Available_Resource` (`room_no`,`capacity`,`address`,`building_name`) 
VALUES 
(1,10,"KTH, D building D1, Stockholm","Sweden"),
(2,20,"KTH, D building D2, Stockholm","Sweden"),
(3,20,"KTH, D building D3, Stockholm","Sweden"),
(4,20,"KTH, D building D4, Stockholm","Sweden"),
(5,20,"KTH, D building D5, Stockholm","Sweden"),
(6,20,"KTH, D building D6, Stockholm","Sweden");

/* Booking */
INSERT INTO Booking (meeting_id, resource_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

/* Facility */

INSERT INTO `Facility` (`name`,`cost`) 
VALUES ("tv",10),
("board",20),
("chairs",40),
("tables",40);

/* Facility_In */
INSERT INTO Facility_In (facility_name, resource_id) 
VALUES 
("tv",1),("tv",2),("tv",3),("tv",4),("tv",5),("tv",6),("tv",7),("tv",8),("tv",9),("tv",10),("tv",11),
("board",2),("board",4),("board",6),("board",10),("board",12),("board",11),("board",9),
("chairs",1),("chairs",2),("chairs",3),("chairs",4),("chairs",5),("chairs",6),("chairs",7),
("tables",5),("tables",6),("tables",7),("tables",8),("tables",9),("tables",10),("tables",11);


