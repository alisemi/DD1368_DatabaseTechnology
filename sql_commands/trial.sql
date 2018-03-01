INSERT INTO Meeting( creator_id, date, end_time, start_time )
(SELECT creator_id, "12/01/2011", CAST('05:00:00' AS time), CAST('06:00:00' AS time) FROM User WHERE User.username = 'doren');

INSERT INTO Booking ( meeting_id, resource_id)
SELECT Meeting.meeting_id, Available_Resource.id 
FROM   Meeting, Available_Resource, 
	(SELECT meeting_id 
	FROM Meeting 
	WHERE creator_id IN
		(SELECT user_id 
		FROM User 
		WHERE User.username = 'doren') 
	AND Meeting.date = "12/01/2011" 
	AND end_time     = CAST('05:00:00' AS time) 
	AND start_time   = CAST('06:00:00' AS time)
	) AS meeting_helper,
	(SELECT Booking.resource_id
	FROM   Meeting 
	INNER JOIN Booking 
	ON Meeting.meeting_id = Booking.meeting_id
	WHERE Meeting.start_time < CAST('05:00:00' AS time)  
	AND   Meeting.end_time   > CAST('06:00:00' AS time) 
	AND   Meeting.date       = DATE()
	) AS resource_helper
WHERE  Meeting.meeting_id IN
	(SELECT meeting_id 
	FROM Meeting 
	WHERE creator_id = meeting_helper.user_id
	AND Available_Resource.id NOT IN ( resource_helper));


INSERT INTO Meeting_Payment 
SELECT Booking.meeting_id, Team_In.team_name, COUNT( Facility.cost ), 0 
FROM   Booking, Team_In , Facility, Facility_In,
	(SELECT meeting_id 
	FROM Meeting 
	WHERE creator_id IN 
		(SELECT user_id 
		FROM User 
		WHERE User.username = 'doren') 
	AND Meeting.date = "12/01/2011" 
	AND end_time     = CAST('05:00:00' AS time) 
	AND start_time   = CAST('06:00:00' AS time)
	) AS meeting_helper,
WHERE  meeting_id IN	
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
