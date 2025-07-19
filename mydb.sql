-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 19, 2025 at 07:50 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

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
  `batchId` int(11) NOT NULL,
  `batch` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `batch`
--

INSERT INTO `batch` (`batchId`, `batch`) VALUES
(22, '2022/2023');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `departmentId` int(11) NOT NULL,
  `departmentName` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`departmentId`, `departmentName`) VALUES
(11, 'Computer Science');

-- --------------------------------------------------------

--
-- Table structure for table `notice`
--

CREATE TABLE `notice` (
  `noticeId` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `date` date NOT NULL,
  `staffId` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notice_batches`
--

CREATE TABLE `notice_batches` (
  `noticeId` int(11) NOT NULL,
  `batchId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notice_departments`
--

CREATE TABLE `notice_departments` (
  `noticeId` int(11) NOT NULL,
  `departmentId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `staffId` varchar(10) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `status` enum('Enrolled','Not Enrolled') NOT NULL DEFAULT 'Not Enrolled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`staffId`, `name`, `email`, `password`, `status`) VALUES
('fc222222', 'xyz.xyzxyz', 'xyz@gmail.com', '00000000', 'Enrolled');

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
  `status` enum('Enrolled','Not Enrolled') NOT NULL DEFAULT 'Not Enrolled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`studentId`, `name`, `password`, `email`, `departmentId`, `batchId`, `status`) VALUES
('fc111111', 'abc.abcabcabc', '11111111', 'abc@gmail.com', 11, 22, 'Enrolled');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `batch`
--
ALTER TABLE `batch`
  ADD PRIMARY KEY (`batchId`),
  ADD UNIQUE KEY `batch_UNIQUE` (`batch`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`departmentId`),
  ADD UNIQUE KEY `departmentName_UNIQUE` (`departmentName`);

--
-- Indexes for table `notice`
--
ALTER TABLE `notice`
  ADD PRIMARY KEY (`noticeId`),
  ADD KEY `fk_notice_staff_idx` (`staffId`);

--
-- Indexes for table `notice_batches`
--
ALTER TABLE `notice_batches`
  ADD PRIMARY KEY (`noticeId`,`batchId`),
  ADD KEY `fk_notice_batch_batch_idx` (`batchId`);

--
-- Indexes for table `notice_departments`
--
ALTER TABLE `notice_departments`
  ADD PRIMARY KEY (`noticeId`,`departmentId`),
  ADD KEY `fk_notice_dept_department_idx` (`departmentId`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staffId`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`studentId`),
  ADD KEY `fk_students_department_idx` (`departmentId`),
  ADD KEY `fk_students_batch_idx` (`batchId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `batch`
--
ALTER TABLE `batch`
  MODIFY `batchId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `departmentId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `notice`
--
ALTER TABLE `notice`
  MODIFY `noticeId` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `notice`
--
ALTER TABLE `notice`
  ADD CONSTRAINT `fk_notice_staff` FOREIGN KEY (`staffId`) REFERENCES `staff` (`staffId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `notice_batches`
--
ALTER TABLE `notice_batches`
  ADD CONSTRAINT `fk_notice_batch` FOREIGN KEY (`batchId`) REFERENCES `batch` (`batchId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_notice_batch_notice` FOREIGN KEY (`noticeId`) REFERENCES `notice` (`noticeId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `notice_departments`
--
ALTER TABLE `notice_departments`
  ADD CONSTRAINT `fk_notice_dept_department` FOREIGN KEY (`departmentId`) REFERENCES `departments` (`departmentId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_notice_dept_notice` FOREIGN KEY (`noticeId`) REFERENCES `notice` (`noticeId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `fk_students_batch` FOREIGN KEY (`batchId`) REFERENCES `batch` (`batchId`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_students_department` FOREIGN KEY (`departmentId`) REFERENCES `departments` (`departmentId`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
