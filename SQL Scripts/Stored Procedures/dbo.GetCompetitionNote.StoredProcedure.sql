USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetCompetitionNote')
	drop procedure GetCompetitionNote
GO
CREATE procedure GetCompetitionNote
	(@CompetitionID int
	,@RoundNo int
	,@EntryID int = NULL
	,@Admin bit = 0
	)
as

set nocount on

declare @tmpNote table
	(CompetitionID	int 
	,RoundNo		int 
	,EntryID		int 
	,PlayByDate		date 
	,Comment		varchar (256) 
	,EntrantID      int
	)

--ensure there's an entry for each round
declare @Round int
       ,@NoRounds int
	   ,@EntrantID int
select @NoRounds = NoRounds from Competitions where ID=@CompetitionID
Select @EntrantID=EntrantID from Competitions_Entries where competitionID=@CompetitionID and entryid=@EntryID and Roundno=@RoundNo
set @Round=0
while @Round < @NoRounds
	begin
	insert @tmpNote (CompetitionID,RoundNo, EntrantID)
		values (@CompetitionID,@Round,@EntrantID)
	set @Round=@Round+1
	end
	
--update play by dates
update @tmpNote 
  set PlayByDate=src.PlayByDate
  from @tmpNote tmp
  join Competitions_Rounds src
	on  tmp.CompetitionID=src.CompetitionID
	and tmp.RoundNo=src.RoundNo
	
 --add any actual notes
 insert @tmpNote
	select top 1 *,@EntrantID
		from Competitions_Rounds 
		where CompetitionID=@CompetitionID
		  and RoundNo=@RoundNo
		  and EntryID = @EntryID

--find winner if any
declare @winner int
declare @loser int

select @winner = EntrantID 
	from Competitions_Entries 
	where CompetitionID=@CompetitionID
		  and RoundNo=@RoundNo+1
		  and EntryID = @EntryID


if (@EntryID % 2) = 0
	select @loser = EntrantID 
		from Competitions_Entries 
		where CompetitionID=@CompetitionID
			  and RoundNo=@RoundNo
			  and EntryID = case when (@EntryID % 2) = 0 then @EntryID + power(2,RoundNo) else @EntryID - power(2,RoundNo) end

select top 1 note = isnull(case when @Admin=0 and @winner is not null and @winner = EntrantID and @loser is not null then 'beat'
								when @Admin=0 and @winner is not null and @winner <> EntrantID and @loser is not null then 'lost to'
				                --when EntryID is null then '' 
                                when @loser is null then ''
								else Comment
					       end,'v')	   
	from @tmpNote
	where RoundNo=@RoundNo
	  and isnull(EntryID,@EntryID)=@EntryID

 order by EntryID desc



GO

exec GetCompetitionNote 5,1,36
--exec GetCompetitionNote 1,3,0,1
--exec GetCompetitionNote 1,4,0


