###Fact and Dim Tables
[Early_Warning_Fact](https://github.com/LarryKDC/Early-Warning-System/blob/master/Early_Warning_Fact.sql)

| Field                     | Type    | Key         | Description                                      | Notes                                                       |
|---------------------------|---------|-------------|--------------------------------------------------|-------------------------------------------------------------|
| Student_Number            | Int     | Foreign Key |                                                  |                                                             |
| StudentID                 | Int     | Foreign Key |                                                  |                                                             |
| StudentKey                | Int     | Foreign Key |                                                  |                                                             |
| SystemStudentID           | Varchar | Foreign Key |                                                  |                                                             |
| TermKey                   | Int     | Foreign Key |                                                  |                                                             |
| Absences                  | Int     |             | Total absences in a given term                   |                                                             |
| Memebership               | Int     |             | Total days of enrollment in a given term         |                                                             |
| Unexcused_Absences        | Int     |             | Total unexcused absences in given term           |                                                             |
| Tardies                   | Int     |             | Total tardies in a given term                    |                                                             |
| Count_OSS                 | Int     |             | Total number of OSS in a given term              |                                                             |
| Days_Of_OSS               | Int     |             | Total days on OSS in a given term                |                                                             |
| Num_Of_Incidents          | Int     |             | Total number of incidents in a given term        |                                                             |
| Num_Of_Referrals          | Int     |             | Total number of referrals in a given term        |                                                             |
| GPA                       | Float   |             | Term GPA form PS                                 |                                                             |
| Num_Ds_And_Fs             | Int     |             | Total number of Ds and Fs earned in a given term |                                                             |
| ScaleScore_Math (Reading) | Int     |             | NWEA MAP Math (Reading) scale score              | See term definitions for testing window to term assignments |
| Percentile_Math (Reading) | Int     |             | NWEA MAP Math (Reading) percentile score         | See term definitions for testing window to term assignments |
| AnnualCGI_Math (Reading)  | Float   |             | NWEA MAP Math (Reading) conditional growth index | See growth definitions table                                |
| AnnualGP_Math (Reading)   | Int     |             | NWEA MAP Math (Reading) growth percentile        | See growth definitions table                                |
| WindowCGI_Math (Reading)  | Float   |             | NWEA MAP Math (Reading) conditional growth index | See growth definitions table                                |
| WindowGP_Math (Reading)   | Int     |             | NWEA MAP Math (Reading) growth percentile        | See growth definitions table                                |

###Staged Tables
[Early_Warning_Attendance](https://github.com/LarryKDC/Early-Warning-System/blob/master/Staged-Tables/Early_Warning_Attendance.sql)

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

[Early_Warning_Behavior](https://github.com/LarryKDC/Early-Warning-System/blob/master/Staged-Tables/Early_Warning_Behavior.sql)

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

[Early_Warning_GPA](https://github.com/LarryKDC/Early-Warning-System/blob/master/Staged-Tables/Early_Warning_GPA.sql)

| Field          | Type     | Key | Description                   | Notes |
|----------------|----------|-----|-------------------------------|-------|
| Student_Number | Int      |     |                               |       |
| TermKEY        | Int      |     |                               |       |
| GPA            | Float(5) |     | Add a definition/caveats here |       |

[Early_Warning_Grades](https://github.com/LarryKDC/Early-Warning-System/blob/master/Staged-Tables/Early_Warning_Grades.sql)

| Field           | Type        | Key | Description                                       | Notes |
|-----------------|-------------|-----|---------------------------------------------------|-------|
| Student_Number  | Int         |     |                                                   |       |
| StudentID       | Int         |     |                                                   |       |
| StudentKEY      | Int         |     |                                                   |       |
| SystemStudentID | Varchar(25) |     |                                                   |       |
| TermKEY         | Int         |     |                                                   |       |
| Num_Ds_AND_Fs   | Int         |     | Total number of D's or F's earned in a given term |       |
