<?php

   /*
      The code below is written by Jason Carpenter.
      GitHub: https://github.com/jmcarpenter2
      
   */
   
   // Submit Data to mySQL database
	include('database_connect.php');
  
   if(! $db )
   {
      die('Could not connect: ' . mysql_error());
   }
   
   $table = $_POST['data_table'];
   $dataType = $_POST['dataType'];
   $session = $_POST['session'];
   $curWorkerID = $_POST['curWorkerID'];
   $checkFBCond = '';
   if (isset($_POST['fbCond']))
   {
	   $feedbackCond = $_POST['fbCond'];
	   if (!empty($feedbackCond))
	   {
		   if($dataType == 'pointsEarned')
			   $checkFBCond = " AND feedbackCond = " . $feedbackCond;
	   }
			
   }
   
   $completeTrials = $_POST['completeTrials'];
   $complete = '';
   if ($dataType == 'pointsEarned' || $dataType == 'feedbackCond')
	   $complete = " AND trial_index_global > " . $completeTrials;
   $sql = "SELECT " . $dataType . " FROM ". $table . " WHERE session = " . $session . " AND workerID <> '". $curWorkerID . "'" . $checkFBCond . $complete . " ORDER BY timestamp DESC, trial_index_global DESC LIMIT 1";
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