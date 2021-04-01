use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'QualifyingMatchesPlayed')
	drop procedure QualifyingMatchesPlayed
GO

create procedure QualifyingMatchesPlayed
	(@PlayerID int)
as

set nocount on

declare  @Played int
        ,@NewRegistration tinyint

--Number of matches played this season
select @Played = count(*)
	from MatchResults
	where HomePlayer1ID=@PlayerID
	   or HomePlayer2ID=@PlayerID
	   or HomePlayer3ID=@PlayerID
	   or HomePlayer4ID=@PlayerID
	   or AwayPlayer1ID=@PlayerID
	   or AwayPlayer2ID=@PlayerID
	   or AwayPlayer3ID=@PlayerID
	   or AwayPlayer4ID=@PlayerID

--add no of matches played last season
select @Played = @Played + P
	from PlayerRecords 
	where PlayerID=@PlayerID
	  and Season=(select datepart(year,[value]) from [Configuration] where [key] = 'CloseSeasonEndDate')

--set new registration if no playing record from last season
select @NewRegistration = case when Count(*) = 0 then 1 else 0 end
	from PlayerRecords 
	where PlayerID=@PlayerID
	  and Season=(select datepart(year,[value]) from [Configuration] where [key] = 'CloseSeasonEndDate')

select Played = @Played, NewRegistration = @NewRegistration

GO

exec QualifyingMatchesPlayed 2408
exec QualifyingMatchesPlayed 236