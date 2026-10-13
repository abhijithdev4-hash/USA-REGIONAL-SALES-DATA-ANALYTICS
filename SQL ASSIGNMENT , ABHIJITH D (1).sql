--  Create a database
CREATE DATABASE school_db;
USE school_db;
CREATE TABLE students
(student_id INT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL, 
last_name VARCHAR (50),
date_of_birth DATE,
email VARCHAR(100) UNIQUE ); 
CREATE TABLE courses
(course_id INT PRIMARY KEY,
course_name VARCHAR(100) NOT NULL,
credit_hours int);
CREATE TABLE enrollments
(enrollment_id INT PRIMARY KEY,
 student_id INT,
course_id INT,
enrollment_date DATETIME NOT NULL,
FOREIGN KEY ( student_id) REFERENCES STUDENTS ( student_id),
FOREIGN KEY ( Course_id ) REFERENCES COURSES ( course_id)
);
insert into students ( student_id, first_name, last_name,date_of_birth,email)
values
(  1, 'Alice', 'johnson', '2002-03-15', 'alice.johnson@email.com'),
(2, 'Bob' , 'smith', '2001-07-22', 'bob.smith@email.com'),
( 3, 'Carol', 'white', '2003-01-09', 'carol.white@email.com'),
( 4, 'David', 'brown', '2002-11-30', 'david.brown@email.com'),
( 5, 'Emma', 'davis' , '2001-05-05', 'emma.davis@gamil.com');
INSERT INTO courses ( course_id, course_name, credit_hours)
values
(101, 'Mathematics', 4),
(102,'English literacture' , 3),
(103,'computer science', 5),
(104, 'History',3),
(105,'physics',4);
insert into enrollments(enrollment_id,student_id,course_id,enrollment_date)
VALUES
(1,1,101,'2024-02-10 09:00:00'),
(2,2,103,'2024-03-12 10:30:00'),
(3,3,102,'2024-01-25 08:15:00'),
(4,4,105, '2024-06-01 11:00:00'),
(5,5,104,'2024-04-18 14:45:00');
DROP DATABASE  school_db;