use hbsa
go

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_HighBreaksByLeague')
	drop procedure dbo.Awards_HighBreaksByLeague
GO

create procedure dbo.Awards_HighBreaksByLeague

as

set nocount ON
set xact_abort on

begin tran

--Get highest breaks by category
declare @HighBreaks table
	(LeagueID int, [High Break] int)
insert @HighBreaks
	select LeagueID, [High Break]=Max([Break])  
						from Breaks B2
						cross apply (Select HomeTeamID from Matchresults where ID=MatchResultID)M2
						cross apply (select SectionID from Teams where ID=HomeTeamID)T2
						cross apply (select LeagueID=ID, [League Name] from Leagues where ID=(select LeagueID from Sections where ID=T2.sectionID))L2
						cross apply (Select Player=dbo.FullPlayerName(Forename,Initials, Surname), Handicap from Players where ID=B2.PlayerID)P2
						cross apply (Select LowHandicap, HighHandicap, BreakCategory=ID from BreaksCategories where LeagueID=L2.LeagueID and Handicap between LowHandicap and HighHandicap)BC2
						group by LeagueID

delete Awards where AwardType=4

insert Awards
	select AwardType=4
		  ,ID=NULL
		  ,SubID=NULL
		  ,LeagueID=L.LeagueID
		  ,EntrantID=PlayerID
		  ,Entrant2ID=[Break]
	from Breaks B
	cross apply (Select HomeTeamID from Matchresults where ID=MatchResultID)M
	cross apply (select SectionID from Teams where ID=HomeTeamID)T
	cross apply (select LeagueID=ID, [League Name] from Leagues where ID=(select LeagueID from Sections where ID=T.sectionID))L
	cross apply (Select Player=dbo.FullPlayerName(Forename,Initials, Surname), Handicap from Players where ID=B.PlayerID)P
	cross apply (Select LowHandicap, HighHandicap, BreakCategory=ID from BreaksCategories where LeagueID=L.LeagueID and Handicap between LowHandicap and HighHandicap)BC
    cross apply (select * from @HighBreaks where LeagueID=(select LeagueID from Sections where ID=T.sectionID) and BreakCategory=BC.BreakCategory and [High Break]=B.[Break])HB
	
	order by L.LeagueID, BC.BreakCategory, [Break] desc

commit tran

GO

exec Awards_HighBreaksByLeague
exec Awards_Report 4
