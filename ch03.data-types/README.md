# UNDERSTANDING DATA TYPES
It’s important to understand data types because storing data in the appropriate format is fundamental to building usable databases and performing accurate analysis.

In a SQL database, each column in a table can hold one and only one data type, which is defined in the CREATE TABLE statement. You declare the data type after naming the column.

## Characters
Character string types are general-purpose types suitable for any combination of text, numbers, and symbols. Character types include:
- `char(n)`: A fixed-length column where the character length is specified by `n`. A column set at `char(20)` stores 20 characters per row regardless of how many characters you insert.
- `varchar(n)`: A variable-length column where the **maximum length** is specified by `n`. If you insert fewer characters than the maximum, PostgreSQL will not store extra spaces.
- `text`: A variable-length column of unlimited length.

## Numbers
### Integers
The SQL standard provides three integer types: `smallint`, ``integer`, and `bigint`. The difference between the three types is the maximum size of the numbers they can hold.

|Data type| Storage size |Range|
|---------|--------------|-----|
| smallint| 2 bytes| −32768 to +32767 |
|integer |4 bytes |−2147483648 to +2147483647 |
|bigint |8 bytes |−9223372036854775808 to +9223372036854775807|

### Auto-Incrementing Integers
When you add a column with a serial type, PostgreSQL will **auto-increment** the value in the column
each time you insert a row, starting with 1, up to the **maximum of each integer** type.
|Data type|Storage size|Range|
|---------|------------|-----|
| smallserial |2 bytes| 1 to 32767 |
|serial |4 bytes |1 to 2147483647 |
|bigserial| 8 bytes |1 to 9223372036854775807|

### Decimal Numbers
As opposed to integers, decimals represent a whole number plus a fraction of a whole number; the fraction is represented by digits following a decimal point.

**Fixed-Point Numbers** \
The fixed-point type, also called the *arbitrary precision* type, is *numeric(precision,scale)*. You give the argument *precision* as the maximum number of digits to the left and right of the decimal point, and the argument *scale* as the number of digits allowable on the right of the decimal point.

`numeric(5,2)` the database will always return two digits to the right of the decimal point, even if you don’t enter a number that contains two digits. For example, `1.47`, `1.00`, and `121.50`.

**Floating-Point Types** \
The two floating-point types are *real* and *double precision*. The difference between the two is how much data they store. The *real* type allows precision to six decimal digits, and *double precision* to 15 decimal points of precision.

**Using Fixed- and Floating-Point Types** \
To see how each of the three data types handles the same numbers, create a small table and insert a variety of test cases.
```
CREATE TABLE number_data_types ( 
    numeric_column numeric(20,5), 
    real_column real, 
    double_column double precision
); 

INSERT INTO number_data_types 
VALUES
    (.7, .7, .7), 
    (2.13579, 2.13579, 2.13579), 
    (2.1357987654, 2.1357987654, 2.1357987654); 

SELECT * FROM number_data_types;
```

```
 numeric_column | real_column | double_column 
----------------+-------------+---------------
        0.70000 |         0.7 |           0.7
        2.13579 |     2.13579 |       2.13579
        2.13580 |   2.1357987 |  2.1357987654
```

### Trouble with Floating-Point Math
```
SELECT 
    numeric_column * 10000000 AS "Fixed", 
    real_column * 10000000 AS "Float" 
FROM number_data_types
WHERE numeric_column = .7;

>>     Fixed     |      Float       
>> --------------+------------------
>> 7000000.00000 | 6999999.88079071
```
The reason floating-point math produces such errors is that the computer attempts to squeeze lots of information into a finite number of bits.

### Choosing Your Number Data Type 
For now, here are three guidelines to consider when you’re dealing with number data types: 
1. Use `integer` when possible. Unless your data uses decimals, stick with integer types. 
2. If you’re working with decimal data and need calculations to be exact (dealing with money, for example), choose `numeric` or its equivalent, `decimal`. Float types will save space, but the inexactness of floating- point math won’t pass muster in many applications. Use them only when exactness is not as important. 
3. Choose a big enough number type. Unless you’re designing a database to hold millions of rows, err on the side of bigger. When using `numeric` or `decimal`, set the precision large enough to accommodate the number of digits on both sides of the decimal point. With whole numbers, use `bigint` unless you’re absolutely sure column values will be constrained to fit into the smaller `integer` or `smallint` types.

# Dates and Times
PostgreSQL’s date and time support includes the four major data types.
|Data type|Storage size|Description Range|
|---------|------------|-----------------|
|timestamp| 8 bytes| Date and time 4713 BC to 294276 AD |
|date| 4 bytes |Date (no time) 4713 BC to 5874897 AD|
|time |8 bytes |Time (no date) 00:00:00 to 24:00:00 |
|interval |16 bytes |Time interval +/− 178,000,000 years|

- `timestamp` Records date and time, which are useful for a range of situations you might track: departures and arrivals of passenger flights, a schedule of Major League Baseball games, or incidents along a timeline. Typically, you’ll want to add the keywords with *time zone* to ensure that the time recorded for an event includes the time zone where it occurred. Otherwise, times recorded in various places around the globe become impossible to compare. The format *timestamp with time zone* is part of the SQL standard; with PostgreSQL you can specify the same data type using `timestamptz`.
- `date` Records just the date. 
- `time` Records just the time.
- `interval` Holds a value representing a unit of time expressed in the format quantity unit. It doesn’t record the start or end of a time period, only its length. Examples include 12 days or 8 hours.

Let’s focus on the `timestamp with time zone` and `interval` types.
```
CREATE TABLE date_time_types ( 
    timestamp_column timestamp with time zone, 
    interval_column interval 
);

