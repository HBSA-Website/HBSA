USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'JuniorsResultsForAdmin')
	drop procedure [dbo].JuniorsResultsForAdmin
GO

create procedure  [dbo].JuniorsResultsForAdmin

as
set nocount on

SELECT ID,Division,HomePlayer,AwayPlayer,HomeFrame1,AwayFrame1,HomeFrame2,AwayFrame2,HomeFrame3,AwayFrame3
	FROM JuniorResults 
    WHERE HomePlayer <> 'Bye' 
	  AND AwayPlayer <> 'Bye'
GO
exec JuniorsResultsForAdmin 