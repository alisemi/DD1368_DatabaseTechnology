<html>
<body>

<p> anne </p>
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
		

		$sql = "SELECT * FROM Meeting;";//"INSERT INTO Booking(meeting_id, resource_id) VALUES($vari_res, $resource_res);"; 
		$stmt = $conn->prepare($sql);
		$stmt->execute();
		$result = $stmt->fetchAll();

		// Print everything
		echo "<p>Select User :</p>";
		foreach($result as $row) {
			echo " <li>" ;
			echo $row['meeting_id'] . " - ", $row["creator_id"];
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

