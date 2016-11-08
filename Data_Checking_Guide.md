For the full documentation go to: [https://github.com/LarryKDC/Early\_Warning\_System](https://github.com/LarryKDC/Early_Warning_System)

# Attendance

1. Log in to PowerSchool
2. Select a school
3. On the left hand side select &quot;System&quot;
4. Select &quot;Direct Database Export (DDE)&quot;
5. Under current table select &quot;Attendance (157)
6. In the &quot;Search Attendance&quot; box
  1. set the Yearid to 25 for 2015 or 26 for 2016
  2. att\_date &gt;= First day of regular school year
  3. att\_date &lt;= Last day of regular school year
  4. set att\_mode\_code = ATT\_ModeDaily
7. Check the box in the bottom left &quot;Search only records belonging to…&quot;
8. Click search all #### records in this table
9. At the top click &quot;Export Records&quot;
10. In the box copy and paste the list of fields below

_StudentID_

_[students]student\_number_
_Att\_Date_
_SchoolID_
_[attendance\_code]att\_code_
_Attendance\_CodeID_
_[attendance\_code]presence\_status\_code_
_[calendar\_day]insession_

1. Click submit
2. Remove records that have an insession value of 0
3. Run the query below and compare that to the export from Powerschool
```SQL
SELECT
FULLNAME,
S.STUDENT_NUMBER,
F.MEMBERSHIP,
F.ABSENCES,
F.MEMBERSHIP,
F.UNEXCUSED_ABSENCES,
F.TARDIES,
T.TERMKEY,
T.FIRSTDAY,
T.LASTDAY
FROM[CUSTOM].[CUSTOM_EARLY_WARNING_FACT]F
JOIN[CUSTOM].[CUSTOM_EARLY_WARNING_STUDENTS] S ON S.STUDENTKEY = F.STUDENTKEY
JOIN[CUSTOM].[CUSTOM_EARLY_WARNING_TERMS] T ON T.TERMKEY = F.TERMKEY
WHERE F.TERMKEY = 25001002
```
_Notes:_

_Only non-present records will be exported_
_Unexcused absences = A + MU_
_Tardies = T + TE + TRE_
_Attendance codes will vary by year_



# Discipline

1. Log in to DeansList
2. Select a School
3. Select the Reports &amp; Data tab then Incidents
4. Select the appropriate term

_Checking Incident and Referral counts:_

1. On the top left select Show By Incident
2. Use the Copy or Excel buttons on the top right to export the incident records
3. Remove the Attendance Intervention incident records

_Checking number of OSS and days of OSS:_

1. On the top left select Show By Resolution
2. On the top right click on the Export button and choose the export type

SELECT

F.STUDENT\_NUMBER,

S.FULLNAME,

[COUNT\_OSS],

[DAYS\_OF\_OSS],

[NUM\_OF\_INCIDENTS],

[NUM\_OF\_REFERRAL]

FROM[CUSTOM].[CUSTOM\_EARLY\_WARNING\_FACT]F

JOIN[CUSTOM].[CUSTOM\_EARLY\_WARNING\_STUDENTS]SONS.STUDENTKEY=F.STUDENTKEY

JOIN[CUSTOM].[CUSTOM\_EARLY\_WARNING\_TERMS]TONT.TERMKEY=F.TERMKEY

WHEREF.TERMKEY= 25001002

AND[REPLACE FIELD HERE]&gt;0

ORDERBYSTUDENT\_NUMBER

_Notes:_

_Only students with records exports will appear in the export from DeansList, but students with no records will still be in the Early Warning System._

_The sum of the days field is equal to Days\_Of\_OSS and the count of the days field is equal to Num\_of\_OSS_



# GPA &amp; Grades

1. Log in to PowerSchool
2. Select a school
3. On the left hand side select &quot;System&quot;
4. Select &quot;Direct Database Export (DDE)&quot;
5. Under current table select &quot;StoredGrades (31)&quot;
6. In the Search StoreGrades box enter:
  1. Schoolid
  2. Termid (2502 for the 15-16 school year) -  _you must use the ##02 termid to pull stored grades and use the storecode to identify the individual term_
7. Click search all #### records in this table
8. In the Search StoreGrades box enter:
  1. Storecode (R1,R2, or R3 for the 15-16 school year)
  2. ExcludefromGPA = 0
9. Click Search _within_ the current #### records only.
10. Click export records
11. Input the fields below in the box at the top

[students]student\_number

schoolid

potentialcrhrs

[students]enroll\_status

grade

excludefromgpa

termid

storecode

[courses]credit\_hours

[courses]gradescaleid

[courses]course\_name

[courses]credittype

_To calculate GPA for all schools except KCP:_

1. Repeat steps 1-4
2. Set current table to GradeScaleItem
3. In the search GradeScaleItem box enter:
  1. Gradescaleid = 1 (use this for all schools except KCP)
4. Select export records
5. Input the fields below in the box at the top

name

gradescaleid

grade\_points

1. Add grade\_points to the stored grades export by using a vlookup on gradescaleitem.name and storedgrades.grade
2. Calculate GPA using the formula GPA = SUM((credit\_hours \* grade\_points))/SUM(credit\_hours)
3. Compare with query below

_To calculate GPA for KCP_

1. Repeat steps 1-4
2. Set current table to GradeScaleItem
3. In the search GradeScaleItem box enter:
  1. ID &gt; 0 (this just ensures that all the records are exported)
4. Select export records
5. Input the fields below in the box at the top

name

gradescaleid

grade\_points

1. Add grade\_points to the stored grades export by looking up the value based on [courses]gradescaleid and grade for the stored grades export
2. Calculate GPA using the formula GPA = SUM((credit\_hours \* grade\_points))/SUM(credit\_hours)
3. Compare with query below

SELECT

s.student\_number,

f.gpa,

f.num\_ds\_and\_fs

FROM[CUSTOM].[CUSTOM\_EARLY\_WARNING\_FACT]F

JOIN[custom].[CUSTOM\_EARLY\_WARNING\_STUDENTS]SONS.STUDENTKEY=F.STUDENTKEY

JOIN[custom].[CUSTOM\_EARLY\_WARNING\_TERMS]TONT.TERMKEY=F.TERMKEY

wheref.termkey= 25051100

orderbys.student\_number

_Notes:_

_15-16 R1 3rd grade General Knowledges (Sci & SS) grades are not available in the StoredGrades table for Quest (1013), but are in the EWS._
_15-16 R1 4th grade General Knowledges (Sci & SS) grades are not available in the StoredGrades table for Valor (1014), but are in the EWS._

# MAP/STEP/F&amp;P

1. Use the Student Acheivement – TestScores data source to compare records to the results of the queries below

**MAP\***

SELECT

s.student\_number,

t.season,

[SCALESCORE\_MATH],

[PERCENTILESCORE\_MATH],

[SCALESCORE\_READING],

[PERCENTILESCORE\_MATH]

FROM[CUSTOM].[CUSTOM\_EARLY\_WARNING\_FACT]F

JOIN[custom].[CUSTOM\_EARLY\_WARNING\_STUDENTS]SONS.STUDENTKEY=F.STUDENTKEY

JOIN[custom].[CUSTOM\_EARLY\_WARNING\_TERMS]TONT.TERMKEY=F.TERMKEY

wheref.termkey= 25051002

orderbys.student\_number



**STEP**
```SQL
SELECT

S.STUDENT\_NUMBER,

T.SEASON,

TERMNAME,

TERMID,

[STEP\_LEVEL],

[STEP\_PROFICIENCY]

FROM[CUSTOM].[CUSTOM\_EARLY\_WARNING\_FACT]F

JOIN[CUSTOM].[CUSTOM\_EARLY\_WARNING\_STUDENTS]SONS.STUDENTKEY=F.STUDENTKEY

JOIN[CUSTOM].[CUSTOM\_EARLY\_WARNING\_TERMS]TONT.TERMKEY=F.TERMKEY

WHERET.SCHOOLYEAR4DIGIT= 2016

ANDT.SCHOOLID= 1012

ORDERBYS.STUDENT\_NUMBER
```
        **F&P**

SELECT

S.STUDENT\_NUMBER,

T.SEASON,

TERMNAME,

TERMID,

[FP LEVEL],

[TARGET LEVEL]

FROM[CUSTOM].[CUSTOM\_EARLY\_WARNING\_FACT]F

JOIN[CUSTOM].[CUSTOM\_EARLY\_WARNING\_STUDENTS]SONS.STUDENTKEY=F.STUDENTKEY

JOIN[CUSTOM].[CUSTOM\_EARLY\_WARNING\_TERMS]TONT.TERMKEY=F.TERMKEY

WHERET.SCHOOLYEAR4DIGIT= 2016

ANDT.SCHOOLID= 1004

ORDERBYS.STUDENT\_NUMBER

\*F&amp;P level assigned to a term is the last entry that falls within that term
