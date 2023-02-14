<?php
    include '../connection.php';
    
    $sqlQuery = "SELECT * FROM items ORDER BY item_id DESC";

    $resultOfQuery = $connectNow->query($sqlQuery);

    if($resultOfQuery->num_rows > 0)
    {
        $itemRecord = array();
        while($rowFound = $resultOfQuery->fetch_assoc())
        {
            $itemRecord[] = $rowFound;
        }

        echo json_encode(
            array(
                "success" => true,
                "itemData" => $itemRecord,
            )
        );
    }
    else
    {
        echo json_encode(array("success" => false));
    }