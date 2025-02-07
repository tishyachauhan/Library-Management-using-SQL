# Library-Management-using-SQL

## Project Overview
This project implements a comprehensive **Library Management System** using **SQL**. It includes database setup, CRUD operations, advanced queries, stored procedures, and CTAS (Create Table As Select) queries to efficiently manage books, members, employees, and library transactions.

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_db`
https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pinterest.com%2Fpin%2F333618284913118749%2F&psig=AOvVaw0HS8QH1R5C6ZTX8vOWYdI8&ust=1738997740344000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCOC-qsn9sIsDFQAAAAAdAAAAABAE
![Library_project](https://github.com/najirh/Library-System-Management---P2/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/najirh/Library-System-Management---P2/blob/main/library_erd.png)

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_db;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

```

## Tasks Implemented

### **CRUD Operations**
- **Create a New Book Record**: Insert a new book into the `books` table.
- **Update an Existing Member's Address**: Modify a member's address in the `members` table.
- **Delete a Record from the Issued Status Table**: Remove a record from `issued_status`.
- **Retrieve All Books Issued by a Specific Employee**: Select all books issued by a particular employee.

### **Advanced Queries**
- **List Members Who Have Issued More Than One Book**: Use `GROUP BY` to identify members who issued multiple books.
- **Retrieve All Books in a Specific Category**: Fetch all books in a given category (e.g., "Classic").
- **Find Total Rental Income by Category**: Compute total rental revenue grouped by book category.
- **List Members Who Registered in the Last 180 Days**: Find recently registered members based on `reg_date`.
- **List Employees with Their Branch Manager’s Name and Details**: Join `employees` and `branch` tables to show employees and their managers.

### **CTAS (Create Table As Select) Queries**
- **Create a Table of Books with Rental Price Above a Certain Threshold**: Store books with rental price > `$7.00`.
- **Retrieve the List of Books Not Yet Returned**: Identify books still issued and not returned.

### **Stored Procedures & Functions**
- **Identify Members with Overdue Books**: Find members with books overdue beyond `30 days`.
- **Update Book Status on Return**: Implement a stored procedure to update book status when returned.
- **Branch Performance Report**: Generate a summary report for branches, including books issued, returned, and revenue.
- **CTAS: Create a Table of Active Members**: Store members who issued at least one book in the last `2 months`.
- **Find Employees with the Most Book Issues Processed**: Identify the top `3 employees` who processed the most book issues.
- **Identify Members Issuing High-Risk Books**: Find members who issued books marked as "damaged" multiple times.
- **Stored Procedure to Manage Book Issuance**: Implement a stored procedure to check book availability and update status on issue.
- **CTAS: Identify Overdue Books & Calculate Fines**: Create a table storing members with overdue books and calculate fines.

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## 🔗 **Project Inspiration**
This project is inspired by **ZeroAnalyst**, whose structured approach to SQL and database management has influenced its development. Explore the original work on GitHub: [ZeroAnalyst's Library System Management](https://github.com/najirh/Library-System-Management---P2).



## 🛠 **Technologies Used**
- **SQL (MySQL / PostgreSQL / SQL Server)**
- **Database Management & Query Optimization**
- **Stored Procedures & Triggers**

## 📜 **License**
This project is open-source and available under the **MIT License**.


## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.
