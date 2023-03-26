# BEGINNING DATA EXPLORATION WITH SELECT
In SQL, interviewing data starts with the `SELECT` keyword, which retrieves rows and columns from one or more of the tables in a database. A SELECT statement can be simple, retrieving everything in a single table, or it can be complex enough to link dozens of tables while handling multiple calculations and filtering by exact criteria.

## Basic SELECT Syntax
```
SELECT * FROM my_table;
```
### Querying a Subset of Columns
You can do this by naming columns, separated by commas, right after the SELECT keyword. For example: 
```
SELECT some_column, another_column, amazing_column FROM table_name;
```
### Using DISTINCT to Find Unique Values
To understand the range of values in a column, we can use the `DISTINCT` keyword as part of a query that eliminates duplicates and shows only unique values.
```
SELECT DISTINCT school FROM teachers;

>>        school        
>> --------------------
>> Myers Middle School
>> F.D. Roosevelt HS
```
The DISTINCT keyword also works on more than one column at a time. If we add a column, the query returns each unique pair of values.
```
SELECT DISTINCT school, salary FROM teachers;
```

## Sorting Data with ORDER BY
In SQL, we order the results of a query using a clause containing the keywords `ORDER BY` followed by the name of the column or columns to sort.

```
SELECT first_name, last_name, salary 
FROM teachers 
ORDER BY salary DESC;
```
The ability to sort in our queries gives us great flexibility in how we view and present data.
```
SELECT last_name, school, hire_date 
FROM teachers 
ORDER BY school ASC, hire_date DESC;
```

## Filtering Rows with WHERE
The ``WHERE` keyword allows you to find rows that match a specific value, a range of values, or multiple values based on criteria supplied via an operator.
```
SELECT last_name, school, hire_date 
FROM teachers 
WHERE school = 'Myers Middle School';
```
**Table 2-1**: Comparison and Matching Operators in PostgreSQL

|Operator |Function |Example|
|---------|-------|-------|
|= |Equal to| WHERE school = 'Baker Middle'|
| <> or != |Not equal to* |WHERE school <> 'Baker Middle'| 
|> |Greater than |WHERE salary > 20000 |
|< |Less than |WHERE salary < 60500 |
|>= |Greater than or equal to |WHERE salary >= 20000 |
|<= |Less than or equal to |WHERE salary <= 60500 |
|BETWEEN |Within a range |WHERE salary BETWEEN 20000 AND 40000 |
|IN |Match one of a set of values |WHERE last_name IN ('Bush', 'Roush') |
|LIKE |Match a pattern (case sensitive) |WHERE first_name LIKE 'Sam%' |
|ILIKE |Match a pattern (case insensitive) |WHERE first_name ILIKE 'sam%' |
|NOT |Negates a condition |WHERE first_name NOT ILIKE 'sam%'|

* The `!=` operator is not part of standard ANSI SQL but is available in PostgreSQL and several other database systems.

### Using LIKE and ILIKE with WHERE
Comparison operators are fairly straightforward, but `LIKE` and `ILIKE` deserve additional explanation. First, both let you search for patterns in strings by using two special characters:
- **Percent sign (%)** A wildcard matching one or more characters 
- **Underscore (_)** A wildcard matching just one character

The difference? The `LIKE` operator, which is part of the ANSI SQL standard, is case sensitive. The `ILIKE` operator, which is a PostgreSQL- only implementation, is case insensitive.
```
analysis=# SELECT first_name FROM teachers WHERE first_name LIKE 'sam%';
>> (0 rows)

analysis=# analysis=# SELECT first_name FROM teachers WHERE first_name ILIKE 'sam%';
>>  first_name 
>> -----------
>> Samuel
>> Samantha
```

### Combining Operators with AND and OR
Comparison operators become even more useful when we combine them. To do this, we connect them using keywords `AND` and `OR` along with, if needed, parentheses.
```
SELECT * FROM teachers
WHERE school = 'Myers Middle School' AND salary < 40000; 

SELECT * FROM teachers 
WHERE last_name = 'Cole' OR last_name = 'Bush'; 

SELECT * FROM teachers 
WHERE school = 'F.D. Roosevelt HS' AND (salary < 38000 OR salary > 40000);
```