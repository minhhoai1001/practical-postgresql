# JOINING TABLES IN A RELATIONAL DATABASE

## Linking Tables Using JOIN
To connect tables in a query, we use a `JOIN ... ON` statement (or one of the other `JOIN` variants I’ll cover in this chapter). The `JOIN` statement links one table to another in the database during a query, using matching values in columns we specify in both tables. The syntax takes this form:
```
SELECT * 
FROM table_a JOIN table_b 
ON table_a.key_column = table_b.foreign_key_column
```

When the query runs, it examines both tables and then returns columns from both tables where the values match in the columns specified in the `ON` clause.

## Relating Tables with Key Columns

Imagine you’re a data analyst with the task of checking on a public agency’s payroll spending by department. You file a Freedom of Information Act request for that agency’s salary data, expecting to receive a simple spreadsheet listing each employee and their salary, arranged like this:
```
dept location first_name last_name salary 
---- -------- ---------- --------- ------ 
Tax  Atlanta  Nancy      Jones     62500 
Tax  Atlanta  Smith      Lee       59300 
IT   Boston   Soo        Nguyen    83000 
IT   Boston   Janet      King      95000
```
But that’s not what arrives. Instead, the agency sends you a data dump from its payroll system: a dozen CSV files, each representing one table in its database. You read the document explaining the data layout (be sure to always ask for it!) and start to make sense of the columns in each table.

Two of the tables stand out: one named `employees` and another named `departments`.

The two tables follow relational model in that each describes attributes about a single entity, in this case the agency’s departments and employees. In the departments table, you should see the following contents:
```
dept_id dept city 
------- ---- ------- 
    1   Tax  Atlanta
    2   IT   Boston
```
The `dept_id` column is the table’s primary key. A primary key is a column or collection of columns whose values uniquely identify each row in a table. A valid primary key column enforces certain constraints:  
- The column or collection of columns must have a unique value for each row. 
- The column or collection of columns can’t have missing values.

The employees table should have the following contents: 
```
emp_id first_name last_name salary dept_id 
------ ---------- --------- ------ ------- 
    1   Nancy       Jones   62500   1 
    2   Lee         Smith   59300   1
    3   Soo         Nguyen  83000   2 
    4   Janet       King    95000   2
```
The `emp_id` column uniquely identifies each row in the `employees` table. For you to know which department each employee works in, the table includes a `dept_id` column. The values in this column refer to values in the `departments` table’s **primary key**. We call this a **foreign key**, which you add as a constraint  when creating the table. A foreign key constraint requires a value entered in a column to already exist in the primary key of the table it references. So, values in `dept_id` in the `employees` table must exist in `dept_id` in the `departments` table; otherwise, you can’t add them. Unlike a primary key, a foreign key column can be empty, and it can contain duplicate values.

Both tables also include a `UNIQUE` constraint. In ``departments`, it requires that each row have a unique pair of values for `dept` and `city` . In `employees`, each row must have a unique pair of `emp_id` and `dept_id` . You add these constraints to avoid duplicate data.

## Querying Multiple Tables Using JOIN
When you join tables in a query, the database connects rows in both tables where the columns you specified for the join have matching values. The query results then include columns from both tables if you requested them as part of the query. You also can use columns from the joined tables to filter results using a `WHERE` clause. Queries that join tables are similar in syntax to basic SELECT statements. The difference is that the query also specifies the following: 
- The tables and columns to join, using a SQL `JOIN ... ON` statement 
- The type of join to perform using variations of the `JOIN` keyword

```
SELECT * 
FROM employees JOIN departments
ON employees.dept_id = departments.dept_id;
```
When you run the query, the results include all values from both tables where values in the `dept_id` columns match. In fact, even the dept_id field appears twice because you selected all columns of both tables:
```
 emp_id | first_name | last_name | salary | dept_id | dept_id | dept |  city   
--------+------------+-----------+--------+---------+---------+------+---------
      1 | Nancy      | Jones     |  62500 |       1 |       1 | Tax  | Atlanta
      2 | Lee        | Smith     |  59300 |       1 |       1 | Tax  | Atlanta
      3 | Soo        | Nguyen    |  83000 |       2 |       2 | IT   | Boston
      4 | Janet      | King      |  95000 |       2 |       2 | IT   | Boston
