
/* New User As Staff */ 
INSERT INTO User(username, password, name, surname, position, status)
	VALUES("doren", "doren123", "Doren", "Calliku", "Cleaner", 1);
INSERT INTO Staff(staff_id) 
SELECT user_id 
FROM User 
WHERE username="doren" 
AND NOT EXISTS(SELECT partner_id FROM Business_Partner WHERE partner_id = user_id);

/* Remember that a User is supposed to join to a Team initially as it is not on GUI part, we are doing manually for now */
INSERT INTO Team_In(team_name, staff_id) 
	SELECT "Team1", User.user_id FROM Team, User WHERE Team.status=1 AND Team.name="Team1" AND User.username = "doren";


/* OR As Business Partner */
INSERT INTO User(username, password, name, surname, position, status)
	VALUES("ali", "ali123", "Ali", "Yenimol", "Business", 1);
INSERT INTO Business_Partner(partner_id, represents) 
	SELECT user_id, "His Company" 
	FROM User 
	WHERE username="ali" 
	AND NOT EXISTS(
		SELECT staff_id 
			FROM  Staff	
			WHERE staff_id = user_id);

/* Trying insert to staff but he is already a Business_Partner */

INSERT INTO Staff(staff_id) 
	SELECT user_id 
	FROM User 
	WHERE username="ali" 
	AND NOT EXISTS(
		SELECT partner_id 
		FROM Business_Partner 
		WHERE partner_id = user_id);

/* Delete User */
/* In the moment we want to delete a user, we just turn its status to 0. So the meetings he has created will not have to be deleted.*/

/* DELETE FROM Meeting
WHERE meeting_id 
IN
(
	SELECT meeting_id FROM
	(
	SELECT Participate.meeting_id, COUNT(Participate.user_id) AS alocount
	FROM Participate, 
		(SELECT user_id
		 FROM User 
		WHERE username = "doren") 
	AS D_User 
	WHERE D_User.user_id = Participate.user_id
	GROUP BY meeting_id
	) AS T2
	WHERE alocount < 2
);*/

UPDATE User SET status = 0 WHERE username = "doren" ;


/* Insert Team */
INSERT INTO  Team (name, status)
	VALUES ("new_team", 1);

INSERT INTO Team_In(team_name, staff_id) 
	SELECT "new_team", 1 FROM Team WHERE status=1 AND name="new_team";


/* Delete Team */
UPDATE Team
	SET status = 0
	WHERE name = "deleted_one";

/* Delete Team with a condition that they paid their debts */
UPDATE Team
	SET status = 0
	WHERE name = "deleted_one" AND NOT EXISTS (SELECT * FROM Meeting_Payment WHERE team_name = "deleted_one" AND status = 0);
/*
DELETE FROM Team_In WHERE Team_In.team_name = "deleted_one";
*/


/* 
Available: 
Answer queries about what rooms are available for a given time slot
*/
SELECT Available_Resource.id, Available_Resource.room_no 
FROM Available_Resource
WHERE Available_Resource.id 
NOT IN (
	SELECT Booking.resource_id
	FROM   Meeting 
	INNER JOIN Booking 
	ON    Meeting.meeting_id  = Booking.meeting_id
	WHERE ((Meeting.start_time BETWEEN CAST('04:01:00' AS time) AND CAST('4:30:00' AS time))
	OR    (Meeting.end_time   BETWEEN CAST('04:01:00' AS time) AND CAST('4:30:00' AS time))
	OR    (Meeting.start_time <= CAST('04:01:00' AS time) AND end_time >= CAST('4:30:00' AS time)))
	AND   Meeting.date        = '2018-04-30'
);


/* Add new meetings. Meeting Payment UPDATE */
INSERT INTO Meeting( creator_id, date, end_time, start_time )
(SELECT user_id, '2011-01-01', CAST('06:00:00' AS time), CAST('05:00:00' AS time) FROM User WHERE User.username = 'Madonna' AND User.status = 1);

INSERT INTO Booking ( meeting_id, resource_id)
SELECT 6, Available_Resource.id
FROM Available_Resource
WHERE Available_Resource.id NOT IN (
	SELECT Booking.resource_id
	FROM   Meeting 
	INNER JOIN Booking 
	ON    Meeting.meeting_id  = Booking.meeting_id
	WHERE ((Meeting.start_time BETWEEN CAST('05:00:00' AS time) AND CAST('06:00:00' AS time))
	OR    (Meeting.end_time   BETWEEN CAST('05:00:00' AS time) AND CAST('06:00:00' AS time))
	OR    (Meeting.start_time <= CAST('05:00:00' AS time) AND end_time >= CAST('06:00:00' AS time)))
	AND   Meeting.date        = '2019-01-01')
