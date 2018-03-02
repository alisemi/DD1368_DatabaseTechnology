<html>
<body>

<?php

	//Connection
	$servername = "localhost";
	$username   = "root";
	$password   = "Alumni2019";
	
	// Taking values from the previous form with the POST variable.
	$sdate = $_POST['sdate'];
	
	$stime = $_POST['stime'];
	 
	$etime = $_POST['etime'];
	
	$vari_res = $_POST['userID'];
	
	$resource_res = $_POST['resource'];
       
	echo $vari_res; 
	echo $resource_res;
	echo $sdate;
	echo $stime;
	echo $etime;
	

	// Working with the database: SELECT what one needs. 
	try {
		$conn = new PDO("mysql:host=$servername;dbname=dd1368", $username, $password);
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

	        // find the meeting with xxxxx values, and take its id.
       	        $sql = "INSERT INTO Meeting( creator_id, date, end_time, start_time )
(SELECT DISTINCT user_id, '$sdate', CAST('$etime' AS time), CAST('$stime' AS time) FROM User WHERE User.user_id = '$vari_res');";
		$conn->exec($sql);

		$sql = "SELECT meeting_id FROM Meeting ORDER BY meeting_id DESC LIMIT 1;";
		$stmt = $conn->prepare($sql);
		$stmt->execute();
		$result = $stmt->fetchAll();
		$meeting_id = 0;
		foreach($result as $row) {
			$meeting_id = $row['meeting_id'];
		}

                $sql = "INSERT INTO Booking(meeting_id, resource_id) (SELECT meeting_id, '$resource_res' FROM Meeting WHERE Meeting.meeting_id = '$meeting_id');";
		$conn->exec($sql);
		
		$sql = "SELECT * FROM Meeting;";
		$stmt = $conn->prepare($sql);
		$stmt->execute();
		$result = $stmt->fetchAll();

		// Print everything
		foreach($result as $row) {
			echo " <li>" ;
			echo $row['meeting_id'] . " - ", $row["creator_id"];
			echo "</li>";
		}
		
		echo "<br><p><Booking:</>";

		$sql = "SELECT * FROM Booking;";
		$stmt = $conn->prepare($sql);
		$stmt->execute();
		$result = $stmt->fetchAll();

		// Print everything
		foreach($result as $row) {
			echo " <li>" ;
			echo $row['meeting_id'] . " - ", $row["resource_id"];
			echo "</li>";
		}
		
		#$vari         = (int)$vari;
		#$meeting_id   = (int)$meeting_id;
		#$resource_res = (int)$resource_res;
		

		$sql = "INSERT INTO Meeting_Payment(meeting_id, team_name, amount, status)
			(SELECT '$meeting_id', Team_In.team_name, SUM( Facility.cost ), 0 
			FROM   Team_In , Facility
			WHERE Team_In.staff_id IN (
				SELECT DISTINCT creator_id
				FROM Meeting 
				WHERE creator_id IN 
					(SELECT user_id 
					FROM User 
					WHERE User.user_id = '$vari_res'
					)
			)
			AND Facility.name IN 
				(
				SELECT DISTINCT Facility_In.facility_name 
				FROM    Facility_In
				WHERE   Facility_In.resource_id = '$resource_res'
				)
			GROUP BY Team_In.team_name
			);";
		$conn->exec($sql);

		echo "<br><p><Booking:</>";

		$sql = "SELECT * FROM Meeting_Payment;";
		$stmt = $conn->prepare($sql);
		$stmt->execute();
		$result = $stmt->fetchAll();

		// Print everything
		foreach($result as $row) {
			echo " <li>" ;
			echo $row['meeting_id'] . " - ", $row["team_name"], " - ", $row["amount"];
			echo "</li>";
		}


		


	}

	catch(PDOException $e) {
	    echo "Error: " . $e->getMessage();
	}

     $conn = null;
?>
</body>
</html> 

