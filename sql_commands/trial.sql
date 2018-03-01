

INSERT INTO Meeting( creator_id, date, end_time, start_time )
(SELECT user_id, '2011-01-01', CAST('06:00:00' AS time), CAST('05:00:00' AS time) FROM User WHERE User.username = 'Madonna');


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
	AND   Meeting.date        = '2011-01-01')
AND Available_Resource.id = 13;


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
GROUP BY Team_In.team_name;

