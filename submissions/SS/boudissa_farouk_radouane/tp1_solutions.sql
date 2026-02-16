-- ============================================
-- TP1: University Management System
-- ============================================

DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;


-- Table: departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2),
    department_head VARCHAR(100),
    creation_date DATE
);

-- Table: professors
CREATE TABLE professors (
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10, 2),
    specialization VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) 
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: students
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    department_id INT,
    level VARCHAR(20) CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: courses
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK (credits > 0),
    semester INT CHECK (semester BETWEEN 1 AND 2),
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: enrollments
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress' CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    UNIQUE (student_id, course_id, academic_year),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: grades
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30) CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    grade DECIMAL(5, 2) CHECK (grade BETWEEN 0 AND 20),
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Indexes
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- Test Data

-- Departments
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'Building A', 500000.00, 'Dr. Alan Turing', '2010-09-01'),
('Mathematics', 'Building B', 350000.00, 'Dr. Isaac Newton', '2010-09-01'),
('Physics', 'Building C', 400000.00, 'Dr. Marie Curie', '2011-01-15'),
('Civil Engineering', 'Building D', 600000.00, 'Dr. Gustave Eiffel', '2012-05-20');

-- Professors
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Smith', 'John', 'john.smith@univ.edu', '123456789', 1, '2015-08-20', 75000.00, 'Artificial Intelligence'),
('Johnson', 'Alice', 'alice.johnson@univ.edu', '234567890', 1, '2016-01-10', 72000.00, 'Data Science'),
('Williams', 'Robert', 'robert.williams@univ.edu', '345678901', 1, '2018-03-15', 68000.00, 'Cybersecurity'),
('Brown', 'Emily', 'emily.brown@univ.edu', '456789012', 2, '2014-09-05', 80000.00, 'Pure Mathematics'),
('Davis', 'Michael', 'michael.davis@univ.edu', '567890123', 3, '2017-11-12', 74000.00, 'Quantum Physics'),
('Miller', 'Sarah', 'sarah.miller@univ.edu', '678901234', 4, '2019-06-30', 71000.00, 'Structural Engineering');

-- Students
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
('STU001', 'Doe', 'Jane', '2003-05-15', 'jane.doe@student.edu', '111222333', '123 Main St', 1, 'L3', '2022-09-01'),
('STU002', 'Wilson', 'David', '2004-02-20', 'david.wilson@student.edu', '222333444', '456 Oak Ave', 1, 'L2', '2023-09-01'),
('STU003', 'Taylor', 'Sophia', '2002-11-10', 'sophia.taylor@student.edu', '333444555', '789 Pine Rd', 2, 'M1', '2021-09-01'),
('STU004', 'Anderson', 'James', '2003-08-25', 'james.anderson@student.edu', '444555666', '321 Elm St', 3, 'L3', '2022-09-01'),
('STU005', 'Thomas', 'Olivia', '2004-01-05', 'olivia.thomas@student.edu', '555666777', '654 Maple Dr', 4, 'L2', '2023-09-01'),
('STU006', 'Moore', 'William', '2001-12-12', 'william.moore@student.edu', '666777888', '987 Cedar Ln', 1, 'M1', '2020-09-01'),
('STU007', 'Jackson', 'Emma', '2003-03-30', 'emma.jackson@student.edu', '777888999', '159 Birch Blvd', 2, 'L3', '2022-09-01'),
('STU008', 'White', 'Lucas', '2004-07-14', 'lucas.white@student.edu', '888999000', '753 Walnut Ct', 3, 'L2', '2023-09-01');

-- Courses
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS101', 'Introduction to Programming', 'Basics of Python', 6, 1, 1, 1, 50),
('CS202', 'Database Systems', 'SQL and Relational Algebra', 5, 2, 1, 2, 40),
('MATH101', 'Calculus I', 'Limits and Derivatives', 6, 1, 2, 4, 60),
('PHYS101', 'General Physics', 'Mechanics and Heat', 6, 1, 3, 5, 45),
('CE101', 'Statics', 'Forces and Equilibrium', 5, 1, 4, 6, 35),
('CS303', 'Artificial Intelligence', 'Machine Learning Basics', 6, 1, 1, 1, 30),
('MATH202', 'Linear Algebra', 'Matrices and Vectors', 5, 2, 2, 4, 40);

