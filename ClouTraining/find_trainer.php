<?

function DBCON_mysqli() {
 $HOST       = "127.0.0.1";
  $DATABASE   = "coachyy";
  $USER       = "dbuser";
  $PASSWORD   = "5EQ%HMu85FT?%Tx";
return new mysqli($HOST, $USER, $PASSWORD, $DATABASE);
}
$mysqli = DBCON_mysqli();
$EMAIL = filter_input(INPUT_GET, 'email', FILTER_SANITIZE_SPECIAL_CHARS);
$EMAIL = trim($EMAIL);

$PASSWORT = filter_input(INPUT_GET, 'password', FILTER_SANITIZE_SPECIAL_CHARS);
$PASSWORT = trim($PASSWORT);
$PASSWORT = utf8_decode($PASSWORT);



if (!($stmt = $mysqli->prepare('select userID,name,vorname,nickname from User where nickname =?'))) {
        echo "error-0-1<br>\n";
		echo $mysqli->error;
        exit();
}
if (!($stmt->bind_param('s', $EMAIL))) {
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
    $stmt->bind_result($userid,$name,$prename,$nickname);
    
    $stmt->fetch();


    if (!($stmt = $mysqli->prepare('select trainerID from Trainer where userID=?'))) {
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
        $stmt->bind_result($trainerid);
        
        $stmt->fetch();
		  echo $trainerid."\n".$prename."\n".$name."\n".$nickname;
		  } else {
		  echo "Nope";
		  }
	  } else {
		echo "Nope";
	  }
?>