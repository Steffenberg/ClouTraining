<?php
# *************************************************************************************************** #
# senden von PulseMeasurePoint
# Stand: 28.01.2015
# *************************************************************************************************** #

include ("function_sql.php");
    
function trainingExists($trainingID){

    global $mysqli;
    if (!($stmt = $mysqli->prepare('select trainingID, LENGTH(pulseMeasurePoints) from Training where trainingID =?'))) {
        echo "error-X-1<br>\n";
        echo $mysqli->error;
        exit();
    }
    if (!($stmt->bind_param('i', $trainingID))) {
        echo "error-X-2<br>\n";
        exit();
    }
    if (!($stmt->execute())) {
        echo "error-X-3<br>\n";
        echo $mysqli->error;
        exit();
    }
    $stmt->store_result();
    

    if ($stmt->num_rows > 0) {
		$stmt->bind_result($tid, $pmplen);
		$stmt->fetch();
        if ($pmplen  > 0) {
			return 2;
		}
        return 1;
    }
    return 0;
    
}
    
    
# *************************************************************************************************** #
# 1. Training
# *************************************************************************************************** #

    function clearTrainings(){
        global $mysqli;
        if (!($stmt = $mysqli->prepare('DELETE from Training'))) {
            echo "error-del-1<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        if (!($stmt->execute())) {
            echo "error-del-2<br>\n";
            exit();
        }
    }
    
    function createTraining($trainingID,$duration,$distance,$trainingDate,$sportsType,$mood,$maxPulse,$participants,$bwert,$kcal,$comment,$userid)
    {
       
        $zero = 0;
        
        global $mysqli;
        if (!($stmt = $mysqli->prepare('replace into Training  (trainingID, userID ,trainerID, trainingDate, distance, duration, sportsType, mood, maxPulse,participants,bwert,kcal,comment) values(?,?,?,?,?,?,?,?,?,?,?,?,?)'))) {
            echo "error-1-7<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        
        if (!($stmt->bind_param('iiissisiiiiis',$trainingID,$userid,$zero,$trainingDate,$distance,$duration,$sportsType,$mood,$maxPulse,$participants,$bwert,$kcal,$comment))) {
            echo "error-1-8<br>\n";
            exit();
        }
        
        if (!($stmt->execute())) {
            echo "error-1-9<br>\n".$mysqli->error;
            exit();
        }
    }
    
    function updateTraining($distance,$sportsType,$mood, $bwert, $kcal, $comment, $trainingID, $duration)
    {
        global $mysqli;
        if (!($stmt = $mysqli->prepare('UPDATE Training SET distance =?, duration=?, sportsType =?, mood=?, bwert=?, kcal=? ,comment=? WHERE trainingID =?'))) {
            echo "error-2-7<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        
        if (!($stmt->bind_param('sisiiisi',$distance, $duration, $sportsType, $mood, $bwert, $kcal ,$comment, $trainingID))) {
            echo "Bind failed: (" . $mysqli->errno . ") " . $mysqli->error;
            echo "error-2-8<br>\n";
            exit();
        }

        if (!($stmt->execute())) {
            echo "error-2-9<br>\n".$mysqli->error;
            exit();
        }
        
        
    }
# *************************************************************************************************** #
# 1 Pulse Measure Points
# *************************************************************************************************** #
    
    function clearPoints(){
        global $mysqli;
        if (!($stmt = $mysqli->prepare('DELETE from PulseMeasurePoint'))) {
            echo "error-del-1<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        if (!($stmt->execute())) {
            echo "error-del-2<br>\n";
            exit();
        }
    }
    
    function createPMP($trainingID,$pulseValue,$timeStamp, $zoneType, $stmt_pmp)
    {
        
        

        global $mysqli;
		
       

        if (!($stmt_pmp->bind_param('iisi',$trainingID,$pulseValue,$timeStamp, $zoneType))) {
            echo "error-1-8<br>\n";
            exit();
        }

        if (!($stmt_pmp->execute())) {
            echo "error-1-9<br>\n";
            exit();
        }
    }
    

    function updateGender($male,$userID)
    {
        global $mysqli;
        if (!($stmt = $mysqli->prepare('UPDATE User SET male=? WHERE userID =?'))) {
            echo "error-2-7<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        
        if (!($stmt->bind_param('ii',$male,$userID))) {
            echo "Bind failed: (" . $mysqli->errno . ") " . $mysqli->error;
            echo "error-2-8<br>\n";
            exit();
        }
        
        if (!($stmt->execute())) {
            echo "error-2-9<br>\n".$mysqli->error;
            exit();
        }
    }

    
    $jsonEncoded = filter_input(INPUT_POST, 'json', FILTER_UNSAFE_RAW);
    $male = filter_input(INPUT_GET, 'male', FILTER_SANITIZE_NUMBER_INT);
    
    //$jsonEncoded = trim($jsonEncoded);
    
    $mysqli = DBCON_mysqli();
    $userid=getUserID($mysqli);
   
    updateGender($male,$userid);
    
    
    $debug = 0;
    
  //  clearPoints();
  //  clearTrainings();
    if($jsonDecoded = json_decode($jsonEncoded)){

        # ** GetUserInfo ** #
/*      
	  $EMAIL = $jsonDecoded->{'email'};
        $PASSWORD = $jsonDecoded->{'password'};
        echo "USER:".$EMAIL." PASSWORD:".$PASSWORD."\n\n";
  */      
        # ** Get training ** #
        $trainingID = $jsonDecoded->{'trainingID'};
        $duration = $jsonDecoded->{'duration'};
        $distance = $jsonDecoded->{'distance'};
        $date = date("Y-m-d H:i:s",$jsonDecoded->{'date'});                       // 10, 3, 2001$jsonDecoded->{'date'};
        $mood = $jsonDecoded->{'mood'};
        $sportsType = $jsonDecoded->{'sportsType'};
        $comment = $jsonDecoded->{'comment'};
        $maxPulse = $jsonDecoded->{'maxPulse'};
        $participants = $jsonDecoded->{'participants'};
        $bwert = $jsonDecoded->{'bwert'};
        $kcal = $jsonDecoded->{'kcal'};
        
        
        //echo "ID:".$trainingID." DURATION".$duration." DISTANCE".$distance." DATE".$date." MOOD".$mood." SPORT".$sportsType." COMMENT".$comment." MAXPULSE".$maxPulse."\n";
        $tr_ex=trainingExists($trainingID);
        if($tr_ex>0){
            updateTraining($distance,$sportsType,$mood,$bwert,$kcal,$comment,$trainingID,$duration);
            
        }else{
            createTraining($trainingID,$duration,$distance,$date,$sportsType,$mood,$maxPulse,$participants,$bwert,$kcal,$comment,$userid);
        }
        if ($tr_ex==2) 
			echo "OK";
        
      
        echo "OK";
    }else{
        echo "Gnar Goes Mad";
    }
    exit();


    



?>