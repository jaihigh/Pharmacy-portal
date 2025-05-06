<?php
require_once 'PharmacyDatabase.php';

class PharmacyPortal {
    private $db;

    public function __construct() {
        $this->db = new PharmacyDatabase();
    }

    public function handleRequest() {
        $action = $_GET['action'] ?? 'home';

        switch ($action) {
            case 'addPrescription':
                $this->addPrescription();
                break;
            case 'addMedication': 
                    include 'templates/addMedication.php';
                    break;
            case 'submitMedication': 
                    $this->submitMedication();
                    break;
            case 'viewPrescriptions':
                $this->viewPrescriptions();
                break;
            case 'viewInventory':
                $this->viewInventory();
                break;
            case 'addUser':
                    $this->showAddUserForm();
                    break;
                
            case 'submitUser':
                    $this->submitUser();
                    break;
            case 'loginUser':
                        $this->loginUser();
                        break;
            case 'loginUserForm':
                 include 'login.php';
                 break;
                
            default:
                $this->home();
        }
    }

    private function home() {
        include 'templates/home.php';
    }

    private function loginUser() {
        // Start the session to manage login state
        session_start();
    
        // Retrieve username and password from the POST request
        $userName = $_POST['userName'];
        $password = $_POST['password'];
    
        // Fetch user data from the database by username
        $user = $this->db->getUserByUsername($userName); 
    
        if ($user && password_verify($password, $user['password'])) {
            // Store user information in session variables for access control
            $_SESSION['userId'] = $user['userId'];
            $_SESSION['userType'] = $user['userType'];
            $_SESSION['userName'] = $user['userName'];
    
            header("Location: ?action=home");
            exit;
        } else {
            echo "Invalid username or password.";
        }
    }
    
    private function addPrescription() {
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $patientUserName = $_POST['patient_username'];
            $medicationId= $_POST['medication_id'];
            $dosageInstructions = $_POST['dosage_instructions'];
            $quantity = $_POST['quantity'];

            $this->db->addPrescription($patientUserName, $medicationId, $dosageInstructions, $quantity);
            header("Location:?action=viewPrescriptions&message=Prescription Added");
        } else {
            include 'templates/addPrescription.php';
        }
    }

    private function viewPrescriptions() {
        $prescriptions = $this->db->getAllPrescriptions();
        include 'templates/viewPrescriptions.php';
    }

    // Display the Add User form
private function showAddUserForm() {
    include 'templates/addUser.php'; // Make sure this file exists
}

// Handle the submitted user form
private function submitUser() {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $userName = $_POST['userName'];
        $contactInfo = $_POST['contactInfo'];
        $userType = $_POST['userType'];
        $password = $_POST['password'];

         // Pass hashed password to the database method
         $this->db->addUser($userName, $contactInfo, $userType, $password);
         header("Location: ?action=loginUserForm&message=Registration successful, please login.");

        exit;
    } else {
        echo "Invalid request method.";
    }
}

    // This function handles the form submission from AddMedication.php
private function submitMedication() {
    // Check if the request was made via POST method
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        
        // Retrieve the input values from the POST request
        $medicationName = $_POST['medicationName'];
        $dosage = $_POST['dosage'];
        $manufacturer = $_POST['manufacturer'];

        // Call the addMedication method from the database class to insert the data
        $this->db->addMedication($medicationName, $dosage, $manufacturer);

        // Redirect to the home page with a success message in the query string
        header("Location: addMedication.php?success=1");
exit;

    } else {
        // If accessed via GET or other method, display an error message
        echo "Invalid request method.";
    }
}
}

$portal = new PharmacyPortal();
$portal->handleRequest();