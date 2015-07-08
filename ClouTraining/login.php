<?
include("function_sql.php");
/*
function DBCON_mysqli() {
 $HOST       = "127.0.0.1";
  $DATABASE   = "coachyy";
  $USER       = "dbuser";
  $PASSWORD   = "5EQ%HMu85FT?%Tx";
return new mysqli($HOST, $USER, $PASSWORD, $DATABASE);
}*/

$mysqli = DBCON_mysqli();


$EMAIL = filter_input(INPUT_GET, 'email', FILTER_SANITIZE_SPECIAL_CHARS);
$EMAIL = trim($EMAIL);

$PASSWORT = filter_input(INPUT_GET, 'password', FILTER_SANITIZE_SPECIAL_CHARS);
$PASSWORT = trim($PASSWORT);
$PASSWORT = utf8_decode($PASSWORT);



if (!($stmt = $mysqli->prepare('select userID, isAlltimeUser, demoTrainingsLeft, aboExpires from User where eMail =? and password=?'))) {
        echo "error-0-1<br>\n";
		echo $mysqli->error;
        exit();
}
if (!($stmt->bind_param('ss', $EMAIL,$PASSWORT))) {
  echo "-1";
  exit();
}	
 if (!($stmt->execute())) {
        echo "error-0-3<br>\n";
		echo $mysqli->error;
        exit();
    }
$stmt->store_result();
	
	
	  if ($stmt->num_rows > 0) {
	  $stmt->bind_result($userid, $isAlltimeUser, $demoTrainingsLeft, $aboExpires);
		$stmt->fetch();	
		
}else {
		echo "Gnar";
		exit();
	  }

		
		if (!($stmt = $mysqli->prepare('select trainerID, isLiveCoach, liveExpires from Trainer where userID=? and isLiveCoach=1'))) {
        echo "error-0-1<br>\n";
		echo $mysqli->error;
        exit();
}

if (!($stmt->bind_param('i', $userid))) {
  echo "-1";
  exit();
}	
 if (!($stmt->execute())) {
        echo "error-0-3<br>\n";
		echo $mysqli->error;
        exit();
    }
	
$stmt->store_result();
		  if ($stmt->num_rows > 0) {
		  $usertype="Trainer";
		   $stmt->bind_result($trainerID, $isLiveCoach, $liveExpires);
		$stmt->fetch();	
		  //echo "Trainer";
		  } else {
		  $usertype="User";
		  //echo "User";
		  }
	  
	  
	  
	  	if (!($stmt = $mysqli->prepare('select Trainer.trainerID, name, vorname, nickname from Trainer, userXtrainer, User where userXtrainer.userID=? and Trainer.trainerID=userXtrainer.trainerID and Trainer.userID=User.userID'))) {
			echo "error-0-1<br>\n";
			echo $mysqli->error;
			exit();
		}
	  
	 if (!($stmt->bind_param('i', $userid))) {
	echo "-1";
	exit();
}	 
	  
	   if (!($stmt->execute())) {
        echo "error-0-3<br>\n";
		echo $mysqli->error;
        exit();
    }
	
$stmt->store_result();
$trainerarray=array();
		   $stmt->bind_result($trainerid,$name,$prename,$nickname);
		  while($stmt->fetch())
        {
		$currenttrainer=array("trainerID" =>$trainerid, "name" => $name, "prename" =>$prename, "nickname" => $nickname );
		$trainerarray[]=$currenttrainer;
		  }
	  
	  
	  
	  
	  
	  
	  $resultarray = array("usertype" => $usertype, "isAlltimeUser"=>$isAlltimeUser, "demoTrainingsLeft"=>$demoTrainingsLeft , "isLiveCoach"=>$isLiveCoach, "liveExpires"=>$liveExpires, "trainers" => $trainerarray, "aboExpires" => strtotime($aboExpires));
	  
	  
	  
	  
	  
	  
	  
	  echo json_encode($resultarray);
?>