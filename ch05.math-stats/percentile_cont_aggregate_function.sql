SELECT 
    sum(p0010001) AS "County Sum", round(avg(p0010001), 0) AS "County Average", 
    percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001) AS "County Median" 
FROM us_counties_2010;