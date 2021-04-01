USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'JuniorsResultsExist')
	drop procedure [dbo].JuniorsResultsExist
GO

create procedure  [dbo].JuniorsResultsExist

as
set nocount on

select case when ISNULL(sum(HomeFrame1)+sum(awayFrame1),0) > 0
				then 1
				else 0
		end
	from Juniorresults

GO
exec [dbo].JuniorsResultsExist 