--77 RECORDS WHERE TESTGRADELEVEL != STUDENTHISTORICALGRADELEVEL

IF OBJECT_ID('tempdb.dbo.#AG', 'U') IS NOT NULL
  DROP TABLE #AG; 

SELECT 
 [MEASUREMENTSCALE]
,[GRADELEVEL]
,[STARTGRADE]
,[STARTRIT]
,CASE [RANGE]
	WHEN 'R44' THEN 'Fall'	 --COMPARES FALL OF FOCAL GRADE TO FALL OF NEXT GRADE - FORWARD LOOKING
	WHEN 'R22' THEN 'Spring' --COMPARES SPRING OF LAST GRADE TO SPRING OF FOCAL GRADE - BACKWARD LOOKING
	WHEN 'R11' THEN 'Winter' --COMPARES WINTER OF LAST GRADE TO WINTER OF FOCAL GRADE - BACKWARD LOOKING
	ELSE NULL 
END AS PERIOD
,GROWTH
INTO #AG
FROM [CUST1220].[TEST_NWEAMAP].[TEST_NWEAMAP_MAPGROWTHNORMS]
	UNPIVOT
	(GROWTH FOR [RANGE] IN 
		([R44]
		,[R22]
		,[R11])
)AS ANNUAL;


IF OBJECT_ID('tempdb.dbo.#WG', 'U') IS NOT NULL
  DROP TABLE #WG; 

SELECT 
 [MEASUREMENTSCALE]
,[GRADELEVEL]
,[STARTGRADE]
,[STARTRIT]
,CASE [RANGE]
	WHEN 'R41' THEN 'Winter' --Compares Fall of focal grade to Winter of focal grade
	WHEN 'R42' THEN 'Spring' --Compares Fall of focal grade to Spring of focal grade
	ELSE NULL 
END AS TESTPERIOD
,'Fall' AS STARTPERIOD
,GROWTH
INTO #WG
FROM [CUST1220].[TEST_NWEAMAP].[TEST_NWEAMAP_MAPGROWTHNORMS]
	UNPIVOT
	(GROWTH FOR [RANGE] IN 
		([R41]  --F2W
		,[R42]  --F2S
		--,[R12]  --W2S
		) 
)AS WINDOW;


IF OBJECT_ID('tempdb.dbo.#FALL', 'U') IS NOT NULL
  DROP TABLE #FALL; 

SELECT
F.SCALESCORE AS SCALESCORE,
F.STUDENTKEY AS STUDENTKEY,
C.SCHOOLYEAR4DIGIT AS SCHOOLYEAR4DIGIT,
T.TESTSUBJECT AS TESTSUBJECT
INTO #FALL
FROM [DW].[DW_FACTTESTSCORES] F
JOIN DW.DW_DIMSTUDENT S ON S.STUDENTKEY = F.STUDENTKEY
JOIN DW.DW_DIMTEST T ON T.TESTKEY = F.TESTKEY
JOIN DW.DW_DIMSCHOOLCALENDAR C ON C.SCHOOLCALENDARKEY = F.SCHOOLCALENDARKEY
JOIN DW.DW_DIMSTUDENTHISTORICAL SH ON SH.STUDENTHISTORICALKEY = F.STUDENTHISTORICALKEY
WHERE T.TESTPERIOD = 'Fall'
AND TESTTYPE = 'NWEA MAP'
AND TESTSCORETYPE = 'Test'
AND T.TESTGRADELEVEL=SH.GRADELEVEL;


/********************MATHEMATICS****************************/

--CHECK IF TABLE EXISTS. IF IT DOES, DROP THE RECORDS. IF IT DOES NOT, CREATE THE TABLE.
IF OBJECT_ID('[custom].[CUSTOM_EARLY_WARNING_ASSESSMENT_SCORES_MATH]', 'U') IS NOT NULL
	DELETE FROM [custom].[CUSTOM_EARLY_WARNING_ASSESSMENT_SCORES_MATH];
