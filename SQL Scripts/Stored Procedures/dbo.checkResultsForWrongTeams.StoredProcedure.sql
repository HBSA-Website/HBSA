USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'checkResultsForWrongTeams')
	drop procedure checkResultsForWrongTeams
GO

CREATE procedure [dbo].[checkResultsForWrongTeams]

as

set nocount on

declare @SectionID int
declare @Fixtures table (MatchDate date, HomeFixtureNo int, AwayFixtureNo int, SectionID int)
select @SectionID =  MIN(ID) from sections
while @SectionID <= (select max(ID) from sections)
	begin
	Insert @Fixtures
		exec FixtureDatesBySection @SectionID 
	set @SectionID = @SectionID + 1
	end

select R.MatchDate,L.[League Name],S.[Section Name],
       [Home Team]=HC.[Club Name]+' '+HT.Team, --HT.ID,HT.FixtureNo,
       [Away Team]=AC.[Club Name]+' '+AT.Team ,--AT.ID,AT.FixtureNo,
       case when FR.MatchDate IS null 
				then case when FD.MatchDate IS not null
								then 'Possible wrong match date'
								else ''
				     end		   		 
				else 'Wrong home team' end as Comment,
       R.ID
	from MatchResults R
	join Teams HT on R.HomeTeamID=HT.ID
		Join Clubs HC on HT.ClubID=HC.ID 
	join Teams AT on R.AwayTeamID=AT.ID
		Join Clubs AC on AT.ClubID=AC.ID     
	join Sections S on S.ID=HT.SectionID 
	join Leagues L on L.ID=S.LeagueID 

	left join @Fixtures	F
	       on F.MatchDate=R.MatchDate
	      and F.HomeFixtureNo=HT.FixtureNo
	      and F.AwayFixtureNo=AT.FixtureNo
	      and F.SectionID=HT.SectionID
    
    left join @Fixtures FR
	       on FR.MatchDate=R.MatchDate
	      and FR.HomeFixtureNo=AT.FixtureNo
	      and FR.AwayFixtureNo=HT.FixtureNo
	      and FR.SectionID=HT.SectionID
    
    left join @Fixtures FD
	       on FD.HomeFixtureNo=HT.FixtureNo
	      and FD.AwayFixtureNo=AT.FixtureNo
	      and FD.SectionID=HT.SectionID
    
	where F.HomeFixtureNo is null       


GO
exec [checkResultsForWrongTeams]