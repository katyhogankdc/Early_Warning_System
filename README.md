# Early-Warning-System
The Early Warning System (EWS) tables exist in the Custom schema of the data warehouse (ARC). The schema follows the same model as the standard Schoolzilla (SZ) data blocks, and includes one Fact table and several dimension tables.

##Getting Started

###Usage
Use these tables to create views and dashboards in Tableau that contain measures from several domains (e.g. grades, attendance, behavior, etc.) without needing to write custom sql or blend data sources.


When creating a view a term must be selected in a filter or added to the view, or you risk inflating measure values.

###Tables
####Fact
This table includes the measures for each domain and Keys for connecting to other tables. The Fact and Dimension tables can be joined using an **inner join** on the dimension key. There is one record for each student and term in the table.

The assessment growth value depends on the term (or season) of the record. The table below outlines which growth values correspond to each term.

| Term               | F2F | F2W | F2S | W2W | W2S | S2S |
|--------------------|-----|-----|-----|-----|-----|-----|
| Fall               | Yes |     |     |     |     |     |
| Winter             |     | Yes |     | Yes |     |     |
| Spring (not added) |     |     | Yes |     |     | Yes |

####DimStudent
This DimStudent table includes dimension values related to student attributes. All values represent a students **current** status. There is no historical information in this table. For example, the school in the SchoolName field is the school in which the student is currently enrolled.
####DimTerms
The DimTerms table includes dimesion values related to term attributes. Term keys are a combination of the the ID from the Powerschool Terms table and the School_Number from the Powerschool Schools table. Some terms, like *School Year* and *2015-2016* are inclusive of other terms. Be careful of your term selections so you are not multiplying measure values.

The field *CommonTerm* is an integer between 1 and 6 and can be used to align terms across school years with differing term structures.

| Term   | Quarter       | Trimester     | Semester      | Season |
|--------|---------------|---------------|---------------|--------|
|  0     | Summer        | Summer        | Summer        | Summer |
|  1     | Q1            | TR1           |               | Fall   |
|  2     | Q2            | TR2           | S1            | Winter |
|  3     | Q3            |               |               |        |
|  4     | Q4            | TR3           | S2            | Spring |
|  5     | Academic Year | Academic Year | Academic Year | EOY    |
|  6     | Full Year     | Full Year     | Full Year     |        |

###Example Query
``` SQL
SELECT *
FROM [CUSTOM].[CUSTOM_EARLY_WARNING_FACT] F
JOIN [custom].[CUSTOM_EARLY_WARNING_STUDENTS] S ON S.STUDENTKEY = F.STUDENTKEY
JOIN [custom].[CUSTOM_EARLY_WARNING_TERMS] T ON T.TERMKEY = F.TERMKEY
``` 

###Implementation Notes
* There are several records for which it was not possible to assign a TermKey, so a value of -1 was assigned.
* Behavior related measures only contain records from DeansList, and only include the 15-16 school year and beyond

###Questions or Concerns
Contact <datasupport@kippdc.org>
