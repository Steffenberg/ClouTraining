<?

include("function_sql.php");
$mysqli = DBCON_mysqli();
$userID=getUserID($mysqli);

$EXPDATE = filter_input(INPUT_GET, 'date', FILTER_SANITIZE_SPECIAL_CHARS);
$EXPDATE = trim($EXPDATE);


    if (!($stmt = $mysqli->prepare('select trainerID from Trainer where userID=?'))) {
        
        echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
        exit();
    }
    
    if (!($stmt->bind_param('i', $userID))) {
		 echo "Bind failed: (" . $mysqli->errno . ") " . $mysqli->error;
        exit();
    }
	if (!($stmt->execute())) {
      
		echo $mysqli->error;
        exit();
    }
    $stmt->store_result();
		  if ($stmt->num_rows > 0) {
			echo ("OK");
			exit();
		  }


    if (!($stmt = $mysqli->prepare('insert into Trainer (userID, isLiveCoach,liveExpires) values (?,1,?)'))) {
        echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
        exit();
    }
    
    if (!($stmt->bind_param('is', $userID,date("Y-m-d H:m:s", $EXPDATE)))) {
       		 echo "Bind failed: (" . $mysqli->errno . ") " . $mysqli->error;

        exit();
    }
    
    if (!($stmt->execute())) {
			echo "error-1-9<br>\n". $mysqli->error;
		
        exit();
    }


echo "OK";
?>