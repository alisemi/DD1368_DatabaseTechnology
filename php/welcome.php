

<?php

		//Connection
		$servername = "localhost";
		$username   = "root";
		$password   = "Alumni2019";
		
		// Taking values from the previous form with the POST variable.
 		$new_date = date('Y-m-d', strtotime($_POST['date_name']));
      		
 		$new_start_time = date('H:i:s', strtotime($_POST['new_start_time']));
    		 
 		$new_end_time   = date('H:i:s', strtotime($_POST['new_end_time']));
     		 
 		$vari = ($_POST['user']);
		echo "$vari";
     		

		// Working with the database: SELECT what one needs. 
  		try {
			$conn = new PDO("mysql:host=$servername;dbname=dd1368", $username, $password);
			$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
      
			$sql = "SELECT Available_Resource.id, Available_Resource.room_no, Available_Resource.capacity ,Available_Resource.address, Available_Resource.building_name
FROM Available_Resource
WHERE Available_Resource.id NOT IN (
	SELECT Booking.resource_id
	FROM   Meeting 
	INNER JOIN Booking 
	ON    Meeting.meeting_id  = Booking.meeting_id
	WHERE ((Meeting.start_time BETWEEN CAST('$new_start_time' AS time) AND CAST('$new_end_time' AS time))
	OR    (Meeting.end_time   BETWEEN CAST('$new_start_time' AS time) AND CAST('$new_end_time' AS time))
	OR    (Meeting.start_time <= CAST('$new_start_time' AS time) AND end_time >= CAST('$new_end_time' AS time)))
	AND   Meeting.date        = DATE('$new_date'));"; 
			$stmt = $conn->prepare($sql);
			$stmt->execute();
			$result = $stmt->fetchAll();
			
      			// Select from Radio Buttons
			echo "<p>Select an available resource :</p>";
			echo "<form action=\"result.php\" id=\"s\" method=\"post\">";
			foreach($result as $row) {
				echo " <input type=\"radio\" name=\"resource\" value=\" ", $row['id'],       "\" required> ";
				
				echo $row['id'] . " - ", $row['room_no'], " - ", $row['capacity'], " - ", $row['address'],"-",  $row['building_name'];
				echo "<br>";
			}
			echo "<input type=\"hidden\" name=\"userID\" value=\"$vari\">";
			echo "<input type=\"hidden\" name=\"sdate\" value=\"$new_date\">";
			echo "<input type=\"hidden\" name=\"stime\" value=\"$new_start_time\">";
			echo "<input type=\"hidden\" name=\"etime\" value=\"$new_end_time\">";
			echo "<input type=\"submit\" name=\"submit\" id=\"submit\" class=\"button\" value=\"Submit\"/>";			
			echo "</form>";
		}

		catch(PDOException $e) {
		    echo "Error: " . $e->getMessage();
		}
?>





<?php
	    // Send to the result.php file. 
	    if(isset($_POST[$new_date])) {
	      echo "selected size: ".htmlspecialchars($_POST[$new_date]);
	    }
	    if(isset($_POST[$new_start_time])) {
	      echo "selected size: ".htmlspecialchars($_POST[$new_start_time]);
	    }
	    if(isset($_POST[$new_end_time])) {
	      echo "selected size: ".htmlspecialchars($_POST[$new_end_time]);
	    }
	    /*if(isset($_POST['halo'])){
	      echo "selected size: ".htmlspecialchars($_POST[$vari]);
	    }*/
            //$_POST['vari'] = $vari;

	     $conn = null;
?> 

</form>
