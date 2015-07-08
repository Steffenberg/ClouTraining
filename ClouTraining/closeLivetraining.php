<?

include("function_sql.php");
$mysqli = DBCON_mysqli();

$EMAIL = filter_input(INPUT_GET, 'email', FILTER_SANITIZE_SPECIAL_CHARS);
$EMAIL = trim($EMAIL);

$PASSWORT = filter_input(INPUT_GET, 'password', FILTER_SANITIZE_SPECIAL_CHARS);
$PASSWORT = trim($PASSWORT);
$PASSWORT = utf8_decode($PASSWORT);

if (!($stmt = $mysqli->prepare('select trainerID from User, Trainer WHERE eMail =? and password=? AND User.userID=Trainer.userID'))) {
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
} else {
    echo "Gnar";
    exit();
}

if (!($stmt = $mysqli->prepare('UPDATE Trainer SET currentSession = 0 WHERE trainerID = ?'))) {
    echo "error-1-7<br>\n";
    echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
    exit();
}

if (!($stmt->bind_param('i',$trainerID))) {
    echo "error-1-8<br>\n";
    exit();
}

if (!($stmt->execute())) {
    echo "error-1-9<br>\n";
    exit();
}



    if (!($stmt = $mysqli->prepare('UPDATE userXtrainer SET liveActive = 0 WHERE trainerID = ?'))) {
        echo "error-1-7<br>\n";
        echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
        exit();
    }
    
    if (!($stmt->bind_param('i',$trainerID))) {
        echo "error-1-8<br>\n";
        exit();
    }
    
    if (!($stmt->execute())) {
        echo "error-1-9<br>\n";
        exit();
    }


echo "OK";
?>