USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'TagDescription')
	drop function TagDescription

/****** Object:  UserDefinedFunction [dbo].[TagDescription]    Script Date: 12/12/2014 17:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TagDescription] 
	(@Tag int
	)
RETURNS varchar(20)
AS
BEGIN

	return case when @Tag=3 then 'Unseasoned'
		        when @Tag=2 then '2 seasons to go'
				when @Tag=1 then '1 season to go'
				              else ''
           end
END


GO

select dbo.TagDescription(0),dbo.TagDescription(1),dbo.TagDescription(2),dbo.TagDescription(3)
