

<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta charset="UTF-8">
      <meta name="description" content=" DD1368, Spring2018, KTH, Stockholm">
      <meta name="keywords"    content="HTML,CSS,PHP">
      <meta name="author"      content="Doren Calliku, Ali Semi Yenimol">
      <meta name="viewport"    content="width=device-width, initial-scale=1.0">
      <title>
         Choose time-slot. 
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
         <div class="section_header">
            Hey ! </br>
            Here the administrator chooses the meeting he or she has to book for the appointment. </br> 
         </div>
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
            	//echo "<input type=\"submit\" name=\"submit\" id=\"submit\" class=\"button\" value=\"Submit\"/>";			
            	echo "</form>";
            }
            
            catch(PDOException $e) {
                echo "Error: " . $e->getMessage();
            }
            ?>
	    <div class="section_header">
		<input type="submit" name="submit" id="submit" class="button" value="Submit">
	    </div>
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
      </div>
   </body>
</html>


