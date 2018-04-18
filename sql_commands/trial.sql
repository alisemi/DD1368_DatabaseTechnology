/* Remember that a User is supposed to join to a Team initially as it is not on GUI part, we are doing manually for now */
INSERT INTO Team_In(team_name, staff_id) 
	SELECT "Team1", User.user_id FROM Team, User WHERE Team.status=1 AND Team.name="Team1" AND User.username = "doren";
