create database employee_db;
use employee_db;

-- Table 1: Job Department 
CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);

-- Table 2: Salary/Bonus 
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10 , 2 ),
    annual DECIMAL(10 , 2 ),
    bonus DECIMAL(10 , 2 ),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID)
        REFERENCES JobDepartment (Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

 -- Table 3: Employee 
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment (Job_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);


 -- Table 4: Qualification 
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee (emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

 -- Table 5: Leaves 
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID)
        REFERENCES Employee (emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);


 -- Table 6: Payroll 
CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10 , 2 ),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID)
        REFERENCES Employee (emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID)
        REFERENCES JobDepartment (job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID)
        REFERENCES SalaryBonus (salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID)
        REFERENCES Leaves (leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

SELECT 
    *
FROM
    jobdepartment;

SELECT 
    *
FROM
    salarybonus;

SELECT 
    *
FROM
    employee;

SELECT 
    *
FROM
    leaves;

SELECT 
    *
FROM
    payroll;

SELECT 
    *
FROM
    qualification;

-- 1
SELECT 
    COUNT(DISTINCT FIRSTNAME, LASTNAME) AS total_emp
FROM
    EMPLOYEE;

-- 2
-- Which departments have the highest number of employees? 

SELECT 
    d.jobdept, COUNT(e.emp_id) AS total_emp
FROM
    jobdepartment AS d
        JOIN
    employee e ON d.job_id = e.Job_ID
GROUP BY d.jobdept
ORDER BY total_emp DESC
LIMIT 1;


-- 3
--  What is the average salary per department? 
SELECT 
    AVG(s.amount) AS avg_sal, d.jobdept
FROM
    salarybonus AS s
        JOIN
    jobdepartment AS d ON d.job_id = s.job_id
GROUP BY d.jobdept;


-- 4
--  Who are the top 5 highest-paid employees?

SELECT 
    e.firstname, e.lastname, s.amount
FROM
    salarybonus AS s
        JOIN
    employee AS e ON e.Job_ID = s.job_id
ORDER BY amount DESC
LIMIT 5;
 
 
 -- 5
SELECT 
    SUM(s.annual + s.bonus) AS total_expenditure
FROM
    employee AS e
        JOIN
    salarybonus AS s ON s.Job_ID = e.Job_ID;
 
 -- 2. JOB ROLE AND DEPARTMENT ANALYSIS
 
SELECT 
    COUNT(name) AS dif_roles, jobdept
FROM
    jobdepartment
GROUP BY jobdept;
 

-- 7
-- What is the average salary range per department?

SELECT 
    AVG(s.annual) AS avg_salary, d.jobdept
FROM
    salarybonus s
        JOIN
    jobdepartment d ON d.job_id = s.job_id
GROUP BY d.jobdept;



-- 8
-- Which job roles offer the highest salary? 

SELECT 
    d.name, MAX(s.annual) AS high_sal
FROM
    salarybonus AS s
        JOIN
    jobdepartment AS d ON d.job_id = s.job_id
GROUP BY d.name
ORDER BY high_sal DESC
LIMIT 1;


-- 9
-- Which departments have the highest total salary allocation? 

SELECT 
    SUM(s.amount) AS high_sal, d.jobdept
FROM
    salarybonus AS s
        JOIN
    jobdepartment AS d ON d.job_id = s.job_id
GROUP BY d.jobdept
ORDER BY high_sal DESC
LIMIT 1;


-- 3 3. QUALIFICATION AND SKILLS ANALYSIS
-- 10
-- How many employees have at least one qualification listed?

SELECT 
    COUNT(DISTINCT e.emp_id) AS qualified_employees
FROM
    employee AS e
        JOIN
    qualification AS q ON e.emp_id = q.emp_id;


-- 11
-- Which positions require the most qualifications?

SELECT 
    position, COUNT(requirements) AS total_qual
FROM
    qualification
GROUP BY position;

-- 12
-- Which employees have the highest number of qualifications?

SELECT 
    COUNT(q.requirements) AS total_qual, e.firstname, e.lastname
FROM
    qualification AS q
        JOIN
    employee AS e ON e.Emp_ID = q.Emp_ID
GROUP BY e.Emp_ID , e.firstname , e.lastname;



-- 4. LEAVE AND ABSENCE PATTERNS 

SELECT 
    YEAR(date) AS year, COUNT(*) AS tot_leave
FROM
    leaves
GROUP BY YEAR(date);

-- 14
-- What is the average number of leave days taken by its employees per department?

SELECT 
    d.jobdept,
    COUNT(*) / COUNT(DISTINCT e.emp_id) AS avg_leave_days
FROM
    leaves l
        JOIN
    employee e ON e.emp_id = l.emp_id
        JOIN
    jobdepartment d ON d.job_id = e.job_id
GROUP BY d.jobdept;


 -- 15
SELECT 
    COUNT(*) AS tot_leaves, e.firstname, e.lastname, e.emp_ID
FROM
    leaves AS l
        JOIN
    employee AS e ON e.emp_id = l.emp_id
GROUP BY e.firstname , e.LastName , e.emp_ID
ORDER BY tot_leaves DESC;
 
 
 -- 16
SELECT 
    COUNT(*) AS total_leaves
FROM
    leaves;
 
 
 -- 17
SELECT 
    e.emp_id,
    e.firstname,
    e.lastname,
    COUNT(l.leave_id) AS total_leaves,
    p.total_amount
FROM
    employee e
        JOIN
    leaves l ON e.emp_id = l.emp_id
        JOIN
    payroll p ON e.emp_id = p.emp_id
GROUP BY e.emp_id , e.firstname , e.lastname , p.total_amount
ORDER BY total_leaves DESC;
 

--  5. PAYROLL AND COMPENSATION ANALYSIS 

SELECT 
    MONTH(date) AS month, SUM(total_amount)
FROM
    payroll
GROUP BY date;
  
  
 -- 19
SELECT 
    AVG(s.bonus) AS avg_bonus, d.jobdept
FROM
    salarybonus AS s
        JOIN
    jobdepartment AS d ON d.Job_ID = s.job_id
GROUP BY d.JobDept;
 
 
 -- 20
SELECT 
    MAX(s.bonus) AS highest_bonus, d.jobdept
FROM
    salarybonus AS s
        JOIN
    jobdepartment AS d ON d.Job_ID = s.Job_ID
GROUP BY d.jobdept
ORDER BY highest_bonus DESC
LIMIT 1;



-- 21

SELECT 
    AVG(total_amount) AS avg_payroll_amount
FROM
    payroll;

