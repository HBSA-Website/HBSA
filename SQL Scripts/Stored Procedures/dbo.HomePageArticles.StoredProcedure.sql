USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'HomePageArticles')
	drop procedure HomePageArticles
GO

create procedure dbo.HomePageArticles

as	

set nocount on

select ID, Title, [Date recorded]=convert (varchar(11),dtLodged,113) 
	from HomeContent
	order by dtLodged desc

GO
