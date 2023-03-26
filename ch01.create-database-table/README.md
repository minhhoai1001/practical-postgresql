# CREATING YOUR FIRST DATABASE AND TABLE
A table is a grid of rows and columns that store data. Each row holds a collection of columns, and each column contains data of a specified type: most commonly, numbers, characters, and dates. We use SQL to define the structure of a table and how each table might relate to other tables in the database. We also use SQL to extract, or query, data from tables.

## Creating a Database
```
$ sudo -u postgres psql
postgres=# CREATE DATABASE analysis;
```
## Connecting to the Analysis Database
```
# list all databases
postgres=# \l
postgres=# \c anlysis
>> You are now connected to database "analysis" as user "postgres".
```

## Creating a Table
As I mentioned earlier, tables are where data lives and its relationships are defined. When you create a table, you assign a name to each *column* (sometimes referred to as a *field* or *attribute*) and assign it a *data type*.

Data stored in a table can be accessed and analyzed, or queried, with SQL statements. You can sort, edit, and view the data, and easily alter the table later if your needs change.

### The CREATE TABLE Statement
```
CREATE TABLE teachers ( 
    id bigserial, 
    first_name varchar(25), 
    last_name varchar(50), 
    school varchar(50), 
    hire_date date, 
    salary numeric
);
```
Run with script
```
postgres=# \i create_table_teacher.sql
```
## Inserting Rows into a Table
### The INSERT Statement 
To insert some data into the table, you first need to erase the `CREATE TABLE` statement you just ran.
```
INSERT INTO teachers (first_name, last_name, school, hire_date, salary)  
VALUES ('Janet', 'Smith', 'F.D. Roosevelt HS', '2011-10-30', 36200), 
    ('Lee', 'Reynolds', 'F.D. Roosevelt HS', '1993-05-22', 65000), 
    ('Samuel', 'Cole', 'Myers Middle School', '2005-08-01', 43500), 
    ('Samantha', 'Bush', 'Myers Middle School', '2011-10-30', 36200),
    ('Betty', 'Diaz', 'Myers Middle School', '2005-08-30', 43500), 
    ('Kathleen', 'Roush', 'F.D. Roosevelt HS', '2010-10-22', 38500);
```

### Viewing the Data
```
SELECT * FROM teachers;

>> id | first_name | last_name |       school        | hire_date  | salary 
>> ----+------------+-----------+---------------------+------------+-------
>>  1 | Janet      | Smith     | F.D. Roosevelt HS   | 2011-10-30 |  36200
>>  2 | Lee        | Reynolds  | F.D. Roosevelt HS   | 1993-05-22 |  65000
>>  3 | Samuel     | Cole      | Myers Middle School | 2005-08-01 |  43500
>>  4 | Samantha   | Bush      | Myers Middle School | 2011-10-30 |  36200
>>  5 | Betty      | Diaz      | Myers Middle School | 2005-08-30 |  43500
>>  6 | Kathleen   | Roush     | F.D. Roosevelt HS   | 2010-10-22 |  38500
```
## Formatting SQL for Readability
SQL requires no special formatting to run, so you’re free to use your own psychedelic style of uppercase, lowercase, and random indentations. But that won’t win you any friends when others need to work with your code (and sooner or later someone will). For the sake of readability and being a good coder, it’s best to follow these conventions: 
- Uppercase SQL keywords, such as `SELECT`. Some SQL coders also uppercase the names of data types, such as `TEXT` and `INTEGER`. I use lowercase characters for data types in this book to separate them in your mind from keywords, but you can uppercase them if desired. 
- Avoid camel case and instead use `lowercase_and_underscores` for object names, such as tables and column names (see more details about case in Chapter 7). 
- Indent clauses and code blocks for readability using either two or four spaces. Some coders prefer tabs to spaces; use whichever works best for you or your organization.