

<?php

		//Connection
		$servername = "localhost";
		$username   = "root";
		$password   = "Alumni2019";
		
		// Taking values from the previous form with the POST variable.
 		$vari = ($_POST['meeting']);
		echo "$vari";
     		

		// Working with the database: SELECT what one needs. 
  		try {
			$conn = new PDO("mysql:host=$servername;dbname=dd1368", $username, $password);
			$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
      
			$sql = "DELETE FROM Meeting 
WHERE Meeting.meeting_id = '$vari'
AND   Meeting.date > CURDATE()
OR ( Meeting.date = CURDATE() AND Meeting.start_time > CURTIME())"; 
			$conn->exec($sql);


		echo "DELETED meeting with id $vari";

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
		
			
      		}

		catch(PDOException $e) {
		    echo "Error: " . $e->getMessage();
		}
?>





<?php
	  

	     $conn = null;
?> 
