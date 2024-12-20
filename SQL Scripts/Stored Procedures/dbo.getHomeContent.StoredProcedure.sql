USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[adminCheckLogin]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'getHomeContent' and SPECIFIC_SCHEMA='dbo')
	drop procedure dbo.getHomeContent
GO

create procedure dbo.getHomeContent

as

set noCount on	

select [Date Recorded] = convert(varchar(11),dbo.UKdateTime(dtlodged),113)
      ,Title=Title
      ,Article=ArticleHTML
	  
	from HomeContent
	order by dtLodged desc
GO
exec getHomeContent
