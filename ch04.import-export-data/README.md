# IMPORTING AND EXPORTING DATA
If your data exists in a delimited text file (with one table row per line of text and each column value separated by a comma or other character) PostgreSQL can import the data in bulk via its `COPY` command. This command is a PostgreSQL-specific implementation with options for including or excluding columns and handling various delimited text types.

Three steps form the outline of most of the imports you’ll do:
1. Prep the source data in the form of a delimited text file. 
2. Create a table to store the data. 
3. Write a COPY script to perform the import.

## Handling Header Rows
Header rows serve a few purposes. For one, the values in the header row identify the data in each column, which is particularly useful when you’re deciphering a file’s contents. Second, some database managers (although not PostgreSQL) use the header row to map columns in the delimited file to the correct columns in the import table. Because PostgreSQL doesn’t use the header row, we don’t want that row imported to a table, so we’ll use a `HEADER` option in the `COPY` command to **exclude** it.

## Using COPY to Import Data 
To import data from an external file into our database, first we need to check out a source CSV file and build the table in PostgreSQL to hold the data. Thereafter, the SQL statement for the import is relatively simple. All you need are the three lines of code in Listing 4-1:
```
COPY table_name 
FROM 'C:\YourDirectory\your_file.csv' 
WITH (FORMAT CSV, HEADER);
```
- Input and output file format \
Use the `FORMAT format_name` option to specify the type of file you’re reading or writing. Format names are `CSV`, `TEXT`, or `BINARY`.
- Presence of a header row \
On import, use `HEADER` to specify that the source file has a header row.
- Delimiter \
The `DELIMITER 'character'` option lets you specify which character (`,`, `;`, `|`, ...) your import or export file uses as a delimiter.

## Importing Census Data Describing Counties
Every 10 years, the government conducts a full count of the population—one of several ongoing programs by the Census Bureau to collect demographic data. Each household in America receives a questionnaire about each person in it—their age, gender, race, and whether they are Hispanic or not.
### Creating the us_counties_2010 Table
```
$ sudo -u postgres psql                             # login user postgres
postgres=# \c analysis                              # connect analysis database
postgres=# \i create_table_us_counties_2010.sql     # run script create table
```

### Performing the Census Import with COPY
```
postgres=# \i import_table_us_counties_2010.sql
>> Query returned successfully: 3143 rows affected
```
Run the following query to show the counties with the largest `area_land` values. We’ll use a `LIMIT` clause, which will cause the query to only return the number of rows we want:
```
SELECT name, stusab, arealand
FROM us_counties_2010 
ORDER BY arealand 
DESC LIMIT 5;

>>            name            | stusab |   arealand   
>> ----------------------------+--------+-------------
>> Yukon-Koyukuk Census Area  | AK     | 376855656455
>> North Slope Borough        | AK     | 229720054439
>> Bethel Census Area         | AK     | 105075822708
>> Northwest Arctic Borough   | AK     |  92132564828
>> Valdez-Cordova Census Area | AK     |  88680877051
```

## Importing a Subset of Columns with COPY
If a CSV file doesn’t have data for all the columns in your target database table, you can still import the data you have by specifying which columns are present in the data. Consider this scenario: you’re researching the salaries of all town supervisors in your state so you can analyze government spending trends by geography. To get started, you create a table called supervisor_salaries with the code in Listing 4-4:
```
CREATE TABLE supervisor_salaries ( 
    town varchar(30), 
    county varchar(30), 
    supervisor varchar(30), 
    start_date date, 
    salary money, 
    benefits money 
);
```
You want columns for the town and county, the supervisor’s name, the date he or she started, and salary and benefits (assuming you just care about current levels). However, the first county clerk you contact says, “Sorry, we only have town, supervisor, and salary. You’ll need to get the rest from elsewhere.” You tell them to send a CSV anyway. You’ll import what you can.

You could try to import it using this basic COPY syntax:
```
COPY supervisor_salaries 
FROM 'C:\YourDirectory\supervisor_salaries.csv' 
WITH (FORMAT CSV, HEADER);
```

