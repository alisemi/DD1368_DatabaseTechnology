
/* New User As Staff */ 
INSERT INTO User(username, password, name, surname, position)
	VALUES("doren", "doren123", "Doren", "Calliku", "Cleaner");
INSERT INTO Staff(staff_id) SELECT user_id FROM User WHERE username="doren" AND NOT EXISTS(SELECT partner_id FROM Business_Partner WHERE partner_id = user_id);


/* OR As Business Partner */
INSERT INTO User(username, password, name, surname, position)
	VALUES("ali", "ali123", "Ali", "Yenimol", "Business");
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
WITH meeting_participate AS (
	SELECT Participate.meeting_id, COUNT(Participate.user_id) AS Count
	FROM Participate, (SELECT user_id FROM User WHERE username = "deleted_one") AS D_User 
	WHERE D_User.user_id = Participate.user_id 
	GROUP BY meeting_id),
DELETE FROM Meeting
	WHERE meeting_id 
	EXISTS meeting_participate 
	AND meeting_participate.Count < 1;

DELETE FROM User 
	WHERE username = "deleted_one" ;

/* Insert Team */
INSERT INTO  Team (name, status)
	VALUES ("new_team", 1) 
	ON DUPLICATE KEY UPDATE
	status = 1;

INSERT INTO Team_In(team_name, staff_id) 
	VALUES( "new_team", 1), 
	VALUES( "new_team", 2);

/* Delete Team */
UPDATE Team
	SET status = 0
	WHERE name = "deleted_one";

DELETE FROM Team_In WHERE team.name = "deleted_one";

/* Available */
SELECT Available_Resource.id, Available_Resource.room_no 
	FROM Available_Resource
	WHERE Available_Resource.id 
	NOT IN (
		SELECT Available_Resource.id
		FROM Meeting 
		INNER JOIN Booking ON Meeting.meeting_id = Booking.meeting_id
		INNER JOIN Available_Resource ON Booking.resource_id = Available_Resource.id
		WHERE Meeting.start_time < CAST('05:00:00' AS time)  
		AND Meeting.end_time > CAST('06:00:00' AS time) 
		AND Meeting.date = DATE());


SELECT Available_Resource.id, Available_Resource.room_no 
FROM Available_Resource
WHERE Available_Resource.id 
NOT IN (
	SELECT Booking.resource_id
	FROM Meeting 
	INNER JOIN Booking ON Meeting.meeting_id = Booking.meeting_id
	WHERE Meeting.start_time < CAST('05:00:00' AS time)  
	AND Meeting.end_time > CAST('06:00:00' AS time) 
	AND Meeting.date = DATE());

/* Add new meetings. Meeting Payment UPDATE */
INSERT INTO Meeting( creator_id, date, end_time, start_time )
(SELECT creator_id, "12/01/2011", CAST('05:00:00' AS time), CAST('06:00:00' AS time) FROM User WHERE User.username = 'doren');

WITH meeting_helper AS 
(SELECT meeting_id 
FROM Meeting 
WHERE creator_id = 
	(SELECT user_id 
	FROM User 
	WHERE User.username = 'doren') 
AND Meeting.date = "12/01/2011" 
AND end_time     = CAST('05:00:00' AS time) 
AND start_time   = CAST('06:00:00' AS time)),

resource_helper AS
(SELECT Booking.resource_id
FROM   Meeting 
INNER JOIN Booking 
ON Meeting.meeting_id = Booking.meeting_id
WHERE Meeting.start_time < CAST('05:00:00' AS time)  
AND   Meeting.end_time   > CAST('06:00:00' AS time) 
AND   Meeting.date       = DATE())

INSERT INTO Booking ( meeting_id, resource_id)
SELECT Meeting.meeting_id, Available_Resource.id 
FROM   Meeting, Available_Resource
WHERE  Meeting.meeting_id = 
	(SELECT meeting_id 
	FROM Meeting 
	WHERE creator_id = meeting_helper.user_id
	AND Available_Resource.id NOT IN ( resource_helper));


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



/* Book an unbooked meeting*/
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

/*Delete Meeting*/

DELETE FROM Meeting 
WHERE Meeting.meeting_id = given_meeting_id 
AND   Meeting.date > CURDATE()
OR    ( Meeting.date = CURDATE() AND Meeting.start_time > CURTIME());

/* Present occupation lists for all rooms on a given date.*/

SELECT Available_Resource.id, Available_Resource.room_name, Available_Resource.building_name, Meeting.start_time, Meeting.end_time
FROM   Available_Resource 
INNER JOIN Booking 
ON    Available_Resource.id = Booking.resource_id 
INNER JOIN Meeting
ON 	  Booking.meeting_id = Meeting.meeting_id 
WHERE Meeting.date = CAST('given' AS date)
GROUP BY Available_Resource.id;

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
WHERE status = 1 
AND meeting_id IN 
	(SELECT meeting_id 
	FROM Meeting 
	WHERE Meeting.date > DATE(1) 
	AND   Meeting.date > DATE(2))
GROUP BY team_name;












