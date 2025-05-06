<?php
// Start a session to track user login
session_start();

// Include your database handler
require_once 'PharmacyDatabase.php';
$db = new PharmacyDatabase();
$conn = $db->getConnection(); // Uses the helper method we'll define in PharmacyDatabase.php

// If the form was submitted
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $userName = $_POST['userName'];
    $password = $_POST['password'];

    // Prepare and execute a query to find the user by username
    $stmt = $conn->prepare("SELECT * FROM Users WHERE userName = ?");
    $stmt->bind_param("s", $userName);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc(); // Fetch user record as an associative array

    // If a user exists and the password is correct
    if ($user && password_verify($password, $user['password'])) {
        // Save session info
        $_SESSION['userId'] = $user['userId'];
        $_SESSION['userName'] = $user['userName'];
        $_SESSION['userType'] = $user['userType'];

        // Redirect based on role
        if ($user['userType'] === 'pharmacist') {
            header("Location: pharmacistDashboard.php");
        } else {
            header("Location: patientDashboard.php");
        }
        exit;
    } else {
        // Show error if login fails
        $error = "Invalid username or password.";
    }
}
?>

<!-- Basic HTML login form -->
<h1>Login</h1>

<?php if (isset($error)) echo "<p style='color:red;'>$error</p>"; ?>

<form method="POST" action="">
    <label>Username:</label>
    <input type="text" name="userName" required><br><br>

    <label>Password:</label>
    <input type="password" name="password" required><br><br>

    <input type="submit" value="Login">
</form>



