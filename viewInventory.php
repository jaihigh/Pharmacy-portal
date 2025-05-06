<?php
require_once 'PharmacyDatabase.php';

// Instantiate the PharmacyDatabase class
$db = new PharmacyDatabase();

// Fetch data from the MedicationInventory view
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
    <?php foreach ($inventory as $item): ?>
        <tr>
            <td><?= htmlspecialchars($item['medicationId']) ?></td>
            <td><?= htmlspecialchars($item['medicationName']) ?></td>
            <td><?= htmlspecialchars($item['dosage']) ?></td>
            <td><?= htmlspecialchars($item['manufacturer']) ?></td>
            <td><?= htmlspecialchars($item['quantityAvailable']) ?></td>
            <td><?= htmlspecialchars($item['lastUpdated']) ?></td>
        </tr>
    <?php endforeach; ?>
</table>
