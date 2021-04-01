USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ResequenceCompetitionEntryIDs')
	drop procedure ResequenceCompetitionEntryIDs
GO
create procedure [dbo].ResequenceCompetitionEntryIDs
	(@CompetitionID int
	)
as

declare @Entries table(
	CompetitionID int,
	EntryID int identity (0,1),
	DrawID int NULL,
	RoundNo int NULL,
	EntrantID int NULL,
	Entrant2ID int NULL
)

set nocount on
set xact_abort on

if (select max(roundNo) from Competitions_Entries where CompetitionID=@CompetitionID) > 0 
		raiserror ('Cannot resequence if the draw has been made.  Make 1st round. if required',15,0)
else
begin
begin tran

Insert @Entries  --this creates new EntryIDs, and nullifies the DrawIDs
	select CompetitionID,DrawID,RoundNo,EntrantID,Entrant2ID
		from Competitions_Entries
		where CompetitionID=@CompetitionID
		order by RoundNo, DrawID

delete Competitions_Entries
		where CompetitionID=@CompetitionID
Insert Competitions_Entries 
	select *
		from @Entries
		where CompetitionID=@CompetitionID

commit tran

end

GO

exec ResequenceCompetitionEntryIDs 3
select * from Competitions_Entries where CompetitionID=3 order by roundNo, entryID