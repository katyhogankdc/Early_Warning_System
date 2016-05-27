# Early-Warning-System
The Early Warning System (EWS) tables exist in the Custom schema. The schema was developed using the dimensional modle. There is a series of staged tables (roughly one table per domain covered in the EWS). There is a fact table that contains columns for each measure derived from the staged tables. In the fact table there is one record per student per term. Terms can take the form of quarters, semesters, trimesters, or full school years.

##[Early_Warning_Attendance](https://github.com/LarryKDC/Early-Warning-System/blob/master/Early_Warning_Attendance.sql)

| Field           | Type    | Key         | Description                                  | Notes |
|-----------------|---------|-------------|----------------------------------------------|-------|
|Student_Number   | Float   | Foreign Key | Join to Powerschool.Powerschool_Students     |       | 
|StudentKEY       | Int     | Foreign Key | Join to dw.DW_DimStudent                     |       | 
|StudentID        | Int     | Foreign KEY | Join directly to PS tables with student data with using Powerschool_Students as                                                                                                 intermediary|
|SystemStudentID  | Varchar | Foreign Key |                                              |       |
|TermKEY          | Int     | Foreign Key | Join to Custom_Early_Warning_Terms;          |       |  
|Absences         | Int     |             | Total number of absences in a given term;    |       |
|Membership   	  | Int     |             | Total number of days enrolled in a given term|       |
|Unexcused_Absences| Int    |             | Total number of unexcused absences in a term;|       |
|Tardies 				  | Int     | n/a         | Total number of tardies in a term;					 |			 |

##[Early_Warning_Behavior](https://github.com/LarryKDC/Early-Warning-System/blob/master/Early_Warning_Behavior.sql)
| Field            | Type    | Key         | Description                                                                                                                        | Notes |
|------------------|---------|-------------|------------------------------------------------------------------------------------------------------------------------------------|-------|
| Student_Number   | Float   | Foreign Key | Join to Powerschool.Powerschool_Students                                                                                           |       |
| StudentKEY       | Int     | Foreign Key | Join to dw.DW_DimStudent                                                                                                           |       |
| StudentID        | Int     | Foreign KEY | Join directly to PS tables with student data                                                                                       |       |
| SystemStudentID  | Varchar | Foreign Key |                                                                                                                                    |       |
| TermKEY          | Int     | Foreign Key | Join to Custom_Early_Warning_Terms;                                                                                                |       |
| Count_OSS        | Int     | n/a         | Total number of OSS in a given term;                                                                                               |       |
| Days_of_OSS      | Int     | n/a         | Total number of days on OSS in a given term;                                                                                       |       |
| Num_of_Incidents | Int     | n/a         | Total number of incidents, regardless of type (except Attendance Intervention) or whether a penalty was assigned, in a given term; |       |
| Num_of_Referral  | Int     | n/a         | Total number of referrals, regardless of type or whether a penalty was assigned, in a given term;                                  |       |

##[Early_Warning_GPA](https://github.com/LarryKDC/Early-Warning-System/blob/master/Early_Warning_GPA.sql)
| Field          | Type     | Key | Description                   | Notes |
|----------------|----------|-----|-------------------------------|-------|
| Student_Number | Int      |     |                               |       |
| TermKEY        | Int      |     |                               |       |
| GPA            | Float(5) |     | Add a definition/caveats here |       |
