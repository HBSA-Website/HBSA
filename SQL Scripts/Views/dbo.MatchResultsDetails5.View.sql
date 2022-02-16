USE [HBSA]
GO
/****** Object:  View [dbo].[MatchResultsDetails5]    Script Date: 12/12/2014 17:44:06 ******/
SET ANSI_NULLS ON
GO
if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'MatchResultsDetails5')
	drop view dbo.MatchResultsDetails5
GO

CREATE view dbo.MatchResultsDetails5

as

select * from MatchResults
         outer apply (Select FixtureDate from MatchResultsFixtureDates where ID=MatchResultID)FD
GO