USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[MissingResults]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MissingResults')
	drop procedure [dbo].[MissingResults]
GO

CREATE procedure [dbo].[MissingResults]

as

set nocount on

 select [Fixture Date] = convert(varchar(11),F.FixtureDate,113)
	  ,Section=[League Name] + ' ' +[Section Name]
	  ,[Home Team] = rtrim(HC.[Club Name] + ' ' + HT.Team)
	  ,[Away Team] = rtrim(AC.[Club Name] + ' ' + AT.Team)
	from FixtureLinks F
	outer apply (select ID 
					from MatchResultsDetails5 M
					 where  F.HomeTeamID = M.HomeTeamID
				      and F.AwayTeamID = M.AwayTeamID
					  and F.FixtureDate = M.FixtureDate ) MID
	cross apply (select ClubID, Team from Teams where ID=F.HomeTeamID) HT 
	cross apply (select ClubID, Team from Teams where ID=F.AwayTeamID) AT 
	cross apply (select [Section Name], LeagueID from Sections where ID = F.SectionID) S
	cross apply (select [League Name] from Leagues where ID = S.LeagueID) L
	cross apply (select [Club Name] from Clubs where ID = HT.ClubID) HC
	cross apply (select [Club Name] from Clubs where ID = AT.ClubID) AC
	where F.FixtureDate < CONVERT(date,dbo.UKdateTime(GETUTCDATE()))
	  and MID.ID is null
	  and HT.ClubID <> 8
	  and AT.ClubID <> 8
	  order by F.FixtureDate,SectionID,[Home Team]

GO
exec [MissingResults]