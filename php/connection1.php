

<html xmlns="http://www.w3.org/1999/xhtml">
   <head>
      <meta charset="UTF-8">
      <meta name="description" content=" DD1368, Spring2018, KTH, Stockholm">
      <meta name="keywords"    content="HTML,CSS,PHP">
      <meta name="author"      content="Doren Calliku, Ali Semi Yenimol">
      <meta name="viewport"    content="width=device-width, initial-scale=1.0">
      <title>
         Insert Meeting: Choose User.
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
         text-align: relative;
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
		<br>
            Choose the staff who will insert the meeting.<br> <br>
         </div>
         <form action="welcome.php" method="POST" style="float:left" margin: 0px;">
            <?php
               //Connection to database
               $servername = "localhost";
               $username = "root";
               $password = "Alumni2019";
               // Create connection
               
               $conn = new PDO("mysql:host=$servername;dbname=dd1368", $username, $password);
               $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
               
               $sql = "SELECT user_id, username, name, surname, position FROM User INNER JOIN Staff ON staff_id = user_id"; 
               $stmt = $conn->prepare($sql);
               $stmt->execute();
               $result = $stmt->fetchAll();
      
		foreach($result as $row) {
			echo " <input type=\"radio\" name=\"meeting\" value=\" ", $row['meeting_id'],  "\" required> ";
			echo $row['user_id'] . ". Username: ", $row['username'], " who works as ", $row['position'], " with full name as ", $row['name']." " ,$row['surname'].".";
			echo "<br>";
		}

?>
<input type="submit" name="user_info" value="Check available resources" style="float:right"/>

            <!-- Choose time slot and date-->
            <br>


            <div class="section_header">
               <label for="date">
               Meeting Date : 
               </label>
<!-- To be added constriction for dateInput> dateNow. In php it is written in the following form.date("Y/m/d")-->
               <input id="date" name = "date" type="date" value="2018-25-02" required/> 
               </br></br>
               <hr>
               <label for="start_time">
               Meeting Start Time : 
               </label>
               <input id="start_time" name = "start_time" type="time" value="05:00:00" required/> 
               </br></br>
               <hr>
               <label for="end_time"> 
               Meeting End Time : 
               </label>
               <input id="end_time"   name = "end_time"   type="time" value="06:00:00" required/>	
               </br></br>
            </div>
            <?php
               if(isset($_POST['date_name'])) {
                 echo "selected size: ".htmlspecialchars($_POST['date']);
               }
               if(isset($_POST['start_time'])) {
                 echo "selected size: ".htmlspecialchars($_POST['start_time']);
               }
               if(isset($_POST['end_time'])) {
                 echo "selected size: ".htmlspecialchars($_POST['end_time']);
               }
               if(isset($_POST['select'])) {
                 echo "selected size: ".htmlspecialchars($_POST['select']);
               }
?>
      
              <?php
                $conn = null;
               ?> 
 
           
         </form>
      </div>
   </body>
</html>


