<?php
// Database connection
$servername = "localhost";
$username = "root";
$password = "root";
$dbname = "WatheqDB";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $companyName = $_POST["companyName"];
    $email = $_POST["email"];
    $password = $_POST["password"];

    // Validate password requirements
    $passwordRegex = "/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()\-_=+{};:,<.>])(?!.*\s).{8,}$/";
    if (!preg_match($passwordRegex, $password)) {
        echo "<script>alert('Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character.');</script>";
        echo '<script>window.location.href = "SignUp.html?companyName=' . urlencode($companyName) . '&email=' . urlencode($email) . '";</script>';
        exit();
    }

    // Check if email already exists
    $checkEmailQuery = "SELECT * FROM JobProvider WHERE JobProviderEmail = ?";
    $stmt = $conn->prepare($checkEmailQuery);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        echo "<script>alert('Email already exists. Please Log In.');</script>";
        echo '<script>window.location.href = "../LogIn page/logIn.html?email=' . urlencode($email) . '";</script>';
        exit();
    }

    // If no errors, insert the user into the database
    if (!isset($error)) {
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT); // Hash the password

        $insertQuery = "INSERT INTO JobProvider (CompanyName, JobProviderEmail, Password) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($insertQuery);
        $stmt->bind_param("sss", $companyName, $email, $hashedPassword);

        if ($stmt->execute()) {
            echo "<script>alert('Registration Completed Successfully');</script>";
            echo '<script>window.location.href = "../LogIn page/logIn.html?email=' . urlencode($email) . '";</script>';
            exit();
        } else {
            $error = "Error: " . $insertQuery . "<br>" . $conn->error;
        }
    }
}
?>

<?php
$conn->close(); // Close the database connection
?>
