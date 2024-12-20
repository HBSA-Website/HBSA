USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Covid19Compliance_Report')
	drop procedure dbo.Covid19Compliance_Report
GO

create procedure  dbo.Covid19Compliance_Report 
	(@ClubID int = 0
	)
as

set nocount on

select C.[Club Name], Covid19Compliance.*
	From Covid19Compliance 
	cross apply (select [club name] from Clubs where ID = ClubID) C
	where @ClubID=0 or @ClubID = ClubID
	order by [Club Name]
GO
exec Covid19Compliance_Report