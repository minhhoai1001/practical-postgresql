# BASIC MATH AND STATS WITH SQL
## Math Operators
**Table 5-1**: Basic Math Operators
|Operator|Description|
|--------|-----------|
| + |Addition|
| - |Subtraction|
|* |Multiplication|
| /| Division (returns the quotient only, no remainder)|
| % |Modulo (returns just the remainder)|
| ^ |Exponentiation|
| \|/ | Square root |
 \|\|/ |Cube root |
|! |Factorial|

### Math and Data Types
In calculations with an operator between two numbers—addition, subtraction, multiplication, and division—the data type returned follows this pattern: 
- Two integers return an *integer*. 
- A *numeric* on either side of the operator returns a *numeric*. 
- Anything with a floating-point number returns a floating-point number of type *double precision*.

### Adding, Subtracting, and Multiplying
```
SELECT 2 + 2; 
SELECT 9 - 1;
SELECT 3 * 4;
```
But because we’re not querying a table and specifying a column, the results appear beneath a `?column?` name, signifying an unknown column:
```
?column? 
--------
       4
```

### Division and Modulo
Division with SQL gets a little trickier because of the difference between math with integers and math with decimals, which was mentioned earlier. Add in modulo, an operator that returns just the remainder in a division operation, and the results can be confusing.

```
SELECT 11 / 6; 
SELECT 11 % 6; 
SELECT 11.0 / 6; 
SELECT CAST (11 AS numeric(3,1)) / 6;
```

If you want to divide two numbers and have the result return as a ``numeric` type, you can do so in two ways: first, if one or both of the numbers is a `numeric`, the result will by default be expressed as a `numeric`. Second, if you’re working with data stored only as integers and need to force decimal division, you can `CAST` one of the integers to a `numeric` type.

### Exponents, Roots, and Factorials
Beyond the basics, PostgreSQL-flavored SQL also provides operators to square, cube, or otherwise raise a base number to an exponent, as well as find roots or the factorial of a number.
```
SELECT 3 ^ 4;
SELECT |/ 10; 
SELECT sqrt(10);
SELECT ||/ 10;
SELECT 4 !;
```

### Minding the Order of Operations
1. Exponents and roots 
2. Multiplication, division, modulo 
3. Addition and subtraction

```
SELECT 7 + 8 * 9;       -- result: 79
SELECT (7 + 8) * 9;     -- result: 135
```

## Doing Math Across Census Table Columns
Let’s try to use the most frequently used SQL math operators on real data by digging into the 2010 Decennial Census population table, `us_counties_2010`.
### Adding and Subtracting Columns
```
SELECT 
    NAME, 
    STUSAB AS "st", 
    p0010003 AS "White Alone", 
    p0010004 AS "Black Alone", 
    p0010003 + p0010004 AS "Total White and Black" 
FROM us_counties_2010
LIMIT 5;
```
Run the query to see the results. The first few rows should resemble this output:
```
      name      | st | White Alone | Black Alone | Total White and Black 
----------------+----+-------------+-------------+-----------------------
 Autauga County | AL |       42855 |        9643 |                 52498
 Baldwin County | AL |      156153 |       17105 |                173258
 Barbour County | AL |       13180 |       12875 |                 26055
 Bibb County    | AL |       17381 |        5047 |                 22428
 Blount County  | AL |       53068 |         761 |                 53829
```

### Finding Percentages of the Whole
Let’s dig deeper into the census data to find meaningful differences in the population demographics of the counties. One way to do this (with any data set, in fact) is to calculate what percentage of the whole a particular variable represents. With the census data, we can learn a lot by comparing percentages from county to county and also by examining how percentages vary over time.
```
SELECT 
    NAME, 
    STUSAB AS "st", 
    (CAST (p0010006 AS numeric(8,1)) / p0010001) * 100 AS "pct_asian" 
FROM us_counties_2010 
ORDER BY "pct_asian" DESC LIMIT 5;
```
By sorting from highest to lowest percentage, the top of the output is as follows:
```
          name          | st |        pct_asian        
------------------------+----+-------------------------
 Honolulu County        | HI | 43.89497769109962474000
 Aleutians East Borough | AK | 35.97580388411333970100
 San Francisco County   | CA | 33.27165361664607226500
 Santa Clara County     | CA | 32.02237037519322063600
 Kauai County           | HI | 31.32461880132953749400
```

### Tracking Percent Change
```
CREATE TABLE percent_change ( 
    department varchar(20), 
    spend_2014 numeric(10,2), 
    spend_2017 numeric(10,2) ); 

INSERT INTO percent_change 
VALUES
    ('Building', 250000, 289000), 
    ('Assessor', 178556, 179500), 
    ('Library', 87777, 90001), 
    ('Clerk', 451980, 650000), 
    ('Police', 250000, 223000), 
    ('Recreation', 199000, 195000); 
    
SELECT 
    department, 
    spend_2014, 
    spend_2017, 
    round( (spend_2017 - spend_2014) / spend_2014 * 100, 1) AS "pct_change" 
