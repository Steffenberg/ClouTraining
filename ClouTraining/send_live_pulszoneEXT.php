<?

include("function_sql.php");
$mysqli = DBCON_mysqli();
//$userID=getUserID($mysqli);


$mysqli = DBCON_mysqli();
$EMAIL = filter_input(INPUT_GET, 'email', FILTER_SANITIZE_SPECIAL_CHARS);
$EMAIL = trim($EMAIL);

$PASSWORT = filter_input(INPUT_GET, 'password', FILTER_SANITIZE_SPECIAL_CHARS);
$PASSWORT = trim($PASSWORT);
$PASSWORT = utf8_decode($PASSWORT);

//$TRAININGID = filter_input(INPUT_GET, 'training', FILTER_SANITIZE_NUMBER_INT);
$CURRENTZONE = filter_input(INPUT_GET, 'currentZone', FILTER_SANITIZE_NUMBER_INT);

$TRAININGID = filter_input(INPUT_GET, 'trainingID', FILTER_SANITIZE_NUMBER_INT);

 if (!($stmt = $mysqli->prepare('update User set LiveTrainingZone=?, LiveTrainingTimestamp=NOW() where eMail=? and password=?'))) {
        echo "error-0-1<br>\n";
		echo $mysqli->error;
        exit();
    }
    if (!($stmt->bind_param('iss', $CURRENTZONE, $EMAIL, $PASSWORT))) {
        echo "error-0-2<br>\n";
		echo $mysqli->error;
        exit();
    }
    if (!($stmt->execute())) {
        echo "error-0-3<br>\n";
		echo $mysqli->error;
        exit();
    }
	 
if ($mysqli->affected_rows>0 && $TRAININGID > 0) {
  
    if (!($stmt = $mysqli->prepare('UPDATE userXliveTraining as uxl SET uxl.trainingID=? WHERE uxl.userID = (SELECT userID FROM User WHERE User.eMail=? AND User.password=?) AND uxl.sessionID IN (SELECT sessionID FROM LiveTraining WHERE LiveTraining.trainerID IN (SELECT userXtrainer.trainerID FROM userXtrainer, Trainer WHERE userXtrainer.userID = uxl.userID AND liveActive = 1 AND Trainer.trainerID = userXtrainer.trainerID AND Trainer.currentSession = uxl.sessionID))'))) {
        echo "error-0-1<br>\n";
        echo $mysqli->error;
        exit();
    }
    if (!($stmt->bind_param('iss',$TRAININGID, $EMAIL, $PASSWORT))) {
        echo "error-0-2<br>\n";
        echo $mysqli->error;
        exit();
    }
    if (!($stmt->execute())) {
        echo "error-0-3<br>\n";
        echo $mysqli->error;
        exit();
    }
    
    if ($mysqli->affected_rows>0) {
        echo "ESKLAPPT";
    }
    
    //check for available live Trainers --Begin
    if (!($stmt = $mysqli->prepare('select eMail from userXtrainer,User WHERE eMail =? and password=? AND User.userID = userXtrainer.userID AND liveActive = 1'))) {
        echo "error-1-1<br>\n";
        echo $mysqli->error;
        exit();
    }
    if (!($stmt->bind_param('ss', $EMAIL,$PASSWORT))) {
        echo "error-1-2<br>\n";
        exit();
    }
    if (!($stmt->execute())) {
        echo "error-1-3<br>\n";
        echo $mysqli->error;
        exit();
    }
    $stmt->store_result();
    
    if ($stmt->num_rows > 0) {
        echo "OK";
        exit();
    } else {
        echo "CLOSED";
        exit();
    }
    //check for available live Trainers --End
 }else{
     echo "Gnar";
}
?>