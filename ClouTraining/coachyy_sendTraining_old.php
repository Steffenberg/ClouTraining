<?php
# *************************************************************************************************** #
# senden von PulseMeasurePoint
# Stand: 28.01.2015
# *************************************************************************************************** #

include ("funktion_sql.php");
    
    function DBCON_mysqli() {
        $HOST       = "127.0.0.1";
        $DATABASE   = "coachyy";
        $USER       = "dbuser";
        $PASSWORD   = "5EQ%HMu85FT?%Tx";
        return new mysqli($HOST, $USER, $PASSWORD, $DATABASE);
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
    
    function createTraining($trainingID,$distance,$duration,$trainingDate,$sportsType,$mood,$maxPulse,$comment)
    {
       
        
        $one = 1;
        $zero = 0;
        
        global $mysqli;
        if (!($stmt = $mysqli->prepare('insert into Training  (trainingID, userID ,trainerID, trainingDate, distance, duration, sportsType, mood, maxPulse,comment) values(?,?,?,?,?,?,?,?,?,?)'))) {
            echo "error-1-7<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        
        if (!($stmt->bind_param('iiisiisiis',$trainingID,$one,$zero,$trainingDate,$distance,$duration,$sportsType,$mood,$maxPulse,$comment))) {
            echo "error-1-8<br>\n";
            exit();
        }
        
        if (!($stmt->execute())) {
            echo "error-1-9<br>\n";
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
    
    function createPMP($trainingID,$pulseValue,$timeStamp, $zoneType)
    {
        
        

        global $mysqli;
        if (!($stmt = $mysqli->prepare('insert into PulseMeasurePoint  (trainingID, pulseValue, timeStamp, zoneType) values(?,?,?,?)'))) {
            echo "error-1-7<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }

        if (!($stmt->bind_param('iisi',$trainingID,$pulseValue,$timeStamp, $zoneType))) {
            echo "error-1-8<br>\n";
            exit();
        }

        if (!($stmt->execute())) {
            echo "error-1-9<br>\n";
            exit();
        }
    }
    

# *************************************************************************************************** #
# 1. ShoppingListEntry
# *************************************************************************************************** #

/*function updateShoppingListEntry($shoppingListEntry, $userID)
{
    global $mysqli;
    if (!($stmt = $mysqli->prepare('update bs2uc_einkaufsliste  set artikelid=?, artikelname=?, preis=?, kategorieid=?, einheitid=?, menge=?, notiz=?, haendler=?, rezeptid=?, fromUserName=? where id=? and benutzerid=?'))) {
        
        echo "error-1-4<br>\n";
        echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
		logError();
        exit();
    } 
    if (!($stmt->bind_param('isdiidssisii',$shoppingListEntry->articleId, $shoppingListEntry->name, $shoppingListEntry->price, $shoppingListEntry->categoryId, $shoppingListEntry->unitId, $shoppingListEntry->amount, $shoppingListEntry->note, $shoppingListEntry->store, $shoppingListEntry->recipeId, $shoppingListEntry->fromUserName, $shoppingListEntry->id, $userID))) {
        echo "error-1-5<br>\n";
        exit();
    } 

    if (!($stmt->execute())) {
        echo "error-1-6<br>\n";
        exit();
    }
} 

function createShoppingListEntry($shoppingListEntry, $userID)
{
    global $mysqli;
    if (!($stmt = $mysqli->prepare('insert into bs2uc_einkaufsliste  (id, benutzerid ,artikelid, artikelname, preis, kategorieid, einheitid, menge, notiz, haendler, rezeptid, fromUserName) values(?,?,?,?,?,?,?,?,?,?,?,?)'))) {
        echo "error-1-7<br>\n";
        echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
        exit();
    }
    if (!($stmt->bind_param('iiisdiidssis',$shoppingListEntry->id, $userID, $shoppingListEntry->articleId, $shoppingListEntry->name, $shoppingListEntry->price, $shoppingListEntry->categoryId, $shoppingListEntry->unitId, $shoppingListEntry->amount, $shoppingListEntry->note, $shoppingListEntry->store, $shoppingListEntry->recipeId, $shoppingListEntry->fromUserName))) {
        echo "error-1-8<br>\n";
        exit();
    }

    if (!($stmt->execute())) {
        echo "error-1-9<br>\n";
        exit();
    }
} 

function deleteShoppingListEntry($shoppingListEntryID, $userID)
{
    global $mysqli;
    if (!($stmt = $mysqli->prepare('delete from bs2uc_einkaufsliste  where id =? and benutzerid=?'))) {
        
        echo "error-1-10<br>\n";
        exit();
    } 
    if (!($stmt->bind_param('ii', $shoppingListEntryID, $userID))) {
        echo "error-1-11<br>\n";
        exit();
    } 
    if (!($stmt->execute())) {
        echo "error-1-12<br>\n";
        exit();
    }
}
*/


# ******************************************************************************************************************************************************************* #
# START 
# ******************************************************************************************************************************************************************* #


/*if (!($stmt = $mysqli->prepare("select idbenutzer, besorgerversion from benutzer where email=? and passwort=? and status=1"))) {
 echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
 return;
}

if (!($stmt->bind_param('ss', $EMAIL, $PASSWORT))) {
 echo "Bind failed: (" . $mysqli->errno . ") " . $mysqli->error;
 return;
} 

if (!($stmt->execute())) {
 echo "Exec failed: (" . $mysqli->errno . ") " . $mysqli->error;
 return;
}

$stmt->store_result();
if ($stmt->num_rows==0) {
  echo "Benutzername oder Passwort falsch, oder Emailadresse noch nicht bestätigt...";
  return;
}

$stmt->bind_result($userID, $besorgerversion);
$stmt->fetch();*/

    
    $jsonEncoded = filter_input(INPUT_POST, 'json', FILTER_UNSAFE_RAW);
    $jsonEncoded = trim($jsonEncoded);
    
    
    echo "checkONE\n";
    
    $mysqli = DBCON_mysqli();
    if (!$mysqli->set_charset("utf8")) {
        printf("Error loading character set utf8: %s\n", $mysqli->error);
        exit();
    }
    
    echo "checkTWO\n";
    
    $debug = 0;
    
    clearPoints();
    clearTrainings();
    
    if($jsonDecoded = json_decode($jsonEncoded)){

        # ** GetUserInfo ** #
        $EMAIL = $jsonDecoded->{'email'};
        $PASSWORD = $jsonDecoded->{'password'};
        echo "USER:".$EMAIL." PASSWORD:".$PASSWORD."\n\n";
        
        # ** Get training ** #
        $trainingID = $jsonDecoded->{'trainingID'};
        $duration = $jsonDecoded->{'duration'};
        $distance = $jsonDecoded->{'distance'};
        $date = date("Y-m-d h:i:s",$jsonDecoded->{'date'});                       // 10, 3, 2001$jsonDecoded->{'date'};
        $mood = $jsonDecoded->{'mood'};
        $sportsType = $jsonDecoded->{'sportsType'};
        $comment = $jsonDecoded->{'comment'};
        $maxPulse = $jsonDecoded->{'maxPulse'};
        
        //echo "ID:".$trainingID." DURATION".$duration." DISTANCE".$distance." DATE".$date." MOOD".$mood." SPORT".$sportsType." COMMENT".$comment." MAXPULSE".$maxPulse."\n";
        
        createTraining($trainingID,$duration,$distance,$date,$sportsType,$mood,$maxPulse,$comment);
        
        echo "\nPOINTS\n\n";
         # ** Get point ** #
        $pulseMeasurePoints = $jsonDecoded->{'pulseMeasurePoints'};
        foreach ($pulseMeasurePoints as $point){
            $pointID = $point->{'pointID'};
            $pulseValue = $point->{'pulseValue'};
            $timestamp = $point->{'timestamp'};
            $zoneType = $point->{'zoneType'};
            
            createPMP($trainingID,$pulseValue,$timestamp, $zoneType);
            //echo "ID:".$pointID." VALUE:".$pulseValue." TIMESTAMP:".$timestamp." TYPE:".$zoneType."\n";
        }
        
        /*$pointID = $jsonDecoded->{'pointID'};
        $pulseValue = $jsonDecoded->{'pulseValue'};
        $timestamp = $jsonDecoded->{'timestamp'};
        $zoneType = $jsonDecoded->{'zoneType'};*/
    }else{
        
    }
    echo "FINISH HIM!";
    
    exit();


    



?>