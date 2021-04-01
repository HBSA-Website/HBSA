USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'JuniorsSetUpLeagues')
	drop procedure JuniorsSetUpLeagues
GO

create procedure JuniorsSetUpLeagues
	(@NoOfLeagues int --must be 1, 2 or 4
    )
as

set nocount on
set xact_abort on

if not @NoOfLeagues in (1,2,4)
	throw 50001,'No of divisions must be 1, 2 or 4',1;

begin tran

truncate table JuniorLeagues

declare @DivSize int
	   ,@EntryID int
	   ,@NoEntries int
select @EntryID=0, @NoEntries=(select count(*) from Competitions_Entries where CompetitionID=10)
select @DivSize=round(@NoEntries / convert(dec(9,2),@NoOfLeagues),0)

while @EntryID <= @NoEntries
	begin
	insert JuniorLeagues
		select Division=@EntryID/@Divsize +1   --, @EntryID, @DivSize
	      ,Entrant
		  ,Club
		  ,0
		  ,((@EntryID) % @Divsize)+1
			from Competitions_Entries 
			cross apply (select Entrant=dbo.FullPlayerName(Forename,initials,surname), ClubID from Players where ID=EntrantID) p
			cross apply (select Club=[Club Name] from Clubs where ID=ClubID) c
			where CompetitionID=10
			  and EntryID=(@EntryID+1)
	set @EntryID=@EntryID + 1
	end

exec JuniorsApplyFixtures

commit tran

GO
