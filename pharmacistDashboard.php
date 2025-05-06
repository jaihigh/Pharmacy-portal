<?php
session_start();

// Restrict access to only logged-in pharmacists
if (!isset($_SESSION['userType']) || $_SESSION['userType'] !== 'pharmacist') {
    header("Location: login.php");
    exit;
}
?>

<h1>Welcome, <?= htmlspecialchars($_SESSION['userName']) ?> (Pharmacist)</h1>
<p>This is the pharmacist dashboard.</p>

<!-- Navigation Links -->
<nav>
    <ul>
        
        <li><a href="addMedication.php">Add Medication</a></li>
        <li><a href="PharmacyServer.php?action=addPrescription">Add Prescription</a></li>
        <li><a href="templates/viewPrescriptions.php">View Prescriptions</a></li>
        <li><a href="viewAllMedications.php">View All Medications</a></li>
    </ul>
</nav>
