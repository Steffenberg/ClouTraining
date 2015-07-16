<?php


include ("function_sql.php");

	function getExerciseShared($exerciseID){
		global $mysqli;
        if (!($stmt = $mysqli->prepare('select shared from Exercise WHERE exerciseid=? AND shared = 1'))) {
            echo "error-0-1<br>\n";
            echo $mysqli->error;
             return -1;
        }
        if (!($stmt->bind_param('i', $exerciseID))) {
            echo "-1";
             return -1;
        }
        if (!($stmt->execute())) {
            echo "error-0-3<br>\n";
            echo $mysqli->error;
             return -1;
        }
        $stmt->store_result();
        
        if ($stmt->num_rows > 0) {
            $stmt->bind_result($shared);
            $stmt->fetch();
            return $shared;
        }
        return -1;
	
	}
    
    
    function createMedia($title,$exerciseID,$date,$type,$randomKey,$text)
    {
       
        $zero = 0;
        
        global $mysqli;
        if (!($stmt = $mysqli->prepare('INSERT INTO Media  (title,exerciseid,type,text,date,randomKey) values(?,?,?,?,?,?)'))) {
            echo "error-1-7<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        
        if (!($stmt->bind_param('siisss',$title,$exerciseID,$type,$text,$date,$randomKey))) {
            echo "error-1-8<br>\n";
            exit();
        }
        
        if (!($stmt->execute())) {
            echo "error-1-9<br>\n".$mysqli->error;
            exit();
        }
        return mysqli_stmt_insert_id ($stmt);
    }
    
    function generateRandomString($length) {
    	$characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    	$charactersLength = strlen($characters);
    	$randomString = '';
   		 for ($i = 0; $i < $length; $i++) {
        	$randomString .= $characters[rand(0, $charactersLength - 1)];
    	}
   		return $randomString;
	}
    
    $mysqli = DBCON_mysqli();
    $debug = 0;
    
    $jsonEncoded = filter_input(INPUT_POST, 'data', FILTER_UNSAFE_RAW);

    if($jsonDecoded = json_decode($jsonEncoded)){
    	$exerciseID = $jsonDecoded->{'exerciseID'};
    	$title = $jsonDecoded->{'title'};
    	$shared = getExerciseShared($exerciseID);
    	if($shared == -1){
    		echo "ERROR:NOT EXIST OR NOT SHARED";
    		exit();
    	}
    	
    	$type = $jsonDecoded->{'type'};
    	$date = date("Y-m-d H:i:s",$jsonDecoded->{'date'});
    	$randomKey = generateRandomString(50);
    	if($type == 3){
    		$text = $jsonDecoded->{'text'};
    		$mediaID = createMedia($title,$exerciseID,$date,$type,$randomKey,$text);
    		echo "TEXTINSERT-".$mediaID;
    		exit();
    	}
    	
    	//echo "\nID ".$exerciseID."\nDate ".$date."\n"."Type ".$type."\n"."Random ".$randomKey."\n";
    	
    	$mediaID = createMedia($title,$exerciseID,$date,$type,$randomKey,"");
    	echo "SUCCESS".$mediaID."-".$randomKey."-".$type;
    }else{
    	echo "ERROR";
    }
    

    
    exit();


    



?>