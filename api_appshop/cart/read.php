<?php
    include '../connection.php';

    $currentOnlineUserID = $_POST['currentOnlineUserID'];

    $sqlQuery = "SELECT * FROM cart CROSS JOIN items WHERE cart.user_id = '$currentOnlineUserID' AND cart.item_id = items.item_id";

    $resultOfQuery = $connectNow->query($sqlQuery);

    if($resultOfQuery->num_rows > 0)
    {
        $cartRecord = array();
        while($rowFound = $resultOfQuery->fetch_assoc())
        {
            $cartRecord[] = $rowFound;
        }

        echo json_encode(
            array(
                "success" => true,
                "currentUserCartData" => $cartRecord,
            )
        );
    }
    else
    {
        echo json_encode(array("success" => false));
    }