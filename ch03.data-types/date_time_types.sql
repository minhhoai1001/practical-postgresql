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
