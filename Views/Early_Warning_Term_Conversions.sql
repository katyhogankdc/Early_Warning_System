DROP VIEW CUSTOM.CUSTOM_TERM_CONVERSIONS

CREATE VIEW custom.custom_term_conversions AS

SELECT DISTINCT --CONVERT GRADEPERIOD TO STORECODE TO UPP 
	T.ID, --NEED THIS
	T.NAME, --NEED THIS
	T.SCHOOLID, --JOIN
	PG.FINALGRADENAME, --JOIN
	T.ABBREVIATION,
	T.YEARID --JOIN 
	FROM POWERSCHOOL.POWERSCHOOL_TERMS T
	LEFT JOIN(
		SELECT DISTINCT
		STARTDATE,
		ENDDATE,
		S.SCHOOLID,
		FINALGRADENAME
		FROM POWERSCHOOL.POWERSCHOOL_PGFINALGRADES P
		LEFT JOIN POWERSCHOOL.POWERSCHOOL_STUDENTS S ON S.ID = P.STUDENTID
) PG ON PG.SCHOOLID = T.SCHOOLID AND ((PG.STARTDATE = T.FIRSTDAY AND PG.ENDDATE = T.LASTDAY) OR PG.FINALGRADENAME = T.ABBREVIATION)
WHERE T.SCHOOLID>0
--ORDER BY T.SCHOOLID, T.ID
