<?php
    include '../connection.php';

    $minRating = 4.4;
    $limitLaptop = 5;
    
    $sqlQuery = "SELECT * FROM items WHERE rating >= '$minRating' ORDER BY rating DESC LIMIT $limitLaptop";

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