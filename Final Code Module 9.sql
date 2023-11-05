create table titles(
	title_id varchar Primary Key,
	dept_name varchar
);

create table employees(
	emp_no int not null Primary Key,
	emp_title varchar references titles (title_id),
	birth_date date,
	first_name varchar not null,
	last_name varchar not null,
	sex varchar(1) not null,
	hire_date date
);

create table dept_manager(
	dept_no varchar not null references departments(dept_no),
	emp_no int not null
);

create table dept_emp(
	emp_no int not null references employees(emp_no),
	dept_no varchar not null references departments(dept_no)
);

create table salaries(
	emp_no int not null references employees(emp_no),
	salary int not null
);

create table departments(
	dept_no varchar primary key,
	dept_name varchar
);


-- for some reason, these two CSV files refused to import the columns, I found this code on Reddit after a google search
-- https://www.reddit.com/r/PostgreSQL/comments/ud1sfb/internal_server_error_columns_when_trying_to/
copy dept_manager from 'C:\Users\Alex\Desktop\Module 9 Project\Starter_Code\data\dept_manager.csv' with CSV header;
copy salaries from 'C:\Users\Alex\Desktop\Module 9 Project\Starter_Code\data\salaries.csv' with CSV Header;

-- list EE number, last name, first name, sex, salary of all employees

select e.emp_no, e.first_name, e.last_name, e.sex, s.salary
from employees as e 
join salaries as s 
on e.emp_no = s.emp_no;


-- list first name, last name, and hire date of the employees who were hired in 1986

select first_name, last_name, hire_date
from employees
where hire_date between '1986-1-1' and '1986-12-31'
order by hire_date;

-- list the manager of each department along with their departmetn number, department name, employee number, last name, and first name

select dm.dept_no, d.dept_name, dm.emp_no, e.first_name, e.last_name
from dept_manager as dm
join departments as d 
on dm.dept_no = d.dept_no
join employees as e
on e.emp_no = dm.emp_no
order by d.dept_no asc;

-- list dept # for each EE along with EE number, last name, first name, and dept name

select d.dept_no , e.emp_no, e.last_name, e.first_name, d.dept_name
from employees as e 
join dept_emp as de 
on e.emp_no = de.emp_no
join departments as d
on d.dept_no = de.dept_no
order by d.dept_no asc;

-- list first name, last name, sex of each employee whose first name =Hercules & last name begins with B

select first_name, last_name, sex
from employees
where first_name = 'Hercules' and last_name Like 'B%';

-- list each EE in sales department, including EE number, last name, first name

select e.emp_no, e.last_name, e.first_name
from employees as e
join dept_emp as de
on e.emp_no = de.emp_no
join departments d 
on de.dept_no = d.dept_no
where d.dept_name = 'Sales';

-- list each ee in the sales and development departmetns including ee number, last name, first name, and dept name

select e.emp_no, e.last_name, e.first_name, d.dept_name
from employees as e
join dept_emp as de
on e.emp_no = de.emp_no
join departments d 
on de.dept_no = d.dept_no
where d.dept_name = 'Sales' or d.dept_name = 'Development';


-- list the frequency in counts in descending order of all the EE last names (how many employees share the same last name)

select last_name, count(emp_no) as same_lastname
from employees 
group by last_name
order by same_lastname DESC;

