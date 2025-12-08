
CREATE DATABASE IF NOT EXISTS ProjectManagementDB_Schema;
USE ProjectManagementDB_Schema;

-- 1. Table: Project
CREATE TABLE Project (
    Project_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Start_Date DATE NOT NULL,
    End_Date DATE,
    Status VARCHAR(50) DEFAULT 'Active', --('Planning', 'Active', 'On Hold', 'Completed', 'Cancelled')
    Budget DECIMAL(12,2),
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    

);

-- 2. Table: Team_Member 
CREATE TABLE Team_Member (
    Member_ID INT PRIMARY KEY AUTO_INCREMENT,
    Full_Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Role VARCHAR(100) NOT NULL,
    Hourly_Rate DECIMAL(8,2),
    Is_Active BOOLEAN DEFAULT TRUE,
    Manager_ID INT,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_manager FOREIGN KEY (Manager_ID) REFERENCES Team_Member(Member_ID) ON DELETE SET NULL,
    

);

-- 3. Table: Milestone
CREATE TABLE Milestone (
    Milestone_ID INT PRIMARY KEY AUTO_INCREMENT,
    Project_ID INT NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Due_Date DATE NOT NULL,
    Description TEXT,
    Is_Completed BOOLEAN DEFAULT FALSE,
    Completed_Date DATE,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID) ON DELETE CASCADE,
    

);

-- 4. Table: Task
CREATE TABLE Task (
    Task_ID INT PRIMARY KEY AUTO_INCREMENT,
    Project_ID INT NOT NULL,
    Milestone_ID INT,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    Start_Date DATE NOT NULL,
    End_Date DATE,
    Priority VARCHAR(50) DEFAULT 'Medium', --('Low', 'Medium', 'High', 'Urgent', 'Critical')
    Status VARCHAR(50) DEFAULT 'Pending', --('Pending', 'In Progress', 'Completed', 'Blocked', 'Deferred', 'Review')
    Task_Type VARCHAR(50) DEFAULT 'Development', --('Development', 'Design', 'Testing', 'Documentation', 'Meeting', 'Other')
    Estimated_Hours DECIMAL(6,2),
    Actual_Hours DECIMAL(6,2),
    Created_By INT,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Updated_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID) ON DELETE CASCADE,
    FOREIGN KEY (Milestone_ID) REFERENCES Milestone(Milestone_ID) ON DELETE SET NULL,
    FOREIGN KEY (Created_By) REFERENCES Team_Member(Member_ID) ON DELETE SET NULL,
    
    
);

-- 5. Table: Member_Task
CREATE TABLE Member_Task (
    Member_Task_ID INT PRIMARY KEY AUTO_INCREMENT,
    Member_ID INT NOT NULL,
    Task_ID INT NOT NULL,
    Role_In_Task VARCHAR(100) DEFAULT 'Assignee', --('Assignee', 'Reviewer', 'Observer', 'Manager')
    Hours_Worked DECIMAL(6,2) DEFAULT 0,
    Is_Primary_Assignee BOOLEAN DEFAULT FALSE,
    Assigned_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Member_ID) REFERENCES Team_Member(Member_ID) ON DELETE CASCADE,
    FOREIGN KEY (Task_ID) REFERENCES Task(Task_ID) ON DELETE CASCADE,
    
    UNIQUE  (Member_ID, Task_ID, Role_In_Task),
    
);

-- 6. Table: Comment
CREATE TABLE Comment (
    Comment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Task_ID INT NOT NULL,
    Member_ID INT NOT NULL,
    Content TEXT NOT NULL,
    Comment_Type VARCHAR(50) DEFAULT 'General', ('General', 'Feedback', 'Question', 'Issue', 'Solution',"instruction")
    Is_Edited BOOLEAN DEFAULT FALSE,
    Edited_At TIMESTAMP NULL,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (Task_ID) REFERENCES Task(Task_ID) ON DELETE CASCADE,
    FOREIGN KEY (Member_ID) REFERENCES Team_Member(Member_ID) ON DELETE CASCADE,
    
    
);

-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