```
## JOIN Types
There’s more than one way to join tables in SQL, and the type of join you’ll use depends on how you want to retrieve data.
- `JOIN` Returns rows from both tables where matching values are found in the joined columns of both tables. Alternate syntax is `INNER JOIN`. 
- `LEFT JOIN` Returns every row from the left table plus rows that match values in the joined column from the right table. When a left table row doesn’t have a match in the right table, the result shows no values from the right table. 
- `RIGHT JOIN` Returns every row from the right table plus rows that match the key values in the key column from the left table. When a right table row doesn’t have a match in the left table, the result shows no values from the left table.
- `FULL OUTER JOIN` Returns every row from both tables and matches rows; then joins the rows where values in the joined columns match. If there’s no match for a value in either the left or right table, the query result contains an empty row for the other table. 
- `CROSS JOIN` Returns every possible combination of rows from both tables.

You have two simple tables that hold names of schools. To better visualize join types, let’s call the tables `schools_left` and `schools_right`.
```
id left_school 
-- ------------------------ 
1   Oak Street School 
2   Roosevelt High School 
5   Washington Middle School 
6   Jefferson High School
```

```
id right_school
-- --------------------- 
1   Oak Street School 
2   Roosevelt High School 
3   Morrison Elementary 
4   Chase Magnet Academy 6 Jefferson High School
```

### JOIN
We use `JOIN`, or `INNER JOIN`, when we want to return rows that have a match in the columns we used for the join.
```
SELECT *
FROM schools_left JOIN schools_right
ON schools_left.id = schools_right.id;
```
```
 id |      left_school      | id |     right_school      
----+-----------------------+----+-----------------------
  1 | Oak Street School     |  1 | Oak Street School
  2 | Roosevelt High School |  2 | Roosevelt High School
  6 | Jefferson High School |  6 | Jefferson High School
```

### LEFT JOIN and RIGHT JOIN
In contrast to `JOIN`, the `LEFT JOIN` and `RIGHT JOIN` keywords each return all rows from one table and display blank rows from the other table if no matching values are found in the joined columns. Let’s look at `LEFT JOIN` in action first.

```
SELECT *
FROM schools_left LEFT JOIN schools_right
ON schools_left.id = schools_right.id;
```
```
 id |       left_school        | id |     right_school      
----+--------------------------+----+-----------------------
  1 | Oak Street School        |  1 | Oak Street School
  2 | Roosevelt High School    |  2 | Roosevelt High School
  5 | Washington Middle School |    | 
  6 | Jefferson High School    |  6 | Jefferson High School
```
Because `schools_right` doesn’t contain a value of `5` in its `right_id` column, there’s no match, so `LEFT JOIN` shows an empty row on the right rather than omitting the entire row from the left table as with `JOIN`.

We see similar but opposite behavior by running `RIGHT JOIN`
```
SELECT *
FROM schools_left RIGHT JOIN schools_right
ON schools_left.id = schools_right.id;
```
```
 id |      left_school      | id |     right_school      
----+-----------------------+----+-----------------------
  1 | Oak Street School     |  1 | Oak Street School
  2 | Roosevelt High School |  2 | Roosevelt High School
    |                       |  3 | Morrison Elementary
    |                       |  4 | Chase Magnet Academy
  6 | Jefferson High School |  6 | Jefferson High Schoo
```

You’d use either of these join types in a few circumstances: 
- You want your query results to contain all the rows from one of the tables. 
- You want to look for missing values in one of the tables; for example, when you’re comparing data about an entity representing two different time periods. 
- When you know some rows in a joined table won’t have matching values.

### FULL OUTER JOIN
When you want to see all rows from both tables in a join, regardless of whether any match, use the `FULL OUTER JOIN` option. To see it in action, run
```
SELECT *
FROM schools_left FULL OUTER JOIN schools_right
ON schools_left.id = schools_right.id;
```
```
 id |       left_school        | id |     right_school      
----+--------------------------+----+-----------------------
  1 | Oak Street School        |  1 | Oak Street School
  2 | Roosevelt High School    |  2 | Roosevelt High School
  5 | Washington Middle School |    | 
  6 | Jefferson High School    |  6 | Jefferson High School
    |                          |  4 | Chase Magnet Academy
    |                          |  3 | Morrison Elementary
```

### CROSS JOIN
In a `CROSS JOIN` query, the result (also known as a Cartesian product) lines up each row in the left table with each row in the right table to present all possible combinations of rows.
```
SELECT * 
FROM schools_left CROSS JOIN schools_right;
```

```
 id |       left_school        | id |     right_school      
----+--------------------------+----+-----------------------
  1 | Oak Street School        |  1 | Oak Street School
  1 | Oak Street School        |  2 | Roosevelt High School
  1 | Oak Street School        |  3 | Morrison Elementary
  1 | Oak Street School        |  4 | Chase Magnet Academy
  1 | Oak Street School        |  6 | Jefferson High School
  2 | Roosevelt High School    |  1 | Oak Street School
  2 | Roosevelt High School    |  2 | Roosevelt High School
  2 | Roosevelt High School    |  3 | Morrison Elementary
  2 | Roosevelt High School    |  4 | Chase Magnet Academy
  2 | Roosevelt High School    |  6 | Jefferson High School
  5 | Washington Middle School |  1 | Oak Street School
  5 | Washington Middle School |  2 | Roosevelt High School
  5 | Washington Middle School |  3 | Morrison Elementary
  5 | Washington Middle School |  4 | Chase Magnet Academy
  5 | Washington Middle School |  6 | Jefferson High School
  6 | Jefferson High School    |  1 | Oak Street School
  6 | Jefferson High School    |  2 | Roosevelt High School
  6 | Jefferson High School    |  3 | Morrison Elementary
  6 | Jefferson High School    |  4 | Chase Magnet Academy
  6 | Jefferson High School    |  6 | Jefferson High School