ELSE
	CREATE TABLE [custom].[CUSTOM_EARLY_WARNING_ASSESSMENT_SCORES_MATH] (
	STUDENT_NUMBER INT,
	STUDENTID INT,
	SYSTEMSTUDENTID VARCHAR(25),
	STUDENTKEY INT,
	SCALESCORE INT,
	PERCENTILESCORE INT,
	TESTPERIOD VARCHAR(10),
	TESTDATE DATE,
	TESTSUBJECT VARCHAR(20),
	TERMKEY INT,
	ANNUAL_PROJECTED_GROWTH INT,
	ANNUAL_COMPARISON INT,
	WINDOW_PROJECTED_GROWTH INT,
	WINDOW_COMPARISON INT
	)
; 

--CHECK IF INDEX ON TABLE EXISTS. IF NOT, CREATE ONE
IF (SELECT OBJECT_ID
	FROM sys.indexes 
	WHERE name='EW_ASSESSMENT_SCORES_MATH' AND object_id = OBJECT_ID('CUSTOM.CUSTOM_EARLY_WARNING_ASSESSMENT_SCORES_MATH')) IS NULL
	CREATE INDEX EW_ASSESSMENT_SCORES_MATH ON CUSTOM.CUSTOM_EARLY_WARNING_ASSESSMENT_SCORES_MATH (STUDENT_NUMBER,TERMKEY);

