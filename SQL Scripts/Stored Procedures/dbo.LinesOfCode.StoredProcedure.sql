use HBSA
GO

if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='LinesOfCode')
	drop procedure dbo.LinesOfCode
GO

create procedure dbo.LinesOfCode

as

set nocount on

SELECT TYPE,
	   LEN(definition)- LEN(REPLACE(definition,CHAR(10),'')) AS LinesOfCode,
       OBJECT_NAME(OBJECT_ID) AS NameOfObject
	into #tempCounters
	FROM sys.all_sql_modules a
	JOIN sysobjects s
			ON a.OBJECT_ID = s.id
	WHERE OBJECTPROPERTY(OBJECT_ID,'IsMSShipped') = 0

SELECT DB_NAME(DB_ID()) as [DB_Name],
       Type,
       COUNT(*)  AS Object_Count,
       SUM(LinesOfCode) AS LinesOfCode
	FROM #tempCounters
GROUP BY TYPE
UNION
SELECT DB_NAME(DB_ID()) as [DB_Name],
       'All',
       COUNT(*)  AS Object_Count,
       SUM(LinesOfCode) AS LinesOfCode
	FROM #tempCounters

drop table #tempCounters

GO
exec LinesOfCode
