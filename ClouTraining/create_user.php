<?

include("function_sql.php");
$mysqli = DBCON_mysqli();
//$userID=getUserID($mysqli);

/*$trainers = explode (",", $trainersInput);

echo $trainers[0]."\n";
echo $trainers[1]."\n";
exit();*/





$EMAIL = filter_input(INPUT_GET, 'email', FILTER_SANITIZE_SPECIAL_CHARS);
$EMAIL = trim($EMAIL);

$PASSWORT = filter_input(INPUT_GET, 'password', FILTER_SANITIZE_SPECIAL_CHARS);
$PASSWORT = trim($PASSWORT);

$NICKNAME = filter_input(INPUT_GET, 'nickname', FILTER_SANITIZE_SPECIAL_CHARS);
$NICKNAME = trim($NICKNAME);

$VORNAME = filter_input(INPUT_GET, 'vorname', FILTER_SANITIZE_SPECIAL_CHARS);
$VORNAME = trim($VORNAME);

$NACHNAME = filter_input(INPUT_GET, 'nachname', FILTER_SANITIZE_SPECIAL_CHARS);
$NACHNAME = trim($NACHNAME);

	

    if (!($stmt = $mysqli->prepare('insert into User (eMail, password, name, vorname, nickname, dateRegistered) values (?,?,?,?,?, CURDATE())'))) {
        echo "error-1-7<br>\n";
        echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
        exit();
    }
    
    if (!($stmt->bind_param('sssss', $EMAIL, $PASSWORT, $NACHNAME, $VORNAME, $NICKNAME))) {
        echo "error-1-8<br>\n";
        exit();
    }
    
    if (!($stmt->execute())) {
		if (strpos($mysqli->error, "for key 'eMail'")) {
			echo "eMail";
			exit();
		} else if (strpos($mysqli->error, "for key 'nickname'")) {
			echo "nickname";
			exit();
		} else
			echo "error-1-9<br>\n". $mysqli->error;
		
        exit();
    }


echo "OK";
?>