INSERT INTO date_time_types 
VALUES
    ('2018-12-31 01:00 EST','2 days'), 
    ('2018-12-31 01:00 -8','1 month'), 
    ('2018-12-31 01:00 Australia/Melbourne','1 century'),
    (now(),'1 week'); 
 
SELECT * FROM date_time_types;

>>       timestamp_column        | interval_column 
>> -------------------------------+-----------------
>> 2018-12-31 13:00:00+07        | 2 days
>> 2018-12-31 16:00:00+07        | 1 mon
>> 2018-12-30 21:00:00+07        | 100 years
>> 2023-03-26 21:42:30.796886+07 | 7 days
```
For the first three rows, our insert for the `timestamp_column` uses the same date and time (December 31, 2018 at 1 AM) using the International Organization for Standardization (ISO) format for dates and times: `YYYY- MM-DD HH:MM:SS`.

In the second row, we set the time zone with the value `-8`. That represents the number of hours difference, or offset, from Coordinated Universal Time (UTC). Using a value of `-8` specifies a time zone eight hours behind UTC, which is the Pacific time zone in the United States and Canada.

## Using the interval Data Type in Calculations
To see how the `interval` data type works, we’ll use the date_time_types table we just created.
```
SELECT
    timestamp_column,
    interval_column, 
    timestamp_column - interval_column AS new_date 
FROM date_time_types;

>>        timestamp_column        | interval_column |           new_date            
>> ------------------------------+-----------------+-------------------------------
>> 2018-12-31 13:00:00+07        | 2 days          | 2018-12-29 13:00:00+07
>> 2018-12-31 16:00:00+07        | 1 mon           | 2018-11-30 16:00:00+07
>> 2018-12-30 21:00:00+07        | 100 years       | 1918-12-30 21:00:00+06:42:04
>> 2023-03-26 21:42:30.796886+07 | 7 days          | 2023-03-19 21:42:30.796886+07
```

Note that the `new_date` column by default is formatted as type `timestamp with time zone`.

## Miscellaneous Types
The character, number, and date/time types you’ve learned so far will likely comprise the bulk of the work you do with SQL. But PostgreSQL supports many additional types, including but not limited to: 
- A Boolean type that stores a value of `true` or `false`
- Geometric types that include points, lines, circles, and other two- dimensional objects 
- Network address types, such as IP or MAC addresses 
- A Universally Unique Identifier (UUID) type, sometimes used as a unique key value in tables 
- XML and JSON data types that store information in those structured formats

## Transforming Values from One Type to Another with CAST
The `CAST()` function only succeeds when the target data type can accommodate the original value. Casting an integer as text is possible, because the character types can include numbers. Casting text with letters of the alphabet as a number is not.
```
SELECT timestamp_column, CAST(timestamp_column AS varchar(10)) FROM date_time_types;

SELECT numeric_column, CAST(numeric_column AS integer), CAST(numeric_column AS varchar(6)) FROM number_data_types; 

SELECT CAST(char_column AS integer) FROM char_data_types;
```
The first `SELECT` statement returns the `timestamp_column` value as a `varchar`, which you’ll recall is a variable-length character column. In this case, I’ve set the character length to 10, which means when converted to a character string, only the first 10 characters are kept.

The second `SELECT` statement returns the numeric_column three times: in its original form and then as an integer and as a character. Upon conversion to an integer, PostgreSQL rounds the value to a whole number. But with the varchar conversion, no rounding occurs: the value is simply sliced at the sixth character. 

The final `SELECT` **doesn’t work** : it returns an error of invalid input syntax for integer because letters can’t become integers!

## CAST Shortcut Notation
It’s always best to write SQL that can be read by another person who might pick it up later, and the way `CAST()` is written makes what you intended when you used it fairly obvious. However, PostgreSQL also offers a less-obvious shortcut notation that takes less space: the *double colon*. 

Insert the double colon in between the name of the column and the data type you want to convert it to. For example, these two statements cast timestamp_column as a varchar: 
```
SELECT timestamp_column, CAST(timestamp_column AS varchar(10)) 
FROM date_time_types; 

SELECT timestamp_column::varchar(10) 
FROM date_time_types;

>>       timestamp_column        | timestamp_column 
>> ------------------------------+------------------
>> 2018-12-31 13:00:00+07        | 2018-12-31
>> 2018-12-31 16:00:00+07        | 2018-12-31
>> 2018-12-30 21:00:00+07        | 2018-12-30
>> 2023-03-26 21:42:30.796886+07 | 2023-03-26
```