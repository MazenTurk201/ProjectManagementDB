-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 05, 2025 at 06:56 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `projectmanagementdb_schema`
--

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

CREATE TABLE `comment` (
  `Comment_ID` int(11) NOT NULL,
  `Task_ID` int(11) NOT NULL,
  `Member_ID` int(11) NOT NULL,
  `Content` text NOT NULL,
  `Comment_Type` varchar(50) DEFAULT 'General',
  `Is_Edited` tinyint(1) DEFAULT 0,
  `Edited_At` timestamp NULL DEFAULT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comment`
--

INSERT INTO `comment` (`Comment_ID`, `Task_ID`, `Member_ID`, `Content`, `Comment_Type`, `Is_Edited`, `Edited_At`, `Timestamp`) VALUES
(1, 1, 5, 'Completed interviews with all stakeholders', 'General', 0, NULL, '2025-12-04 19:54:42'),
(2, 1, 4, 'Please add more details about payment gateway requirements', 'Feedback', 0, NULL, '2025-12-04 19:54:42'),
(3, 3, 3, 'Started working on the database schema design', 'General', 0, NULL, '2025-12-04 19:54:42'),
(4, 3, 1, 'Consider adding indexes for performance optimization', 'Solution', 0, NULL, '2025-12-04 19:54:42'),
(5, 7, 6, 'Need clarification on homepage design requirements', 'Question', 0, NULL, '2025-12-04 19:54:42');

-- --------------------------------------------------------

--
-- Table structure for table `member_task`
--

CREATE TABLE `member_task` (
  `Member_Task_ID` int(11) NOT NULL,
  `Member_ID` int(11) NOT NULL,
  `Task_ID` int(11) NOT NULL,
  `Role_In_Task` varchar(100) DEFAULT 'Assignee',
  `Hours_Worked` decimal(6,2) DEFAULT 0.00,
  `Is_Primary_Assignee` tinyint(1) DEFAULT 0,
  `Assigned_Date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `member_task`
--

INSERT INTO `member_task` (`Member_Task_ID`, `Member_ID`, `Task_ID`, `Role_In_Task`, `Hours_Worked`, `Is_Primary_Assignee`, `Assigned_Date`) VALUES
(1, 5, 1, 'Assignee', 0.00, 1, '2025-12-04 19:54:42'),
(2, 4, 1, 'Reviewer', 0.00, 0, '2025-12-04 19:54:42'),
(3, 3, 3, 'Assignee', 0.00, 1, '2025-12-04 19:54:42'),
(4, 1, 3, 'Reviewer', 0.00, 0, '2025-12-04 19:54:42'),
(5, 1, 5, 'Assignee', 0.00, 1, '2025-12-04 19:54:42'),
(6, 6, 7, 'Assignee', 0.00, 1, '2025-12-04 19:54:42'),
(7, 4, 7, 'Manager', 0.00, 0, '2025-12-04 19:54:42'),
(8, 2, 3, 'Observer', 0.00, 0, '2025-12-04 19:54:42');

-- --------------------------------------------------------

--
-- Table structure for table `milestone`
--

CREATE TABLE `milestone` (
  `Milestone_ID` int(11) NOT NULL,
  `Project_ID` int(11) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Due_Date` date NOT NULL,
  `Description` text DEFAULT NULL,
  `Is_Completed` tinyint(1) DEFAULT 0,
  `Completed_Date` date DEFAULT NULL,
  `Created_At` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `milestone`
--

INSERT INTO `milestone` (`Milestone_ID`, `Project_ID`, `Name`, `Due_Date`, `Description`, `Is_Completed`, `Completed_Date`, `Created_At`) VALUES
(1, 1, 'Requirement Analysis', '2024-01-31', 'Gather and document all requirements', 0, NULL, '2025-12-04 19:54:42'),
(2, 1, 'Database Design', '2024-02-28', 'Design and implement database schema', 0, NULL, '2025-12-04 19:54:42'),
(3, 1, 'Backend Development', '2024-05-31', 'Complete backend APIs', 0, NULL, '2025-12-04 19:54:42'),
(4, 1, 'Frontend Development', '2024-07-31', 'Complete user interface', 0, NULL, '2025-12-04 19:54:42'),
(5, 1, 'Testing Phase', '2024-08-31', 'Comprehensive testing', 0, NULL, '2025-12-04 19:54:42'),
(6, 1, 'Deployment', '2024-09-30', 'Production deployment', 0, NULL, '2025-12-04 19:54:42');

-- --------------------------------------------------------

--
-- Table structure for table `project`
--

CREATE TABLE `project` (
  `Project_ID` int(11) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Description` text DEFAULT NULL,
  `Start_Date` date NOT NULL,
  `End_Date` date DEFAULT NULL,
  `Status` varchar(50) DEFAULT 'Active',
  `Budget` decimal(12,2) DEFAULT NULL,
  `Created_At` timestamp NOT NULL DEFAULT current_timestamp(),
  `Updated_At` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `project`
--

INSERT INTO `project` (`Project_ID`, `Name`, `Description`, `Start_Date`, `End_Date`, `Status`, `Budget`, `Created_At`, `Updated_At`) VALUES
(1, 'E-commerce Platform', 'Build new online shopping platform', '2024-01-01', '2024-09-30', 'Active', 150000.00, '2025-12-04 19:54:42', '2025-12-04 19:54:42'),
(2, 'Data Analytics Dashboard', 'Real-time business analytics dashboard', '2024-02-15', '2024-07-31', 'Active', 80000.00, '2025-12-04 19:54:42', '2025-12-04 19:54:42'),
(3, 'Internal HR System', 'Employee management system', '2024-03-01', '2024-12-31', 'Planning', 120000.00, '2025-12-04 19:54:42', '2025-12-04 19:54:42'),
(4, 'mmm', '201201', '2025-12-05', '2020-12-01', 'In Progress', 0.00, '2025-12-04 23:13:33', '2025-12-04 23:13:33'),
(5, 'mmm', 'ewe', '2025-12-05', '2020-12-01', 'Completed', 3333.00, '2025-12-04 23:16:30', '2025-12-04 23:16:30');

-- --------------------------------------------------------

--
-- Table structure for table `task`
--

CREATE TABLE `task` (
  `Task_ID` int(11) NOT NULL,
  `Project_ID` int(11) NOT NULL,
  `Milestone_ID` int(11) DEFAULT NULL,
  `Title` varchar(255) NOT NULL,
  `Description` text DEFAULT NULL,
  `Start_Date` date NOT NULL,
  `End_Date` date DEFAULT NULL,
  `Priority` varchar(50) DEFAULT 'Medium',
  `Status` varchar(50) DEFAULT 'Pending',
  `Task_Type` varchar(50) DEFAULT 'Development',
  `Estimated_Hours` decimal(6,2) DEFAULT NULL,
  `Actual_Hours` decimal(6,2) DEFAULT NULL,
  `Created_By` int(11) DEFAULT NULL,
  `Created_At` timestamp NOT NULL DEFAULT current_timestamp(),
  `Updated_At` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `task`
--

INSERT INTO `task` (`Task_ID`, `Project_ID`, `Milestone_ID`, `Title`, `Description`, `Start_Date`, `End_Date`, `Priority`, `Status`, `Task_Type`, `Estimated_Hours`, `Actual_Hours`, `Created_By`, `Created_At`, `Updated_At`) VALUES
(1, 1, 1, 'User Requirements Gathering', 'Interview stakeholders and gather requirements', '2024-01-02', '2024-01-15', 'High', 'Completed', 'Documentation', 40.00, NULL, 5, '2025-12-04 19:54:42', '2025-12-05 05:37:14'),
(2, 1, 1, 'Technical Requirements Document', 'Create technical specification document', '2024-01-16', '2024-01-25', 'High', 'Completed', 'Documentation', 30.00, NULL, 4, '2025-12-04 19:54:42', '2025-12-05 05:37:22'),
(3, 1, 2, 'Database Schema Design', 'Design normalized database schema', '2024-02-01', '2024-02-15', 'High', 'Completed', 'Development', 50.00, NULL, 3, '2025-12-04 19:54:42', '2025-12-05 05:51:35'),
(4, 1, 2, 'ER Diagram Creation', 'Create entity-relationship diagram', '2024-02-05', '2024-02-12', 'Medium', 'Completed', 'Documentation', 20.00, NULL, 3, '2025-12-04 19:54:42', '2025-12-05 04:42:37'),
(5, 1, 3, 'User Authentication API', 'Implement user login/registration APIs', '2024-03-01', '2024-03-15', 'High', 'Pending', 'Development', 60.00, NULL, 1, '2025-12-04 19:54:42', '2025-12-04 20:06:56'),
(6, 1, 3, 'Product Management APIs', 'Create CRUD APIs for products', '2024-03-10', '2024-03-31', 'High', 'Pending', 'Development', 70.00, NULL, 1, '2025-12-04 19:54:42', '2025-12-04 19:54:42'),
(7, 1, 4, 'Homepage UI Development', 'Create homepage with product listing', '2024-04-01', '2024-04-20', 'High', 'Pending', 'Development', 45.00, NULL, 6, '2025-12-04 19:54:42', '2025-12-04 19:54:42'),
(11, 1, NULL, 'wewe', 'fdfd', '2025-12-05', '2025-12-09', 'Low', 'Pending', 'Development', 0.00, 0.00, 1, '2025-12-05 02:26:23', '2025-12-05 02:26:23'),
(12, 1, NULL, 'ertetr', 'ewfsdf', '2025-12-05', '2026-01-06', 'Medium', 'Completed', 'Development', 0.00, 0.00, 1, '2025-12-05 04:41:56', '2025-12-05 04:42:28');

-- --------------------------------------------------------

--
-- Table structure for table `team_member`
--

CREATE TABLE `team_member` (
  `Member_ID` int(11) NOT NULL,
  `Full_Name` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Role` varchar(100) NOT NULL,
  `Hourly_Rate` decimal(8,2) DEFAULT NULL,
  `Is_Active` tinyint(1) DEFAULT 1,
  `Manager_ID` int(11) DEFAULT NULL,
  `Created_At` timestamp NOT NULL DEFAULT current_timestamp(),
  `Password` varchar(255) DEFAULT '123456'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `team_member`
--

INSERT INTO `team_member` (`Member_ID`, `Full_Name`, `Email`, `Role`, `Hourly_Rate`, `Is_Active`, `Manager_ID`, `Created_At`, `Password`) VALUES
(1, 'Mohamed El-Sayed', 'mohamed.s@company.com', 'Senior Developer', 50.00, 1, NULL, '2025-12-04 19:54:42', '123456'),
(2, 'Nourhan Ahmed', 'nourhan.a@company.com', 'DevOps Engineer', 45.00, 1, 1, '2025-12-04 19:54:42', '123456'),
(3, 'Youssef Khalil', 'youssef.k@company.com', 'Database Administrator', 55.00, 1, 1, '2025-12-04 19:54:42', '123456'),
(4, 'Mona Samir', 'mona.s@company.com', 'Product Manager', 60.00, 1, NULL, '2025-12-04 19:54:42', '123456'),
(5, 'Hassan Mostafa', 'hassan.m@company.com', 'Business Analyst', 40.00, 1, 4, '2025-12-04 19:54:42', '123456'),
(6, 'Laila Fathy', 'laila.f@company.com', 'Frontend Developer', 42.00, 1, 1, '2025-12-04 19:54:42', '123456'),
(7, 'Mazen Turk', 'turk@turk.com', 'Member', NULL, 1, NULL, '2025-12-05 05:21:18', '0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`Comment_ID`),
  ADD KEY `idx_comment_task` (`Task_ID`),
  ADD KEY `idx_comment_member` (`Member_ID`),
  ADD KEY `idx_comment_timestamp` (`Timestamp`),
  ADD KEY `idx_comment_type` (`Comment_Type`);

--
-- Indexes for table `member_task`
--
ALTER TABLE `member_task`
  ADD PRIMARY KEY (`Member_Task_ID`),
  ADD UNIQUE KEY `uq_member_task` (`Member_ID`,`Task_ID`,`Role_In_Task`),
  ADD KEY `idx_member_task_member` (`Member_ID`),
  ADD KEY `idx_member_task_task` (`Task_ID`),
  ADD KEY `idx_member_task_role` (`Role_In_Task`),
  ADD KEY `idx_member_task_primary` (`Is_Primary_Assignee`);

--
-- Indexes for table `milestone`
--
ALTER TABLE `milestone`
  ADD PRIMARY KEY (`Milestone_ID`),
  ADD KEY `idx_milestone_project` (`Project_ID`),
  ADD KEY `idx_milestone_due_date` (`Due_Date`),
  ADD KEY `idx_milestone_completed` (`Is_Completed`),
  ADD KEY `idx_milestone_name` (`Name`);

--
-- Indexes for table `project`
--
ALTER TABLE `project`
  ADD PRIMARY KEY (`Project_ID`),
  ADD KEY `idx_project_status` (`Status`),
  ADD KEY `idx_project_dates` (`Start_Date`,`End_Date`),
  ADD KEY `idx_project_budget` (`Budget`);

--
-- Indexes for table `task`
--
ALTER TABLE `task`
  ADD PRIMARY KEY (`Task_ID`),
  ADD KEY `idx_task_project` (`Project_ID`),
  ADD KEY `idx_task_milestone` (`Milestone_ID`),
  ADD KEY `idx_task_status` (`Status`),
  ADD KEY `idx_task_priority` (`Priority`),
  ADD KEY `idx_task_type` (`Task_Type`),
  ADD KEY `idx_task_dates` (`Start_Date`,`End_Date`),
  ADD KEY `idx_task_created_by` (`Created_By`);

--
-- Indexes for table `team_member`
--
ALTER TABLE `team_member`
  ADD PRIMARY KEY (`Member_ID`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD KEY `idx_member_email` (`Email`),
  ADD KEY `idx_member_role` (`Role`),
  ADD KEY `idx_member_active` (`Is_Active`),
  ADD KEY `idx_member_manager` (`Manager_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comment`
--
ALTER TABLE `comment`
  MODIFY `Comment_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `member_task`
--
ALTER TABLE `member_task`
  MODIFY `Member_Task_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `milestone`
--
ALTER TABLE `milestone`
  MODIFY `Milestone_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `project`
--
ALTER TABLE `project`
  MODIFY `Project_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `task`
--
ALTER TABLE `task`
  MODIFY `Task_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `team_member`
--
ALTER TABLE `team_member`
  MODIFY `Member_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`Task_ID`) REFERENCES `task` (`Task_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`Member_ID`) REFERENCES `team_member` (`Member_ID`) ON DELETE CASCADE;

--
-- Constraints for table `member_task`
--
ALTER TABLE `member_task`
  ADD CONSTRAINT `member_task_ibfk_1` FOREIGN KEY (`Member_ID`) REFERENCES `team_member` (`Member_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `member_task_ibfk_2` FOREIGN KEY (`Task_ID`) REFERENCES `task` (`Task_ID`) ON DELETE CASCADE;

--
-- Constraints for table `milestone`
--
ALTER TABLE `milestone`
  ADD CONSTRAINT `milestone_ibfk_1` FOREIGN KEY (`Project_ID`) REFERENCES `project` (`Project_ID`) ON DELETE CASCADE;

--
-- Constraints for table `task`
--
ALTER TABLE `task`
  ADD CONSTRAINT `task_ibfk_1` FOREIGN KEY (`Project_ID`) REFERENCES `project` (`Project_ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `task_ibfk_2` FOREIGN KEY (`Milestone_ID`) REFERENCES `milestone` (`Milestone_ID`) ON DELETE SET NULL,
  ADD CONSTRAINT `task_ibfk_3` FOREIGN KEY (`Created_By`) REFERENCES `team_member` (`Member_ID`) ON DELETE SET NULL;

--
-- Constraints for table `team_member`
--
ALTER TABLE `team_member`
  ADD CONSTRAINT `fk_manager` FOREIGN KEY (`Manager_ID`) REFERENCES `team_member` (`Member_ID`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
