COPY (
    SELECT name, stusab 
    FROM us_counties_2010 
    WHERE name ILIKE '%mill%'
) 
TO '/home/hoaitran/dev/practical-sql/ch04.import-export-data/us_counties_mill_export.txt' 
WITH (FORMAT CSV, HEADER, DELIMITER '|');