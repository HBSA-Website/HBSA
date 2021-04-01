use hbsa
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='MatchTeamUsers')
	drop procedure dbo.MatchTeamUsers
GO

create procedure dbo.MatchTeamUsers
	@matchResultID int
as

set nocount on

select eMailAddress
	from MatchResults
	cross apply (select eMailAddress, Confirmed from ResultsUsers where TeamID=HomeTeamID)h
	where ID=@matchResultID
	  and Confirmed='Confirmed'
	
union

select eMailAddress
	from MatchResults
	cross apply (select eMailAddress, Confirmed from ResultsUsers where TeamID=AwayTeamID)a
	where ID=@matchResultID
	  and Confirmed='Confirmed'
							
GO

exec MatchTeamUsers 1
select * from MatchResultsDetails4 where ID=1
select * from resultsUsers where TeamID in (30,27) order by teamID desc