But if you do, PostgreSQL will return an error:
```
********** Error ********** 
ERROR: missing data for column "start_date" 
SQL state: 22P04 
Context: COPY supervisor_salaries, line 2: "Anytown,Jones,27000"
```

The database complains that when it got to the fourth column of the table, `start_date`, it couldn’t find any data in the CSV. The workaround for this situation is to tell the database which columns in the table are present in the CSV, as shown in Listing 4-5:

```
analysis=# \i import_table_supervisor_salaries.
analysis=# SELECT * FROM supervisor_salaries;

>>    town     | county | supervisor | start_date |   salary   | benefits 
>> -------------+--------+------------+------------+------------+----------
>> Anytown     |        | Jones      |            | $27,000.00 |         
>> Bumblyburg  |        | Baker      |            | $24,999.00 |         
>> Moetown     |        | Smith      |            | $32,100.00 |         
>> Bigville    |        | Kao        |            | $31,500.00 |         
>> New Brillig |        | Carroll    |            | $72,690.00 |  
```

## Adding a Default Value to a Column During Import
What if you want to populate the county column during the import, even though the value is missing from the CSV file? You can do so by using a **temporary table**. Temporary tables exist only until you end your database session. When you reopen the database (or lose your connection), those tables disappear. They’re handy for performing intermediary operations on data as part of your processing pipeline; we’ll use one to add a county name to the `supervisor_salaries` table as we import the CSV. 

Start by clearing the data you already imported into `supervisor_salaries` using a `DELETE` query:
```
DELETE FROM supervisor_salaries;
```
When that query finishes, run the code
```
CREATE TEMPORARY TABLE supervisor_salaries_temp (LIKE supervisor_salaries);

COPY supervisor_salaries_temp (town, supervisor, salary) 
FROM 'C:\YourDirectory\supervisor_salaries.csv' WITH (FORMAT CSV, HEADER);

INSERT INTO supervisor_salaries (town, county, supervisor, salary) 
SELECT town, 'Some County', supervisor, salary FROM supervisor_salaries_temp;

DROP TABLE supervisor_salaries_temp;
```

## Using COPY to Export Data 
The main difference between exporting and importing data with `COPY` is that rather than using `FROM` to identify the source data, you use `TO` for the path and name of the output file. You control how much data to export— an entire table, just a few columns, or to fine-tune it even more, the results of a query.

### Exporting All Data
I’ve used the `.txt` file extension here for two
reasons. First, it demonstrates that you can export to any text file format; second, we’re using a pipe for a delimiter, not a comma. I like to avoid calling files .csv unless they truly have commas as a separator.
```
COPY us_counties_2010 
TO '/home/hoaitran/dev/practical-sql/ch04.import-export-data/us_counties_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');
```

### Exporting Particular Columns
You don’t always need (or want) to export all your data: you might have sensitive information, such as Social Security numbers or birthdates, that need to remain private. Or, in the case of the census county data, maybe you’re working with a mapping program and only need the county name and its geographic coordinates to plot the locations. We can export only these three columns by listing them in parentheses after the table name, as shown in Listing 4-8. Of course, you must enter these column names precisely as they’re listed in the data for PostgreSQL to recognize them.

```
COPY us_counties_2010 (name, intptlat, intptlon) 
TO '/home/hoaitran/dev/practical-sql/ch04.import-export-data/us_counties_latlon_export.txt' 
WITH (FORMAT CSV, HEADER, DELIMITER '|');
```

### Exporting Query Results
Additionally, you can add a query to `COPY` to fine-tune your output. In Listing 4-9 we export the name and state abbreviation of only those counties whose name contains the letters `mill` in either uppercase or lowercase by using the case-insensitive `ILIKE` and the `%` wildcard character we covered in “Using `LIKE` and `ILIKE` with `WHERE`” on page 19.

```
COPY (
    SELECT name, stusab 
    FROM us_counties_2010 
    WHERE name ILIKE '%mill%'
) 
TO '/home/hoaitran/dev/practical-sql/ch04.import-export-data/us_counties_mill_export.txt' 
WITH (FORMAT CSV, HEADER, DELIMITER '|');
```