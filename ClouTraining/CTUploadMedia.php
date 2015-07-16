<?php
    
    
    include ("function_sql.php");
    
    $mysqli = DBCON_mysqli();
    $debug = 0;
    $reply = array();
    
    function getMedia($mediaID,$randomKey){
        
        global $mysqli;
        global $reply;
        if (!($stmt = $mysqli->prepare('select mediaid,date,exerciseid from Media WHERE mediaid=? AND randomKey =?'))) {
            echo "error-0-1<br>\n";
            echo $mysqli->error;
            exit();
        }
        if (!($stmt->bind_param('is', $mediaID,$randomKey))) {
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
            $stmt->bind_result($mediaID,$date,$exerciseID);
            $stmt->fetch();
            return array('mediaID'=>$mediaID,'date'=>$date,'exerciseID'=>$exerciseID);
        }
        $reply['test'] = 1;
        return -1;
    }
    
    function updateMediaWithURL($mediaID,$url)
    {
        
        global $mysqli;
        if (!($stmt = $mysqli->prepare('UPDATE Media SET url = ? WHERE mediaid = ?'))) {
            echo "error-1-7<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        
        if (!($stmt->bind_param('si',$url,$mediaID))) {
            echo "error-1-8<br>\n";
            exit();
        }
        
        if (!($stmt->execute())) {
            echo "error-1-9<br>\n".$mysqli->error;
            exit();
        }
    }
    
    function removeMedia($mediaID)
    {
        
        global $mysqli;
        if (!($stmt = $mysqli->prepare('DELETE FROM Media WHERE mediaid = ?'))) {
            echo "error-1-7<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        
        if (!($stmt->bind_param('i',$mediaID))) {
            echo "error-1-8<br>\n";
            exit();
        }
        
        if (!($stmt->execute())) {
            echo "error-1-9<br>\n".$mysqli->error;
            exit();
        }
    }
    
    function writeImage($mediaID,$date,$exerciseID){
    	global $reply;
    	
    	$uploaddir = '../media/'.$exerciseID.'/images/';
    	
		if (!is_dir($uploaddir)) {
    		mkdir($uploaddir, 0777, true);
		}
		
		$uploadfile = $uploaddir.$exerciseID.'-'.$mediaID.'-'.$date.basename($_FILES['image']['name']);

		//echo '<pre>';
		if (move_uploaded_file($_FILES['image']['tmp_name'], $uploadfile)) {
    		//echo "Datei ist valide und wurde erfolgreich hochgeladen.\n";
    		updateMediaWithURL($mediaID,$uploadfile);
    		$reply['success'] = 1;
    		
		} else {
    		//echo "Möglicherweise eine Dateiupload-Attacke!\n";
    		removeMedia($mediaID);
    		$reply['success'] = -1;
    		
		}

		//echo 'Weitere Debugging Informationen:';
		//print_r($_FILES);

		//print "</pre>";
    }
    
    function writeVideo($mediaID,$date,$exerciseID){
    	global $reply;
    	
    	$uploaddir = '../media/'.$exerciseID.'/videos/';
    	
		if (!is_dir($uploaddir)) {
    		mkdir($uploaddir, 0777, true);
		}
		
		$uploadfile = $uploaddir.$exerciseID.'-'.$mediaID.'-'.$date.basename($_FILES['video']['name']);

		//echo '<pre>';
		if (move_uploaded_file($_FILES['video']['tmp_name'], $uploadfile)) {
    		//echo "Datei ist valide und wurde erfolgreich hochgeladen.\n";
    		updateMediaWithURL($mediaID,$uploadfile);
    		$reply['success'] = 1;
    		
    		
		} else {
    		//echo "Möglicherweise eine Dateiupload-Attacke!\n";
    		removeMedia($mediaID);
    		$reply['success'] = -1;
    
		}

		//echo 'Weitere Debugging Informationen:';
		//print_r($_FILES);

		//print "</pre>";
    }
	
   
	
    	$mediaID = $_POST['mediaID'];
    	$randomKey = $_POST['randomKey'];
    	$type = $_POST['type'];
    
    	//$mediaData = filter_input(INPUT_POST, 'data', FILTER_UNSAFE_RAW);
    	$result = getMedia($mediaID,$randomKey);
    	if($result != -1){
    		$mediaID = $result['mediaID'];
    		$date = date("d_m_y", strtotime($result['date']));
    		$exerciseID = $result['exerciseID'];
    		
    		if($type == 1){
    			writeVideo($mediaID,$date,$exerciseID);
    		}
    		if($type == 2){
    			writeImage($mediaID,$date,$exerciseID);
    		}
        	
    	}else{
        	$reply['success'] = -1;
        	$reply['error'] = "No Media:".$mediaID." or wrong secret:".$randomKey;
    		
    	}
   
    
    
    echo json_encode($reply);
    
    
    exit();
    
    
    
    
    
    
    ?>