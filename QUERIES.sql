
-- LIBRARY MANAGEMENT SYSTEM -- 

Create database Library;
USE LIBRARY;

# CREATE TABLES : 
CREATE TABLE BOOKS(
				isbn VARCHAR(20)PRIMARY KEY,
                book_title VARCHAR(20),
                category VARCHAR(20),
                rental_price INT,
                status_ VARCHAR(5),
                author VARCHAR(20),
                publisher VARCHAR(30)
);
CREATE TABLE BRANCH (
					branch_id VARCHAR(20) PRIMARY KEY,
                    manager_id VARCHAR(20),
                    branch_address VARCHAR(20),
                    contact_no VARCHAR(20)
);
CREATE TABLE EMPLOYEES (
						emp_id VARCHAR(20) PRIMARY KEY,
                        emp_name VARCHAR(20),
                        position VARCHAR(20),
                        salary INT,
                        branch_id VARCHAR(20),
						FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);
CREATE TABLE ISSUED_STATUS (
    issued_id VARCHAR(20),
    issued_member_id VARCHAR(20),
    issued_book_name VARCHAR(30),
    issued_date DATE,
    issued_book_isbn VARCHAR(20),
    issued_emp_id VARCHAR(20),
    FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
	FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
	FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);
CREATE TABLE  MEMBERS (
						member_id VARCHAR(20) PRIMARY KEY,
                        member_name VARCHAR(20),
                        member_address VARCHAR(20),
                        reg_date DATE
);
CREATE TABLE RETURN_STATE(
						return_id VARCHAR(20) PRIMARY KEY,
                        issued_id VARCHAR(20),
                        return_book_name VARCHAR(30),
                        return_date DATE,
                        return_book_isbn VARCHAR(20)
);
														-- IMPORT DATA  IN GIVEN TABLES FROM CSV FILES.
                                                        
                                                        
# List of SQL Queries to Solve in the Library Management System
-- Basic CRUD Queries:
	-- Insert a new book into the books table.
	-- Update a member's address in the members table.
	-- Delete a record from the issued_status table.
	-- Retrieve all books issued by a specific employee.
-- Advanced Queries:
	-- List members who have issued more than one book (using GROUP BY).
	-- Retrieve all books in a specific category (e.g., "Classic").
	-- Compute total rental income grouped by book category.
	-- Find members who registered in the last 180 days.
	-- List employees with their branch manager’s name and details (using JOIN).
-- CTAS (Create Table As Select) Queries:
	-- Create a table of books with a rental price above a certain threshold (e.g., $7.00).
	-- Retrieve the list of books that have not been returned.
	-- Create a table of active members who issued at least one book in the last two months.
	-- Identify overdue books and calculate fines.
-- Stored Procedures & Functions:
	-- Identify members with overdue books (overdue beyond 30 days).
	-- Implement a stored procedure to update book status when returned.
	-- Generate a branch performance report, including books issued, returned, and revenue.
	-- Identify the top 3 employees who processed the most book issues.
	-- Find members who issued books marked as "damaged" multiple times.
	-- Implement a stored procedure to check book availability and update status when issued.

-- Basic CRUD Queries:
	-- Insert a new book into the books table.
		INSERT INTO books VALUES('978-0-7432-7356-5', '1984', 'Dystopian', 6.75, 'no', 'George Orwell', 'Signet Classics');
    
	-- Update a member's address in the members table.
		UPDATE members 
		SET member_address = 'JAIN COLONY PART-1'
		WHERE member_id = 'C107';
    
	-- Delete a record from the issued_status table.
		DELETE FROM issued_status WHERE issued_id = 'IS114';
    
	-- Retrieve all books issued by a specific employee.
		SELECT issued_book_name FROM issued_status WHERE issued_emp_id = 'E108';
    
-- Advanced Queries:
	-- List members who have issued more than one book (using GROUP BY).
		SELECT issued_member_id FROM issued_status  GROUP BY issued_member_id HAVING COUNT(issued_book_name)>1;
        
	-- Retrieve all books in a specific category (e.g., "Classic").
		SELECT book_title FROM books WHERE category='classic';
        
	-- Compute total rental income grouped by book category.
		SELECT category,SUM(rental_price) FROM books GROUP BY category;
        
	-- Find members who registered in the last 180 days.
		SELECT member_id , member_name FROM members WHERE reg_date >= (CURDATE() - INTERVAL 180 DAY);
        
	-- List employees with their branch manager’s name and details.
		SELECT emp_id,emp_name,employees.branch_id,manager_id FROM employees INNER JOIN branch ON  employees.branch_id = branch.branch_id  ;
	
