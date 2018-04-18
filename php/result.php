

<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta charset="UTF-8">
      <meta name="description" content=" DD1368, Spring2018, KTH, Stockholm">
      <meta name="keywords"    content="HTML,CSS,PHP">
      <meta name="author"      content="Doren Calliku, Ali Semi Yenimol">
      <meta name="viewport"    content="width=device-width, initial-scale=1.0">
      <title>
         Check results. 
      </title>
      <style type="text/css" media="screen">
         * {
         margin:   3px 3px 3px 3px;
         padding:  3px 3px 3px 3px;
         }
         body, html {
         padding: 3px 3px 3px 3px;
         background-color: #D8DBE2;
         font-family: Verdana, sans-serif;
         font-size: 11pt;
         text-align: center;
         }
         div.main_page {
         position: relative;
         display: table;
         width: 800px;
         margin-bottom: 3px;
         margin-left: auto;
         margin-right: auto;
         padding: 0px 0px 0px 0px;
         border-width: 2px;
         border-color: #212738;
         border-style: solid;
         background-color: #FFFFFF;
         text-align: left;
         }
         div.page_header {
         height: 100%;
         width: 100%;
         background-color: #F5F6F7;
         }
         div.page_header span {
         margin: 15px 0px 0px 50px;
         font-size: 180%;
         font-weight: bold;
         }
         div.page_header img {
         margin: 3px 0px 0px 40px;
         border: 0px 0px 0px;
         }
         div.content_section {
         margin: 3px 3px 3px 3px;
         background-color: #FFFFFF;
         text-align: left;
         }
         div.section_header {
         padding: 3px 6px 3px 6px;
         background-color: #8E9CB2;
         color: #FFFFFF;
         font-weight: bold;
         font-size: 112%;
         text-align: center;
         }
         .floating_element {
         display: inline-block;
         position: relative;
         float: center;
         }
         .img {
         width:100%;
         }
         .radioLeft {
         display: block;
         text-align: left;
         float: left;
         }
         #formItem label {
         display: block;
         text-align: center;
         line-height: 150%;
         font-size: .85em;
         }
      </style>
   </head>
   <body>
      <div class="main_page">
         <form action="status.php" method="post" style="vertical-align: left; margin: 0px;">
            <?php
               //Connection
               $servername = "localhost";
               $username   = "root";
               $password   = "jaja123";
               
               // Taking values from the previous form with the POST variable.    
               $vari_res = $_POST['userID'];
               $resource_res = $_POST['resourceSelecter'];   
	       $team_sel = $_POST['teamSelecter']; 	
               $sdate = date('Y-m-d', strtotime($_POST['sdate']));
               $stime = date('H:i:s', strtotime($_POST['stime']));
               $etime = date('H:i:s', strtotime($_POST['etime']));
               /**
               echo $resource_res;
               echo $vari_res;
               echo $stime;
               echo $etime;
               echo $sdate;
               **/
               
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
?>


            <div class="section_header">
               <label for="payment"> 
               The creator, the meeting id, and the resource id it booked.
               </label>
               <br>
            </div>
            <?php
               $sql = "SELECT Meeting.creator_id, Booking.meeting_id, Booking.resource_id FROM Booking INNER JOIN Meeting ON Booking.meeting_id = Meeting.meeting_id WHERE Booking.meeting_id = '$meeting_id';";
               $stmt = $conn->prepare($sql);
               $stmt->execute();
               $result = $stmt->fetchAll();
               
               // Print everything
               foreach($result as $row) {
               	echo " <li>" ;
               	echo "Creator: ",$row['creator_id']." - Meeting: ", $row['meeting_id'] . " - Resource: ", $row["resource_id"];
               	echo "</li>";
               }
               
               	
               	$sql = "SELECT * FROM Meeting;";
               	$stmt = $conn->prepare($sql);
               	$stmt->execute();
               	$result = $stmt->fetchAll();
               ?>
            <div class="section_header">
               <label for="payment"> 
               The creator id and the meetings they have created.
               </label>
               <br>
            </div>
            <?php
               // Print everything
               foreach($result as $row) {
               	echo " <li>" ;
               	echo $row["creator_id"] . " - ", $row['meeting_id'];
               	echo "</li>";
               }
               
               echo "<br><p><Booking:</>";
               

               
               $sql = "INSERT INTO Meeting_Payment(meeting_id, team_name, amount, status)
               	(SELECT '$meeting_id', '$team_sel', SUM( Facility.cost ), 0 
               	FROM   Facility
               	WHERE Facility.name IN 
               		(
               		SELECT DISTINCT Facility_In.facility_name 
               		FROM    Facility_In
               		WHERE   Facility_In.resource_id = '$resource_res'
               		)
               	);";
               $conn->exec($sql);
               
               echo "<br><p><Booking:</>";
               ?>
            <div class="section_header">
               <label for="payment"> 
               This is the meeting payment table. Given in one row is the meeting id, the team name of the creator and the amount that should be payed from the team.
               </label>
               <br>
            </div>
            <?php
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
            <input name="Status" type="Submit" value="Present Status of Database">
         </form>
      </div>
   </body>
</html>


