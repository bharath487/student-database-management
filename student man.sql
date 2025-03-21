create database studentdb;
use studentdb;
-- Students – Stores student details.

CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Age INT,
    Gender ENUM('Male', 'Female'),
    Address VARCHAR(255),
    Phone VARCHAR(15) UNIQUE
);


-- Departments – Stores department details.

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) UNIQUE NOT NULL
);


-- Courses – Stores course details.

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY AUTO_INCREMENT,
    CourseName VARCHAR(100) UNIQUE NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE CASCADE
);


-- Enrollments – Tracks which students are enrolled in which courses.

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE
);


-- Grades – Stores student grades for courses.

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY AUTO_INCREMENT,
    EnrollmentID INT NOT NULL,
    Grade ENUM('A', 'B', 'C', 'D', 'F'),
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID) ON DELETE CASCADE
);

-- Insert Students --

INSERT INTO Students (Name, Age, Gender, Address, Phone) VALUES  
('Rahul Sharma', 20, 'Male', 'Delhi, India', '9876543210'),  
('Priya Singh', 19, 'Female', 'Mumbai, India', '8765432109'),  
('Ankit Verma', 21, 'Male', 'Bangalore, India', '7654321098'),  
('Sneha Mehta', 22, 'Female', 'Chennai, India', '6543210987'),  
('Vikram Patel', 18, 'Male', 'Kolkata, India', '5432109876');

-- Insert Departments --
INSERT INTO Departments (DepartmentName) VALUES  
('Computer Science'),  
('Mathematics'),  
('Physics'),  
('Biology'),  
('Chemistry');


 -- Insert Courses --

INSERT INTO Courses (CourseName, DepartmentID) VALUES  
('Database Management', 1),  
('Data Structures', 1),  
('Calculus', 2),  
('Linear Algebra', 2),  
('Quantum Physics', 3);

 -- Insert Enrollments --
INSERT INTO Enrollments (StudentID, CourseID) VALUES  
(1, 1),  
(2, 2),  
(3, 3),  
(4, 4),  
(5, 5);


---

-- Insert Grades

INSERT INTO Grades (EnrollmentID, Grade) VALUES  
(1, 'A'),  
(2, 'B'),  
(3, 'C'),  
(4, 'A'),  
(5, 'B');


-- Views

-- View: Student Enrollments

CREATE VIEW StudentEnrollments AS
SELECT S.StudentID, S.Name, C.CourseName, D.DepartmentName
FROM Students S
JOIN Enrollments E ON S.StudentID = E.StudentID
JOIN Courses C ON E.CourseID = C.CourseID
JOIN Departments D ON C.DepartmentID = D.DepartmentID;
-- call view --
select * from studentenrollments;
-- View: Course Details

CREATE VIEW CourseDetails AS
SELECT C.CourseID, C.CourseName, D.DepartmentName
FROM Courses C
JOIN Departments D ON C.DepartmentID = D.DepartmentID;
-- call view--
select *from coursedetails;

-- View: Student Grades

CREATE VIEW StudentGrades AS
SELECT S.StudentID, S.Name, C.CourseName, G.Grade
FROM Students S
JOIN Enrollments E ON S.StudentID = E.StudentID
JOIN Courses C ON E.CourseID = C.CourseID
LEFT JOIN Grades G ON E.EnrollmentID = G.EnrollmentID;
-- call view--
select*from studentgrades;

-- View: Department Wise Student Count

CREATE VIEW DepartmentStudentCount AS
SELECT D.DepartmentName, COUNT(E.StudentID) AS TotalStudents
FROM Departments D
JOIN Courses C ON D.DepartmentID = C.DepartmentID
JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY D.DepartmentName;
-- call view --
select * from DepartmentStudentCount;

-- View: Enrolled Students in a Course

CREATE VIEW CourseEnrollments AS
SELECT C.CourseName, COUNT(E.StudentID) AS EnrolledStudents
FROM Courses C
LEFT JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY C.CourseName;
-- call view--
select * from CourseEnrollments;



---

-- Stored Procedures

-- Get All Students

DELIMITER //
CREATE PROCEDURE GetAllStudents()
BEGIN
    SELECT * FROM Students;
END //
DELIMITER ;

-- Usage:

CALL GetAllStudents();


-- Get Courses by Department

DELIMITER //
CREATE PROCEDURE GetCoursesByDepartment(IN DeptID INT)
BEGIN
    SELECT * FROM Courses WHERE DepartmentID = DeptID;
END //
DELIMITER ;

-- Usage:

CALL GetCoursesByDepartment(1);


Insert New Student

DELIMITER //
CREATE PROCEDURE InsertStudent(
    IN StudentName VARCHAR(100), 
    IN StudentAge INT, 
    IN StudentGender ENUM('Male', 'Female'), 
    IN StudentAddress VARCHAR(255), 
    IN StudentPhone VARCHAR(15)
)
BEGIN
    INSERT INTO Students (Name, Age, Gender, Address, Phone) 
    VALUES (StudentName, StudentAge, StudentGender, StudentAddress, StudentPhone);
END //
DELIMITER ;

-- Usage:

CALL InsertStudent('Amit Kumar', 23, 'Male', 'Pune, India', 9956880776);


-- Update Student Phone Number

DELIMITER //
CREATE PROCEDURE UpdateStudentsPhone(IN StudentID INT, IN NewPhone VARCHAR(15))
BEGIN
    UPDATE Students 
    SET Phone = NewPhone 
    WHERE StudentID = StudentID;
    select*from students;
    
     
END //
DELIMITER ;


SET SQL_SAFE_UPDATES = 0;
CALL UpdateStudentsPhone(1, '9112233445');
SET SQL_SAFE_UPDATES = 1;


-- Delete Student by ID

DELIMITER //
CREATE PROCEDURE DeleteStudent(IN StudentID INT)
BEGIN
    DELETE FROM Students WHERE StudentID = StudentID;
END //
DELIMITER ;

-- Usage:
SET SQL_SAFE_UPDATES = 0;
CALL DeleteStudent(2);
SET SQL_SAFE_UPDATES = 1;
-- Queries (Questions)

-- Find all students enrolled in a specific course (e.g., "Database Management")

SELECT S.StudentID, S.Name 
FROM Students S
JOIN Enrollments E ON S.StudentID = E.StudentID
JOIN Courses C ON E.CourseID = C.CourseID
WHERE C.CourseName = 'Database Management';


-- Get the total number of students in each department

SELECT D.DepartmentName, COUNT(E.StudentID) AS TotalStudents
FROM Departments D
JOIN Courses C ON D.DepartmentID = C.DepartmentID
JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY D.DepartmentName;


-- Retrieve students who have received an 'A' grade

SELECT S.StudentID, S.Name, C.CourseName
FROM Students S
JOIN Enrollments E ON S.StudentID = E.StudentID
JOIN Grades G ON E.EnrollmentID = G.EnrollmentID
JOIN Courses C ON E.CourseID = C.CourseID
WHERE G.Grade = 'A';


-- List all courses offered by a specific department (e.g., "Computer Science")

SELECT CourseName FROM Courses
WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'Computer Science');


-- Find the number of students enrolled in each course

SELECT C.CourseName, COUNT(E.StudentID) AS TotalStudents
FROM Courses C
LEFT JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY C.CourseName;