INSERT INTO Project (Name, Description, Start_Date, End_Date, Status, Budget) VALUES
('E-commerce Platform', 'Build new online shopping platform', '2024-01-01', '2024-09-30', 'Active', 150000.00),
('Data Analytics Dashboard', 'Real-time business analytics dashboard', '2024-02-15', '2024-07-31', 'Active', 80000.00),
('Internal HR System', 'Employee management system', '2024-03-01', '2024-12-31', 'Planning', 120000.00);

INSERT INTO Team_Member (Full_Name, Email, Role, Hourly_Rate, Is_Active, Manager_ID) VALUES
('Mohamed El-Sayed', 'mohamed.s@company.com', 'Senior Developer', 50.00, TRUE, NULL),
('Nourhan Ahmed', 'nourhan.a@company.com', 'DevOps Engineer', 45.00, TRUE, 1),
('Youssef Khalil', 'youssef.k@company.com', 'Database Administrator', 55.00, TRUE, 1),
('Mona Samir', 'mona.s@company.com', 'Product Manager', 60.00, TRUE, NULL),
('Hassan Mostafa', 'hassan.m@company.com', 'Business Analyst', 40.00, TRUE, 4),
('Laila Fathy', 'laila.f@company.com', 'Frontend Developer', 42.00, TRUE, 1);

INSERT INTO Milestone (Project_ID, Name, Due_Date, Description) VALUES
(1, 'Requirement Analysis', '2024-01-31', 'Gather and document all requirements'),
(1, 'Database Design', '2024-02-28', 'Design and implement database schema'),
(1, 'Backend Development', '2024-05-31', 'Complete backend APIs'),
(1, 'Frontend Development', '2024-07-31', 'Complete user interface'),
(1, 'Testing Phase', '2024-08-31', 'Comprehensive testing'),
(1, 'Deployment', '2024-09-30', 'Production deployment');

INSERT INTO Task (Project_ID, Milestone_ID, Title, Description, Start_Date, End_Date, Priority, Status, Task_Type, Estimated_Hours, Created_By) VALUES
(1, 1, 'User Requirements Gathering', 'Interview stakeholders and gather requirements', '2024-01-02', '2024-01-15', 'High', 'Completed', 'Documentation', 40, 5),
(1, 1, 'Technical Requirements Document', 'Create technical specification document', '2024-01-16', '2024-01-25', 'High', 'Completed', 'Documentation', 30, 4),
(1, 2, 'Database Schema Design', 'Design normalized database schema', '2024-02-01', '2024-02-15', 'High', 'In Progress', 'Development', 50, 3),
(1, 2, 'ER Diagram Creation', 'Create entity-relationship diagram', '2024-02-05', '2024-02-12', 'Medium', 'Pending', 'Documentation', 20, 3),
(1, 3, 'User Authentication API', 'Implement user login/registration APIs', '2024-03-01', '2024-03-15', 'High', 'Pending', 'Development', 60, 1),
(1, 3, 'Product Management APIs', 'Create CRUD APIs for products', '2024-03-10', '2024-03-31', 'High', 'Pending', 'Development', 70, 1),
(1, 4, 'Homepage UI Development', 'Create homepage with product listing', '2024-04-01', '2024-04-20', 'High', 'Pending', 'Development', 45, 6);

INSERT INTO Member_Task (Member_ID, Task_ID, Role_In_Task, Is_Primary_Assignee) VALUES
(5, 1, 'Assignee', TRUE),
(4, 1, 'Reviewer', FALSE),
(3, 3, 'Assignee', TRUE),
(1, 3, 'Reviewer', FALSE),
(1, 5, 'Assignee', TRUE),
(6, 7, 'Assignee', TRUE),
(4, 7, 'Manager', FALSE),
(2, 3, 'Observer', FALSE);

INSERT INTO Comment (Task_ID, Member_ID, Content, Comment_Type) VALUES
(1, 5, 'Completed interviews with all stakeholders', 'General'),
(1, 4, 'Please add more details about payment gateway requirements', 'Feedback'),
(3, 3, 'Started working on the database schema design', 'General'),
(3, 1, 'Consider adding indexes for performance optimization', 'Solution'),
(7, 6, 'Need clarification on homepage design requirements', 'Question');