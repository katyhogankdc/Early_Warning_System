IF OBJECT_ID('CUSTOM.CUSTOM_EARLY_WARNING_FP', 'U') IS NOT NULL
	DELETE FROM CUSTOM.CUSTOM_EARLY_WARNING_FP

ELSE
	CREATE TABLE CUSTOM.CUSTOM_EARLY_WARNING_FP (
	STUDENT_NUMBER INT,
	STUDENTID INT,
	STUDENTKEY INT,
	SYSTEMSTUDENTID VARCHAR(25),
	TERMKEY INT,
	[FP LEVEL] INT,
	[TARGET LEVEL] INT,
	LASTUPDATED DATETIME);

IF (SELECT OBJECT_ID
	FROM sys.indexes 
	WHERE name='EW_FP' AND object_id = OBJECT_ID('CUSTOM.CUSTOM_EARLY_WARNING_FP')) IS NULL
	CREATE INDEX EW_FP ON CUSTOM.CUSTOM_EARLY_WARNING_FP (STUDENT_NUMBER,TERMKEY);

INSERT INTO CUSTOM.CUSTOM_EARLY_WARNING_FP
SELECT
[POWERSCHOOL_STUDENTS].STUDENT_NUMBER,
[POWERSCHOOL_STUDENTS].ID,
[TEST SCORES].STUDENTKEY,
[STUDENT].SYSTEMSTUDENTID,
TERMKEY,
MAX(TESTSCORE) [FP LEVEL],
MAX([FP PROFICIENCY].[LEVEL]) [TARGET LEVEL],
GETDATE()
FROM [dw].[DW_factTestScores] [TEST SCORES]
INNER JOIN [dw].[DW_dimTest] [TEST] ON [TEST].TESTKEY = [TEST SCORES].TESTKEY
INNER JOIN [dw].[DW_dimTestProficiencyLevel] [PROFICIENCY] ON [PROFICIENCY].TESTPROFICIENCYLEVELKEY = [TEST SCORES].TESTPROFICIENCYLEVELKEY
INNER JOIN [dw].[DW_dimSchoolCalendar] [CALENDAR] ON [CALENDAR].SCHOOLCALENDARKEY = [TEST SCORES].SCHOOLCALENDARKEY
INNER JOIN [dw].[DW_dimSchool] [SCHOOL] ON [SCHOOL].SCHOOLKEY = [TEST SCORES].SCHOOLKEY
INNER JOIN [dw].[DW_dimStudent] [STUDENT] ON [STUDENT].STUDENTKEY = [TEST SCORES].STUDENTKEY
INNER JOIN [dw].[DW_dimStudentHistorical] [STUDENT HISTORICAL] ON [STUDENT HISTORICAL].STUDENTHISTORICALKEY = [TEST SCORES].STUDENTHISTORICALKEY
INNER JOIN [CUSTOM].[CUSTOM_STUDENTBRIDGE] [CUSTOM_STUDENTBRIDGE] ON ([STUDENT].[SYSTEMSTUDENTID] = [CUSTOM_STUDENTBRIDGE].[SYSTEMSTUDENTID])
INNER JOIN [POWERSCHOOL].[POWERSCHOOL_STUDENTS] [POWERSCHOOL_STUDENTS] ON ([CUSTOM_STUDENTBRIDGE].[STUDENT_NUMBER] = [POWERSCHOOL_STUDENTS].[STUDENT_NUMBER])
INNER JOIN POWERSCHOOL.POWERSCHOOL_SCHOOLS SCH ON SCH.ABBREVIATION = SCHOOL.SCHOOLNAME_ABBREVIATION
LEFT JOIN CUSTOM.CUSTOM_EARLY_WARNING_TERMS [TERMS] ON [CALENDAR].FULLDATE BETWEEN [TERMS].FIRSTDAY AND [TERMS].LASTDAY AND [TERMS].SCHOOLID = SCH.SCHOOL_NUMBER
INNER JOIN CUSTOM.[CUSTOM_EARLY_WARNING_F_AND_P_PROFICIENCY] [FP PROFICIENCY] ON [FP PROFICIENCY].[GRADE LEVEL] = [STUDENT HISTORICAL].GRADELEVEL_NUMERIC AND MONTH(CALENDAR.FULLDATE) = [FP PROFICIENCY].[MONTH]
WHERE    [TEST].[TESTTYPE] LIKE 'F&P%'
	 AND [TEST].TESTSCORETYPE = 'Test'
	 AND PROFICIENCYLEVEL = 'Independent'
GROUP BY [POWERSCHOOL_STUDENTS].STUDENT_NUMBER,
		 [POWERSCHOOL_STUDENTS].ID,
		 [TEST SCORES].STUDENTKEY,
		 [STUDENT].SYSTEMSTUDENTID,TERMKEY,
		 [STUDENT HISTORICAL].GRADELEVEL_NUMERIC;
