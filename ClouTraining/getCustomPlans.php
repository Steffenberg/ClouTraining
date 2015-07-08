<?

include("function_sql.php");
$mysqli = DBCON_mysqli();

$EMAIL = filter_input(INPUT_GET, 'email', FILTER_SANITIZE_SPECIAL_CHARS);
$EMAIL = trim($EMAIL);

$PASSWORT = filter_input(INPUT_GET, 'password', FILTER_SANITIZE_SPECIAL_CHARS);
$PASSWORT = trim($PASSWORT);
$PASSWORT = utf8_decode($PASSWORT);

if (!($stmt = $mysqli->prepare('select planDetail,planName,planDauer from trainingsPlan,User WHERE eMail =? and password=? AND User.userID = trainingsPlan.userID'))) {
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
    $stmt->bind_result($detail,$name,$dauer);
    echo "BEGIN";
    while ($stmt->fetch()) {
        echo ($name.";".$dauer."\r".$detail."END");
    }
    
} else {
    echo "Gnar";
    exit();
}

?>