# Early-Warning-System
The Early Warning System (EWS) tables exist in the Custom schema. The schema was developed using the dimensional modle. There is a series of staged tables (roughly one table per domain covered in the EWS). There is a fact table that contains columns for each measure derived from the staged tables. In the fact table there is one record per student per term. Terms can take the form of quarters, semesters, trimesters, or full school years.

##[Early_Warning_Attendance](https://github.com/LarryKDC/Early-Warning-System/blob/master/Early_Warning_Attendance.sql)

Field | Type | Key | Description | Notes
-----|----|---|-----------|-----
Student_Number | Float | Foreign Key | Join to Powerschool.Powerschool_Students | 
StudentKEY | Int | Foreign Key | Join to dw.DW_DimStudent |
StudentID | Int | Foreign KEY | Join directly to PS tables with student data with using Powerschool_Students as intermediary |
SystemStudentID | Varchar | Foreign Key |  |
TermKEY | Int | Foreign Key | Join to Custom_Early_Warning_Terms; |CAST(CAST(POWERSCHOOL.POWERSCHOOL_TERMS.ID AS VARCHAR) CAST(E.SCHOOLID AS VARCHAR) AS INT)
Absences | Int | n/a | Total number of absences in a given term; | CASE WHEN POWERSCHOOL.POWERSCHOOL_ATTENDANCE_CODE.PRESENCE_STATUS_CD = 'Absent' THEN 1 ELSE 0 END
Membership | Int | n/a | Total number of days enrolled in a given term |
Unexcused_Absences | Int | n/a | Total number of unexcused absences in a term;| CASE WHEN POWERSCHOOL.POWERSCHOOL_ATTENDANCE_CODE.DESCRIPTION IN ('Absent','Medical Unexcused','Tardy Absent','Released Early Absent') THEN 1 ELSE 0 END |
Tardies | Int | n/a | Total number of tardies in a term;| CASE WHEN POWERSCHOOL.POWERSCHOOL_ATTENDANCE_CODE.DESCRIPTION IN ('Tardy','Tardy Excused','Tardy Released Early') THEN 1 ELSE 0 END