AND Available_Resource.id = 12;


/*Limit to insert to one team*/
INSERT INTO Meeting_Payment 
SELECT 6, Team_In.team_name, SUM( Facility.cost ), 0 
FROM   Team_In , Facility
WHERE Team_In.staff_id IN (
	SELECT DISTINCT creator_id
	FROM Meeting 
	WHERE creator_id IN 
		(SELECT user_id 
		FROM User 
		WHERE User.username = 'Madonna')
	)
AND Facility.name IN 
	(SELECT DISTINCT Facility_In.facility_name 
	FROM    Facility_In
	WHERE   Facility_In.resource_id = 13)
GROUP BY Team_In.team_name
LIMIT 1;


/* Book an unbooked meeting THIS is trivial*/
INSERT INTO Booking ( meeting_id, resource_id)
SELECT Meeting.meeting_id, Available_Resource.id 
FROM   Meeting, Available_Resource
WHERE  Meeting.meeting_id = 
	(SELECT meeting_id 
	FROM Meeting 
	WHERE creator_id = 
		(SELECT user_id FROM User WHERE User.username = 'doren') 
		AND Meeting.date = "12/01/2011" 
		AND end_time     = CAST('05:00:00' AS time) 
		AND start_time   = CAST('06:00:00' AS time) ) 
	AND Available_Resource.id 
	NOT IN 
		(SELECT Booking.resource_id
		FROM   Meeting 
		INNER JOIN Booking ON Meeting.meeting_id = Booking.meeting_id
		WHERE Meeting.start_time < CAST('05:00:00' AS time)  
		AND   Meeting.end_time > CAST('06:00:00' AS time) 
		AND   Meeting.date = DATE());


INSERT INTO Meeting_Payment 
SELECT Booking.meeting_id, Team_In.team_name, COUNT( Facility.cost ), 0 
FROM   Booking, Team_In , Facility, Facility_In 
WHERE  meeting_id =	
	(SELECT meeting_id 
	FROM Meeting 
	WHERE creator_id = meeting_helper.user_id)
AND    Team_In.staff_id = meeting_helper.user_id
AND    Facility.name IN 
	(SELECT Facility_In.name  
	FROM    Facility_In , Booking
	WHERE   Facility_In.resource_id = Booking.resource_id)
	AND Booking.meeting_id = 	
		(SELECT meeting_id 
		FROM Meeting 
		WHERE creator_id = meeting_helper.user_id)
		;


/*Delete Meeting , if the meeting was paid already we don't allow it to be deleted for now because no more information is provided for this case in lab instructions*/
DELETE FROM Meeting 
WHERE (Meeting.meeting_id = given_meeting_id 
AND   Meeting.date > CURDATE()
OR    ( Meeting.date = CURDATE() AND Meeting.start_time > CURTIME())) AND NOT EXISTS (SELECT * FROM Meeting_Payment WHERE meeting_id = given_meeting_id AND status=1);


/* Present occupation lists for all rooms on a given date.*/
SELECT Available_Resource.id, Available_Resource.room_no, Available_Resource.building_name, Meeting.start_time, Meeting.end_time
FROM   Available_Resource 
INNER JOIN Booking 
ON    Available_Resource.id = Booking.resource_id 
INNER JOIN Meeting
ON 	  Booking.meeting_id = Meeting.meeting_id 
WHERE Meeting.date = CAST('2020-01-01' AS date);



/* Show which users have booked which meetings.*/
SELECT username , user_id, Meeting.meeting_id, Meeting.start_time, Meeting.end_time, Meeting.date 
FROM User 
INNER JOIN Meeting 
ON User.user_id = Meeting.creator_id; 


/* Show all participants of a given meeting. */
SELECT  User.user_id ,User.username 
FROM Participate
INNER JOIN User 
ON Participate.user_id = User.user_id 
WHERE Participate.meeting_id = 'givenMeeting';


/* Show cost accrued by teams for any given time interval.  */
SELECT team_name, SUM ( amounts ) 
FROM Meeting_Payment 
WHERE status = 0 /* Meaning that the payment has not been paid yet*/
AND meeting_id IN 
	(SELECT meeting_id 
	FROM Meeting 
	WHERE Meeting.date > CAST('2010-01-01' AS date) 
	AND   Meeting.date < CAST('2020-02-01' AS date))
GROUP BY team_name;













