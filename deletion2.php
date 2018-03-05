

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
	<form action="status.php" id="s" method="post">
   
	 <div class="section_header">
               <label for="end"> 
           		Meetings after deletion.
               </label>
         </div>
<?php

		//Connection
		$servername = "localhost";
		$username   = "root";
		$password   = "Alumni2019";
		
		// Taking values from the previous form with the POST variable.
 		$vari = ($_POST['meeting']);
		
   		

		// Working with the database: SELECT what one needs. 
  		try {
			$conn = new PDO("mysql:host=$servername;dbname=dd1368", $username, $password);
			$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
      
			$sql = "DELETE FROM Meeting 
WHERE Meeting.meeting_id = '$vari'
AND   Meeting.date > CURDATE()
OR ( Meeting.date = CURDATE() AND Meeting.start_time > CURTIME())"; 
			$conn->exec($sql);

		$sql = "SELECT * FROM Meeting;";
		$stmt = $conn->prepare($sql);
		$stmt->execute();
		$result = $stmt->fetchAll();
  
		// Print everything
		foreach($result as $row) {
			echo " <li>" ;
			echo "Meeting id is ", $row['meeting_id'] . " and is created from staff with id ", $row["creator_id"].".";
			echo "</li>";
		}
		echo "";
		echo "Deleted meeting with id $vari.";
			
      		}

		catch(PDOException $e) {
		    echo "Error: " . $e->getMessage();
		}	  

		echo "";

	     $conn = null;
?>
  	
            <input name="Status" type="Submit" style = "float:right" value="Present Status of Database">
</form>
</div>
</html>

