USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ApplyNewPlayerTags')
	drop procedure ApplyNewPlayerTags
GO

create Procedure [dbo].[ApplyNewPlayerTags]

as

set nocount on
set xact_abort on

if (select count(*) from MatchResults) = 0
	throw 50000,'No match results - No tags changed.',1;

begin tran

declare @NoOfSeasonsToUntag int
       ,@TagNoOfMatchesToPlay int
       ,@thisSeason int

select @NoOfSeasonsToUntag = [Value] 
      ,@thisSeason = datepart(year,dbo.UKdateTime(getUTCdate())) 
	from [Configuration] 
	where [Key]='TagNoOfSeasonsToUntag' 

select @TagNoOfMatchesToPlay = [Value]
	from [Configuration]
	where [Key] = 'TagNoOfMatchesToPlay'

--identify qualifying seasons as those that exist in playing records
declare @SeasonsToQualify table (ID int identity(1,1),season int)
insert into @SeasonsToQualify
	select distinct top (@NoOfSeasonsToUntag) Season 
		from PlayerRecords 
		order by Season desc

declare @Surname varchar(50)
       ,@Forename varchar(50)
	   ,@Initials varchar(4)
	   ,@PlayerID int
	   ,@LeagueID int
       ,@newTag int
       ,@QualifyingSeasonID int

declare playersCursor cursor fast_forward for
	select Surname, Forename, Initials, ID, LeagueID from Players where ID > 0

open playersCursor
fetch playersCursor into @Surname, @Forename, @Initials, @PlayerID, @LeagueID
while @@fetch_status = 0
	begin
	declare @prLeagueID int
	      , @Player varchar(255)
		  , @Season int
		  , @Team char(1)
	declare playerRecordsCursor cursor fast_forward for
		select distinct LeagueID, Player, Season, Team
            from PlayerRecords
            where PlayerID=@PlayerID
              and Season >= (select min(Season) from @SeasonsToQualify)
              group by LeagueID, Player, Season, Team, PlayerID
              having sum(P) >= @TagNoOfMatchesToPlay
              order by season desc

	set @newTag = @NoOfSeasonsToUntag --start at max rag
	set @QualifyingSeasonID=1

	open playerRecordsCursor
	fetch playerRecordsCursor into @prLeagueID, @Player, @Season, @Team
	while @@fetch_status = 0
		begin
		--adjust tag according to qualifying seasons
		if @season = (select season from @SeasonsToQualify where ID = @QualifyingSeasonID)
			begin
			set @newTag = @newTag - 1
			set @QualifyingSeasonID = @QualifyingSeasonID + 1
			end
		else
			break  --jump out of while @@fetch_status = 0 loop
	
		fetch playerRecordsCursor into @prLeagueID, @Player, @Season, @Team
		end
	close playerRecordsCursor
	deallocate playerRecordsCursor

	update Players 
		set Tagged = @newTag 
        where ID = @PlayerID
	
	fetch playersCursor into @Surname, @Forename, @Initials, @PlayerID, @LeagueID
	end

close playersCursor
deallocate playersCursor

commit tran
GO

exec ApplyNewPlayerTags
