<?

include("function_sql.php");
$mysqli = DBCON_mysqli();
$userID=getUserID($mysqli);
 
$trainingID = filter_input(INPUT_GET, 'trainingID', FILTER_SANITIZE_NUMBER_INT);

$pulsedata = file_get_contents('php://input');
$mysize = strlen($pulsedata);
echo ($mysize);




  // global $mysqli;
        if (!($stmt = $mysqli->prepare('update Training  set pulseMeasurePoints=? where trainingID=?'))) {
            echo "error-1-7<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        $null = NULL;
        if (!($stmt->bind_param('bi',$null,$trainingID))) {
            echo "error-1-8<br>\n";
            exit();
        }
        $stmt->send_long_data(0, $pulsedata);
        if (!($stmt->execute())) {
            echo "error-1-9<br>\n";
            exit();
        }






?>