FROM percent_change;
```

## Aggregate Functions for Averages and Sums
So far, we’ve performed math operations across columns in each row of a table. SQL also lets you calculate a result from values within the same column using *aggregate functions*.

```
SELECT sum(p0010001) AS "County Sum", 
    round(avg(p0010001), 0) AS "County Average" 
FROM us_counties_2010;
```
This calculation produces the following result:
```
 County Sum | County Average 
------------+----------------
  308745538 |          98233
```

## Finding the Median 
The *median* value in a set of numbers is as important an indicator, if not more so, than the average. Here’s the difference between median and average, and why median matters: 
- Average The sum of all the values divided by the number of values 
- Median The “middle” value in an ordered set of values

### Finding the Median with Percentile Functions
The `percentile_cont(n)` function calculates percentiles as continuous values. That is, the result does not have to be one of the numbers in the data set but can be a decimal value in between two of the numbers. This follows the methodology for calculating medians on an even number of values, where the median is the average of the two middle numbers. On the other hand, `percentile_disc(n)` returns only discrete values. That is, the result returned will be rounded to one of the numbers in the set.

```
CREATE TABLE percentile_test ( numbers integer );

INSERT INTO percentile_test (numbers) VALUES 
    (1), (2), (3), (4), (5), (6);

SELECT 
    percentile_cont(.5) WITHIN GROUP (ORDER BY numbers), 
    percentile_disc(.5) WITHIN GROUP (ORDER BY numbers) 
FROM percentile_test;
```
Running the code returns the following:
```
 percentile_cont | percentile_disc 
-----------------+-----------------
             3.5 |               3
```
The `percentile_cont()` function returned what we’d expect the **median** to be: `3.5`. But because `percentile_disc()` calculates discrete values, it reports `3`, the last value in the first 50 percent of the numbers. Because the accepted method of calculating medians is to average the two middle values in an even-numbered set, use `percentile_cont(.5)` to find a median.

### Median and Percentiles with Census Data
```
SELECT 
    sum(p0010001) AS "County Sum", 
    round(avg(p0010001), 0) AS "County Average", 
    percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001) AS "County Median" 
FROM us_counties_2010;
```
Your result should equal the following:
```
 County Sum | County Average | County Median 
------------+----------------+---------------
  308745538 |          98233 |         25857
```

### Finding Other Quantiles with Percentile Functions
You can also slice data into smaller equal groups. Most common are *quartile*s (four equal groups), *quintiles* (five groups), and *deciles* (10 groups). To find any individual value, you can just plug it into a percentile function.
```
SELECT 
    percentile_cont(array[.25,.5,.75]) WITHIN GROUP (ORDER BY p0010001) AS "quartiles" 
FROM us_counties_2010;
```
Run the query, and you should see this output:
```
       quartiles       
-----------------------
 {11104.5,25857,66699}
```

A handy function for working with the result returned is `unnest()`, which makes the array easier to read by turning it into rows.
```
SELECT 
    unnest(percentile_cont(array[.25,.5,.75]) 
    WITHIN GROUP (ORDER BY p0010001) ) AS "quartiles" 
FROM us_counties_2010;
```
Now the output should be in rows:
```
 quartiles 
-----------
   11104.5
     25857
     66699
```
### Creating a median() Function
Although PostgreSQL does not have a built-in median() aggregate function, but we can create one.
```
CREATE OR REPLACE FUNCTION _final_median(anyarray) 
    RETURNS float8 AS 
$$
    WITH q AS ( 
        SELECT val 
        FROM unnest($1) val 
        WHERE VAL IS NOT NULL 
        ORDER BY 1
        ),
        cnt AS ( 
            SELECT COUNT(*) AS c FROM q 
            )
        SELECT AVG(val)::float8 
        FROM ( 
            SELECT val FROM q 
            LIMIT 2 - MOD((SELECT c FROM cnt), 2) 
            OFFSET GREATEST(CEIL((SELECT c FROM cnt) / 2.0) - 1,0) 
            ) q2; 
$$
LANGUAGE sql IMMUTABLE; 

CREATE AGGREGATE median(anyelement) ( 
    SFUNC=array_append, 
    STYPE=anyarray, 
    FINALFUNC=_final_median, 
    INITCOND='{}' 
);
```

The code contains two main blocks: one to make a function called `_final_median` that sorts the values in the column and finds the midpoint, and a second that serves as the callable aggregate function `median()` and passes values to `_final_median`. For now, you can skip reviewing the script line by line and simply execute the code.
```
SELECT 
    sum(p0010001) AS "County Sum", 
    round(AVG(p0010001), 0) AS "County Average", 
    median(p0010001) AS "County Median", 
    percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001) AS "50th Percentile" 
FROM us_counties_2010;
```
The query results show that the median function and the percentile function return the same value:
```
 County Sum | County Average | County Median | 50th Percentile 
------------+----------------+---------------+-----------------
  308745538 |          98233 |         25857 |           25857
```

## Finding the Mode 
Additionally, we can find the `mode`, the value that appears most often, using the PostgreSQL `mode()` function. The function is not part of standard SQL and has a syntax similar to the percentile functions.
```
SELECT mode() WITHIN GROUP (ORDER BY p0010001) 
FROM us_counties_2010;

>> 
    mode  
    -------
    21720
```