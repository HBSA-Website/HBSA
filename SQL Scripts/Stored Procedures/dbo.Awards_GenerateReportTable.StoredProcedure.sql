USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Awards_GenerateReportTable')
	drop procedure Awards_GenerateReportTable
GO

CREATE procedure dbo.Awards_GenerateReportTable

as

set nocount on
set xact_abort on

begin tran

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Awards_Report_Table')
	drop table Awards_Report_Table

Create table dbo.Awards_Report_Table
	([League Name] varchar (50)
	,Competition varchar(255)
	,Trophy varchar(255)
	,Winner varchar(255)
	,Award varchar(255)
	,AwardType int
	,AwardID int
	,SubId int
	,LeagueID int
	,EntrantID int
	,Entrant2ID int
	)
insert Awards_Report_Table
	exec Awards_Report

commit tran

GO