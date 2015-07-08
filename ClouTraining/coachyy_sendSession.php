<?php
# *************************************************************************************************** #
# senden von PulseMeasurePoint
# Stand: 28.01.2015
# *************************************************************************************************** #

include ("function_sql.php");

    
# *************************************************************************************************** #
# 1. Training
# *************************************************************************************************** #

  
    
    function createSession($EMAIL,$PASSWORT,$date)
    {
        
        global $mysqli;
        
        if (!($stmt = $mysqli->prepare('SELECT trainerID from User,Trainer WHERE eMail =? and password=? AND User.userID = Trainer.userID'))) {
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
            
            if (!($stmt = $mysqli->prepare('INSERT INTO LiveTraining  (trainerID, date) values(?,?)'))) {
                echo "error-1-7<br>\n";
                echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
                exit();
            }
            
            if (!($stmt->bind_param('is',$trainerID,$date))) {
                echo "error-1-8<br>\n";
                exit();
            }
            
            if (!($stmt->execute())) {
                echo "error-1-9<br>\n".$mysqli->error;
                exit();
            }
            
            $sessionID = $stmt->insert_id;
            
            if (!($stmt = $mysqli->prepare('UPDATE Trainer SET currentSession = ? WHERE trainerID = ?'))) {
                echo "error-1-7<br>\n";
                echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
                exit();
            }
            
            if (!($stmt->bind_param('is',$sessionID, $trainerID))) {
                echo "error-1-8<br>\n";
                exit();
            }
            
            if (!($stmt->execute())) {
                echo "error-1-9<br>\n".$mysqli->error;
                exit();
            }
            
            addActiveUsers($sessionID, $trainerID);
            
            return $sessionID;
        } else {
            echo "Session Gnar";
            exit();
        }
        
        
        return -1;
    }
    
    function addActiveUsers($sessionID, $trainerID){
        
        global $mysqli;
        
        if (!($stmt = $mysqli->prepare('SELECT User.userID FROM User,userXtrainer WHERE userXtrainer.trainerID = ? AND User.userID = userXtrainer.userID AND userXtrainer.liveActive = 1'))) {
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
            $stmt->bind_result($userID);
            
            
            while($stmt->fetch()){
                addParticipant($sessionID,$userID);
            }
        }
    }
    
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
    
    
    
    /*$EMAIL = filter_input(INPUT_GET, 'email', FILTER_SANITIZE_SPECIAL_CHARS);
    $EMAIL = trim($EMAIL);
    
    $PASSWORT = filter_input(INPUT_GET, 'password', FILTER_SANITIZE_SPECIAL_CHARS);
    $PASSWORT = trim($PASSWORT);
    $PASSWORT = utf8_decode($PASSWORT);

    
    $jsonEncoded = filter_input(INPUT_POST, 'json', FILTER_UNSAFE_RAW);
    //$jsonEncoded = trim($jsonEncoded);
    
    $mysqli = DBCON_mysqli();
    $userid=getUserID($mysqli);
    
    
    
    $debug = 0;

    if($jsonDecoded = json_decode($jsonEncoded)){

        # ** GetUserInfo ** #
     
        //$EMAIL = $jsonDecoded->{'email'};
        //$PASSWORD = $jsonDecoded->{'password'};
        //echo "USER:".$EMAIL." PASSWORD:".$PASSWORD."\n\n";
     
        # ** Get training ** #
        $date = date("Y-m-d H:i:s",$jsonDecoded->{'date'});
        $participants = $jsonDecoded->{'participants'};
        
        $sessionID = createSession($EMAIL,$PASSWORT,$date);
        
        if($trainerID != -1){
            foreach($jsonDecoded->participants as $participant)
            {
                addParticipant($sessionID,$participant);
            }
        }
        

        
      
        echo "OK";
    }else{
        echo "Gnar Goes Mad";
    }
    exit();*/


    



?>