USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetAllClubs]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GetAllClubs')
	drop procedure [dbo].[GetAllClubs]
GO

CREATE procedure [dbo].[GetAllClubs]

as

set nocount on

select
	 ID	= isnull(ID,'')
	,[Club Name]	= isnull([Club Name],'')
	,Address1	= isnull(Address1,'')
	,Address2	= isnull(Address2,'')
	,PostCode	= isnull(PostCode,'')
	,ContactName	= isnull(ContactName,'')
	,ClubUserEMail	= isnull(ContactEMail,'')
	,ContactTelNo	= isnull(ContactTelNo,'')
	,ContactMobNo	= isnull(ContactMobNo,'')
	,AvailableTables=MatchTables

	from ClubsDetails 
	where [Club Name] <> 'Bye'
	ORDER BY [Club Name]
GO
