USE AsDB
GO 


INSERT INTO Student (student_id, student_name, student_address)
VALUES 
(1, 'Ali', 'Tehran'),
(2, 'Sara', 'Mashhad');


INSERT INTO Seat (seat_no, seat_position, student_id)
VALUES 
(1, 'Front Row', 1),
(2, 'Back Row', 2);


INSERT INTO Instructor (Instructor_no, Instructor_name, Instructor_faculty)
VALUES 
(1, 'Dr. Smith', 'Computer Science'),
(2, 'Dr. Johnson', 'Mathematics');


INSERT INTO Course (course_id, Course_name, Course_number, Instructor_no)
VALUES 
(1, 'Algorithms', 'CS101', 1),
(2, 'Data Structures', 'CS102', 1);


INSERT INTO StudentCourse (Student_id, Course_id)
VALUES 
(1, 1),
(2, 2);


INSERT INTO Professor (professor_id, professor_name, professor_faculty)
VALUES 
(1, 'Prof. Williams', 'Computer Science'),
(2, 'Prof. Brown', 'Mathematics');


INSERT INTO Section (section_number, professor_id)
VALUES 
(101, 1),
(102, 2);


INSERT INTO Class (class_name, num_registered, class_date_time, course_id, section_number)
VALUES 
('CS101-A', 30, '2024-09-15', 1, 101),
('CS102-A', 25, '2024-09-16', 2, 102);
