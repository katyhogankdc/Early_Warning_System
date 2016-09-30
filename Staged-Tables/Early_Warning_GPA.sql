DROP TABLE CUSTOM.CUSTOM_EARLY_WARNING_GPA

CREATE TABLE CUSTOM.CUSTOM_EARLY_WARNING_GPA (
STUDENT_NUMBER INT,
TERMKEY INT,
GPA FLOAT(5),
LASTUPDATED DATETIME);

CREATE INDEX EW_GPA ON CUSTOM.CUSTOM_EARLY_WARNING_GPA (STUDENT_NUMBER,TERMKEY);

INSERT INTO CUSTOM.CUSTOM_EARLY_WARNING_GPA --(STUDENT_NUMBER,TERMKEY,GPA)

-------------------
--- IN PROGRESS ---
-------------------

Select 
  s.student_number AS STUDENT_NUMBER
--, LEFT(sc.termid,2) AS YEARID
, COALESCE(CAST(CAST(TC.ID AS VARCHAR) + CAST(S.SCHOOLID AS VARCHAR) AS INT),-1) AS TERMKEY
, SUM((c.credit_hours * gs.grade_points))/SUM(c.credit_hours) AS "GPA"
, GETDATE()

FROM [powerschool].[PowerSchool_STUDENTS] s 
LEFT JOIN [custom].[custom_StudentBridge] csb ON csb.student_number = s.student_number
LEFT JOIN [custom].[custom_Students] cs ON cs.systemstudentid = csb.systemstudentid
LEFT JOIN [powerschool].[PowerSchool_PGFINALGRADES] g ON g.studentid = s.id
LEFT JOIN [powerschool].[PowerSchool_SECTIONS] sc ON sc.id = g.sectionid  
LEFT JOIN [powerschool].[PowerSchool_COURSES] c ON c.course_number = sc.course_number
LEFT JOIN [powerschool].[PowerSchool_GRADESCALEITEM] gs ON gs.name = g.grade
LEFT JOIN CUSTOM.CUSTOM_TERM_CONVERSIONS TC ON TC.SCHOOLID = SC.SCHOOLID AND TC.FINALGRADENAME = G.FINALGRADENAME AND TC.YEARID = LEFT(SC.termid,2)


WHERE gs.gradescaleid = CASE sc.schoolid WHEN 1100 THEN c.gradescaleid ELSE (SELECT id FROM [powerschool].[PowerSchool_gradescaleitem] WHERE name = 'Default') END
AND s.enroll_status = 0
--AND LEFT(sc.termid,2) = 25
--AND g.finalgradename IN ('S1','A1','A2','A3','A4','T1','T2','R1','R2','R3','Y1')
AND g.grade != '--'
AND c.excludefromgpa = 0
AND GETDATE() BETWEEN G.STARTDATE AND G.ENDDATE -- ONLY GET GPAs FOR TERMS THAT INCLUDE THE CURRENT DATE 

GROUP BY
s.student_number,LEFT(sc.termid,2), TC.ID,S.SCHOOLID

HAVING SUM(c.credit_hours) > 0

UNION

-------------------
------ FINAL ------
-------------------

SELECT 
  s.student_number AS STUDENT_NUMBER
--  ,sg.schoolid
--, LEFT(se.termid,2) AS YEARID
, COALESCE(CAST(CAST(TC.ID AS VARCHAR) + CAST(SG.SCHOOLID AS VARCHAR) AS INT),-1) AS TERMKEY
, SUM(gs.grade_points * sg.potentialcrhrs)/SUM(sg.potentialcrhrs) AS "GPA"
, GETDATE()

    
FROM [PowerSchool].[PowerSchool_STUDENTS] s
LEFT JOIN [custom].[custom_StudentBridge] csb ON csb.student_number = s.student_number
LEFT JOIN [custom].[custom_Students] cs ON cs.systemstudentid = csb.systemstudentid
LEFT JOIN [PowerSchool].[PowerSchool_STOREDGRADES] sg ON sg.studentid = s.id
--LEFT JOIN [PowerSchool].[PowerSchool_SECTIONS] se ON se.id = sg.sectionid
LEFT JOIN [PowerSchool].[PowerSchool_COURSES] c ON c.course_number = sg.course_number 
LEFT JOIN [powerschool].[PowerSchool_GRADESCALEITEM] gs ON gs.name = sg.grade
LEFT JOIN CUSTOM.CUSTOM_TERM_CONVERSIONS TC ON TC.SCHOOLID = SG.SCHOOLID AND TC.FINALGRADENAME = SG.STORECODE AND TC.YEARID = LEFT(sg.termid,2)

WHERE gs.gradescaleid = CASE sg.schoolid WHEN 1100 THEN c.gradescaleid ELSE (SELECT id FROM [powerschool].[PowerSchool_gradescaleitem] WHERE name = 'Default') END
AND s.enroll_status = 0
--AND sg.storecode IN ('S1','A1','A2','A3','A4','T1','T2','R1','R2','R3','Y1')
AND sg.grade != '--'
AND sg.excludefromgpa = 0
--and sg.termid = 2502
--and sg.storecode = 'R1'    
GROUP BY
s.student_number, LEFT(sg.termid,2), TC.ID, SG.SCHOOLID

HAVING SUM(sg.potentialcrhrs) > 0
