USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ScratchCompetitionEntry')
	drop procedure ScratchCompetitionEntry
GO
create procedure ScratchCompetitionEntry
	(@CompetitionID int
	,@EntryID int
	,@RoundNo int
	)

as

set nocount on
	
--determine next Entrant ID
declare @nextID int
set @nextID=floor((@EntryID / power(2,@RoundNo))/2)*power(2,@RoundNo+1)

if (select count(*) 
		from Competitions_Entries 
		where CompetitionID=@CompetitionID
		  and EntryID = @nextID
		  and RoundNo = @RoundNo+1) > 0
	raiserror ('Cannot scratch an entry that has already has a winner.',15,0)
else
	begin
	insert Competitions_Entries
		(CompetitionID,EntryID,DrawID,RoundNo,EntrantID,Entrant2ID)
		select @CompetitionID, @nextID, DrawID,RoundNo+1,NULL,NULL
			from Competitions_Entries
			where CompetitionID=@CompetitionID
		      and EntryID = @EntryID
			  and RoundNo = @RoundNo
	end
GO
