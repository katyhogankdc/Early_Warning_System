/*next update change the name of the table to Early_Warning_DimTerms to follow dim/fact conventions*/

DROP TABLE CUSTOM.CUSTOM_EARLY_WARNING_TERMS

CREATE TABLE CUSTOM.CUSTOM_EARLY_WARNING_TERMS (
TERMKEY INT PRIMARY KEY,
TERMID INT,
TERMNAME VARCHAR(40),
YEARID INT,
ABBREVIATION VARCHAR(10),
COMMONTERM INT,
SCHOOLID INT,
FIRSTDAY DATE,
LASTDAY DATE,
SEASON VARCHAR(10));

CREATE INDEX EW_TERMS ON CUSTOM.CUSTOM_EARLY_WARNING_TERMS (TERMKEY);

INSERT INTO CUSTOM.CUSTOM_EARLY_WARNING_TERMS (TERMKEY,TERMID,TERMNAME,YEARID,ABBREVIATION,COMMONTERM,SCHOOLID,FIRSTDAY,LASTDAY,SEASON)
SELECT SUB.*, -- use subquery to add assessment terms
CASE 
	WHEN SUB.[COMMON TERM] = 0 THEN 'Summer'
	WHEN SUB.[COMMON TERM] = 1 THEN 'Fall'
	WHEN SUB.[COMMON TERM] = 2 THEN 'Winter'
	WHEN SUB.[COMMON TERM] = 4 THEN 'Spring' -- 7/11/16 -- changed from ">=" 4 to "=" 4 so that spring assessment scores are only assigned to the spring term not the full year terms as well
	ELSE '-----' END 'SEASON'
FROM (
SELECT
CAST(CAST(T.ID AS VARCHAR) + CAST(T.SCHOOLID AS VARCHAR) AS INT) AS TERMKEY,
T.ID AS TERMID,
T.NAME AS TERMNAME,
T.YEARID AS YEARID,
T.ABBREVIATION AS ABBREVIATION,
CASE -- THIS ASSIGNS A UNIFORM TERM CODE (0 THROUGH 5) WHETHER IT IS TRIMESTERS OR QUARTERS
	WHEN NAME LIKE '%Summer%' THEN 0 --ALWAYS MAKE THE SUMMER 0
	WHEN T.ID LIKE '%00' THEN 6 --ALWAYS MAKE THE FULL YEAR TERM 6 (INCLUDING SUMMER)
	WHEN PORTION = 2 AND T.NAME NOT LIKE '%Summer%' THEN 5 --Make the school year (not including summer) term equal to 5
	WHEN T.SCHOOLID != 1100 THEN ( --not KCP
		CASE 
			WHEN PORTION = 3 AND TERMRANK = 4 THEN 4
			WHEN PORTION = 3 AND TERMRANK != 4 THEN TERMRANK-1
			WHEN PORTION = 4 THEN TERMRANK-1
			WHEN PORTION = 5 THEN TERMRANK-1
			ELSE NULL
		END)
	WHEN T.SCHOOLID = 1100 THEN ( --KCP only
		CASE 
			WHEN PORTION = 3 AND TERMRANK = 4 THEN 4
			WHEN PORTION = 3 AND TERMRANK != 4 THEN TERMRANK-1
			WHEN PORTION = 5 AND TERMRANK <= 5 THEN TERMRANK-3
			WHEN PORTION = 5 AND TERMRANK > 5 THEN TERMRANK-4
			WHEN PORTION = 6 AND TERMRANK <= 3 THEN TERMRANK-1
			WHEN PORTION = 6 AND TERMRANK > 3 THEN TERMRANK-2
			ELSE NULL 
		END)
END 'COMMON TERM',
T.SCHOOLID AS SCHOOLID,
T.FIRSTDAY AS FIRSTDAY,
T.LASTDAY AS LASTDAY
FROM POWERSCHOOL.POWERSCHOOL_TERMS T
JOIN (SELECT --use the rank values to determine the common term values 
		ID,
		SCHOOLID,rank() over (partition by schoolid, yearid order by schoolid, lastday,firstday desc) TERMRANK 
		FROM POWERSCHOOL.POWERSCHOOL_TERMS 
		WHERE DATEDIFF(DAY,FIRSTDAY,LASTDAY)>7
	  ) T_RANK ON T_RANK.SCHOOLID = T.SCHOOLID AND T_RANK.ID = T.ID
WHERE T.SCHOOLID not in (999999,2001) --exclude alumni school, and NPP
AND T.ID >= 2000 --only include 10-11 school year and after
AND NOT (T.SCHOOLID = 1100 AND T.NAME LIKE 'Semester%') --do not inlcude sememster terms for KCP, they are not real terms just used for rolling up grades
) SUB --only include 2010 to present to simplify term transformation - could go back to 2006 if necessary
--ORDER BY TERMKEY
;

/*add a row of termkey -1 so you don't drop records on with an inner join*/
INSERT INTO CUSTOM.CUSTOM_EARLY_WARNING_TERMS
VALUES(-1,-1,'-----',-1,'-----',-1,-1,'01-01-1900','01-01-1900','-----');

