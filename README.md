# Early-Warning-System
The Early Warning System (EWS) tables exist in the Custom schema of the data warehouse (ARC). The schema follows the same model as the standard Schoolzilla (SZ) data blocks, and includes one Fact table and several dimension tables.

##Getting Started

###Usage
Use these tables to create views and dashboards in Tableau that contain measures from several domains (e.g. grades, attendance, behavior, etc.) without needing to write custom sql or blend data sources.

The Fact and Dimension tables can be joined using an **inner join** on the dimension key.<br>
*There are several records for which it was not possible to assign a TermKey, so a value of -1 was assigned.*

###Example Query
``` SQL
SELECT *
FROM [CUSTOM].[CUSTOM_EARLY_WARNING_FACT] F
JOIN [custom].[CUSTOM_EARLY_WARNING_STUDENTS] S ON S.STUDENTKEY = F.STUDENTKEY
JOIN [custom].[CUSTOM_EARLY_WARNING_TERMS] T ON T.TERMKEY = F.TERMKEY
``` 
