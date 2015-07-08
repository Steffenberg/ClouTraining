<?
include("function_sql.php");
$mysqli = DBCON_mysqli();
$userid = getUserID($mysqli);

$ANONYMUS = filter_input(INPUT_GET, 'anonymus', FILTER_SANITIZE_NUMBER_INT);




if (!($stmt = $mysqli->prepare('update User set anonymus=? where userID=?'))) {
        echo "error-0-1<br>\n";
		echo $mysqli->error;
        exit();
}
if (!($stmt->bind_param('ii', $ANONYMUS, $userid))) {
  echo "-1";
  exit();
}	
 if (!($stmt->execute())) {
        echo "error-0-3<br>\n";
		echo $mysqli->error;
        exit();
}

echo "OK";
	
	

?>