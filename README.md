# Early-Warning-System
The Early Warning System (EWS) tables exist in the Custom schema of the data warehouse (ARC). The schema follows the same model as the standard Schoolzilla (SZ) data blocks, and includes one Fact table and several dimension tables.

##Getting Started

###Usage
Use these tables to create views and dashboards in Tableau that contain measures from several domains (e.g. grades, attendance, behavior, etc.) without needing to write custom sql or blend data sources.


When creating a view a term must be selected in a filter or added to the view, or you risk inflating measure values.

###Tables
####Fact
This table includes the measures for each domain and Keys for connecting to other tables. The Fact and Dimension tables can be joined using an **inner join** on the dimension key. There is for each student and term in the table. Term keys are a combination of the the ID from the Powerschool Terms table and the School_Number from the Powerschool Schools table. 
####DimStudent
####DimTerms

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
