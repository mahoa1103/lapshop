<?php
    include '../connection.php';

    $name = $_POST['name'];
    $rating = $_POST['rating'];
    $tags = $_POST['tags'];
    $price = $_POST['price'];
    $sizes = $_POST['sizes'];
    $colors = $_POST['colors'];
    $description = $_POST['description'];
    $image = $_POST['image'];

    $sqlQuery = "INSERT INTO items SET name = '$name', rating = '$rating', tags = '$tags', price = '$price', sizes = '$sizes', colors = '$colors', description = '$description', image = '$image'";

    $resultOfQuery = $connectNow->query($sqlQuery);

    if($resultOfQuery)
    {
        echo json_encode(array("success" => true));
    }
    else
    {
        echo json_encode(array("success" => false));
    }