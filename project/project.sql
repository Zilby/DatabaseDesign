DROP DATABASE IF EXISTS university;
CREATE DATABASE university;
USE university;

CREATE TABLE students 
(
	student_id         INT            PRIMARY KEY,
	first_name 		   VARCHAR(30)    NOT NULL, 
	last_name 		   VARCHAR(30)    NOT NULL,
	college_name       VARCHAR(30)    NOT NULL,
	CONSTRAINT college_name_fk
		FOREIGN KEY (college_name)
		REFERENCES colleges (college_name)
	ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE group_admin
(
	student_id        INT             PRIMARY KEY, 
	CONSTRAINT student_id_fk
		FOREIGN KEY (student_id)
		REFERENCES students (student_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE colleges
(
	college_name       VARCHAR(30)    PRIMARY KEY
);