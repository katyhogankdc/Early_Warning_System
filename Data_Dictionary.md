
##[Early_Warning_Attendance](https://github.com/LarryKDC/Early-Warning-System/blob/master/Staged-Tables/Early_Warning_Attendance.sql)

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

##[Early_Warning_Behavior](https://github.com/LarryKDC/Early-Warning-System/blob/master/Staged-Tables/Early_Warning_Behavior.sql)
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

##[Early_Warning_GPA](https://github.com/LarryKDC/Early-Warning-System/blob/master/Staged-Tables/Early_Warning_GPA.sql)
| Field          | Type     | Key | Description                   | Notes |
|----------------|----------|-----|-------------------------------|-------|
| Student_Number | Int      |     |                               |       |
| TermKEY        | Int      |     |                               |       |
| GPA            | Float(5) |     | Add a definition/caveats here |       |

##[Early_Warning_Grades](https://github.com/LarryKDC/Early-Warning-System/blob/master/Staged-Tables/Early_Warning_Grades.sql)
| Field           | Type        | Key | Description                                       | Notes |
|-----------------|-------------|-----|---------------------------------------------------|-------|
| Student_Number  | Int         |     |                                                   |       |
| StudentID       | Int         |     |                                                   |       |
| StudentKEY      | Int         |     |                                                   |       |
| SystemStudentID | Varchar(25) |     |                                                   |       |
| TermKEY         | Int         |     |                                                   |       |
| Num_Ds_AND_Fs   | Int         |     | Total number of D's or F's earned in a given term |       |