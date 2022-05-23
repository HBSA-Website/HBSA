USE HBSA
GO
if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'DownloadHandicapsSeason')
	drop procedure dbo.DownloadHandicapsSeason
go

create procedure dbo.DownloadHandicapsSeason

as

set nocount on



select isnull(convert (varchar, DATEPART(year, min(Effective))) + '/' +
	          convert (varchar, (DATEPART(year, min(Effective))+1) % 100) 
			  ,'No handicaps to report')
	from HandicapsReportTable

select PlayerID, Effective=convert(varchar(11), max(Effective), 113)  
	into #RecordSelector
	from HandicapsReportTable
	group by PlayerID

GO
exec DownloadHandicapsSeason
