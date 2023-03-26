COPY us_counties_2010
FROM '/home/hoaitran/dev/practical-sql/ch04.import-export-data/us_counties_2010.csv'
WITH (FORMAT CSV, HEADER);