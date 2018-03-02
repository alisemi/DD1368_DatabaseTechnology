<form action="welcome.php" id="s" method="post">



<?php
	//Connection to database
	$servername = "localhost";
	$username = "root";
	$password = "Alumni2019";
	
	try {
		$conn = new PDO("mysql:host=$servername;dbname=dd1368", $username, $password);
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

		$sql = "SELECT user_id, username, name, surname, position FROM User INNER JOIN Staff ON staff_id = user_id"; 
		$stmt = $conn->prepare($sql);
		$stmt->execute();
		$result = $stmt->fetchAll();
		
			
		// Print everything
		echo "<p>Select User :</p>";
		foreach($result as $row) {
			echo " <input type=\"radio\" name=\"user\" value=\" ", $row['user_id'],  "\" required> ";
			echo $row['username'] . " - ", $row['name'], " - ", $row['surname'], " - ", $row['position'];
			echo "<br>";
		}
	}
	catch(PDOException $e) {
	    echo "Error: " . $e->getMessage();
	}
?>



<!-- Choose time slot and date-->
</br>
	<label for="date">Meeting Date : 
	</label>
	<input id="date" name = "date_name" type="date" value="2018-25-02" required/> 
        </br></br>
</br>
	<label for="start_time">Meeting Start Time : 
	</label>
	<input id="start_time" name = "new_start_time" type="time" value="05:00:00" required/> 
</br>
	<label for="end_time">Meeting End Time : 
	</label>
	<input id="end_time"   name = "new_end_time"   type="time" value="06:00:00" required/>	
</br>

<input type="submit" name="Submit Size" value="Continue"> 


<?php
    if(isset($_POST['date'])) {
      echo "selected size: ".htmlspecialchars($_POST['date']);
    }
    if(isset($_POST['start_time'])) {
      echo "selected size: ".htmlspecialchars($_POST['start_time']);
    }
    if(isset($_POST['end_time'])) {
      echo "selected size: ".htmlspecialchars($_POST['end_time']);
    }
     $conn = null;
?> 

</form>
