<form action="deletion2.php" id="s" method="post">



<?php
	//Connection to database
	$servername = "localhost";
	$username = "root";
	$password = "Alumni2019";
	
	try {
		$conn = new PDO("mysql:host=$servername;dbname=dd1368", $username, $password);
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

		$sql = "SELECT * FROM Meeting"; 
		$stmt = $conn->prepare($sql);
		$stmt->execute();
		$result = $stmt->fetchAll();
		
			
		// Print everything
		echo "<p>Select User :</p>";
		foreach($result as $row) {
			echo " <input type=\"radio\" name=\"meeting\" value=\" ", $row['meeting_id'],  "\" required> ";
			echo $row['meeting_id'] . " - ", $row['creator_id'], " - ", $row['date'], " - ", $row['start_time'] ," - ", $row['end_time'];
			echo "<br>";
		}
	}
	catch(PDOException $e) {
	    echo "Error: " . $e->getMessage();
	}
?>

<input type="submit" name="Submit Size" value="Delete"> 


<?php
     $conn = null;
?> 

</form>
