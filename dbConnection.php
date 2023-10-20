<?php


$servername = "localhost";
$username = "root";
$password = "root";
$dbname = "watheqdb";


/*
$servername = "localhost";
$username = "csfrybmy_admin";
$password = "Watheq12345";
$dbname = "csfrybmy_watheqdb";
*/


$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
 
?>