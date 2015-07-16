<?php


include ("function_sql.php");
    
    


    function clearExercises(){
        global $mysqli;
        if (!($stmt = $mysqli->prepare('DELETE from Exercise'))) {
            echo "error-del-1<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        if (!($stmt->execute())) {
            echo "error-del-2<br>\n";
            exit();
        }
    }
    
    function createExercise($name,$description,$maxWeight,$shared,$date)
    {
       
        $zero = 0;
        
        global $mysqli;
        if (!($stmt = $mysqli->prepare('INSERT INTO exercise (name,description,maxWeight,shared,date) VALUES (?,?,?,?,?)'))) {
            echo "error-1-7<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        
        if (!($stmt->bind_param('ssiis',$name,$describe,$maxWeight,$shared,$date))) {
            echo "error-1-8<br>\n";
            exit();
        }
        
        if (!($stmt->execute())) {
            echo "error-1-9<br>\n".$mysqli->error;
            exit();
        }
        
        return mysqli_stmt_insert_id ($stmt);
    }
    
    function updateExercise($exerciseID,$name,$description,$maxWeight,$shared,$date)
    {
        global $mysqli;
        if (!($stmt = $mysqli->prepare('UPDATE exercise SET name =?, description=?, maxWeight =?, shared=?, date = ? WHERE exerciseID = ?'))) {
            echo "error-2-7<br>\n";
            echo "Prepare failed: (" . $mysqli->errno . ") " . $mysqli->error;
            exit();
        }
        
        if (!($stmt->bind_param('ssiisi',$name,$describe,$maxWeight,$shared,$date,$exerciseID))) {
            echo "Bind failed: (" . $mysqli->errno . ") " . $mysqli->error;
            echo "error-2-8<br>\n";
            exit();
        }

        if (!($stmt->execute())) {
            echo "error-2-9<br>\n".$mysqli->error;
            exit();
        }
        
        
    }
    
    
    $jsonEncoded = filter_input(INPUT_POST, 'data', FILTER_UNSAFE_RAW);
    
    //$jsonEncoded = trim($jsonEncoded);
    
    $mysqli = DBCON_mysqli();
    $debug = 0;
    

    if($jsonDecoded = json_decode($jsonEncoded)){

        $exerciseID = $jsonDecoded->{'exerciseID'};
        $name = $jsonDecoded->{'name'};
        $description = $jsonDecoded->{'describe'};
        $maxWeight = $jsonDecoded->{'maxWeight'};
        $shared = $jsonDecoded->{'shared'};
        $date = date("Y-m-d H:i:s",$jsonDecoded->{'date'});
       
        if($exerciseID != 0){
            updateExercise($exerciseID,$name,$description,$maxWeight,$shared,$date);
            echo "OK-UPDATE";
        }else{
            $returnID = createExercise($name,$description,$maxWeight,$shared,$date);
            echo "OK-ID".$returnID;
        }
        

        
      
        
    }else{
        echo "NODATA";
    }
    exit();


    



?>