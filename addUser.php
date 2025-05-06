<h1>Add New User</h1>

<!-- Sends user input to PharmacyServer.php using 'submitUser' action -->
<form method="POST" action="?action=submitUser">

    <label>Username:</label>
    <input type="text" name="userName" required><br><br>

    <label>Contact Info:</label>
    <input type="text" name="contactInfo" required><br><br>

    <label>User Type:</label>
    <select name="userType" required>
        <option value="patient">Patient</option>
        <option value="pharmacist">Pharmacist</option>
    </select><br><br>

    <label>Password:</label>
    <input type="password" name="password" required><br><br>

    <input type="submit" value="Add User">
</form>