-- CTAS (Create Table As Select) Queries:
	-- Create a table of books with a rental price above a certain threshold (e.g., $7.00).
		CREATE TABLE BOOKS_WITH_HIGH_RENT AS 
			SELECT * FROM books WHERE rental_price > 7;
            
	-- Retrieve the list of books that have not been returned.
		SELECT * FROM issued_status LEFT JOIN return_state ON issued_status.issued_id = return_state.issued_id WHERE  return_state.issued_id IS NULL;
        
	-- Create a table of active members who issued at least one book in the last 10 MONTH.
		SELECT 	DISTINCT member_id,member_name FROM members INNER JOIN issued_status ON members.member_id = issued_status.issued_member_id WHERE issued_date > CURDATE() - INTERVAL 10 MONTH ;
    
        
-- Stored Procedures & Functions:
	-- Identify members with overdue books (overdue beyond 90 days).
		SELECT issued_member_id FROM issued_status WHERE issued_date < CURDATE() - INTERVAL 90 DAY;
        
	-- Implement a stored procedure to update book status when returned.
		DELIMITER $$
        CREATE PROCEDURE RETURN_STATUS( IN ISSUED_ID VARCHAR(12) , OUT ISRETURNED BOOL)
        BEGIN 
			IF EXISTS (SELECT 1 FROM return_state WHERE issued_id = ISSUED_ID) THEN
				SET ISRETURNED = TRUE;
			ELSE SET ISRETURNED = FALSE;
            END IF;
		END $$
        DELIMITER ;
        
	-- Generate a branch performance report, including books issued, returned, and revenue.
		CREATE TABLE A AS SELECT BRANCH.BRANCH_ID, 
								BRANCH.BRANCH_ADDRESS,
								EMPLOYEES.EMP_ID
		FROM  BRANCH LEFT JOIN EMPLOYEES ON BRANCH.BRANCH_ID = EMPLOYEES.BRANCH_ID;
        CREATE TABLE B AS SELECT * FROM A JOIN ISSUED_STATUS ON A.EMP_ID = ISSUED_STATUS.ISSUED_EMP_ID;
        CREATE TABLE C AS SELECT * FROM B JOIN BOOKS ON B.ISSUED_BOOK_ISBN = BOOKS.ISBN;
        CREATE TABLE D AS SELECT RETURN_STATE.RETURN_ID,
								BRANCH_ID,
								BRANCH_ADDRESS,
								EMP_ID,
								RETURN_STATE.issued_id,
								issued_member_id,
								issued_book_name,
								issued_date,
								issued_book_isbn,
								issued_emp_id,
								isbn,
								book_title,
								category,
								rental_price,
								status_,
								author,
								publisher FROM C JOIN RETURN_STATE ON RETURN_STATE.ISSUED_ID = C.ISSUED_ID;
        
        CREATE TABLE BRANCH_REPORT AS SELECT BRANCH_ID , COUNT(ISSUED_BOOK_ISBN)AS ISSUED_BOOK,COUNT(RETURN_ID)  AS RETURNED_BOOKS, SUM(RENTAL_PRICE) AS REVENUE FROM D GROUP BY BRANCH_ID ;
        SELECT * FROM BRANCH_REPORT;
        DROP TABLE A ; 
        DROP TABLE B; 
        DROP TABLE C; 
        DROP TABLE D;

	-- Identify the top 3 employees who processed the most book issues.
		SELECT issued_emp_id,COUNT(issued_id) AS NO_OF_ISSUED_BOOKS FROM issued_status GROUP BY issued_emp_id  ORDER BY COUNT(issued_id) DESC LIMIT 3;
		
	-- Implement a stored procedure to check book availability and update status when issued.
		CREATE TABLE overdue_books_fines AS
		SELECT 
			issued_status.issued_member_id, 
			issued_status.issued_book_name, 
			DATEDIFF(CURDATE(), issued_status.issued_date) AS overdue_days,
			DATEDIFF(CURDATE(), issued_status.issued_date) * 1.00 AS fine_amount
		FROM issued_status JOIN return_state ON issued_status.issued_id = return_state.issued_id
		WHERE return_state.issued_id IS NULL
		AND DATEDIFF(CURDATE(), issued_status.issued_date) > 30;

