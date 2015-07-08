<?

include("function_sql.php");
$mysqli = DBCON_mysqli();
$userID=getUserID($mysqli);

$trainersInput = filter_input(INPUT_GET, 'trainers', FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_THOUSAND);

$trainers = explode (",", $trainersInput);

/*echo $trainers[0]."\n";
echo $trainers[1]."\n";
exit();*/

function addParticipant($sessionID,$userID)
{
    global $mysqli;
    
    
    
    
    if (!($stmt = $mysqli->prepare('INSERT INTO userXliveTraining (userID,sessionID) values(?,?)'))) {
        echo "error-2-7<br>\n";
        echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
        exit();
    }
    
    if (!($stmt->bind_param('ii',$userID,$sessionID))) {
        echo "Bind failed: (" . $mysqli->errno . ") " . $mysqli->error;
        echo "error-2-8<br>\n";
        exit();
    }
    
    if (!($stmt->execute())) {
        echo "error-2-9<br>\n".$mysqli->error;
        exit();
    }
    
    
}


    if (!($stmt = $mysqli->prepare('UPDATE userXtrainer SET liveActive = IF (trainerID IN ('.$trainersInput.'),1,0) WHERE userID = ?'))) {
        echo "error-1-7<br>\n";
        echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
        exit();
    }
    
    if (!($stmt->bind_param('i',$userID))) {
        echo "error-1-8<br>\n";
        exit();
    }
    
    if (!($stmt->execute())) {
        echo "error-1-9<br>\n";
        exit();
    }

    foreach($trainers as $trainerID){
        
        if (!($stmt = $mysqli->prepare('SELECT currentSession from Trainer WHERE trainerID = ?'))) {
            echo "error-0-1<br>\n";
            echo $mysqli->error;
            exit();
        }
        if (!($stmt->bind_param('i', $trainerID))) {
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
            $stmt->bind_result($sessionID);
            $stmt->fetch();
            
            if($sessionID > 0){
                addParticipant($sessionID,$userID);
            }
            
            
            
        } else {
            echo "Trainer Gnar";
            exit();
        }
    }




echo "OK";
?>