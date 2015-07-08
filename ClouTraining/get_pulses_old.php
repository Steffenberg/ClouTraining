<?

function DBCON_mysqli() {
 $HOST       = "127.0.0.1";
  $DATABASE   = "coachyy";
  $USER       = "dbuser";
  $PASSWORD   = "5EQ%HMu85FT?%Tx";
return new mysqli($HOST, $USER, $PASSWORD, $DATABASE);
}



header('Content-Type: text/json');
header('Cache-Control: private, no-cache, no-store, must-revalidate, no-transform'); // HTTP 1.1.
header('Pragma: no-cache'); // HTTP 1.0.
header('Expires: 0'); // Proxies.

$mysqli = DBCON_mysqli();
$USERID = filter_input(INPUT_GET, 'user', FILTER_SANITIZE_NUMBER_FLOAT, FILTER_FLAG_ALLOW_THOUSAND);

$lastValues = array();
echo "start\n";




if (!($stmt = $mysqli->prepare('select LiveTrainingZone, LiveTrainingTimestamp, userID from User where userID in ('.$USERID.')'))) {
        echo "error-0-1<br>\n";
		echo $mysqli->error;
        exit();
    }
	while(true) {
	/*
    if (!($stmt->bind_param('i', $USERID))) {
        echo "error-0-2<br>\n";
		echo $mysqli->error;
        exit();
    }
	*/
    if (!($stmt->execute())) {
        echo "error-0-3<br>\n";
		echo $mysqli->error;
        exit();
    }
	$stmt->store_result();
	
	
	
	  if ($stmt->num_rows > 0) {
		$stmt->bind_result($LiveTrainingZone, $LiveTrainingTimestamp, $userID);
		while ($stmt->fetch()) {
		if ($lastValues[$userID]!==$LiveTrainingZone) {
		echo ($userID." ".$LiveTrainingZone."\n");
		$lastValues[$userID]=$LiveTrainingZone;
		}
		}
	
 	 
	  } else echo "empty\n\n";
	  ob_flush();
	  flush();
	  sleep(1);
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