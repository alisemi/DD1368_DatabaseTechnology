<html>
<body>

<?php $new_date = date('Y-m-d', strtotime($_POST['date_name']));
      echo $new_date; ?>
<br>

<?php $new_start_time = date('H:i:s', strtotime($_POST['new_start_time']));
     echo $new_start_time; ?><br>
<?php $new_end_time   = date('H:i:s', strtotime($_POST['new_end_time']));
     echo $new_end_time;   ?><br>
<?php $vari = ($_POST['user']);
     echo $vari;   ?><br>


</body>
</html> 
