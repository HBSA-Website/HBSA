USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'HomePageArticle')
	drop procedure dbo.HomePageArticle
GO

create procedure dbo.HomePageArticle
	(@ID as integer
	)
as	

set nocount on

select ID, Title, ArticleHTML,dtLodged
	from HomeContent
	where ID = @ID

GO
