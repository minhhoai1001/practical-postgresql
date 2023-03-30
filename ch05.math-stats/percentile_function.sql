CREATE TABLE percentile_test ( numbers integer );

INSERT INTO percentile_test (numbers) VALUES 
    (1), (2), (3), (4), (5), (6);

SELECT 
    percentile_cont(.5) WITHIN GROUP (ORDER BY numbers), 
    percentile_disc(.5) WITHIN GROUP (ORDER BY numbers) 
FROM percentile_test;