<?php
require_once 'PharmacyDatabase.php';

// Instantiate the database class
$db = new PharmacyDatabase();

// Fetch inventory data from the view
$inventory = $db->MedicationInventory();
?>

<h1>Medication Inventory</h1>
<table border="1" cellpadding="10">
    <tr>
        <th>Medication ID</th>
        <th>Name</th>
        <th>Dosage</th>
        <th>Manufacturer</th>
        <th>Quantity</th>
        <th>Last Updated</th>
    </tr>

    <?php foreach ($inventory as $row): ?>
        <tr>
            <td><?= htmlspecialchars($row['medicationId']) ?></td>
            <td><?= htmlspecialchars($row['medicationName']) ?></td>
            <td><?= htmlspecialchars($row['dosage']) ?></td>
            <td><?= htmlspecialchars($row['manufacturer']) ?></td>
            <td><?= htmlspecialchars($row['quantityAvailable']) ?></td>
            <td><?= htmlspecialchars($row['lastUpdated']) ?></td>
        </tr>
    <?php endforeach; ?>
</table>

