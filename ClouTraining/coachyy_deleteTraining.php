<?php
# *************************************************************************************************** #
# Löschen von Trainings zu Username, passwort, ID
# Stand: 28.01.2015
# *************************************************************************************************** #

include ("function_sql.php");
    
    global $mysqli;
    
    $TRAININGID = filter_input(INPUT_GET, 'trainingID', FILTER_SANITIZE_NUMBER_INT);
    
    $mysqli = DBCON_mysqli();
    $userid=getUserID($mysqli);
    
    if (!($stmt = $mysqli->prepare('DELETE FROM Training WHERE userID = ? AND trainingID = ?'))) {
        echo "error-2-7<br>\n";
        echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
        exit();
    }
    
    if (!($stmt->bind_param('ii',$userid, $TRAININGID))) {
        echo "Bind failed: (" . $mysqli->errno . ") " . $mysqli->error;
        echo "error-2-8<br>\n";
        exit();
    }
    
    if (!($stmt->execute())) {
        echo "error-2-9<br>\n".$mysqli->error;
        exit();
    }
    
    echo "OK";
    
    exit();

?>