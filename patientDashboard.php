<?php
session_start();
if (!isset($_SESSION['userType']) || $_SESSION['userType'] !== 'patient') {
    header("Location: login.php");
    exit;
}
?>
<h1>Welcome, <?= htmlspecialchars($_SESSION['userName']) ?> (Patient)</h1>
<p>This is the patient dashboard.</p>

<!-- Add navigation links for patient features -->
<nav>
    <ul>
        <li><a href="viewAllMedications.php">View All Medications</a></li>
        <li><a href="templates/viewPrescriptions.php">View Prescriptions</a></li>
    </ul>
</nav>