SELECT 
    NAME, 
    STUSAB AS "st",
    P0010001 AS "Totaal populaaation",
    P0010003 AS "White Alone",
    P0010004 AS "Black or African American Alone",
    P0010005 AS "Am Indian/Alaska Native Alone", 
    p0010006 AS "Asian Alone", 
    p0010007 AS "Native Hawaiian and Other Pacific Islander Alone", 
    p0010008 AS "Some Other Race Alone", 
    p0010009 AS "Two or More Races" 
FROM us_counties_2010
LIMIT 5;