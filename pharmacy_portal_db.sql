-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 06, 2025 at 04:53 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pharmacy_portal_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddOrUpdateUser` (IN `p_userId` INT, IN `p_userName` VARCHAR(45), IN `p_contactInfo` VARCHAR(200), IN `p_userType` VARCHAR(10))   BEGIN
    IF p_userId IS NULL THEN
        -- Insert new user
        INSERT INTO Users (userName, contactInfo, userType)
        VALUES (p_userName, p_contactInfo, p_userType);
    ELSE
        -- Update existing user
        UPDATE Users
        SET userName = p_userName,
            contactInfo = p_contactInfo,
            userType = p_userType
        WHERE userId = p_userId;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ProcessSale` (IN `p_prescriptionId` INT, IN `p_quantitySold` INT)   BEGIN
    DECLARE medId INT;
    DECLARE currentStock INT;
    DECLARE unitPrice DECIMAL(10,2);
    DECLARE totalAmount DECIMAL(10,2);

    -- Get the medicationId from the prescription
    SELECT medicationId INTO medId
    FROM Prescriptions
    WHERE prescriptionId = p_prescriptionId;

    -- Get current stock from inventory
    SELECT quantityAvailable INTO currentStock
    FROM Inventory
    WHERE medicationId = medId;

    -- Assume fixed unit price for this example
    SET unitPrice = 5.00;
    SET totalAmount = p_quantitySold * unitPrice;

    IF currentStock >= p_quantitySold THEN
        -- Deduct quantity from inventory
        UPDATE Inventory
        SET quantityAvailable = quantityAvailable - p_quantitySold,
            lastUpdated = NOW()
        WHERE medicationId = medId;

        -- Insert into sales
        INSERT INTO Sales (prescriptionId, saleDate, quantitySold, saleAmount)
        VALUES (p_prescriptionId, NOW(), p_quantitySold, totalAmount);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough inventory to complete the sale.';
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Inventory`
--

CREATE TABLE `Inventory` (
  `inventoryId` int(11) NOT NULL,
  `medicationId` int(11) NOT NULL,
  `quantityAvailable` int(11) NOT NULL,
  `lastUpdated` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Inventory`
--

INSERT INTO `Inventory` (`inventoryId`, `medicationId`, `quantityAvailable`, `lastUpdated`) VALUES
(1, 1, 76, '2025-05-04 15:33:51'),
(2, 2, 180, '2025-05-05 22:17:24'),
(3, 3, 150, '2025-05-04 09:48:52');

--
-- Triggers `Inventory`
--
DELIMITER $$
CREATE TRIGGER `UpdateInventoryTimestamp` BEFORE UPDATE ON `Inventory` FOR EACH ROW BEGIN
  -- Update lastUpdated to the current timestamp
  SET NEW.lastUpdated = CURRENT_TIMESTAMP;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `medicationinventoryview`
-- (See below for the actual view)
--
CREATE TABLE `medicationinventoryview` (
`medicationId` int(11)
,`medicationName` varchar(45)
,`dosage` varchar(45)
,`manufacturer` varchar(100)
,`quantityAvailable` int(11)
,`lastUpdated` datetime
);

-- --------------------------------------------------------

--
-- Table structure for table `Medications`
--

