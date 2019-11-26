ALTER TABLE employees
ADD name VARCHAR(80) NULL
GO

UPDATE employees set name = CONCAT(first_name, ' ', last_name)
GO

ALTER TABLE employees DROP column last_name
ALTER TABLE employees DROP column first_name
GO

ALTER VIEW employee_positions AS
SELECT employees.id AS employee_id,
	name,
	title
FROM employees
	LEFT JOIN titles on employees.title_id = titles.id