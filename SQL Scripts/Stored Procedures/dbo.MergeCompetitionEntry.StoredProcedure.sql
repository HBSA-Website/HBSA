USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ReplaceCompetitionEntry')
	drop procedure ReplaceCompetitionEntry
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'AddCompetitionEntry')
	drop procedure AddCompetitionEntry
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MergeCompetitionEntry')
	drop procedure MergeCompetitionEntry
GO
create procedure [dbo].[MergeCompetitionEntry]
	(@CompetitionID int
	,@EntryID int   --Note:  -1 = add new entrant, otherwise replace existing entrant with new one.
	,@EntrantID int
	,@Entrant2ID int = NULL
	)
as		

set nocount on
set xact_abort on

--to add a new entry need to ensure that the draw has not been made
if @EntryID = -1
	if (select isnull(NoRounds,0) from Competitions  where ID=@CompetitionID) > 0
		begin
		raiserror ('Cannot add entry after the draw has been made',15,0)
		return
		end

begin tran

declare @Entrant varchar(55)
declare @nullEntrantEntryID int

if @Entrant2ID is null
	if (select COUNT(*) from Competitions_Entries 
			where CompetitionID=@CompetitionID 
			  and (EntrantID=@EntrantID or
	              (Entrant2ID is not null and Entrant2ID=@EntrantID))) > 0
		begin
		select @Entrant = dbo.FullPlayerName(Forename, Initials, Surname) 
			from Players where ID=@EntrantID
		raiserror ('This Entrant (%s) already exists',15,0,@Entrant)
		end 

	else
		if @EntryID = -1
			begin
			select top 1 @nullEntrantEntryID=EntryID from Competitions_Entries 
				where CompetitionID=@CompetitionID 
				  and EntrantID is null 
				order by DrawID
			if @nullEntrantEntryID is null
				insert Competitions_Entries 
					select   @CompetitionID 
					        ,(select isnull(max(EntryID),0) from Competitions_Entries where CompetitionID=@CompetitionID)+1 
							,NULL,0,@EntrantID,NULL
			else
				update Competitions_Entries 
					set EntrantID=@EntrantID
					   ,Entrant2ID=NULL 
					where CompetitionID=@CompetitionID 
				      and EntryID=@nullEntrantEntryID
			end
		else
			update Competitions_Entries 
				set EntrantID=@EntrantID
				   ,Entrant2ID=NULL 
				where CompetitionID=@CompetitionID 
				  and EntryID=@EntryID

else
	if (select COUNT(*) from Competitions_Entries 
		where CompetitionID=@CompetitionID 
		  and (EntrantID=@EntrantID or
              (Entrant2ID is not null and Entrant2ID=@EntrantID))) > 0
		begin
		select @Entrant = dbo.FullPlayerName(Forename, Initials, Surname) 
			from Players 
			where ID=@EntrantID
		raiserror ('This Entrant (%s) already exists',15,0,@Entrant)
		end 
	else
		if (select COUNT(*) from Competitions_Entries 
			where CompetitionID=@CompetitionID 
			 and (EntrantID=@Entrant2ID or
			     (Entrant2ID is not null and Entrant2ID=@Entrant2ID))) > 0
			begin
			declare @Entrant2 varchar(55)
			select @Entrant2 = dbo.FullPlayerName(Forename, Initials, Surname) 
				from Players 
				where ID=@Entrant2ID
			raiserror ('This Entrant (%s) already exists',15,0,@Entrant2)
			end

		else
			if @EntryID = -1
				begin
				select top 1 @nullEntrantEntryID=EntryID 
					from Competitions_Entries 
					where CompetitionID=@CompetitionID 
					 and EntrantID is null
					order by DrawID
				if @nullEntrantEntryID is null
					insert Competitions_Entries 
						select @CompetitionID 
					         ,(select isnull(max(EntryID),0) from Competitions_Entries where CompetitionID=@CompetitionID)+1 
							 ,NULL,0,@EntrantID,@Entrant2ID
				else
					update Competitions_Entries  
						set EntrantID=@EntrantID
						   ,Entrant2ID=@Entrant2ID 
						where CompetitionID=@CompetitionID 
						  and EntryID=@nullEntrantEntryID
				end
			else
				update Competitions_Entries  
					set EntrantID=@EntrantID
					   ,Entrant2ID=@Entrant2ID 
					where CompetitionID=@CompetitionID 
					  and EntryID=@EntryID
commit tran

GO


