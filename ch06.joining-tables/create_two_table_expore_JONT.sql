CREATE TABLE schools_left ( 
    id integer CONSTRAINT left_id_key PRIMARY KEY, 
    left_school varchar(30) 
);

CREATE TABLE schools_right ( 
    id integer CONSTRAINT right_id_key PRIMARY KEY, 
    right_school varchar(30) 
); 
    
INSERT INTO schools_left (id, left_school) 
VALUES 
    (1, 'Oak Street School'), 
    (2, 'Roosevelt High School'),
    (5, 'Washington Middle School'), 
    (6, 'Jefferson High School'); 
    
INSERT INTO schools_right (id, right_school) 
VALUES 
    (1, 'Oak Street School'), 
    (2, 'Roosevelt High School'), 
    (3, 'Morrison Elementary'), 
    (4, 'Chase Magnet Academy'), 
    (6, 'Jefferson High School');