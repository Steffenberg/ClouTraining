<?

include ("coachyy_sendSession.php");

header('Content-Type: text/json');
header('Cache-Control: private, no-cache, no-store, must-revalidate, no-transform'); // HTTP 1.1.
header('Pragma: no-cache'); // HTTP 1.0.
header('Expires: 0'); // Proxies.

$mysqli = DBCON_mysqli();

$EMAIL = filter_input(INPUT_GET, 'email', FILTER_SANITIZE_SPECIAL_CHARS);
$EMAIL = trim($EMAIL);

$PASSWORT = filter_input(INPUT_GET, 'password', FILTER_SANITIZE_SPECIAL_CHARS);
$PASSWORT = trim($PASSWORT);
$PASSWORT = utf8_decode($PASSWORT);

$CREATESESSION = filter_input(INPUT_GET, 'createSession', FILTER_SANITIZE_NUMBER_INT);

$date = filter_input(INPUT_GET, 'date', FILTER_SANITIZE_NUMBER_INT);
$date = date("Y-m-d H:i:s", $date);

if($CREATESESSION == 1){
    if (!($stmt = $mysqli->prepare('select trainerID from User, Trainer WHERE eMail =? and password=? AND User.userID=Trainer.userID AND Trainer.currentSession = 0'))) {
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
        $stmt->bind_result($trainerID);
        $stmt->fetch();
    } else {
        echo "Gnar";
        exit();
    }
    $r = createSession($EMAIL,$PASSWORT,$date);
}else{
    if (!($stmt = $mysqli->prepare('select trainerID from User, Trainer WHERE eMail =? and password=? AND User.userID=Trainer.userID'))) {
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
        $stmt->bind_result($trainerID);
        $stmt->fetch();
    } else {
        echo "Gnar2";
        exit();
    }
}

$knownUsers = array();



//$USERID = filter_input(INPUT_GET, 'user', FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_THOUSAND);

$lastValues = array();

echo "start\n";


$idletimeCount=0;

	$firstEmpty=0;
	while(true) {
	if (!($stmt = $mysqli->prepare('select LiveTrainingZone, TIMESTAMPDIFF(SECOND, LiveTrainingTimestamp, NOW()) as tdiff, User.userID, nickname from User,userXtrainer WHERE userXtrainer.trainerID=? AND userXtrainer.userID=User.userID AND liveActive=1 AND TIMESTAMPDIFF(SECOND, LiveTrainingTimestamp, NOW())<61'))) {
        echo "error-0-1<br>\n";
		echo $mysqli->error;
        exit();
    }
    if (!($stmt->bind_param('i', $trainerID))) {
        echo "error-0-2<br>\n";
		echo $mysqli->error;
        exit();
    }
    if (!($stmt->execute())) {
        echo "error-0-3<br>\n";
		echo $mysqli->error;
        exit();
    }
	$stmt->store_result();
	
	
	$currentlyActiveUsers=array();
	  if ($stmt->num_rows > 0) {
	 
		$stmt->bind_result($LiveTrainingZone, $LiveTrainingTimestamp, $userID, $nickname);
		$isIdle=1;
		
		while ($stmt->fetch()) {
			//echo ($LiveTrainingTimestamp. " timediff\n");
            if ($lastValues[$userID]!==$LiveTrainingZone) {
                if ($knownUsers[$userID]!==$nickname) {
                    echo ($userID." ".$LiveTrainingZone." ".$nickname."\n");
                    $knownUsers[$userID]=$nickname;
                    $lastValues[$userID]=$LiveTrainingZone;
                }else{
                    echo ($userID." ".$LiveTrainingZone."\n");
                    $lastValues[$userID]=$LiveTrainingZone;
                }
                $isIdle=0;
            }
			$currentlyActiveUsers[$userID]=1;
			
		}
		
		
		
		if ($isIdle) {
			$idletimeCount++;
		} else {
			$idletimeCount=0;
		}
		if ($idletimeCount>20) {
			echo ("Poke\n");
			ob_flush();
			flush();
			$idletimeCount=0;
		}
 	 
	  } else { 
		if ($firstEmpty==0) {
			echo "empty\n";
			ob_flush();
			flush();
			$firstEmpty=1;
		}
		$idletimeCount++;
		if ($idletimeCount>20) {
			echo ("Poke\n");
			ob_flush();
			flush();
			$idletimeCount=0;
		}
	  }
	  foreach (array_keys($lastValues) as $activeUser) {
		
			if ($currentlyActiveUsers[$activeUser]==1) {
			//	echo ($activeUser." still here\n");
			} else {
				echo ($activeUser." -1\n");
				unset($lastValues[$activeUser]);
			}
			
		}		
	  
        
        
        $mysqli->close();
	  ob_flush();
	  flush();

        /*if (connection_aborted()==1) {
            if (!($stmt = $mysqli->prepare('UPDATE Trainer SET currentSession = 0 WHERE trainerID = ?'))) {
                echo "error-1-7<br>\n";
                echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
                exit();
            }
            
            if (!($stmt->bind_param('i', $trainerID))) {
                echo "error-1-8<br>\n";
                exit();
            }
            
            if (!($stmt->execute())) {
                echo "error-1-9<br>\n".$mysqli->error;
                exit();
            }
        }*/
	
	  sleep(1);
	  $mysqli = DBCON_mysqli();
        
        
        
}
/*
while(true) {

 if (!($stmt_getHistory = $mysqli->prepare('insert into PulseMeasurePoint (trainingID, pulsevalue) values(?,?)'))) {
        echo "error-0-1<br>\n";
		echo $mysqli->error;
        exit();
    }
    if (!($stmt_getHistory->bind_param('ii', $TRAININGID, $PULSEVALUE))) {
        echo "error-0-2<br>\n";
		echo $mysqli->error;
        exit();
    }
    if (!($stmt_getHistory->execute())) {
        echo "error-0-3<br>\n";
		echo $mysqli->error;
        exit();
    }
}
*/
//echo("OK");

?>