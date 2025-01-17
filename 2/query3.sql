Use AsDB
GO

Select Project.pro_name, COUNT(Empoloyee_Project.emp_id) as emp_count from Empoloyee_Project
inner join Project on Empoloyee_Project.pro_id = Project.pro_id
group by Empoloyee_Project.pro_id, Project.pro_name
Having COUNT(Empoloyee_Project.emp_id) < 4 


Select Employee.emp_name,Project.pro_name from Employee inner Join Empoloyee_Project
On Employee.emp_id = Empoloyee_Project.emp_id
Inner Join Project 
On Project.pro_id = Empoloyee_Project.pro_id
Group by Employee.emp_name,Project.pro_name

Select Sum(emp_salary) from Employee Inner Join Empoloyee_Project
ON Employee.emp_id = Empoloyee_Project.emp_id Inner Join Project
ON Project.pro_id = Empoloyee_Project.pro_id
Where Project.pro_name = 'B'

Select Project.pro_name,Employee.emp_salary from Project 
inner join Empoloyee_Project ON
Empoloyee_Project.pro_id = Project.pro_id
inner Join Employee ON
Employee.emp_id = Empoloyee_Project.emp_id

Select Project.pro_name from Project
Inner join Empoloyee_Project ON
Project.pro_id = Empoloyee_Project.pro_id
Inner Join Employee ON
Employee.emp_id = Empoloyee_Project.emp_id where Employee.emp_name = 'manager'
