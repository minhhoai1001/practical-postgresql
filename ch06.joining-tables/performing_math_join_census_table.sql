CREATE TABLE us_counties_2000 ( 
    name varchar(90), 
    STUSAB varchar(2), 
    STATE varchar(2), 
    COUNTY varchar(3), 
    p0010001 integer, 
    p0010002 integer, 
    p0010003 integer, 
    p0010004 integer, 
    p0010005 integer, 
    p0010006 integer, 
    p0010007 integer, 
    p0010008 integer, 
    p0010009 integer, 
    p0010010 integer, 
    p0020002 integer, 
    p0020003 integer 
);

COPY us_counties_2000 
FROM '/home/hoaitran/dev/practical-sql/ch06.joining-tables/us_counties_2000.csv' 
WITH (FORMAT CSV, HEADER);


SELECT 
    c2010.name, 
    c2010.STUSAB AS state, 
    c2010.p0010001 AS pop_2010,
    c2000.p0010001 AS pop_2000,
    c2010.p0010001 - c2000.p0010001 AS raw_change,
    round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001) / c2000.p0010001 * 100, 1 ) AS pct_change 
FROM us_counties_2010 AS c2010 INNER JOIN us_counties_2000 AS c2000 
ON c2010.state = c2000.state 
    AND c2010.county = c2000.county
    AND c2010.p0010001 <> c2000.p0010001 
ORDER BY pct_change DESC;