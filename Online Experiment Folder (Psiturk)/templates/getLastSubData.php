<?php
   
   // Submit Data to mySQL database
	include('database_connect.php');
  
   if(! $db )
   {
      die('Could not connect: ' . mysql_error());
   }
   
   $table = $_POST['data_table'];
   $dataType = $_POST['dataType'];
   $session = $_POST['session'];
   $sql = 'SELECT ' . $dataType . ' FROM ' . $table . ' WHERE session = ' . $session . ' ORDER BY timestamp DESC LIMIT 1';
   $retval = mysql_query($sql);
   
   if(! $retval )
   {
      die('Could not get data: ' . mysql_error());
   }
   
   $dataVal = mysql_fetch_array($retval, MYSQL_ASSOC);
   
   foreach($dataVal as $value)
   {
	   echo $value;
   }
   
   mysql_close();
?>