

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
            Hey ! 
            <br>Here the administrator chooses the meeting he or she has to book for the appointment. 
         </div>
         <form action="result.php" method="post" style="vertical-align: left; margin: 0px;">
	    <input type="hidden" name="userID" value="<?=$_POST['select'];?>">
	    <input type="hidden" name="sdate"  value="<?=$_POST['date'];?>">
	    <input type="hidden" name="stime"  value="<?=$_POST['start_time'];?>">
	    <input type="hidden" name="etime"  value="<?=$_POST['end_time'];?>">
	    <input type="hidden" name="resource" value="<?=$_POST['resource'];?>">
						
            <?php
               //Connection
               $servername = "localhost";
               $username   = "root";
               $password   = "Alumni2019";
               
 
               	$new_date       = date('Y-m-d', strtotime($_POST['date']));
               	$new_start_time = date('H:i:s', strtotime($_POST['start_time']));
               	$new_end_time   = date('H:i:s', strtotime($_POST['end_time']));
               	$vari 		= ($_POST['select']);
				
                echo "$vari";
		

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
               OR    (Meeting.end_time    BETWEEN CAST('$new_start_time' AS time) AND CAST('$new_end_time' AS time))
               OR    (Meeting.start_time <= CAST('$new_start_time' AS time) AND end_time >= CAST('$new_end_time' AS time)))
               AND   Meeting.date        = DATE('$new_date'));"; 
               	$stmt = $conn->prepare($sql);
               	$stmt->execute();
               	$result = $stmt->fetchAll();
             ?>

            <select name='resourceSelecter' class="floating_element">
               <?php foreach ($result as $row): ?>
               <option><?=$row['id']//.". ",$row['room_no']." has capacity ",$row['capacity']." and is in (",$row['address']. ",",$row['building_name'].")."?></option>
               <?php endforeach ?>
            </select>

		<?php
		#$resource = $_POST['resource'];

	    
	  
               // Send to the result.php file. 
	       if(isset($_POST['resourceSelecter'])){
                 echo "selected size: ".htmlspecialchars($_POST['resourceSelecter']);
               }

               
                $conn = null;
               ?> 
		
            <input type="submit" name="submit" id="submit" class="button" value="Submit"/>
         </form>
      </div>
   </body>
</html>


