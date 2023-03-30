SELECT 
    unnest(percentile_cont(array[.25,.5,.75]) 
    WITHIN GROUP (ORDER BY p0010001) ) AS "quartiles" 
FROM us_counties_2010;