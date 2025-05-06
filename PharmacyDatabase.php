<?php
class PharmacyDatabase {
    private $host = "localhost";
    private $port = "3306";
    private $database = "pharmacy_portal_db";
    private $user = "root";
    private $password = "";
    private $connection;

    public function __construct() {
        $this->connect();
    }

    private function connect() {
        $this->connection = new mysqli($this->host, $this->user, $this->password, $this->database, $this->port);
        if ($this->connection->connect_error) {
            die("Connection failed: " . $this->connection->connect_error);
        }
        echo "Successfully connected to the database";
    }
    public function getConnection() {
        return $this->connection;
    }
    
    public function addPrescription($patientUserName, $medicationId, $dosageInstructions, $quantity)  {
        $stmt = $this->connection->prepare(
            "SELECT userId FROM Users WHERE userName = ? AND userType = 'patient'"
        );
        $stmt->bind_param("s", $patientUserName);
        $stmt->execute();
        $stmt->bind_result($patientId);
        $stmt->fetch();
        $stmt->close();
        
        if ($patientId){
            $stmt = $this->connection->prepare(
                "INSERT INTO prescriptions (userId, medicationId, dosageInstructions, quantity) VALUES (?, ?, ?, ?)"
            );
            $stmt->bind_param("iisi", $patientId, $medicationId, $dosageInstructions, $quantity);
            $stmt->execute();
            $stmt->close();
            echo "Prescription added successfully";
        }else{
            echo "failed to add prescription";
        }
    }

    public function getAllPrescriptions() {
        $result = $this->connection->query("SELECT * FROM  prescriptions join medications on prescriptions.medicationId= medications.medicationId");
        return $result->fetch_all(MYSQLI_ASSOC);
    }
    
    public function MedicationInventory() {
        $result = $this->connection->query("SELECT * FROM medicationinventoryview");
    
        if ($result) {
            return $result->fetch_all(MYSQLI_ASSOC);
        } else {
            echo "Error fetching medication inventory: " . $this->connection->error;
            return [];
        }
    
    
    }

    // This function adds a new user (either a pharmacist or a patient) to the Users table
    public function addUser($userName, $contactInfo, $userType, $password) {
        // Hash the plain text password
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    
        // Prepare an SQL statement to insert the user with hashed password
        $stmt = $this->connection->prepare(
            "INSERT INTO Users (userName, contactInfo, userType, password) VALUES (?, ?, ?, ?)"
        );
    
        // Bind the parameters (all are strings)
        $stmt->bind_param("ssss", $userName, $contactInfo, $userType, $hashedPassword);
    
        // Execute the statement
        $stmt->execute();
    
        // Close the statement
        $stmt->close();
    }
    
    

    
     
    //  This function adds a new medication to the Medications table
    public function addMedication($medicationName, $dosage, $manufacturer) {
        $stmt = $this->connection->prepare(
            "INSERT INTO Medications (medicationName, dosage, manufacturer) VALUES (?, ?, ?)"
        );
        $stmt->bind_param("sss", $medicationName, $dosage, $manufacturer);
        $stmt->execute();
        $stmt->close();
    }
    
    
        // This function retrieves all medications from the Medications table
        public function getAllMedications() {
            // Query to select all records from Medications table
            $result = $this->connection->query("SELECT * FROM Medications");
    
            // If the query is successful, return the data as an associative array
            if ($result) {
                return $result->fetch_all(MYSQLI_ASSOC);
            } else {
                // If the query fails, display the error and return an empty array
                echo "Error fetching medications: " . $this->connection->error;
                return [];
            }
        }
    // This function retrieves user details including prescriptions and user type
public function getUserDetails($userId) {
    $stmt = $this->connection->prepare(
        "SELECT u.userId, u.userName, u.contactInfo, u.userType,
                p.prescriptionId, p.dosageInstructions, p.quantity,
                m.medicationName, m.dosage
         FROM Users u
         LEFT JOIN Prescriptions p ON u.userId = p.userId
         LEFT JOIN Medications m ON p.medicationId = m.medicationId
         WHERE u.userId = ?"
    );
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();
    $userDetails = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();
    return $userDetails;
}
public function getUserByUsername($userName) {
    // Prepare a SQL statement to safely select a user by their username
    $stmt = $this->connection->prepare("SELECT * FROM Users WHERE userName = ?");

    $stmt->bind_param("s", $userName);

    $stmt->execute();

    $result = $stmt->get_result();

    return $result->fetch_assoc();
}

    //Add Other needed functions here
}

?>