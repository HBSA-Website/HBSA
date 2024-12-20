USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FullPlayerName')
	drop function FullPlayerName

/****** Object:  UserDefinedFunction [dbo].[FullPlayerName]    Script Date: 12/12/2014 17:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FullPlayerName] 
	(@Forename varchar(50)
	,@Inits varchar(4)
	,@Surname varchar(50)
	)
RETURNS varchar(110)
AS
BEGIN

	return @Forename +
	       case when @Inits='' then ' '
		        when @Inits='jnr' then ' (Jnr) '
				when @Inits='snr' then ' (Snr) '
				when @Inits='van' then ' Van '
		                       else ' ' + @Inits + '. '
		   end +
		   @Surname					    
END


GO

select dbo.FullPlayerName('Dom','','Surnamne'),dbo.FullPlayerName('Ulysses','S','Grant')
