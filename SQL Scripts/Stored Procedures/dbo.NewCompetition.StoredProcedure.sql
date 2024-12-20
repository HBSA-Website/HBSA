USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'NewCompetition')
	drop procedure NewCompetition
GO
create procedure NewCompetition
	(@Name varchar(50)
	,@LeagueID int
	,@CompType int    --1 = Individual, 2 = Pair, 3 = Team
	,@Comment varchar(256)
	,@Remove bit = 0 --set to 1 to delete from Competitions table
	,@EntryForm bit --set to 1 for comps that need an entry form entry
	,@EntryFee decimal(5,2)
	)
as		

set nocount on
set xact_abort on 

declare @CompetitionID int
select @CompetitionID=ID from Competitions where Name=@Name

if @remove = 0 and @CompetitionID is not null
	raiserror ('This competition (%s) already exists',15,0,@name)
else
    begin
    
	begin tran
    
    if @CompetitionID is not null
		delete Competitions where ID=@CompetitionID
	
	delete Competitions_Entries where CompetitionID=@CompetitionID
	delete Competitions_Rounds  where CompetitionID=@CompetitionID   
 
    insert Competitions 
		select @Name,@LeagueID,@CompType,null,@Comment,@EntryForm,@EntryFee
	
    set @CompetitionID=SCOPE_IDENTITY()
	delete Competitions_Entries where CompetitionID=@CompetitionID
	delete Competitions_Rounds  where CompetitionID=@CompetitionID   
	
	commit tran

	end


GO

exec NewCompetition 'Snooker Championship',1,1,'',0 ,1,8.00
select * from Competitions
