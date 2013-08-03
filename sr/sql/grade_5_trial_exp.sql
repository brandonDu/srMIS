SELECT s.name, c.name, g.grade 
    FROM course_grade as g
        INNER JOIN student as s ON g.stu_sn = s.sn
        INNER JOIN course as c  ON g.cou_sn = c.sn ;


SELECT s.name, c.name, g.grade
    FROM (student as s CROSS JOIN course as c) 
        LEFT JOIN course_grade as g 
            ON g.stu_sn = s.sn AND g.cou_sn = c.sn ;
    
UPDATE course_grade SET grade = 88 
    WHERE stu_sn =101 AND cou_sn = 102 ;


DELETE FROM student WHERE sn=101;


DELETE FROM course_grade WHERE stu_sn = 101;
DELETE FROM student WHERE sn = 101;

