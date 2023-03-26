CREATE TEMPORARY TABLE supervisor_salaries_temp (LIKE supervisor_salaries);

COPY supervisor_salaries_temp (town, supervisor, salary) 
FROM '/home/hoaitran/dev/practical-sql/ch04.import-export-data/supervisor_salaries.csv' WITH (FORMAT CSV, HEADER);

INSERT INTO supervisor_salaries (town, county, supervisor, salary) 
SELECT town, 'Some County', supervisor, salary FROM supervisor_salaries_temp;

DROP TABLE supervisor_salaries_temp;