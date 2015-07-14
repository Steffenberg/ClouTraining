<?

function DBCON_mysqli() {
 $HOST       = "127.0.0.1";
  $DATABASE   = "cloutraining";
  $USER       = "dbuser";
  $PASSWORD   = "5EQ%HMu85FT?%Tx";
  $mysqli = new mysqli($HOST, $USER, $PASSWORD, $DATABASE);
     if (!$mysqli->set_charset("utf8")) {
        printf("Error loading character set utf8: %s\n", $mysqli->error);
        exit();
    }
	$mysqli->query("SET NAMES utf8mb4");	
 return $mysqli;
}

function getUserID($mysqli) {

$EMAIL = filter_input(INPUT_GET, 'email', FILTER_SANITIZE_SPECIAL_CHARS);
$EMAIL = trim($EMAIL);

$PASSWORT = filter_input(INPUT_GET, 'password', FILTER_SANITIZE_SPECIAL_CHARS);
$PASSWORT = trim($PASSWORT);
$PASSWORT = utf8_decode($PASSWORT);



if (!($stmt = $mysqli->prepare('select userID from User where eMail =? and password=?'))) {
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
	  $stmt->bind_result($userid);
		$stmt->fetch();	
		return $userid;
}else {
		echo "Gnar";
		exit();
	  }

}

?>