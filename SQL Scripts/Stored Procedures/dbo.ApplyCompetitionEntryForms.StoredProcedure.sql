USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ApplyCompetitionEntryForms')
	drop procedure ApplyCompetitionEntryForms
GO

CREATE procedure ApplyCompetitionEntryForms
	(@CompID int = 0 -- NON	 zero implies only apply that competition's entries
	)
as

set nocount on
set xact_abort on

begin tran

--Clear competition(s)
if @CompID = 0
	exec ClearCompetitions
else
	exec ClearCompetition @CompID


--work thru each competition, transferring entrants
create table #temp
	(CompetitionID int
	,EntryID int identity (1,1)
	,DrawID int
	,RoundNo int
	,EntrantID int
	,Entrant2ID int
	)
declare Competitions_cursor cursor fast_forward for
	select distinct CompetitionID
		from Competitions_EntryForms
		where @CompID = 0 or CompetitionID = @compID
declare @CompetitionID int
open Competitions_cursor
fetch Competitions_cursor into @CompetitionID
while @@fetch_status=0
	begin
	truncate table #temp  
	insert #temp     --build #temp using identity to populate entryid
		select @CompetitionID
			  ,NULL, 0
			  ,EntrantID
			  ,Entrant2ID
			from Competitions_EntryForms
			cross apply (Select PrivacyAccepted 
							from Competitions_EntryFormsClubs 
							where ClubID = Competitions_EntryForms.ClubID) Privacy
			where CompetitionID=@CompetitionID
			  and PrivacyAccepted = 1

	
	insert Competitions_Entries --now transfer to actual table with identities per competition
		select * from #temp

	fetch Competitions_cursor into @CompetitionID

	end

close Competitions_cursor
deallocate Competitions_cursor

if @CompID = 0
	begin
	--class all entry forms as fixed
	update Competitions_EntryFormsClubs
		set WIP=3

	--Inhibit entry forms
	update configuration
		set value='0'
		where [key]='AllowCompetitionsEntryForms'
	end

commit tran

--report clubs without PrivacyAccepted
Select [Club Name], 
	   Contact=ContactName, 
	   Mobile=ContactMobNo, 
	   eMail=ContactEMail, 
	   [Tel No]=ContactTelNo, 
	   [No of Entrants]=EntrantsCount

	from Competitions_EntryFormsClubs E
	outer apply (select [Club Name], 
						ContactName, 
					    ContactMobNo, 
						ContactEMail, 
						ContactTelNo
	    from ClubsDetails where ID=ClubID) C
	outer apply (select EntrantsCount=count(*) from Competitions_EntryForms where ClubID=E.ClubID)Entrants
	where PrivacyAccepted = 0
	  and EntrantsCount > 0

GO

--exec ApplyCompetitionEntryForms 