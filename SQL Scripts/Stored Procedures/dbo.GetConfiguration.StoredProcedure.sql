USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetConfiguration]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetConfiguration')
	drop procedure GetConfiguration
GO

create procedure [dbo].[GetConfiguration]

as

set noCount on	

select [Key],[Value] 
	from Configuration
	order by [Key]


GO
