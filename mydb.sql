-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 19, 2025 at 07:50 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30
-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 19, 2025 at 07:50 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

DROP DATABASE IF EXISTS education_management;
CREATE DATABASE education_management;
USE education_management;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Charset Settings
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `education_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `batch`
--

CREATE TABLE `batch` (
  `batchId` int(11) NOT NULL AUTO_INCREMENT,
  `batch` varchar(10) NOT NULL,
  PRIMARY KEY (`batchId`),
  UNIQUE KEY `batch_UNIQUE` (`batch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `batch`
--

INSERT INTO `batch` (`batchId`, `batch`) VALUES
(22, '2022/2023'),
(23, '2023/2024'),
(24, '2024/2025');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `departmentId` int(11) NOT NULL AUTO_INCREMENT,
  `departmentName` varchar(45) NOT NULL,
  PRIMARY KEY (`departmentId`),
  UNIQUE KEY `departmentName_UNIQUE` (`departmentName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`departmentId`, `departmentName`) VALUES
(11, 'Computer Science'),
(12, 'Software Engineering'),
(13, 'Information System');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `staffId` varchar(10) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `status` enum('Enrolled','Not Enrolled') NOT NULL DEFAULT 'Not Enrolled',
  PRIMARY KEY (`staffId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`staffId`, `password`) VALUES
('fc222222', '22222222');

-- --------------------------------------------------------

--
-- Table structure for table `notice`
--

CREATE TABLE `notice` (
  `noticeId` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `date` date NOT NULL,
  `staffId` varchar(10) NOT NULL,
  PRIMARY KEY (`noticeId`),
  KEY `fk_notice_staff_idx` (`staffId`),
  CONSTRAINT `fk_notice_staff` 
    FOREIGN KEY (`staffId`) REFERENCES `staff` (`staffId`) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notice_batches`
--

CREATE TABLE `notice_batches` (
  `noticeId` int(11) NOT NULL,
  `batchId` int(11) NOT NULL,
  PRIMARY KEY (`noticeId`, `batchId`),
  KEY `fk_notice_batch_batch_idx` (`batchId`),
  CONSTRAINT `fk_notice_batch` 
    FOREIGN KEY (`batchId`) REFERENCES `batch` (`batchId`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notice_batch_notice` 
    FOREIGN KEY (`noticeId`) REFERENCES `notice` (`noticeId`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notice_departments`
--

CREATE TABLE `notice_departments` (
  `noticeId` int(11) NOT NULL,
  `departmentId` int(11) NOT NULL,
  PRIMARY KEY (`noticeId`, `departmentId`),
  KEY `fk_notice_dept_department_idx` (`departmentId`),
  CONSTRAINT `fk_notice_dept_department` 
    FOREIGN KEY (`departmentId`) REFERENCES `departments` (`departmentId`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notice_dept_notice` 
    FOREIGN KEY (`noticeId`) REFERENCES `notice` (`noticeId`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------


--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `studentId` varchar(10) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(45) DEFAULT NULL,
  `departmentId` int(11) DEFAULT NULL,
  `batchId` int(11) DEFAULT NULL,
  `status` enum('Enrolled','Not Enrolled') NOT NULL DEFAULT 'Not Enrolled',
  PRIMARY KEY (`studentId`),
  KEY `fk_students_department_idx` (`departmentId`),
  KEY `fk_students_batch_idx` (`batchId`),
  CONSTRAINT `fk_students_department` 
    FOREIGN KEY (`departmentId`) REFERENCES `departments` (`departmentId`) 
    ON UPDATE CASCADE,
  CONSTRAINT `fk_students_batch` 
    FOREIGN KEY (`batchId`) REFERENCES `batch` (`batchId`) 
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`studentId`, `password`) VALUES
('fc111111', '11111111');

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
