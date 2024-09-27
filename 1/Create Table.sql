USE AsDB
Go 
Create Table Student(
	student_id int PRIMARY KEY,
	student_name nvarchar(255),
	student_address nvarchar(255)

)

CREATE Table Seat(
	seat_no INT PRIMARY KEY,
	seat_position nvarchar(255),
	student_id INT UNIQUE,
	CONSTRAINT FK_Seat_Student FOREIGN KEY (student_id) REFERENCES Student(student_id)
)

CREATE TABLE Course(
	course_id INT PRIMARY KEY,
	Course_name nvarchar(255) ,
	Course_number nvarchar(255),
	Instructor_no Int
	CONSTRAINT FK_Course_Instructor FOREIGN KEY (Instructor_no) REFERENCES Instructor(Instructor_no)
)

CREATE TABLE StudentCourse(
    Student_id INT,    
    Course_id INT,     
    CONSTRAINT FK_Student FOREIGN KEY (Student_id) REFERENCES Student(Student_id),
    CONSTRAINT FK_Course FOREIGN KEY (Course_id) REFERENCES Course(Course_id),
    PRIMARY KEY (Student_id, Course_id)  
)

CREATE TABLE Instructor(
	Instructor_no int PRIMARY KEY,
	Instructor_name nvarchar(255),
	Instructor_faculty nvarchar(255)

)

CREATE TABLE Class(
	class_name nvarchar(255) PRIMARY KEY,
	--section_number Int,
	num_registered Int,
	class_date_time Date,
	course_id Int,
	section_number Int,
	Constraint FK_Course_Class FOREIGN KEY (course_id) REFERENCES Course(Course_id),
	Constraint FK_Section FOREIGN KEY (section_number) REFERENCES Section(section_number)

)

CREATE Table Section(
	section_number INT PRIMARY KEY,
	professor_id INT,
	Constraint FK_Professor FOREIGN KEY (professor_id) REFERENCES Professor(professor_id)
)

CREATE TABLE Professor(
	professor_id INT Primary KEY,
	professor_name nvarchar(255),
	professor_faculty nvarchar(255)

)