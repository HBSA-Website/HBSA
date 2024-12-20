USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MakeCompetitionDraw')
	drop procedure MakeCompetitionDraw
GO

create procedure [dbo].[MakeCompetitionDraw]
	(@CompetitionID int
	)

as

set nocount on

begin tran
	
--Ensure it's in the correct state
exec MakeCompetition1stRound @CompetitionID

--Create random draw Ids
declare MakeCompetitionDrawCursor cursor fast_forward for
	select EntryID from Competitions_Entries 
		where CompetitionID=@CompetitionID 
declare @EntryID int
       ,@Norecs int
select @Norecs=COUNT(*) from Competitions_Entries where CompetitionID=@CompetitionID       
open MakeCompetitionDrawCursor
fetch MakeCompetitionDrawCursor into @EntryID
while @@FETCH_STATUS=0
	begin
	update Competitions_Entries 
		set DrawID= convert(int,RAND()*100000000)*10 
		where EntryID=@EntryID
	fetch MakeCompetitionDrawCursor into @EntryID
	end
close MakeCompetitionDrawCursor
deallocate MakeCompetitionDrawCursor

--add Null entrants (byes) to make up the number of entrants to a power of 2
declare @RequiredRecs int
       ,@DrawID int
select @Norecs=COUNT(*) from Competitions_Entries where CompetitionID=@CompetitionID

set @RequiredRecs=1
while @RequiredRecs<@Norecs
	set @RequiredRecs=@RequiredRecs*2

declare OrderCompetitionDrawCursor cursor fast_forward for
	select DrawID from Competitions_Entries where CompetitionID=@CompetitionID order BY DrawID desc
open OrderCompetitionDrawCursor
fetch OrderCompetitionDrawCursor into @DrawID
while @RequiredRecs > (select COUNT(*) from Competitions_Entries where CompetitionID=@CompetitionID)
	begin
	insert Competitions_Entries  
		select @CompetitionID, NULL, @DrawID+5,0,NULL,NULL
	fetch OrderCompetitionDrawCursor into @DrawID
	end
close OrderCompetitionDrawCursor
deallocate OrderCompetitionDrawCursor		

--create new EntryIds
exec ResequenceCompetitionEntryIDs @CompetitionID

--promote those with Byes
insert Competitions_Entries
	(CompetitionID,EntryID,DrawID,RoundNo,EntrantID,Entrant2ID)
	
	select winner.CompetitionID,winner.EntryID,winner.DrawID,winner.RoundNo+1,winner.EntrantID,winner.Entrant2ID
		from Competitions_Entries loser
		JOIN Competitions_Entries winner
		  on loser.CompetitionID=winner.CompetitionID
		 and loser.drawid=winner.DrawID+5 
		 and loser.RoundNo=winner.RoundNo
		left join Competitions_Entries next
		  on winner.CompetitionID=next.CompetitionID
		 and winner.EntryID=next.EntryID 
		 and winner.DrawID=next.DrawID 
		 and winner.RoundNo+1=next.RoundNo 

		where loser.CompetitionID=@CompetitionID
		  and loser.EntrantID is null
		  and next.EntryID is null
		  
--update the competition with the number of rounds needed
update Competitions
	set NoRounds = (select dbo.integerRoot((select count(*) 
												from Competitions_Entries 
												where CompetitionID=@CompetitionID
												and RoundNo=0),2))
	where ID = @CompetitionID


--Initialise the Competitions_Rounds table
delete Competitions_Rounds
	where CompetitionID = @CompetitionID

insert Competitions_Rounds
	(CompetitionID, RoundNo)
	values
	(@CompetitionID,0)
 
commit tran

GO

exec MakeCompetitionDraw 3

select * from Competitions_Entries where CompetitionID=3
