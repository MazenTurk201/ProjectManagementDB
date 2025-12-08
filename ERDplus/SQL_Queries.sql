CREATE DATABASE IF NOT EXISTS projectmanagementdb_schema;
USE projectmanagementdb_schema;

-- =========================
-- 1. Table: project
-- =========================
CREATE TABLE project (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(50) DEFAULT 'Active', -- ('Planning', 'Active', 'On Hold', 'Completed', 'Cancelled')
    budget DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =========================
-- 2. Table: team_member
-- =========================
CREATE TABLE team_member (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    Password varchar(255) DEFAULT '123456',
    role VARCHAR(100) NOT NULL,
    hourly_rate DECIMAL(8,2),
    is_active TINYINT(1) DEFAULT 1,
    manager_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

        FOREIGN KEY (manager_id)
        REFERENCES team_member(member_id)
        ON DELETE SET NULL
);

-- =========================
-- 3. Table: milestone
-- =========================
CREATE TABLE milestone (
    milestone_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    due_date DATE NOT NULL,
    description TEXT,
    is_completed TINYINT(1) DEFAULT 0,
    completed_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

        FOREIGN KEY (project_id)
        REFERENCES project(project_id)
        ON DELETE CASCADE
);

-- =========================
-- 4. Table: task
-- =========================
CREATE TABLE task (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    milestone_id INT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    priority VARCHAR(50) DEFAULT 'Medium', -- ('Low', 'Medium', 'High', 'Urgent', 'Critical')
    status VARCHAR(50) DEFAULT 'Pending', -- ('Pending', 'In Progress', 'Completed', 'Blocked', 'Deferred', 'Review')
    task_type VARCHAR(50) DEFAULT 'Development', -- ('Development', 'Design', 'Testing', 'Documentation', 'Meeting', 'Other')
    estimated_hours DECIMAL(6,2),
    actual_hours DECIMAL(6,2),
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

        FOREIGN KEY (project_id)
        REFERENCES project(project_id)
        ON DELETE CASCADE,

        FOREIGN KEY (milestone_id)
        REFERENCES milestone(milestone_id)
        ON DELETE SET NULL,

        FOREIGN KEY (created_by)
        REFERENCES team_member(member_id)
        ON DELETE SET NULL
);

-- =========================
-- 5. Table: member_task
-- =========================
CREATE TABLE member_task (
    member_task_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    task_id INT NOT NULL,
    role_in_task VARCHAR(100) DEFAULT 'Assignee', -- ('Assignee', 'Reviewer', 'Observer', 'Manager')
    hours_worked DECIMAL(6,2) DEFAULT 0,
    is_primary_assignee TINYINT(1) DEFAULT 0,
    assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

        FOREIGN KEY (member_id)
        REFERENCES team_member(member_id)
        ON DELETE CASCADE,

        FOREIGN KEY (task_id)
        REFERENCES task(task_id)
        ON DELETE CASCADE,

        UNIQUE (member_id, task_id, role_in_task)
);

-- =========================
-- 6. Table: comment
-- =========================
CREATE TABLE comment (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    member_id INT NOT NULL,
    content TEXT NOT NULL,
    comment_type VARCHAR(50) DEFAULT 'General', -- ('General', 'Feedback', 'Question', 'Issue', 'Solution',"instruction")
    is_edited TINYINT(1) DEFAULT 0,
    edited_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

        FOREIGN KEY (task_id)
        REFERENCES task(task_id)
        ON DELETE CASCADE,

        FOREIGN KEY (member_id)
        REFERENCES team_member(member_id)
        ON DELETE CASCADE
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