CREATE TABLE `Medications` (
  `medicationId` int(11) NOT NULL,
  `medicationName` varchar(45) NOT NULL,
  `dosage` varchar(45) NOT NULL,
  `manufacturer` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Medications`
--

INSERT INTO `Medications` (`medicationId`, `medicationName`, `dosage`, `manufacturer`) VALUES
(1, 'Amoxicillin', '500mg', 'Pfizer'),
(2, 'Ibuprofen', '200mg', 'Bayer'),
(3, 'Metformin', '850mg', 'Teva'),
(4, 'Ibuprofen', '200mg', 'Bayer'),
(5, 'Tylenol', '200mg ', 'Johnson & Johnson'),
(6, 'Claritin', '10mg', 'Bayer'),
(7, 'Eylea', '20mg', 'Bayer'),
(8, 'Canister', '50mg', 'Bayer');

-- --------------------------------------------------------

--
-- Stand-in structure for view `patientprescriptiondetails`
-- (See below for the actual view)
--
CREATE TABLE `patientprescriptiondetails` (
`userName` varchar(45)
,`medicationName` varchar(45)
,`dosage` varchar(45)
,`dosageInstructions` varchar(200)
,`prescribedDate` datetime
);

-- --------------------------------------------------------

--
-- Table structure for table `Prescriptions`
--

CREATE TABLE `Prescriptions` (
  `prescriptionId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `medicationId` int(11) NOT NULL,
  `prescribedDate` datetime NOT NULL DEFAULT current_timestamp(),
  `dosageInstructions` varchar(200) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `refillCount` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Prescriptions`
--

INSERT INTO `Prescriptions` (`prescriptionId`, `userId`, `medicationId`, `prescribedDate`, `dosageInstructions`, `quantity`, `refillCount`) VALUES
(1, 1, 1, '2025-05-04 09:48:52', 'Take 1 capsule every 8 hours', 30, 0),
(2, 2, 2, '2025-05-04 09:48:52', 'Take 1 tablet after meals', 20, 0),
(3, 1, 3, '2025-05-04 09:48:52', 'Take 1 tablet before bed', 15, 0),
(4, 1, 1, '2025-05-04 14:24:47', '500mg Take 2 Twice a Day.', 40, 0),
(5, 1, 1, '2025-05-04 15:23:53', 'Take 1 capsule daily', 10, 0),
(6, 1, 1, '2025-05-04 15:33:51', 'take 1 capsule every 8 hours', 10, 0),
(7, 10, 8, '2025-05-05 21:03:38', 'Take Twice a Day', 20, 0),
(8, 10, 8, '2025-05-05 21:05:59', 'Take Twice a Day', 20, 0),
(9, 10, 8, '2025-05-05 21:06:17', 'Take Twice a Day', 50, 0),
(10, 10, 8, '2025-05-05 21:23:05', 'Take 1 a Day', 10, 0),
(11, 7, 2, '2025-05-05 22:17:24', 'one a day', 10, 0);

--
-- Triggers `Prescriptions`
--
DELIMITER $$
CREATE TRIGGER `AfterPrescriptionInsert` AFTER INSERT ON `Prescriptions` FOR EACH ROW BEGIN
  DECLARE currentStock INT;

  -- 1. Subtract prescribed quantity from inventory
  UPDATE Inventory
  SET quantityAvailable = quantityAvailable - NEW.quantity,
      lastUpdated = NOW()
  WHERE medicationId = NEW.medicationId;

  -- 2. Get the new stock level
  SELECT quantityAvailable INTO currentStock
  FROM Inventory
  WHERE medicationId = NEW.medicationId;

  -- 3. If stock is low, show a custom warning
  IF currentStock < 10 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Warning: Medication stock is low!';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Sales`
--

CREATE TABLE `Sales` (
  `saleId` int(11) NOT NULL,
  `prescriptionId` int(11) NOT NULL,
  `saleDate` datetime NOT NULL DEFAULT current_timestamp(),
  `quantitySold` int(11) NOT NULL,
  `saleAmount` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Sales`
--

INSERT INTO `Sales` (`saleId`, `prescriptionId`, `saleDate`, `quantitySold`, `saleAmount`) VALUES
(1, 1, '2025-05-04 09:48:52', 30, 45.00),
(2, 2, '2025-05-04 09:48:52', 20, 18.00),
(3, 3, '2025-05-04 09:48:52', 15, 25.00),
(4, 1, '2025-05-04 14:53:28', 2, 10.00),
(5, 2, '2025-05-04 18:08:46', 10, 25.00);

--
-- Triggers `Sales`
--
DELIMITER $$
CREATE TRIGGER `updateInventoryAfterSale` AFTER INSERT ON `Sales` FOR EACH ROW BEGIN
  -- Declare variable to hold medicationId
  DECLARE medId INT;

  -- Get the medicationId from the Prescriptions table using the new prescriptionId
  SELECT medicationId INTO medId
  FROM Prescriptions
  WHERE prescriptionId = NEW.prescriptionId;

  -- Update the Inventory quantity based on quantity sold
  UPDATE Inventory
  SET quantityAvailable = quantityAvailable - NEW.quantitySold
  WHERE medicationId = medId;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE `Users` (
  `userId` int(11) NOT NULL,
  `userName` varchar(45) NOT NULL,
  `contactInfo` varchar(200) DEFAULT NULL,
  `userType` enum('pharmacist','patient') NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Users`
--

INSERT INTO `Users` (`userId`, `userName`, `contactInfo`, `userType`, `password`) VALUES
(1, 'turbo54', 'turbo@gmail.com', 'patient', ''),
(2, 'fight21', 'fight@gmail.com', 'patient', ''),
(3, 'drjones', 'jones@pharmacy.com', 'pharmacist', ''),
(5, 'john21', 'john@gmail.com', 'patient', ''),
(6, 'noah32', 'noah@hotmail.com', 'patient', ''),
(7, 'carlos33', 'carlos@yahoo.com', 'patient', '$2y$10$MAA2jCXhefjqYTyPiDJ9v.NbDmk8sv1Oxzs.EkWl1MhlkJMv58A3C'),
(8, 'heather12', 'heather@yahoo.com', 'pharmacist', '$2y$10$1R3Q148WAIYU0JwRNcPUXuUuUjSaHhAh6c1sbBWp5hbwLhs.gtrJq'),
(9, 'honey21', 'honey@gmail.com', 'pharmacist', '$2y$10$37S41tx8aGV8ltfz5uSE5OsCCqZpHBslrZX6W6sM6HQcypwlLnKHC'),
(10, 'sam21', 'sam@gmail.com', 'patient', '$2y$10$CAeo5JO4N9ZfA8/t9GHf7ORZekhMv6LcO6WBF5BCLbqg0Xqi3rjPO'),
(12, 'doug21', 'doug@yahoo.com', 'pharmacist', '$2y$10$ecYO1La.R057wRqESooB9ubvp.1hS8.UTA2K9TjZKfK6k14AENw5m'),
(13, 'joah21', 'joah@yahoo.com', 'patient', '$2y$10$NljsXDFtXDujLsfCMDuSGOJ0qZUjQQVLp0eNSNF5nSGC0vdyE6/sm'),
(14, 'jenn21', 'jenn@gmail.com', 'pharmacist', '$2y$10$ZKO7qdsniikzwXsW7cOBD.2UYnqCmnccCAMFAjwxR9Qgb3mGdYJEm');

-- --------------------------------------------------------

--
-- Structure for view `medicationinventoryview`
--
DROP TABLE IF EXISTS `medicationinventoryview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `medicationinventoryview`  AS SELECT `m`.`medicationId` AS `medicationId`, `m`.`medicationName` AS `medicationName`, `m`.`dosage` AS `dosage`, `m`.`manufacturer` AS `manufacturer`, `i`.`quantityAvailable` AS `quantityAvailable`, `i`.`lastUpdated` AS `lastUpdated` FROM (`medications` `m` join `inventory` `i` on(`m`.`medicationId` = `i`.`medicationId`)) ;

-- --------------------------------------------------------

--
-- Structure for view `patientprescriptiondetails`
--
DROP TABLE IF EXISTS `patientprescriptiondetails`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `patientprescriptiondetails`  AS SELECT `u`.`userName` AS `userName`, `m`.`medicationName` AS `medicationName`, `m`.`dosage` AS `dosage`, `p`.`dosageInstructions` AS `dosageInstructions`, `p`.`prescribedDate` AS `prescribedDate` FROM ((`prescriptions` `p` join `users` `u` on(`p`.`userId` = `u`.`userId`)) join `medications` `m` on(`p`.`medicationId` = `m`.`medicationId`)) WHERE `u`.`userType` = 'patient' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Inventory`
--
ALTER TABLE `Inventory`
  ADD PRIMARY KEY (`inventoryId`),
  ADD KEY `medicationId` (`medicationId`);

--
-- Indexes for table `Medications`
--
ALTER TABLE `Medications`
  ADD PRIMARY KEY (`medicationId`);

--
-- Indexes for table `Prescriptions`
--
ALTER TABLE `Prescriptions`
  ADD PRIMARY KEY (`prescriptionId`),
  ADD KEY `userId` (`userId`),
  ADD KEY `medicationId` (`medicationId`);

--
-- Indexes for table `Sales`
--
ALTER TABLE `Sales`
  ADD PRIMARY KEY (`saleId`),
  ADD KEY `prescriptionId` (`prescriptionId`);

--
-- Indexes for table `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`userId`),
  ADD UNIQUE KEY `userName` (`userName`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Inventory`
--
ALTER TABLE `Inventory`
  MODIFY `inventoryId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Medications`
--
ALTER TABLE `Medications`
  MODIFY `medicationId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `Prescriptions`
--
ALTER TABLE `Prescriptions`
  MODIFY `prescriptionId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `Sales`
--
ALTER TABLE `Sales`
  MODIFY `saleId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Users`
--
ALTER TABLE `Users`
  MODIFY `userId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Inventory`
--
ALTER TABLE `Inventory`
  ADD CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`medicationId`) REFERENCES `Medications` (`medicationId`);

--
-- Constraints for table `Prescriptions`
--
ALTER TABLE `Prescriptions`
  ADD CONSTRAINT `prescriptions_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `Users` (`userId`),
  ADD CONSTRAINT `prescriptions_ibfk_2` FOREIGN KEY (`medicationId`) REFERENCES `Medications` (`medicationId`);

--
-- Constraints for table `Sales`
--
ALTER TABLE `Sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`prescriptionId`) REFERENCES `Prescriptions` (`prescriptionId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
