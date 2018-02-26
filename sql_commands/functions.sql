
/* New User As Staff */ 
INSERT INTO User(username, password, name, surname, position)
	VALUES("doren", "doren123", "Doren", "Calliku", "Cleaner");
INSERT INTO Staff(staff_id) SELECT user_id FROM User WHERE username="doren" AND NOT EXISTS(SELECT partner_id FROM Business_Partner WHERE partner_id = user_id);


/* OR As Business Partner */
INSERT INTO User(username, password, name, surname, position)
	VALUES("ali", "ali123", "Ali", "Yenimol", "Business");
INSERT INTO Business_Partner(partner_id, represents) SELECT user_id, "His Company" FROM User WHERE username="ali" AND NOT EXISTS(SELECT staff_id FROM Staff WHERE staff_id = user_id);

/* Trying insert to staff but he is already a Business_Partner */

INSERT INTO Staff(staff_id) SELECT user_id FROM User WHERE username="ali" AND NOT EXISTS(SELECT partner_id FROM Business_Partner WHERE partner_id = user_id);
