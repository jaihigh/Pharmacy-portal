<!DOCTYPE html>
<html>
<head>
    <title>Pharmacy Portal</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<?php
// Display a success message if one was passed
if (isset($_GET['message'])): ?>
    <p style="color: green; font-weight: bold;">
        <?= htmlspecialchars($_GET['message']) ?>
    </p>
<?php endif; ?>

<h1>Pharmacy Portal</h1>

<nav>
    <a href="?action=addUser" class="nav-link">Register</a>
    <a href="?action=loginUserForm" class="nav-link">Login</a>
</nav>

</body>
</html>
