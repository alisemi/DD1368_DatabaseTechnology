

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
         <div class="section_header">
            Hey ! </br>
            Here is the presentation of the main tables of the database dd1368.</br> 
         </div>
         <form action="index.php" method="post" style="vertical-align: left; margin: 0px;">
            <?php
               //Connection
               $servername = "localhost";
               $username   = "root";
               $password   = "Alumni2019";
               
               
               $conn = new PDO("mysql:host=$servername;dbname=dd1368", $username, $password);
               $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);?>
               <div class="section_header">
               <label for="payment"> 
                  User table. It includes Staff and Business Partners with active status.
               </label>
               <br>
            </div>
               <?php
               $sql = "SELECT user_id, username, name, surname, position FROM User WHERE status = 1"; 
               $stmt = $conn->prepare($sql);
               $stmt->execute();
               $result = $stmt->fetchAll();
               
               // Print everything
               foreach($result as $row) {
               echo " <li>" ;
               echo $row['user_id'].". ",$row['username']." (",$row['name']." ",$row['surname'].") who works as ",$row['position']. ".";
               echo "</li>";
               }
               ?>
            <div class="section_header">
               <label for="meetings"> 
               Meetings.
               </label>
               <br>
            </div>
            <?php
               $sql  = "SELECT * FROM Meeting;";
               	$stmt = $conn->prepare($sql);
               	$stmt ->execute();
               	$result = $stmt->fetchAll();
               
               	// Print everything
               	foreach($result as $row) {
               		echo " <li>" ;
               		echo "For the meeting with id ", $row['meeting_id']." which will happen on ", $row['date']." between time ", $row['meeting_id']." and ", $row['meeting_id']." the creator is the user with id ",$row['creator_id'].".";
               		echo "</li>";
               	}
                    ?>
            <div class="section_header">
               <label for="Bookings"> 
                  Booking Table.
               </label>
               <br>
            </div>
            <?php 
               $sql = "SELECT Meeting.creator_id, Booking.meeting_id, Booking.resource_id FROM Booking INNER JOIN Meeting ON Booking.meeting_id = Meeting.meeting_id ORDER BY Meeting.creator_id, Booking.meeting_id;";
               $stmt = $conn->prepare($sql);
               $stmt->execute();
               $result = $stmt->fetchAll();
               
               // Print everything
               foreach($result as $row) {
               	echo " <li>" ;
               	echo "Creator: ",$row['creator_id']." - Meeting: ", $row['meeting_id'] . " - Resource: ", $row["resource_id"];
               	echo "</li>";
               }
               
               ?>
            <div class="section_header">
               <label for="payment"> 
              		Meeting payment table.
               </label>
               <br>
            </div>
            <?php
               $sql = "SELECT meeting_id,team_name,amount FROM Meeting_Payment;";
               $stmt = $conn->prepare($sql);
               $stmt->execute();
               $result = $stmt->fetchAll();
               
               // Print everything
               foreach($result as $row) {
                   echo " <li>" ;
               	echo "The meeting is ",$row['meeting_id'] . ", team name that will pay ", $row["team_name"], " and the amount to be payed is ", $row["amount"].".";
                         echo "</li>";
               }
               
               $conn = null;
               ?>
            <div class="section_header">
               <label for="end"> 
              
           <input name="index" type="Submit" value="Go to first page" style = "float:right">
<br>
               </label>
               <br>
            </div>
		
         </form>
      </div>
   </body>
</html>


