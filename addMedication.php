<!-- AddMedication.php -->

<!-- 
  This page displays a form that allows the user to enter
  a new medication's name, dosage, and manufacturer. 
  The form submits via POST to the action 'submitMedication',
  which should be handled in PharmacyServer.php or index.php.
-->
<?php if (isset($_GET['success']) && $_GET['success'] == '1'): ?>
    <p style="color: green;">Medication added successfully!</p>
<?php endif; ?>

<h1>Add Medication</h1>

<!-- Form that sends POST data to ?action=submitMedication -->
<form method="POST" action="PharmacyServer.php?action=submitMedication">

    
    <!-- Input for Medication Name -->
    <label>Medication Name:</label>
    <input type="text" name="medicationName" required><br><br>

    <!-- Input for Dosage -->
    <label>Dosage:</label>
    <input type="text" name="dosage" required><br><br>

    <!-- Input for Manufacturer -->
    <label>Manufacturer:</label>
    <input type="text" name="manufacturer"><br><br>

    <!-- Submit button -->
    <input type="submit" value="Add Medication">
</form>
