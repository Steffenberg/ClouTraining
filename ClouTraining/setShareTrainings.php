<?
include("function_sql.php");
$mysqli = DBCON_mysqli();
$userid=getUserID($mysqli);

$SHARETRAININGS = filter_input(INPUT_GET, 'shareTrainings', FILTER_SANITIZE_NUMBER_INT);
$SHARETRAININGS = trim($SHARETRAININGS);
$SHARETRAININGS = utf8_decode($SHARETRAININGS);



if (!($stmt = $mysqli->prepare('update User set shareTrainings=? where userID=?'))) {
        echo "error-0-1<br>\n";
		echo $mysqli->error;
        exit();
}
if (!($stmt->bind_param('ii', $SHARETRAININGS, $userid))) {
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