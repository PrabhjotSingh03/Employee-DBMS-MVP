-- Create Employee Table
CREATE TABLE Employee (
  Employee_ID INT PRIMARY KEY AUTO_INCREMENT,
  Empee_Name VARCHAR(255),
  Employment_num INT
);

-- Create Jobs Table
CREATE TABLE Job (
  Job_ID INT PRIMARY KEY AUTO_INCREMENT,
  Job_Name VARCHAR(255)
);

-- Create Work Hours Table
CREATE TABLE Work_Hours (
  Hours_ID INT PRIMARY KEY AUTO_INCREMENT,
  Hours INT
);
-- Create Employment (Bridging) table
CREATE TABLE Employment (
  employment_Id INT PRIMARY KEY AUTO_INCREMENT,
  Employee_ID INT,
  Job_ID INT,
  Hours_ID INT,
  FOREIGN KEY (Employee_ID) REFERENCES Employee (Employee_ID),
  FOREIGN KEY (Job_ID) REFERENCES Job(Job_ID),
  FOREIGN KEY (Hours_ID) REFERENCES Work_Hours(Hours_ID)
);

-- Create Logs table
CREATE TABLE Logs (
  log_ID INT PRIMARY KEY AUTO_INCREMENT,
  Employee_ID INT,
  Empee_Name VARCHAR(255),
  timestamp TIMESTAMP
);


--Create View Table
CREATE VIEW Employee_Work_Hours AS
SELECT Employee.Employee_ID, Empee_Name, Hours
FROM Employee
JOIN Employment ON Employee.Employee_ID = Employment.Employee_ID
JOIN Work_Hours ON Employment.Hours_ID = Work_Hours.Hours_ID;



-- Create Trigger
DELIMITER //
CREATE TRIGGER employee_joining_trigger
AFTER INSERT ON Employee
FOR EACH ROW
BEGIN
    INSERT INTO Logs (Employee_ID, Empee_Name, timestamp)
    VALUES (NEW.Employee_ID, NEW.Empee_Name, NOW());
END //
DELIMITER ;

-- Create Procedure to update entries in all necessary tables
DELIMITER //
CREATE PROCEDURE Add_New_Employee (IN Name varchar(255), IN Employment_Num int, IN Job_Name varchar(255), IN Hours int)
BEGIN
  -- Insert new employee data into Employee table
  INSERT INTO Employee (Empee_Name, Employment_num) VALUES (Name, Employment_Num);
  -- Get the ID of the newly inserted employee
  SET @Employee_ID = LAST_INSERT_ID();
  -- Insert new job data into Job table
  INSERT INTO Job (Job_Name) VALUES (Job_Name);
  -- Get the ID of the newly inserted job
  SET @Job_ID = LAST_INSERT_ID();
  -- Insert new work hours data into Work Hours table
  INSERT INTO Work_Hours (Hours) VALUES (Hours);
  -- Get the ID of the newly inserted work hours
  SET @Hours_ID = LAST_INSERT_ID();
  -- Insert new employment data into Employment table
  INSERT INTO Employment (Employee_ID, Job_ID, Hours_ID) VALUES (@Employee_ID, @Job_ID, @Hours_ID);
END //
DELIMITER ;

-- Insert values
CALL Add_New_Employee('John Doe', 12345, 'Manager', 40);

--Calling View Table
SELECT * FROM Employee_Work_Hours;