-- Enrollments
INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES
(1, 1, '2024-2025', 'Passed'),
(1, 2, '2024-2025', 'In Progress'),
(2, 1, '2024-2025', 'Passed'),
(2, 2, '2024-2025', 'In Progress'),
(3, 3, '2024-2025', 'Passed'),
(3, 7, '2024-2025', 'In Progress'),
(4, 4, '2024-2025', 'Passed'),
(5, 5, '2024-2025', 'Passed'),
(6, 1, '2023-2024', 'Passed'),
(6, 6, '2024-2025', 'In Progress'),
(7, 3, '2024-2025', 'Passed'),
(7, 7, '2024-2025', 'In Progress'),
(8, 4, '2024-2025', 'Passed'),
(1, 6, '2024-2025', 'In Progress'),
(2, 6, '2024-2025', 'In Progress');

-- Grades
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Exam', 15.50, 1.00, '2024-12-15', 'Good job'),
(3, 'Exam', 14.00, 1.00, '2024-12-15', 'Well done'),
(5, 'Exam', 18.00, 1.00, '2024-12-16', 'Excellent'),
(7, 'Exam', 12.50, 1.00, '2024-12-17', 'Satisfactory'),
(8, 'Exam', 16.00, 1.00, '2024-12-18', 'Great'),
(9, 'Exam', 17.00, 1.00, '2023-12-15', 'Old record'),
(11, 'Exam', 13.00, 1.00, '2024-12-16', 'Good'),
(13, 'Exam', 11.00, 1.00, '2024-12-17', 'Pass'),
(1, 'Assignment', 16.00, 0.50, '2024-11-10', 'Nice work'),
(3, 'Assignment', 15.00, 0.50, '2024-11-10', 'Good'),
(5, 'Assignment', 19.00, 0.50, '2024-11-11', 'Perfect'),
(7, 'Assignment', 14.00, 0.50, '2024-11-12', 'Good');

-- SQL Queries (30)

-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1. List all students with their main information (name, email, level)
SELECT last_name, first_name, email, level FROM students;

-- Q2. Display all professors from the Computer Science department
SELECT p.last_name, p.first_name, p.email, p.specialization 
FROM professors p 
JOIN departments d ON p.department_id = d.department_id 
WHERE d.department_name = 'Computer Science';

-- Q3. Find all courses with more than 5 credits
SELECT course_code, course_name, credits FROM courses WHERE credits > 5;

-- Q4. List students enrolled in L3 level
SELECT student_number, last_name, first_name, email FROM students WHERE level = 'L3';

-- Q5. Display courses from semester 1
SELECT course_code, course_name, credits, semester FROM courses WHERE semester = 1;


-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6. Display all courses with the professor's name
SELECT c.course_code, c.course_name, CONCAT(p.last_name, ' ', p.first_name) AS professor_name 
FROM courses c 
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7. List all enrollments with student name and course name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, c.course_name, e.enrollment_date, e.status 
FROM enrollments e 
JOIN students s ON e.student_id = s.student_id 
JOIN courses c ON e.course_id = c.course_id;

-- Q8. Display students with their department name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, d.department_name, s.level 
FROM students s 
LEFT JOIN departments d ON s.department_id = d.department_id;

-- Q9. List grades with student name, course name, and grade obtained
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, c.course_name, g.evaluation_type, g.grade 
FROM grades g 
JOIN enrollments e ON g.enrollment_id = e.enrollment_id 
JOIN students s ON e.student_id = s.student_id 
JOIN courses c ON e.course_id = c.course_id;

-- Q10. Display professors with the number of courses they teach
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, COUNT(c.course_id) AS number_of_courses 
FROM professors p 
LEFT JOIN courses c ON p.professor_id = c.professor_id 
GROUP BY p.professor_id, p.last_name, p.first_name;


-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate the overall average grade for each student
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, AVG(g.grade) AS average_grade 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
JOIN grades g ON e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id, s.last_name, s.first_name;

-- Q12. Count the number of students per department
SELECT d.department_name, COUNT(s.student_id) AS student_count 
FROM departments d 
LEFT JOIN students s ON d.department_id = s.department_id 
GROUP BY d.department_id, d.department_name;

-- Q13. Calculate the total budget of all departments
SELECT SUM(budget) AS total_budget FROM departments;

-- Q14. Find the total number of courses per department
SELECT d.department_name, COUNT(c.course_id) AS course_count 
FROM departments d 
LEFT JOIN courses c ON d.department_id = c.department_id 
GROUP BY d.department_id, d.department_name;

-- Q15. Calculate the average salary of professors per department
SELECT d.department_name, AVG(p.salary) AS average_salary 
FROM departments d 
LEFT JOIN professors p ON d.department_id = p.department_id 
GROUP BY d.department_id, d.department_name;


