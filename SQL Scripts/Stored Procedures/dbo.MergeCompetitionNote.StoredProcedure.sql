USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MergeCompetitionNote')
	drop procedure MergeCompetitionNote
GO

CREATE procedure MergeCompetitionNote
	(@CompetitionID	int
	,@RoundNo		int
	,@EntryID		int = NULL
	,@PlayByDate	date = NULL
	,@Comment		varchar(256) = NULL
	)
as

set nocount on
set xact_abort on

merge
	Competitions_Rounds as target
	using (Select @CompetitionID,@RoundNo,@EntryID,@PlayByDate,@Comment) as source
		         ( CompetitionID, RoundNo, EntryID, PlayByDate, Comment)
	on target.CompetitionID=@CompetitionID
   and target.RoundNo=@RoundNo
   and isnull(target.EntryID,-99)=isnull(@EntryID,-99)
	
	when matched and @EntryID is not null and ltrim(rtrim(@Comment)) = '' then
		DELETE
	
	when matched then
		update set PlayByDate	=@PlayByDate
		         , Comment		=@Comment
				 
	when not matched and not (@EntryID is not null and ltrim(rtrim(@Comment)) = '') then
		insert  
			( CompetitionID, RoundNo, EntryID, PlayByDate, Comment)
		values
			(@CompetitionID,@RoundNo,@EntryID,@PlayByDate,@Comment);



GO
