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
   
   $ID = $_POST['completionCode'];
   $IDType = $_POST['IDType'];
   $table = $_POST['data_table'];
   $completeTrials = $_POST['completeTrials'];
   $complete = '';
   if (isset($_POST['domain']))
   {
	   $domain = $_POST['domain'];
	   $complete = $complete . " AND domain = '" . $domain . "'";
   }
   if (isset($_POST['stimType']))
   {
	   $stimType = $_POST['stimType'];
	   $complete = $complete . "AND stimType = '" . $stimType . "'";
   }
   
   if ($IDType == 'workerID' || $IDType == 'ue_workerID')
	   $complete =  $complete . " AND trial_index_global > " . $completeTrials;
		
   $sql = "SELECT DISTINCT " . $IDType . " FROM " . $table . $complete;
   $retval = mysql_query($sql);
   
   
   if(! $retval )
   {
      die('Could not get data: ' . mysql_error());
   }
   

   $exists = 0;
   while($rows = mysql_fetch_array($retval, MYSQL_ASSOC))
   {
	   foreach($rows as $element)
	   {
		   if($element == $ID)
			   $exists = 1;
	   }
   }
   
   if($ID == 'AT3C00TKZK13L' || $ID == 'A3K4MDM191NKF6' || $ID == 'A3AZJGI9D7C0PD' || $ID == 'A2C39KTRMOM1XZ' || $ID == 'A2CNNBX9KLQUQJ' || $ID == 'A77K8W55MJEKX' || $ID == 'A28JIPBK8BEKHS' || $ID == 'A1R0689JPSQ3OF' || $ID == 'A1MMC6X3ZNJ9OT' || $ID == 'A33O23NO99ZA1D' || $ID == 'A3JI3B5GTVA95F' || $ID == 'A33QUS4NRVVMTN' || $ID == 'A14HW0XMI4R2ON' || $ID == 'A1G2XYC7T6HE2H' || $ID == 'ANUXUJE8QRE0C' || $ID == 'A3N1W4VYI7VXEV' || $ID == 'A2OO4PG3LBLP5I' || $ID == 'A16ICTTBPD7Q6Y' || $ID == 'A8028AFBBS29G' || $ID == 'A341XKSRZ58FJK' || $ID == 'AOMTL7RWZTP3Z' || $ID == 'AM2KK02JXXW48' || $ID == 'A1H2E85EW10IO3' || $ID == 'A1DY3EW6Q0B5K5' || $ID == 'A3U74S280Z4B0' || $ID == 'A27PVIL93ZMY46' || $ID == 'A98XHW6B1VSSQ')
	   $exists = 2; // Failed launch #1 ineligibility
   if($ID == 'A1MRX2GTR1SBDH' || $ID == 'A2W59CL4UQ3S4S' || $ID == 'AMPFH3OAXMTT0' || $ID == 'APGX2WZ59OWDN' || $ID == 'A3RHGIM99R25Q9' || $ID == 'A3U2WCPN59KBX5' || $ID == 'A1EQ2HDHF2WWSY' || $ID == 'A3AJJHOAV7WIUQ' || $ID == 'ANVAFB99K5RKP' || $ID == 'A5WYEGVV9VZ2P' || $ID == 'A5YVMQWA2IYPF' || $ID == 'A25MM8IKSW3G19' || $ID == 'A2GNV6ORRCB1OC' || $ID == 'AVC1PLLFS210S' || $ID == 'A17CJYH3NI201S' || $ID == 'A2XOKJX2IPLOA8' || $ID == 'AO2LJAB0IA1DX' || $ID == 'A3UV9UAE6MP36J' || $ID == 'A2Z6NL0CTXY0ZB' || $ID == 'AZ9BZONG644TU' || $ID == 'ATMQRDBW7WM1Z' || $ID == 'A3VHWEJL3QI4LE' || $ID == 'A2S75O867RJG0I')
	   $exists = 3; // Took too long between sessions
   if($ID == 'A2Z70GL7HTFFQR' || $ID == 'A2S5GPVIUV8RJI' || $ID == 'AU849EHZNGV2Z' || $ID == 'A16G6PPH1INQL8' || $ID == 'A2DWPP1KKAY0HG' || $ID == 'A2R9OK4M877ZCC' || $ID == 'ABUABR22YMOGG')
	   $exists = 4; // Exclusion criteria session 1
   
	echo $exists;

   
   mysql_close();
?>