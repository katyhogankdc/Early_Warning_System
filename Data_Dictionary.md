###Fact and Dim Tables
[Early_Warning_Fact](https://github.com/LarryKDC/Early-Warning-System/blob/master/Early_Warning_Fact.sql)

| Field                     | Type    | Key         | Description                                        | Notes                                                       |
|---------------------------|---------|-------------|----------------------------------------------------|-------------------------------------------------------------|
| Student_Number            | Int     | Foreign Key |                                                    |                                                             |
| StudentID                 | Int     | Foreign Key |                                                    |                                                             |
| StudentKey                | Int     | Foreign Key |                                                    |                                                             |
| SystemStudentID           | Varchar | Foreign Key |                                                    |                                                             |
| TermKey                   | Int     | Foreign Key |                                                    |                                                             |
| Absences                  | Int     |             | Total absences in a given term                     |                                                             |
| Memebership               | Int     |             | Total days of enrollment in a given term           |                                                             |
| Unexcused_Absences        | Int     |             | Total unexcused absences in given term             |                                                             |
| Tardies                   | Int     |             | Total tardies in a given term                      |                                                             |
| Count_OSS                 | Int     |             | Total number of OSS in a given term                |                                                             |
| Days_Of_OSS               | Int     |             | Total days on OSS in a given term                  |                                                             |
| Num_Of_Incidents          | Int     |             | Total number of incidents in a given term          |                                                             |
| Num_Of_Referrals          | Int     |             | Total number of referrals in a given term          |                                                             |
| GPA                       | Float   |             | Term GPA form PS                                   |                                                             |
| Num_Ds_And_Fs             | Int     |             | Total number of Ds and Fs earned in a given term   |                                                             |
| ScaleScore_Math (Reading) | Int     |             | NWEA MAP Math (Reading) scale score                | See term definitions for testing window to term assignments |
| Percentile_Math (Reading) | Int     |             | NWEA MAP Math (Reading) percentile score           | See term definitions for testing window to term assignments |
| AnnualCGI_Math (Reading)  | Float   |             | NWEA MAP Math (Reading) conditional growth index   | See growth definitions table                                |
| AnnualGP_Math (Reading)   | Int     |             | NWEA MAP Math (Reading) growth percentile          | See growth definitions table                                |
| WindowCGI_Math (Reading)  | Float   |             | NWEA MAP Math (Reading) conditional growth index   | See growth definitions table                                |
| WindowGP_Math (Reading)   | Int     |             | NWEA MAP Math (Reading) growth percentile          | See growth definitions table                                |
| STEP_Level                | Int     |             | STEP Level from -1 to 12                           |                                                             |
| STEP_Proficiency          | Varchar |             | Above/At/Below grade level                         |                                                             |
| FP Level                  | Int     |             | F&P levels represented with integers A=1, B=2, etc.|                                                           |
| Target Level              | Int     |             | Based on month and grade level of student        | See  CUSTOM_EARLY_WARNING_F_AND_P_PROFICIENCY               |

[Early_Warning_DimStudents](https://github.com/LarryKDC/Early-Warning-System/blob/master/Early_Warning_DimStudent.sql)

| Field               | Type         | Key         | Description                                              | Notes |
|---------------------|--------------|-------------|----------------------------------------------------------|-------|
| STUDENTKEY          | int          | Primary Key |                                                          |       |
| STUDENT_NUMBER      | int          |             | Powerschool Student_Number                               |       |
| SPED_CLASSIFICATION | varchar(100) |             | Current Special education classification                 |       |
| SPED_FUNDING        | varchar(10)  |             | Current special education funding level                  |       |
| HOMELESS            | int          |             | Current self-reported homeless status                    |       |
| ELL                 | int          |             | Current ELL status                                       |       |
| SPED                | int          |             | Current special education status (binary)                |       |
| AGE_YEARS           | int          |             | Current Age in years                                     |       |
| DOB                 | date         |             | Date of birth                                            |       |
| EVER_RETAINED       | int          |             | Binary indicator for whether a student was ever retained |       |
| ENROLLMENT_STATUS   | varchar(40)  |             | Current enrollment status                                |       |
| SCHOOLID            | int          |             | Powerschool SchoolID                                     |       |


[Early_Warning_DimTerms](https://github.com/LarryKDC/Early-Warning-System/blob/master/Early_Warning_DimTerms.sql)

| Field        | Type        | Key         | Description                                              | Notes                      |
|--------------|-------------|-------------|----------------------------------------------------------|----------------------------|
| TERMKEY      | int         | Primary Key | Combination of TermID and SchoolID                       |                            |
| TERMID       | int         |             | ID from Powerschool Terms Table                          |                            |
| TERMNAME     | varchar(40) |             | Name from Powerschool Terms table                        |                            |
| YEARID       | int         |             | YearID from Powerschool                                  |                            |
| ABBREVIATION | varchar(10) |             | Shortened TermName                                       |                            |
| COMMONTERM   | int         |             | Integer between 1 and 6 for comparing terms across years | see term definitions table |
| SCHOOLID     | int         |             | Powerschool SchoolID                                     |                            |
| FIRSTDAY     | date        |             | First day of the term                                    |                            |
| LASTDAY      | date        |             | Last day of the term                                     |                            |
| SEASON       | varchar(10) |             | Fall, winter, spring - corresponds to testing windows    | see term definitions table |


###Staged Tables

[Early_Warning_Assessment_Scores_Math/Reading](https://github.com/LarryKDC/Early-Warning-System/blob/master/Staged-Tables/Early_Warning_Assessment_Scores.sql)

| Field           | Type    | Key         | Description                          | Notes |
|-----------------|---------|-------------|--------------------------------------|-------|
| Student_Number  | int     | Foreign key |                                      |       |
| Studentid       | int     | Foreign key |                                      |       |
| Systemstudentid | varchar |             |                                      |       |
| Studentkey      | int     | Foreign key |                                      |       |
| Scalescore      | int     |             | RIT Score                            |       |
| Percentilescore | int     |             | RIT Percentile                       |       |
| Testperiod      | varchar |             | Fall, Winter, Spring                 |       |
| Testdate        | date    |             |                                      |       |
| Testsubject     | varchar |             | Mathematics, Reading, Language Usage |       |
| Termkey         | int     | Foreign key |                                      |       |


[Early_Warning_Assessment_Growth_Math/Reading](https://github.com/LarryKDC/Early-Warning-System/blob/master/Staged-Tables/Early_Warning_Assessment_Growth.sql)

| Field          | Type    | Key         | Description                                                         | Notes |
|----------------|---------|-------------|---------------------------------------------------------------------|-------|
| Student_Number | int     | Foreign Key |                                                                     |       |
| Testsubject    | varchar |             |                                                                     |       |
| Testperiod     | varchar |             |                                                                     |       |
| Yearid         | int     |             |                                                                     |       |
| Testdate       | date    |             |                                                                     |       |
| Annual_CGI     | real    |             | Annual Conditional Growth Index (i.e. S2S, W2W, F2F)                |       |
| Annual_GP      | int     |             | Annual Conditional Growth Percentile (i.e. S2S, W2W, F2F)           |       |
| Window_CGI     | real    |             | Window to Window Conditional Growth Index (i.e. F2S, F2W, W2S)      |       |
| Window_GP      | int     |             | Window to Window Conditional Growth Percentile (i.e. F2S, F2W, W2S) |       |
| School_Number  | int     |             |                                                                     |       |
| Termkey        | int     | Foreign Key |                                                                     |       |


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

[Early_Warning_FP](https://github.com/LarryKDC/Early-Warning-System/blob/master/Staged-Tables/Early_Warning_FP.sql)

| Field           | Type    | Key         | Description                                         | Notes |
|-----------------|---------|-------------|-----------------------------------------------------|-------|
| Student_Number  | int     | Foreign key |                                                     |       |
| Studentid       | int     |             |                                                     |       |
| Studentkey      | int     |             |                                                     |       |
| Systemstudentid | varchar |             |                                                     |       |
| Termkey         | int     | Foreign key |                                                     |       |
| FP Level        | int     |             | Integer equivalent of actual level (A=1, B=2, C=3…) |       |
| Target Level    | int     |             | Integer equivalent of level target (A=1, B=2, C=3…) |       |


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