-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 3 students with the best averages
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, AVG(g.grade) AS average_grade 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
JOIN grades g ON e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id, s.last_name, s.first_name 
ORDER BY average_grade DESC 
LIMIT 3;

-- Q17. List courses with no enrolled students
SELECT course_code, course_name 
FROM courses 
WHERE course_id NOT IN (SELECT DISTINCT course_id FROM enrollments);

-- Q18. Display students who have passed all their courses (status = 'Passed')
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, COUNT(e.enrollment_id) AS passed_courses_count 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
WHERE s.student_id NOT IN (SELECT student_id FROM enrollments WHERE status != 'Passed')
GROUP BY s.student_id, s.last_name, s.first_name;

-- Q19. Find professors who teach more than 2 courses
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, COUNT(c.course_id) AS courses_taught 
FROM professors p 
JOIN courses c ON p.professor_id = c.professor_id 
GROUP BY p.professor_id, p.last_name, p.first_name 
HAVING COUNT(c.course_id) > 2;

-- Q20. List students enrolled in more than 2 courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, COUNT(e.enrollment_id) AS enrolled_courses_count 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
GROUP BY s.student_id, s.last_name, s.first_name 
HAVING COUNT(e.enrollment_id) > 2;


-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find students with an average higher than their department's average
SELECT student_name, student_avg, department_avg
FROM (
    SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, s.department_id, AVG(g.grade) AS student_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id, s.last_name, s.first_name, s.department_id
) AS student_averages
JOIN (
    SELECT s.department_id, AVG(g.grade) AS department_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.department_id
) AS dept_averages ON student_averages.department_id = dept_averages.department_id
WHERE student_avg > department_avg;

-- Q22. List courses with more enrollments than the average number of enrollments
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count 
FROM courses c 
JOIN enrollments e ON c.course_id = e.course_id 
GROUP BY c.course_id, c.course_name 
HAVING COUNT(e.enrollment_id) > (
    SELECT AVG(enrollment_count) 
    FROM (SELECT COUNT(enrollment_id) AS enrollment_count FROM enrollments GROUP BY course_id) AS counts
);

-- Q23. Display professors from the department with the highest budget
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, d.department_name, d.budget 
FROM professors p 
JOIN departments d ON p.department_id = d.department_id 
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Find students with no grades recorded
SELECT CONCAT(last_name, ' ', first_name) AS student_name, email 
FROM students 
WHERE student_id NOT IN (
    SELECT DISTINCT e.student_id 
    FROM enrollments e 
    JOIN grades g ON e.enrollment_id = g.enrollment_id
);

-- Q25. List departments with more students than the average
SELECT d.department_name, COUNT(s.student_id) AS student_count 
FROM departments d 
LEFT JOIN students s ON d.department_id = s.department_id 
GROUP BY d.department_id, d.department_name 
HAVING COUNT(s.student_id) > (
    SELECT AVG(student_count) 
    FROM (SELECT COUNT(student_id) AS student_count FROM students GROUP BY department_id) AS counts
);


-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate the pass rate per course (grades >= 10/20)
SELECT c.course_name, 
       COUNT(g.grade_id) AS total_grades, 
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       (SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id)) * 100 AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name;

-- Q27. Display student ranking by descending average
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS `rank`, 
       CONCAT(s.last_name, ' ', s.first_name) AS student_name, 
       AVG(g.grade) AS average_grade 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
JOIN grades g ON e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id, s.last_name, s.first_name;

-- Q28. Generate a report card for student with student_id = 1
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient, (g.grade * g.coefficient) AS weighted_grade 
FROM grades g 
JOIN enrollments e ON g.enrollment_id = e.enrollment_id 
JOIN courses c ON e.course_id = c.course_id 
WHERE e.student_id = 1;

-- Q29. Calculate teaching load per professor (total credits taught)
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, SUM(c.credits) AS total_credits 
FROM professors p 
LEFT JOIN courses c ON p.professor_id = c.professor_id 
GROUP BY p.professor_id, p.last_name, p.first_name;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
SELECT c.course_name, 
       COUNT(e.enrollment_id) AS current_enrollments, 
       c.max_capacity, 
       (COUNT(e.enrollment_id) / c.max_capacity) * 100 AS percentage_full 
FROM courses c 
LEFT JOIN enrollments e ON c.course_id = e.course_id 
GROUP BY c.course_id, c.course_name, c.max_capacity 
HAVING (COUNT(e.enrollment_id) / c.max_capacity) > 0.8;
