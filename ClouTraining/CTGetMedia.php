<?php
    
    
    include ("function_sql.php");
    
    $mysqli = DBCON_mysqli();
    $debug = 0;

    
    function getMedia($exerciseID,$type){
        
        global $mysqli;

        if (!($stmt = $mysqli->prepare('SELECT mediaid,title,url FROM Media WHERE exerciseid =? AND type = ?'))) {
            echo "error-0-1<br>\n";
            echo $mysqli->error;
            exit();
        }
        if (!($stmt->bind_param('ii', $exerciseID, $type))) {
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
        	
            $stmt->bind_result($mediaID,$title,$url);
            $result = array();
            while($stmt->fetch()){
            	$result[$mediaID] = array('url'=>$url,'title'=>$title);
            }
            return $result;
        }
        
        return -1;
    }
    
   
   
	
    	$exerciseID = filter_input(INPUT_GET, 'exerciseID', FILTER_SANITIZE_NUMBER_INT);
    	$type = filter_input(INPUT_GET, 'type', FILTER_SANITIZE_NUMBER_INT);
    	
    	//$mediaData = filter_input(INPUT_POST, 'data', FILTER_UNSAFE_RAW);
    	$result = getMedia($exerciseID,$type);
    	if($result != -1){
    		echo json_encode($result);
        	
    	}else{
        	echo "ERROR";
    		
    	}
   
    
    
    
    
    
    exit();
    
    
    
    
    
    
    ?>