INSERT INTO [custom].[CUSTOM_EARLY_WARNING_ASSESSMENT_SCORES_MATH]
SELECT
PS.STUDENT_NUMBER,
PS.ID AS STUDENTID,
S.SYSTEMSTUDENTID,
S.STUDENTKEY,
F.SCALESCORE,
F.PERCENTILESCORE,
T.TESTPERIOD,
F.TESTDATE,
T.TESTSUBJECT,
COALESCE(TERMS.TERMKEY,-1) AS TERMKEY,--IF TERM KEY IS NULL THEN MAKE IT -1
--FOR WINTER AND SPRING THE PROJECTED GROWTH VALUE COMES FROM THE PREVIOUS YEAR NORM FOR FALL IT COMES FROM THE CURRENT YEAR NORM
CASE 
	WHEN T.TESTPERIOD IN ('Winter','Spring') THEN LAG(#AG.GROWTH) OVER (PARTITION BY S.SYSTEMSTUDENTID,t.TESTSUBJECT,T.TESTPERIOD ORDER BY S.SYSTEMSTUDENTID,t.TESTSUBJECT,T.TESTPERIOD,FULLDATE)
	WHEN T.TESTPERIOD = 'Fall' THEN #AG.GROWTH
	ELSE NULL 
END ANNUAL_PROJECTED_GROWTH,
LAG(F.SCALESCORE) OVER (PARTITION BY S.SYSTEMSTUDENTID,t.TESTSUBJECT,T.TESTPERIOD ORDER BY S.SYSTEMSTUDENTID,t.TESTSUBJECT,T.TESTPERIOD,FULLDATE) AS ANNUAL_COMPARISON,
#WG.GROWTH AS WINDOW_PROJECTED_GROWTH,
CASE 
	WHEN T.TESTPERIOD = 'Fall' THEN NULL 
	ELSE #FALL.SCALESCORE 
END AS WINDOW_COMPARISON
FROM [DW].[DW_FACTTESTSCORES] F
JOIN DW.DW_DIMSTUDENT S ON S.STUDENTKEY = F.STUDENTKEY
JOIN [custom].[custom_StudentBridge] SB ON SB.SYSTEMSTUDENTID = S.SYSTEMSTUDENTID
JOIN [powerschool].[powerschool_Students] PS ON PS.STUDENT_NUMBER = SB.SYSTEMSTUDENTID
JOIN DW.DW_DIMTEST T ON T.TESTKEY = F.TESTKEY
JOIN DW.DW_DIMSCHOOLCALENDAR C ON C.SCHOOLCALENDARKEY = F.SCHOOLCALENDARKEY
JOIN DW.DW_DIMSTUDENTHISTORICAL SH ON SH.STUDENTHISTORICALKEY = F.STUDENTHISTORICALKEY
JOIN [dw].[DW_dimSchool] SC ON SC.SCHOOLKEY = F.SCHOOLKEY
LEFT JOIN [custom].CUSTOM_EARLY_WARNING_TERMS TERMS ON RIGHT(C.SCHOOLYEAR4DIGIT,2)+9 = TERMS.YEARID AND TERMS.SEASON = TESTPERIOD AND CAST(SC.SYSTEMSCHOOLID AS INT) = TERMS.SCHOOLID 
LEFT JOIN #AG ON #AG.MEASUREMENTSCALE = T.TESTSUBJECT AND #AG.GRADELEVEL = T.TESTGRADELEVEL AND #AG.STARTRIT = F.SCALESCORE AND #AG.PERIOD = T.TESTPERIOD
LEFT JOIN #FALL ON #FALL.STUDENTKEY = F.STUDENTKEY AND #FALL.SCHOOLYEAR4DIGIT = C.SCHOOLYEAR4DIGIT AND #FALL.TESTSUBJECT = T.TESTSUBJECT
LEFT JOIN #WG ON #WG.MEASUREMENTSCALE = T.TESTSUBJECT AND #WG.GRADELEVEL = T.TESTGRADELEVEL AND #WG.STARTRIT = #FALL.SCALESCORE AND #WG.TESTPERIOD = T.TESTPERIOD
WHERE TESTTYPE = 'NWEA MAP'
AND TESTSCORETYPE = 'Test'
AND T.TESTGRADELEVEL=SH.GRADELEVEL
--AND S.SYSTEMSTUDENTID = '16919'
AND T.TESTSUBJECT = 'Mathematics'
AND SC.SYSTEMSCHOOLID != '-----' 
ORDER BY SYSTEMSTUDENTID,t.TESTSUBJECT,FULLDATE;


/********************READING****************************/

--CHECK IF TABLE EXISTS. IF IT DOES, DROP THE RECORDS. IF IT DOES NOT, CREATE THE TABLE.
IF OBJECT_ID('[custom].[CUSTOM_EARLY_WARNING_ASSESSMENT_SCORES_READING]', 'U') IS NOT NULL
	DELETE FROM [custom].[CUSTOM_EARLY_WARNING_ASSESSMENT_SCORES_READING];
ELSE
	CREATE TABLE [custom].[CUSTOM_EARLY_WARNING_ASSESSMENT_SCORES_READING] (
	STUDENT_NUMBER INT,
	STUDENTID INT,
	SYSTEMSTUDENTID VARCHAR(25),
	STUDENTKEY INT,
	SCALESCORE INT,
	PERCENTILESCORE INT,
	TESTPERIOD VARCHAR(10),
	TESTDATE DATE,
	TESTSUBJECT VARCHAR(20),
	TERMKEY INT,
	ANNUAL_PROJECTED_GROWTH INT,
	ANNUAL_COMPARISON INT,
	WINDOW_PROJECTED_GROWTH INT,
	WINDOW_COMPARISON INT
	)
; 


--CHECK IF INDEX ON TABLE EXISTS. IF NOT, CREATE ONE
IF (SELECT OBJECT_ID
	FROM sys.indexes 
	WHERE name='EW_ASSESSMENT_SCORES_READING' AND object_id = OBJECT_ID('CUSTOM.CUSTOM_EARLY_WARNING_ASSESSMENT_SCORES_READING')) IS NULL
	CREATE INDEX EW_ASSESSMENT_SCORES_READING ON CUSTOM.CUSTOM_EARLY_WARNING_ASSESSMENT_SCORES_READING (STUDENT_NUMBER,TERMKEY);

INSERT INTO [custom].[CUSTOM_EARLY_WARNING_ASSESSMENT_SCORES_READING]
SELECT
PS.STUDENT_NUMBER,
PS.ID AS STUDENTID,
S.SYSTEMSTUDENTID,
S.STUDENTKEY,
F.SCALESCORE,
F.PERCENTILESCORE,
T.TESTPERIOD,
F.TESTDATE,
T.TESTSUBJECT,
COALESCE(TERMS.TERMKEY,-1) AS TERMKEY,--IF TERM KEY IS NULL THEN MAKE IT -1
--FOR WINTER AND SPRING THE PROJECTED GROWTH VALUE COMES FROM THE PREVIOUS YEAR NORM FOR FALL IT COMES FROM THE CURRENT YEAR NORM
CASE 
	WHEN T.TESTPERIOD IN ('Winter','Spring') THEN LAG(#AG.GROWTH) OVER (PARTITION BY S.SYSTEMSTUDENTID,t.TESTSUBJECT,T.TESTPERIOD ORDER BY S.SYSTEMSTUDENTID,t.TESTSUBJECT,T.TESTPERIOD,FULLDATE)
	WHEN T.TESTPERIOD = 'Fall' THEN #AG.GROWTH
	ELSE NULL 
END ANNUAL_PROJECTED_GROWTH,
LAG(F.SCALESCORE) OVER (PARTITION BY S.SYSTEMSTUDENTID,t.TESTSUBJECT,T.TESTPERIOD ORDER BY S.SYSTEMSTUDENTID,t.TESTSUBJECT,T.TESTPERIOD,FULLDATE) AS ANNUAL_COMPARISON,
#WG.GROWTH AS WINDOW_PROJECTED_GROWTH,
CASE 
	WHEN T.TESTPERIOD = 'Fall' THEN NULL 
	ELSE #FALL.SCALESCORE 
END AS WINDOW_COMPARISON
FROM [DW].[DW_FACTTESTSCORES] F
JOIN DW.DW_DIMSTUDENT S ON S.STUDENTKEY = F.STUDENTKEY
JOIN [custom].[custom_StudentBridge] SB ON SB.SYSTEMSTUDENTID = S.SYSTEMSTUDENTID
JOIN [powerschool].[powerschool_Students] PS ON PS.STUDENT_NUMBER = SB.SYSTEMSTUDENTID
JOIN DW.DW_DIMTEST T ON T.TESTKEY = F.TESTKEY
JOIN DW.DW_DIMSCHOOLCALENDAR C ON C.SCHOOLCALENDARKEY = F.SCHOOLCALENDARKEY
JOIN DW.DW_DIMSTUDENTHISTORICAL SH ON SH.STUDENTHISTORICALKEY = F.STUDENTHISTORICALKEY
JOIN [dw].[DW_dimSchool] SC ON SC.SCHOOLKEY = F.SCHOOLKEY
LEFT JOIN [custom].CUSTOM_EARLY_WARNING_TERMS TERMS ON RIGHT(C.SCHOOLYEAR4DIGIT,2)+9 = TERMS.YEARID AND TERMS.SEASON = TESTPERIOD AND CAST(SC.SYSTEMSCHOOLID AS INT) = TERMS.SCHOOLID 
LEFT JOIN #AG ON #AG.MEASUREMENTSCALE = T.TESTSUBJECT AND #AG.GRADELEVEL = T.TESTGRADELEVEL AND #AG.STARTRIT = F.SCALESCORE AND #AG.PERIOD = T.TESTPERIOD
LEFT JOIN #FALL ON #FALL.STUDENTKEY = F.STUDENTKEY AND #FALL.SCHOOLYEAR4DIGIT = C.SCHOOLYEAR4DIGIT AND #FALL.TESTSUBJECT = T.TESTSUBJECT
LEFT JOIN #WG ON #WG.MEASUREMENTSCALE = T.TESTSUBJECT AND #WG.GRADELEVEL = T.TESTGRADELEVEL AND #WG.STARTRIT = #FALL.SCALESCORE AND #WG.TESTPERIOD = T.TESTPERIOD
WHERE TESTTYPE = 'NWEA MAP'
AND TESTSCORETYPE = 'Test'
AND T.TESTGRADELEVEL=SH.GRADELEVEL
--AND S.SYSTEMSTUDENTID = '16919'
AND T.TESTSUBJECT = 'Reading'
AND SC.SYSTEMSCHOOLID != '-----' 
ORDER BY SYSTEMSTUDENTID,t.TESTSUBJECT,FULLDATE;