```
Unless you want to take an extra-long coffee break, I’d suggest avoiding a `CROSS JOIN` query on **large tables**.

## Using NULL to Find Rows with Missing Values
In SQL, `NULL` is a special value that represents a condition in which there’s no data present or where the data is unknown because it wasn’t included.

When a SQL join returns empty rows in one of the tables, those columns don’t come back empty but instead come back with the value `NULL`.

```
SELECT * FROM schools_left LEFT JOIN schools_right ON schools_left.id = schools_right.id WHERE schools_right.id IS NULL;
```

```
 id |       left_school        | id | right_school 
----+--------------------------+----+--------------
  5 | Washington Middle School |    | 
```

## Three Types of Table Relationships
### One-to-One Relationship
In our JOIN example in **JOIN**, there is only one match for an `id` in each of the two tables. In addition, there are no duplicate `id` values in either table: only one row in the left table exists with an `id` of `1`, and only one row in the right table has an `id` of `1`. In database parlance, this is called a **one-to-one** relationship.

### One-to-Many Relationship
In a **one-to-many** relationship, a key value in the first table will have multiple matching values in the second table’s joined column. Consider a database that tracks automobiles. One table would hold data on automobile manufacturers, with one row each for Ford, Honda, Kia, and so on. A second table with model names, such as Focus, Civic, Sedona, and Accord, would have several rows matching each row in the manufacturers’ table.

### Many-to-Many Relationship
In a **many-to-many** relationship, multiple rows in the first table will have multiple matching rows in the second table. As an example, a table of baseball players could be joined to a table of field positions. Each player can be assigned to multiple positions, and each position can be played by multiple people.

## Selecting Specific Columns in a Join
As you learned in single-table queries, to select particular columns you use the `SELECT` keyword followed by the desired column names. When joining tables, the syntax changes slightly: you must include the column as well as its table name. The reason is that more than one table can contain columns with the same name, which is certainly true of our joined tables so far.

To fix `id` appears two time, we need to add the table name in front of each column we’re querying, as we do in the `ON` clause.
```
SELECT 
    school_left.id, 
    schools_left.left_school
    schools_right.right_school
FROM schools_left LEFT JONT schools_right
ON schools_left.id = schools_right.id;
```

```
 id |       left_school        |     right_school      
----+--------------------------+-----------------------
  1 | Oak Street School        | Oak Street School
  2 | Roosevelt High School    | Roosevelt High School
  5 | Washington Middle School | 
  6 | Jefferson High School    | Jefferson High School
```

## Simplifying JOIN Syntax with Table Aliases
To create a table alias, we place a character or two after the table name when we declare it in the `FROM` clause. Those characters then serve as an alias we can use instead of the full table name anywhere we reference the table in the code:
```
SELECT  lt.id,
        lt.left_school,
        rt.right_school
FROM schools_left AS lt LEFT JOIN schools_right AS rt
ON lt.id = rt.id;
```

## Joining Multiple Tables
Let’s say we obtain two more school-related tables and want to join them to schools_left in a three-table join. Here are the tables: `schools_enrollment` has the number of students per school: 
```
id enrollment 
-- ---------- 
1   360 
2   1001 
5   450 
6   927
```
 
The `schools_grades` table contains the grade levels housed in each building: 
```
id grades 
-- ------ 
1   K-3 
2   9-12 
5   6-8 
6   9-12
```

```
 id |       left_school        | enrollment | grades 
----+--------------------------+------------+--------
  1 | Oak Street School        |        360 | K-3
  2 | Roosevelt High School    |       1001 | 9-12
  5 | Washington Middle School |        450 | 6-8
  6 | Jefferson High School    |        927 | 9-12
```

## Performing Math on Joined Table Columns
That’s certainly what I and many journalists do each time a new set of census data is released. We’ll load the new data and try to find patterns in the growth or decline of the population, income, education, and other indicators. Let’s look at how to do this by revisiting the `us_counties_2010` table we created in Chapter 4 and loading similar county data from the previous Decennial Census, in 2000, to a new table.

```
analysis=# \i performing_math_join_census_table.sql
```
```
              name               | state | pop_2010 | pop_2000 | raw_change | pct_change 
---------------------------------+-------+----------+----------+------------+------------
 Kendall County                  | IL    |   114736 |    54544 |      60192 |      110.4
 Kendall County                  | IL    |   114736 |    54544 |      60192 |      110.4
 Kendall County                  | IL    |   114736 |    54544 |      60192 |      110.4
 Kendall County                  | IL    |   114736 |    54544 |      60192 |      110.4
 Kendall County                  | IL    |   114736 |    54544 |      60192 |      110.4
 Kendall County                  | IL    |   114736 |    54544 |      60192 |      110.4
```