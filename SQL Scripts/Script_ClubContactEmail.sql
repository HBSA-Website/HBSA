use HBSA
GO

alter table Clubs
	drop column ContactEMail
alter table EntryForm_Clubs
	drop column ContactEMail
GO
if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where routine_name='eMailsForClub')
	drop function [dbo].[eMailsForClub]
GO

create FUNCTION [dbo].[eMailsForClub]
	(@ClubID int
	)

RETURNS varchar(4000)

AS

BEGIN

declare @eMails table (eMail varchar(255))

--insert @emails select isnull(ContactEMail,'') from Clubs where ID=@ClubID
insert @emails select isnull(eMailAddress,'') from ClubUsers where ClubID=@clubID
insert @emails select isnull(eMailAddress,'') from resultsUsers join teams on teams.ID=TeamID where ClubID=@clubID
--insert @emails select isnull(email,'') from teams where ClubID=@clubID

declare eMailAdressesCursor cursor fast_forward for 
	select distinct * from @eMails where eMail <> ''
declare @eMailAddressList varchar(max)
	   ,@eMailAddress varchar(255)
set @eMailAddressList=''
open eMailAdressesCursor
fetch eMailAdressesCursor into @eMailAddress
while @@FETCH_STATUS=0
	begin
	set @eMailAddressList = @eMailAddressList+@eMailAddress + ';'
	fetch eMailAdressesCursor into @eMailAddress
	end

close eMailAdressesCursor
deallocate eMailAdressesCursor

 return left(@eMailAddressList,len(@eMailAddressList)-1)
 
END
GO

ALTER TRIGGER [dbo].[HandicapChange]
   ON  [dbo].[Players]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--log changes to handicaps
	Insert PlayersHandicapChanges
		select getdate(),deleted.ID, deleted.Handicap,P.Handicap

        	  ,eMails = isnull(C.ContactEMail + isnull('; ' + dbo.eMailsForTeamUsers(T.ID),''),'') +
		                isnull('; ' + P.email,'')

			from deleted
			cross apply (select Handicap, eMail, ClubID  from inserted where ID = deleted.ID) P
            outer apply (select ContactEMail from ClubsDetails where ID=P.ClubID) C
			outer apply (select ID from teams where ClubID=P.ClubID and SectionID=deleted.SectionID) T

			where P.Handicap <> deleted.Handicap

END

GO
create view	[dbo].[EntryForm_ClubsDetails]

as

select ClubID, [Club Name], Address1, Address2, PostCode, ContactName, ContacteMail, ContactTelNo,ContactMobNo,MatchTables, WIP, FeePaid, PrivacyAccepted
	from EntryForm_Clubs
	outer apply (select ContacteMail=eMailAddress 
					from ClubUsers
					where ClubID=EntryForm_Clubs.ClubID)X
GO
create view	[dbo].[ClubsDetails]

as

select ID, [Club Name], Address1, Address2, PostCode, ContactName, ContacteMail, ContactTelNo,ContactMobNo,MatchTables
	from Clubs
	outer apply (select ContacteMail=eMailAddress 
					from ClubUsers
					where ID=ClubID)X
GO
/****** Object:  StoredProcedure [dbo].[PrivacyReport]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[PrivacyReport]
GO
/****** Object:  StoredProcedure [dbo].[MergeFixtureDates]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[MergeFixtureDates]
GO
/****** Object:  StoredProcedure [dbo].[MergeClub]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[MergeClub]
GO
/****** Object:  StoredProcedure [dbo].[HandicapChangesReport]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[HandicapChangesReport]
GO
/****** Object:  StoredProcedure [dbo].[GetPlayerDetailsByPlayer]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[GetPlayerDetailsByPlayer]
GO
/****** Object:  StoredProcedure [dbo].[GetPlayerDetailsByName]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[GetPlayerDetailsByName]
GO
/****** Object:  StoredProcedure [dbo].[GetPlayerDetailsByID]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[GetPlayerDetailsByID]
GO
/****** Object:  StoredProcedure [dbo].[GetAllClubs]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[GetAllClubs]
GO
/****** Object:  StoredProcedure [dbo].[FullReportAGM_Vote]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[FullReportAGM_Vote]
GO
/****** Object:  StoredProcedure [dbo].[EntryForm_SummaryReport_ContactsByState]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[EntryForm_SummaryReport_ContactsByState]
GO
/****** Object:  StoredProcedure [dbo].[EntryForm_SummaryReport_All]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[EntryForm_SummaryReport_All]
GO
/****** Object:  StoredProcedure [dbo].[EntryForm_MergeClub]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[EntryForm_MergeClub]
GO
/****** Object:  StoredProcedure [dbo].[EntryForm_FullReportForClub]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[EntryForm_FullReportForClub]
GO
/****** Object:  StoredProcedure [dbo].[EntryForm_Details]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[EntryForm_Details]
GO
/****** Object:  StoredProcedure [dbo].[EntryForm_CreateTables]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[EntryForm_CreateTables]
GO
/****** Object:  StoredProcedure [dbo].[ContactsReport]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[ContactsReport]
GO
/****** Object:  StoredProcedure [dbo].[Competitions_Report]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[Competitions_Report]
GO
/****** Object:  StoredProcedure [dbo].[Competitions_EntrantsReport]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[Competitions_EntrantsReport]
GO
/****** Object:  StoredProcedure [dbo].[ClubsWithoutClubLogin]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[ClubsWithoutClubLogin]
GO
/****** Object:  StoredProcedure [dbo].[ClubRecord]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[ClubRecord]
GO
/****** Object:  StoredProcedure [dbo].[ClubEMailAddresses]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[ClubEMailAddresses]
GO
/****** Object:  StoredProcedure [dbo].[ClubDetails]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[ClubDetails]
GO
/****** Object:  StoredProcedure [dbo].[ApplyTaggedPlayersNewHandicaps]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[ApplyTaggedPlayersNewHandicaps]
GO
/****** Object:  StoredProcedure [dbo].[ApplyEntryForms]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[ApplyEntryForms]
GO
/****** Object:  StoredProcedure [dbo].[ApplyCompetitionEntryForms]    Script Date: 05/09/2020 21:45:49 ******/
DROP PROCEDURE [dbo].[ApplyCompetitionEntryForms]
GO
/****** Object:  StoredProcedure [dbo].[ApplyCompetitionEntryForms]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ApplyCompetitionEntryForms]
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
/****** Object:  StoredProcedure [dbo].[ApplyEntryForms]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[ApplyEntryForms] 
		@user varchar(3000) = 'Not specified'

as

set nocount on
set xact_abort on

begin tran

--report clubs not accepted privacy policy
select [Club Name], 
	   Contact=ContactName, 
	   Mobile=ContactMobNo, 
	   eMail=ContactEMail, 
	   [Tel No]=ContactTelNo, 
	   [No of Players]=playersCount,
	   [No of Teams]=teamsCount

	from EntryForm_ClubsDetails 
	outer apply (select playersCount=count(*) from EntryForm_Players where ClubID=EntryForm_ClubsDetails.ClubID)Players
	outer apply (select teamsCount=count(*) from EntryForm_Teams where ClubID=EntryForm_ClubsDetails.ClubID)Teams
	where PrivacyAccepted=0 
	  and (playersCount > 0 or teamsCount > 0)
	order by [Club Name]


--delete teams & players for clubs which have not accepted privacy
declare @ClubID int
declare clubCursor  cursor fast_forward for
	select ClubID from EntryForm_Clubs
	              where PrivacyAccepted=0
open clubCursor
fetch clubCursor into @ClubID
while @@FETCH_STATUS=0
	begin
	
	declare teamCursor  cursor fast_forward for
		select teamID from EntryForm_teams
			          where ClubID = @ClubID
	declare @teamID int
	open teamCursor
	fetch teamCursor into @teamID
	while @@FETCH_STATUS=0
		begin
		exec removeTeam @teamID, '@user'
		fetch teamCursor into @teamID
		end

	close teamCursor
	deallocate teamCursor
	
	fetch clubCursor into @ClubID
	end

close clubCursor
deallocate clubCursor

--Clubs
set identity_insert Clubs on 
 MERGE Clubs AS target
    USING (SELECT * from EntryForm_Clubs where PrivacyAccepted=1) AS source
    
    ON (target.ID = source.ClubID)
    
    WHEN MATCHED THEN 
        UPDATE SET
            [Club Name]		= source.[Club Name]
			,Address1		= source.Address1
			,Address2		= source.Address2
			,PostCode		= source.PostCode
			,ContactName	= source.ContactName
			,ContactTelNo	= source.ContactTelNo
			,ContactMobNo	= source.ContactMobNo
			,MatchTables    = source.MatchTables
					
    WHEN NOT MATCHED THEN    
		INSERT ( ID
		        ,[Club Name]
				,Address1
				,Address2
				,PostCode
				,ContactName
				,ContactTelNo
				,ContactMobNo
				,MatchTables
				)
			values(	 source.ClubID
			        ,source.[Club Name]
					,source.Address1
					,source.Address2
					,source.PostCode
					,source.ContactName
					,source.ContactTelNo
					,source.ContactMobNo
					,source.MatchTables)

	WHEN NOT MATCHED BY SOURCE THEN 
		DELETE;
set identity_insert Clubs off

--teams
--teams with no matching entry form teams need removing 
delete teams
	where Teams.ID not in (select T.TeamID
								from EntryForm_Teams T
								left join EntryForm_Clubs C on T.ClubID=C.ClubID
								where PrivacyAccepted=1
								  and T.teamID is not null)
--Update teams that have matching IDs
update teams
	set Team=source.team
	   ,Captain=source.Captain
	from EntryForm_Teams source
	join EntryForm_Clubs C on source.ClubID=C.Clubid 
	join teams on ID=source.TeamID
	WHERE PrivacyAccepted=1
--insert newly added teams
insert teams
	select (Select max(ID) from sections where LeagueID=source.LeagueID)  --new team into lowest section of this league
			,0 -- FixtureNo
			,source.ClubID
			,source.Team
			,source.Captain

		from EntryForm_Teams source
		join EntryForm_Clubs C on source.ClubID=C.Clubid 
		left join teams on ID=source.TeamID
		WHERE PrivacyAccepted=1
		  and teams.ID is null

--Players
--ID	Forename	Initials	Surname	Handicap	LeagueID	SectionID	ClubID	Team	email	TelNo	Tagged	Over70	Played	dateRegistered
--Entry Form
--PlayerID	ClubID	LeagueID	Team	Forename	Initials	Surname	Handicap	email	TelNo	Tagged	Over70  ReRegister
merge
	Players as target
	using (select * from EntryForm_Players where LeagueID <> 0) as source
		        
	on target.ID=source.PlayerID

	when matched then
		update set ClubID		= source.clubID 
				  ,SectionID    = case when source.ClubID=0 or ReRegister=0 then 0 
				                       else --calculate the section from the matching team
									        (select SectionID from teams 
									            where ClubID=source.ClubID 
												  and SectionID in (select ID from Sections where LeagueID=source.LeagueID) 
												  and Team=source.team)
                                  end  -- if ClubId is zero = entry form deleted.  If ReRegister is zero(false) flag the the player deleted
				  ,LeagueID		= source.LeagueID
				  ,Team			= case when source.ClubID=0 then '' else source.Team end
				  ,Forename		= source.Forename
		          ,Initials		= source.Initials
				  ,Surname		= source.Surname
				  ,Handicap		= source.Handicap
				  ,email		= source.eMail
				  ,TelNo		= source.TelNo
				  ,Tagged		= source.Tagged
				  ,Over70		= source.Over70
				  ,Played		= 0
				 
		when not matched then
		insert  
			(Forename
			,Initials
			,Surname
			,Handicap
			,LeagueID
			,SectionID
			,ClubID
			,Team
			,email
			,Telno
			,Tagged
			,Over70
			,Played
			,dateRegistered)
		values
			(source.Forename
			,source.Initials
			,source.Surname
			,source.Handicap
			,source.LeagueID
			,case when ReRegister=0 or ClubID = 0 then 0
			--calculate the section from the matching team
	 	         else (select SectionID from teams 
							where ClubID=source.ClubID 
							  and SectionID in (select ID from Sections where LeagueID=source.LeagueID) 
							  and Team=source.team)
			 end
			,source.ClubID
			,source.Team
			,source.email
			,source.Telno
			,source.Tagged
			,source.Over70
			,0
			, dbo.UKdateTime(getUTCdate()))
	;

INSERT ActivityLog select dbo.UKdateTime(getUTCdate()),'Apply Entry Forms',0,@user

commit tran

GO
/****** Object:  StoredProcedure [dbo].[ApplyTaggedPlayersNewHandicaps]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[ApplyTaggedPlayersNewHandicaps]
	(@LeagueID int = 0
	,@SectionID int = 0
	,@ClubID int = 0
	)
as

set nocount on
set xact_abort on

begin tran

create table #TaggedPlayersReport
	  ([Last Date] varchar(11)
	  ,PlayerID int
      ,Player varchar(150)
      ,Handicap int
	  ,Played bit
	  ,Won int
	  ,Lost int      
      ,ActionNeeded	varchar(25)
      ,NewHandicap int
	  ,Section varchar(100)
      ,Team varchar(100)
	  ,ClubID int
	  ,TeamID int
	  )

insert #TaggedPlayersReport
	exec TaggedPlayersReport @LeagueID, @SectionID, @ClubID, 1, 1

update Players
	set Handicap=T.NewHandicap 
	from Players P
	join #TaggedPlayersReport T 
	  on T.PlayerID=P.ID
	where ActionNeeded in ('Raise','Reduce')

select [Last Date],PlayerID,Player,T.Handicap,T.Played,Won,Lost,ActionNeeded='None(Changed)',NewHandicap,Section,T.Team
		,ClubLoginEmail=isnull(Clubs.ContactEMail + ';' + dbo.eMailsForTeamUsers(TeamID),'')
		,TeamEmail=isnull(TD.eMail,'')
		,PlayerEMail=isnull(Players.email,'')
	from #TaggedPlayersReport T
	join ClubsDetails Clubs on Clubs.ID = ClubID
	left join TeamsDetails TD  on TD.ID=TeamID
	left join Players on Players.ID=PlayerID
	where ActionNeeded in ('Raise','Reduce')

--update AppliedTaggedPlayersHandicaps set dtUpdated=dbo.UKdateTime(getUTCdate())

commit tran

GO
/****** Object:  StoredProcedure [dbo].[ClubDetails]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[ClubDetails]
	(@ID as integer
	)
as

set nocount on

if (select PrivacyAccepted from EntryForm_Clubs where ClubID=@ID) = 0
	begin	
	select Club	= isnull([Club Name],'')
		  ,Contact= '(Privacy policy not accepted)'
				from Clubs 
				where ID = @ID
	select TOP 0 
	   League=[League Name]
	  ,Team
      ,Section=[Section Name]
	  ,Contact=isnull(Contact,'')
	  ,eMail=isnull(eMail,'')
	  ,TelNo=isnull(TelNo,'')
	from TeamsDetails 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	WHERE ClubID=@ID 
	
	select TOP 0 
	   Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
      ,handicap
	  ,League=[League Name],Section=[Section Name]
      ,Tagged=case when Tagged=3 then 'Unseasoned'
	               when Tagged=2 then '2 Seasons to go'
				   when Tagged=1 then '1 Season to go'
				                 else ''
			  end 
	  ,[Over70(80 Vets)]=Over70,[Played this season]=Played, eMail=isnull(eMail,''), TelNo=isnull(TelNo,'')
	from Players 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=Players.LeagueID
	where ClubID=@ID

	end
else
	begin
	select Club, Contact
	 from (
			select   Seq=1
					 ,Club	= isnull([Club Name],'')
					,Contact= isnull(ContactName,'')
				from Clubs 
				where ID = @ID
			union
			select   Seq=2
					 ,Club	= isnull(Address1,'')
					,Contact= isnull(ContactEmail,'')
				from ClubsDetails 
				where ID = @ID
			union
			select   Seq=3
					 ,Club	= isnull(Address2,'')
					,Contact= isnull(ContactTelNo,'')
				from Clubs 
				where ID = @ID
			union
			select    Seq=4
					 ,Club	= isnull(PostCode,'')
					,Contact= isnull(ContactMobNo,'')
				from Clubs 
				where ID = @ID
			union
			select    Seq=5
					 ,Club	= 'Available Tables:'
					,Contact= isnull(convert(varchar,MatchTables),'')
				from Clubs 
				where ID = @ID
				) ClubAndContact
	order by Seq
	
	select League=[League Name]
	  ,Team
      ,Section=[Section Name]
	  ,Captain=isnull(Contact,'')
	  ,eMail=isnull(eMail,'')
	  ,TelNo=isnull(TelNo,'')
	from TeamsDetails 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	WHERE ClubID=@ID 
	order by LeagueID,Team
	
	select Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
      ,handicap
	  ,League=[League Name],Section=[Section Name]
      ,Tagged=case when Tagged=3 then 'Unseasoned'
	               when Tagged=2 then '2 Seasons to go'
				   when Tagged=1 then '1 Season to go'
				                 else ''
			  end 
	  ,[Over70(80 Vets)]=Over70,[Played this season]=Played, eMail=isnull(eMail,''), TelNo=isnull(TelNo,'')
	from Players 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=Players.LeagueID
	where ClubID=@ID
	order by Players.LeagueID,Team, Forename,surname

	end
GO
/****** Object:  StoredProcedure [dbo].[ClubEMailAddresses]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[ClubEMailAddresses]
	(@LeagueID  int = 0 
	,@SectionID int =  0
	)
as

set nocount on

declare @email varchar (255)
       ,@Club varchar(256)
       ,@emailList varchar(max)
	   ,@ClubList varchar(max)
set @emailList=''
set @ClubList=''
declare emailsCursor cursor fast_forward for
	select distinct [Club Name], ContactEMail 
		from ClubsDetails Clubs
		outer apply (select sectionID from Teams where ClubID = Clubs.ID) c
		cross apply (select LeagueID from Sections where Sections.ID=c.SectionID) l
		where isnull(ContactEmail,'') <> ''
		  and (@SectionID=0 or @SectionID=SectionID)
		  and (@leagueID=0 or @leagueID=leagueID)

open emailsCursor
fetch emailsCursor into @Club, @email
while @@fetch_status = 0
	begin
	set @emailList=@emailList +  @email + ';'
	set @ClubList=@ClubList + @Club + ', '
	fetch emailsCursor into  @Club, @email
	end
set @emailList=left(@emailList,len(@emailList)-1)
close emailsCursor
deallocate emailsCursor
select eMailList=@emailList, ClubsList=@ClubList

GO
/****** Object:  StoredProcedure [dbo].[ClubRecord]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[ClubRecord]
	(@ID as integer
	)
as

set nocount on

select ID
      ,[Club Name]=isnull([Club Name],'')
	  ,Address1=isnull(Address1,'')
	  ,Address2=isnull(Address2,'')
	  ,PostCode=isnull(PostCode,'')
	  ,ContactName=isnull(ContactName,'')
	  ,ClubLoginEMail=isnull(ContactEMail,'')
	  ,ContactTelNo=isnull(ContactTelNo,'')
	  ,ContactMobNo=isnull(ContactMobNo,'')
	  ,Matchtables

	 from ClubsDetails
	 
	 where ID=@ID

	 select Team,League=[League Name],Section=[Section Name]
	from Teams 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	WHERE ClubID=@ID 
	order by LeagueID,Team
	
select Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
      ,handicap
	  ,League=[League Name],Section=[Section Name]
      ,Tagged=case when Tagged=3 then 'Unseasoned'
	               when Tagged=2 then '2 Seasons to go'
				   when Tagged=1 then '1 Season to go'
				                 else ''
			  end 
	  ,[Over70(80 Vets)]=Over70,[Played this season]=Played, eMail=isnull(eMail,''), TelNo=isnull(TelNo,'')
	from Players 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=Players.LeagueID
	where ClubID=@ID
	order by Players.LeagueID,Team, Forename,surname

Select * from Teams where ClubID=@ID
	
Select * from Players where ClubID=@ID


GO
/****** Object:  StoredProcedure [dbo].[ClubsWithoutClubLogin]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[ClubsWithoutClubLogin]

as

set nocount on

select [Club Name], 
       Contact = ContactName, 
	   Telephone = ContactTelNo, 
	   Mobile = ContactMobNo, 
	   [Address] = isnull(Address1 + ', ','') + isnull(Address2 + ', ','') + isnull(PostCode,'')
	from Clubs
	left join Clubusers 
		on ClubID = ID
	where ClubID is null
	  and [Club Name] <> 'bye'
	order by [Club Name]
GO
/****** Object:  StoredProcedure [dbo].[Competitions_EntrantsReport]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Competitions_EntrantsReport] 
	@CompetitionID int

as

set NoCount on

	select   Competition
	        ,[Entry Form Club]=coalesce(Clubs.[Club Name],L.[Club Name],M.[Club Name])
			,[Entrant(s)] = case when CompType = 4 then Clubs.[Club Name] + ' ' + T.Team
					                               else dbo.FullPlayerName(P.Forename,P.Initials,P.Surname) +
														case when CompType=2 then '(' + convert(varchar,P.Handicap) + ')' else '' end +
					                                    case when CompType=3 then '/' + dbo.FullPlayerName(P2.Forename,P2.Initials,P2.Surname) else '' end +
				                                        case when P.ClubID <> Clubs.ID then ' [' + L.[Club Name] + ']' else '' end
															
	                        end 
						
			,TelNo = case when CompType = 4 then T.TelNo
			                                else  coalesce(P.TelNo,Clubs.ContactTelNo + ' (Club TelNo)', clubs.ContactMobNo+' (Club Mobile)')
				     end
			,eMail = case when CompType = 4 then T.eMail
			                                else isnull( P.eMail,Clubs.ContactEMail+' (Club eMail)')
			         end

		From Competitions_EntryForms E
		cross apply (Select Competition = Name 
	                   ,CompType
					from Competitions 
					where ID=E.CompetitionID) C
		left join Players P
		  on P.ID=EntrantID
		left join Players P2
		  on P2.ID=Entrant2ID
	    left join teamsDetails T
		  on T.ID=EntrantID
	    outer apply (select top 1 * from ClubsDetails where ID=E.ClubID) Clubs -- OR ID=P.ClubID OR ID=P2.ClubID OR ID=T.ClubID) Clubs
        OUTER apply (Select [Club Name] = ISNULL([Club Name],'') from Clubs where ID=  P.ClubID) L
        OUTER apply (Select [Club Name] = ISNULL([Club Name],'') from Clubs where ID=  T.ClubID) M

		where CompetitionID=@CompetitionID
		order by  [Entrant(s)]

GO
/****** Object:  StoredProcedure [dbo].[Competitions_Report]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[Competitions_Report]
	(@ClubID int
	)
as

set nocount on

if @ClubID=0
	begin
	exec Competitions_ReportAll
	return
	end

declare @Report table
	(Competition varchar(256)
	,[Entrant(s)] varchar(256)
	,TelNo varchar(20)
	,eMail varchar(256)
	,EntryFee varchar(10)
	)
create table #Comp 
		(ID int identity(0,1)
		,line varchar(256)
		)

create table #Entrants 
		(ID int identity(0,1)
		,[Entrant(s)] varchar(600)
		,TelNo varchar(20)
		,eMail varchar(256)
		,EntryFee decimal (5,2)
		) 

--insert @Report
--	select 'Entry form for',[Club Name] + ' (' + dbo.EntryForm_State(WIP) + ')','TelNo','eMail','Fee' 
--		from Clubs 
--		cross apply (Select WIP from Competitions_EntryFormsClubs where ClubID=@ClubID) x
--		where ID=@ClubID

declare @CompetitionID int
declare CompetitionIDs_cursor cursor fast_forward for
	select distinct CompetitionID 
		from Competitions_EntryForms
		where ClubID=@ClubID
		order by CompetitionID

open CompetitionIDs_cursor
fetch CompetitionIDs_cursor into @CompetitionID
while @@fetch_status=0
	begin

	insert #Comp 
		select '<b>'+name+'</b>' From Competitions where ID=@CompetitionID
	insert #Comp 
		select 'Entry Fee £' + convert(varchar,EntryFee) From Competitions where ID=@CompetitionID

	declare @Comment varchar(256)
	select @Comment=Comment From Competitions where ID=@CompetitionID
	declare @ix int, @iy int
	set @ix=0
	while @ix < len(@Comment)
		begin
		set @iy = charindex(char(13)+char(10),@Comment,@ix)
		if @iy > 0
			begin
			insert #Comp select substring(@comment,@ix,@iy-@ix)
			set @ix=@iy+2
			end
		else
			begin
			insert #Comp select substring(@comment,@ix,len(@Comment)-@ix+1)
			set @ix=len(@Comment)
			end
	end

	insert #Entrants 
		select NULL,NULL,NULL,NULL
	insert #Entrants
	select   [Entrant(s)] = case when CompType = 4 then Clubs.[Club Name] + ' ' + T.Team
					                               else dbo.FullPlayerName(P.Forename,P.Initials,P.Surname) +
														case when CompType=2 then '(' + convert(varchar,P.Handicap) + ')' else '' end +
					                                    case when CompType=3 then '/' + dbo.FullPlayerName(P2.Forename,P2.Initials,P2.Surname) else '' end +
				                                        case when P.ClubID <> @ClubID then ' [' + L.[Club Name] + ']' else '' end
															
	                        end 
			,TelNo = case when CompType = 4 then T.TelNo
			                                else P.TelNo
				     end
			,eMail = case when CompType = 4 then T.eMail
			                                else P.eMail
			         end

			,EntryFee
		From Competitions_EntryForms E
		cross apply (Select Competition = Name 
	                   ,CompType
					   ,EntryFee
					   ,LeagueID
					from Competitions 
					where ID=E.CompetitionID) C
		left join Players P
		  on P.ID=EntrantID
		left join Players P2
		  on P2.ID=Entrant2ID
	    left join Clubs 
		  on Clubs.ID=E.ClubID
	    left join teamsDetails T
		  on T.ID=EntrantID
        OUTER apply (Select [Club Name] = ISNULL([Club Name],'')
						from Clubs 
						where ID=  P.ClubID) L

		where CompetitionID=@CompetitionID
		  and E.ClubID=@ClubID
		order by CompetitionID
		        ,case when P.LeagueID=C.LeagueID then 0 else P.LeagueID end
				,P.Surname, T.Team

	if (select count(*) from #Comp) > (select count(*) from #Entrants)
		insert @Report
			select CompetitionIDs_cursor.line, E.[Entrant(s)], TelNo,eMail,EntryFee 
				from #Comp CompetitionIDs_cursor 
				left join #Entrants E on CompetitionIDs_cursor.ID=E.ID
	else
		insert @Report
			select CompetitionIDs_cursor.line, E.[Entrant(s)], TelNo,eMail,EntryFee 
				from #Entrants E
				left join #Comp CompetitionIDs_cursor on CompetitionIDs_cursor.ID=E.ID
	truncate table #Entrants
	truncate table #Comp

	fetch CompetitionIDs_cursor into @CompetitionID
	end

close CompetitionIDs_cursor
deallocate CompetitionIDs_cursor

select Competition,[Entrant(s)],TelNo,eMail
		,EntryFee= case when isnumeric(EntryFee)=1 then '£' +  convert(varchar,entryFee) else EntryFee end
	from @Report

drop table #Comp
drop table #Entrants

GO
/****** Object:  StoredProcedure [dbo].[ContactsReport]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[ContactsReport]

as

set nocount on

create table #tmp
	(Seq      int identity (1,1)
	,[Source] varchar(16)
	,Entity   varchar(16)
	,Club   varchar(250)
	,League   varchar(50)
	,Section  varchar(50)
	,Team     char(1)
	,[Player Name]  varchar(100)
	,eMail    varchar(250)
	,[Tel No 1] varchar(20)
    ,[Tel No 2] varchar(20)
	)

insert #tmp
select	 [Source] = 'Base'
	   	,Entity = 'Club'
		,Club = [Club Name]
		,League = ''
		,Section = ''
		,Team = ''
		,[Player Name] = ContactName
	    ,Email = ''
	    ,[Tel No 1] = ContactTelNo
	    ,[Tel No 2] = ContactMobNo
	from Clubs 
	where [Club Name] <> 'Bye'
	order by [Club Name]

insert into #tmp
select	 [Source] = 'Base'
	   	,Entity = 'Club Login'
		,Club = [Club Name]
		,League=''
		,Section = ''
		,Team=''
		,[Player Name]=dbo.FullPlayerName(FirstName,'',Surname) 
	    ,Email=eMailAddress 
	    ,[Tel No 1] = Telephone 
	    ,[Tel No 2] = ''
	
	from ClubUsers
	outer apply (select [Club Name] from Clubs where ID=ClubID) C
	where [Club Name] <> 'Bye'
	order by [Club Name]

insert into #tmp
select	 [Source] = 'Base'
	   	,Entity = 'Team'
		,Club = [Club Name]
		,League = [League Name]
		,Section = [Section Name]
		,Team = Team
		,[Player Name] = Contact
	    ,Email = eMail
	    ,[Tel No 1] = TelNo
	    ,[Tel No 2] = ''
	
	from Teams T
	outer apply (select LeagueID, [Section Name] from Sections where ID=SectionID)S
	outer apply (select ID, [League Name] from Leagues where ID=S.LeagueID)L
	outer apply (select [Club Name] from Clubs where ID = ClubID)C
	outer apply (select Contact=dbo.FullPlayerName(Forename,Initials,Surname), eMail, TelNo from Players where ID=Captain)X
	where [Club Name] <> 'Bye'
	order by [Club Name], L.ID, Team 

insert into #tmp
select	 [Source] = 'Base'
	   	,Entity = 'Team Login'
		,Club = [Club Name]
		,League = [League Name]
		,Section = [Section Name]
		,Team = Team
		,[Player Name] = Contact
	    ,Email = eMail
	    ,[Tel No 1] = T.Telephone
	    ,[Tel No 2] = ''
	
	from ResultsUsers R
	outer apply (select TeamID, ClubID, SectionID, Team, Contact=dbo.FullPlayerName(FirstName,'',Surname), eMail, Telephone 
					from Teams 	outer apply (select eMail from Players where ID=Captain)X
					where ID = TeamID)T
	outer apply (select LeagueID, [Section Name] from Sections where ID=SectionID)S
	outer apply (select ID, [League Name] from Leagues where ID=S.LeagueID)L
	outer apply (select [Club Name] from Clubs where ID = ClubID)C
	order by [Club Name], L.ID, Team 

insert into #tmp
select	 [Source] = 'Base'
	   	,Entity = 'Player'
		,Club = isnull([Club Name],'_No Club')
		,League = [League Name] 
		,Section = [Section Name]
		,Team = Team
		,[Player Name] = dbo.FullPlayerName(Forename,Initials,Surname)  + case when SectionID < 1 then ' (deleted)' else '' end 
	    ,Email = isnull(eMail,'')
	    ,[Tel No 1] = isnull(TelNo,'')
	    ,[Tel No 2] = ''
	
	from Players P
	outer apply (select ID, [League Name] from Leagues where ID = P.LeagueID)L
	outer apply (select [Section Name] from Sections where ID = P.SectionID)S
	outer apply (select [Club Name] from  Clubs where ID = P.ClubID)C	where P.ID > 0
	order by isnull([Club Name],'_No Club'), L.ID, Team, [Player Name]

insert into #tmp
select	 [Source] = 'Entry Form'
	   	,Entity = 'Club'
		,Club = [Club Name]
		,League = ''
		,Section = ''
		,Team = ''
		,[Player Name] = ContactName
	    ,Email = ''
	    ,[Tel No 1] = ContactTelNo
	    ,[Tel No 2] = ContactMobNo
	
	from EntryForm_Clubs 
	where [Club Name] <> 'Bye'
	order by [Club Name]

insert into #tmp
select	 [Source] = 'Entry Form'
	   	,Entity = 'Club Login'
		,Club = [Club Name]
		,League=''
		,Section = ''
		,Team=''
		,[Player Name]=dbo.FullPlayerName(FirstName,'',Surname) 
	    ,Email=eMailAddress 
	    ,[Tel No 1] = Telephone 
	    ,[Tel No 2] = ''
	
	from ClubUsers
	outer apply (select [Club Name] from EntryForm_Clubs where ClubID=ClubUsers.ClubID) C
	where [Club Name] <> 'Bye'
	order by [Club Name]

insert into #tmp
select	 [Source] = 'Entry Form'
	   	,Entity = 'Team'
		,Club = [Club Name]
		,League = [League Name]
		,Section = ''
		,Team = Team
		,[Player Name] = X.Contact
	    ,Email = X.eMail
	    ,[Tel No 1] = X.TelNo
	    ,[Tel No 2] = ''
	
	from EntryForm_Teams T
	outer apply (select ID, [League Name] from Leagues where ID=LeagueID)L
	outer apply (select [Club Name] from EntryForm_Clubs where ClubID = T.ClubID)C
	outer apply (select Contact=dbo.FullPlayerName(Forename,Initials,Surname), eMail, TelNo from EntryForm_Players where PlayerID=Captain)X

	order by [Club Name], L.ID, Team 

insert into #tmp
select	 [Source] = 'Entry Form'
	   	,Entity = 'Team Login'
		,Club = [Club Name]
		,League = [League Name]
		,Section = ''
		,Team = Team
		,[Player Name] = dbo.FullPlayerName(FirstName,'',Surname)
	    ,Email = R.eMailAddress
	    ,[Tel No 1] = R.Telephone
	    ,[Tel No 2] = ''
	
	from ResultsUsers R
	left join EntryForm_Teams E on E.TeamID=R.TeamID
	outer apply (select ID, [League Name] from Leagues where ID=E.LeagueID)L
	outer apply (select [Club Name] from Entryform_Clubs where ClubID = E.ClubID)C
	order by [Club Name], L.ID, Team 	

insert into #tmp
select	 [Source] = 'Entry Form'
	   	,Entity = 'Player'
		,Club = isnull([Club Name],'_No Club')
		,League = [League Name] 
		,Section = ''
		,Team = Team
		,[Player Name] = dbo.FullPlayerName(Forename,Initials,Surname) + case when LeagueID < 0 then ' (deleted)' else '' end
	    ,Email = isnull(eMail,'')
	    ,[Tel No 1] = isnull(TelNo,'')
	    ,[Tel No 2] = ''
	
	from Entryform_Players P
	outer apply (select [League Name] from  Leagues where ID = LeagueID)L
	outer apply (select [Club Name] from Entryform_Clubs C where ClubID = P.ClubID) C
	where P.PlayerID > 0
	order by isnull([Club Name],'_No Club'), LeagueID, Team, [Player Name]

select * from #tmp
drop table #tmp

GO
/****** Object:  StoredProcedure [dbo].[EntryForm_CreateTables]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[EntryForm_CreateTables]

as

set nocount on
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
set xact_abort on

begin tran

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EntryForm_Teams')
	DROP TABLE EntryForm_Teams

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EntryForm_Players')
	DROP TABLE EntryForm_Players

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EntryForm_Clubs')
	DROP TABLE EntryForm_Clubs

CREATE TABLE EntryForm_Clubs(
	ClubID int NOT NULL,
	[Club Name] varchar(50) NOT NULL,
	Address1 varchar(50),
	Address2 varchar(50),
	PostCode char(8),
	ContactName varchar(104),
	ContactTelNo varchar(20),
	ContactMobNo varchar(20),
	MatchTables int,
	WIP int,
	FeePaid bit,
	PrivacyAccepted bit
) 
CREATE TABLE EntryForm_Teams(
	ClubID int NOT NULL, 
	Team char(1) NOT NULL,
	LeagueID int NOT NULL,
	Captain int,
	TeamID int
) 

CREATE TABLE EntryForm_Players(
	PlayerID int NOT NULL,
	ClubID int, 
	LeagueID int,
	Team char(1),
	Forename varchar(50),
	Initials varchar(4),
	Surname varchar(50),
	Handicap int,
	email varchar(250),
	TelNo varchar(20),
	Tagged tinyint,
	Over70 bit,
	ReRegister bit
)

insert EntryForm_Clubs
			select *, 0, 0, 0 from Clubs 
	
insert EntryForm_Teams
			select   ClubID
					,Team
					,LeagueID
					,Captain
					,Teams.ID
				from Teams 
				join Sections on Sections.ID=SectionID
				join Clubs on Clubs.ID=ClubID
				where [Club Name]<>'bye'

insert EntryForm_Players
			select   Players.ID 
					,ClubID
					,LeagueID
					,Team
			        ,Forename 
					,Initials 
					,Surname 
					,Handicap 
					,email
					,TelNo
					,Tagged
					,Over70
					,0 --set ReRegister off (until set on at the entry form)
				from Players 
				where ID > 0

if not exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='PaymentsHistory')
	select top 0 * into PaymentsHistory from Payments

insert PaymentsHistory 
	select P.* 
		from Payments P
		left join PaymentsHistory H
		       on P.DateTimePaid = H.DateTimePaid
			  and P.ClubID       = H.ClubID
			  and P.FineID       = H.FineID
			  and P.AmountPaid   = H.AmountPaid 
		where P.PaymentReason = 'League Entry Fee' 
		  and H.DateTimePaid is null

delete Payments
		from Payments P
		join PaymentsHistory H
		       on P.DateTimePaid = H.DateTimePaid
			  and P.ClubID       = H.ClubID
			  and P.FineID       = H.FineID
			  and P.AmountPaid   = H.AmountPaid 
		where P.PaymentReason = 'League Entry Fee' 

exec AllowLeaguesEntryForms

commit tran

GO
/****** Object:  StoredProcedure [dbo].[EntryForm_Details]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[EntryForm_Details]
	(@ClubID int
	,@Refresh bit = 0
	)
as

set nocount on
set xact_abort on

begin tran


if @Refresh=1 and @ClubID <> 0
	begin
	delete from EntryForm_Clubs   where  ClubID=@ClubID
	delete from EntryForm_Teams   where  ClubID=@ClubID
	delete from EntryForm_Players where  ClubID=@ClubID
	
	insert EntryForm_Clubs
			select *,1,0, 0 from Clubs where ID=@ClubID
	
	insert EntryForm_Teams
			select   ClubID
					,Team
					,LeagueID
					,Captain
					,Teams.ID
				from Teams 
				join Sections on Sections.ID=SectionID
				where ClubID=@ClubID

	insert EntryForm_Players
		select   ID
				,ClubID
				,LeagueID
				,Team
				,Forename
				,Initials
				,Surname
				,Handicap
				,email
				,TelNo
				,Tagged
				,Over70
				,0 
			from Players
			where ClubID=@Clubid
	end

select ClubID, [Club Name], Address1, Address2, PostCode, ContactName, ContactEMail, ContactTelNo, ContactMobNo, MatchTables, WIP
		, Fee=isnull((Select Fee from EntryForm_Fees where Entity='club'),0)
        ,AmountPaid = ISNULL((select SUM(AmountPaid)
								from Payments
								where ClubID=@ClubID
								  and PaymentReason='League Entry Fee')
                           ,0)
        ,PrivacyAccepted
	from EntryForm_ClubsDetails C
	where ClubID=@ClubID 

select  League = [League Name]
       ,Team
 	   ,T.LeagueID
	   ,Captain
	   ,Fee=isnull(Fee,0)
	from EntryForm_Teams T
	join Leagues on Leagues.ID = T.LeagueID
	join EntryForm_Fees F on F.LeagueID=T.LeagueID
	where ClubID=@ClubID
	order by LeagueID, Team

select	 PlayerID
        ,P.LeagueID
		,Forename
		,Inits = Initials 
		,Surname
		,[H'cap]=Handicap
		,P.Team
		,eMail = ISNULL(eMail,'')
		,TelNo = ISNULL(TelNo,'')
		,Tag = dbo.TagDescription(Tagged)
        ,Over70
 	    ,Tagged
	    ,FullName = dbo.FullPlayerName(Forename,Initials,Surname)
 	    ,Captain = case when PlayerID = Captain then 1 else 0 end
	    ,ReRegister

	from EntryForm_Players P
	cross apply (Select Captain
						from EntryForm_Teams 
						where LeagueID = P.LeagueID 
						  and ClubID = P.ClubID 
						  and Team = P.Team ) T
	where P.ClubID=@ClubID
	order by P.LeagueID,Team,Forename,Surname

select [Date]=CONVERT(varchar(17),DateTimePaid,113)
      ,PaymentMethod
	  ,PaymentReason
	  ,Amount = '&pound;' + CONVERT (varchar, AmountPaid)
	  ,Note
	  ,PaidBy=ISNULL(PaidBy,'')
	from Payments
	where ClubID=@ClubID
	  and AmountPaid <> 0
	  and PaymentReason = 'League Entry Fee'
commit tran


GO
/****** Object:  StoredProcedure [dbo].[EntryForm_FullReportForClub]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[EntryForm_FullReportForClub]
	(@ClubID int
	)
as

set nocount on

declare @Report table
	(Seq int identity(1,1)
	,Col1 varchar(1000)
	,Col2 varchar(1000)
	,Col3 varchar(1000)
	,Col4 varchar(1000)
	,Col5 varchar(1000)
	,Col6 varchar(1000)
	,Col7 varchar(1000)
	,Col8 varchar(1000)
	)
insert @Report
	select 'Club Name', [Club Name],'Contact',ContactName,'',''
	      ,case when Feepaid= 1 then 'Fee Paid' else 'Fee NOT paid' end
		  , case when PrivacyAccepted=1 then 'Privacy accepted' else 'Privacy NOT accepted' end
		from EntryForm_Clubs TeamsCursor
		where TeamsCursor.ClubID = @ClubID
insert @Report
	select 'Address 1', Address1,'eMail',ClubLoginEMail=ContactEMail,'','','',''
		from EntryForm_ClubsDetails TeamsCursor
		where TeamsCursor.ClubID = @ClubID
insert @Report
	select 'Address 2', Address2,'Tel',ContactTelNo,'','','',''
		from EntryForm_Clubs TeamsCursor
		where TeamsCursor.ClubID = @ClubID
insert @Report
	select 'Post Code', PostCode,'Mobile',ContactMobNo,'','','',''
		from EntryForm_Clubs TeamsCursor
		where TeamsCursor.ClubID = @ClubID
insert @Report
	select 'No Of Tables', MatchTables,'','','','','',''
		from EntryForm_Clubs TeamsCursor
		where TeamsCursor.ClubID = @ClubID

declare TeamsCursor cursor fast_forward for
	select Team, LeagueID, TelNo, Contact, eMail, [League Name]
		from EntryForm_TeamDetail T
		join Leagues on ID=LeagueID 
		where T.ClubID = @ClubID
		order by LeagueID,Team
declare @LeagueID int
       ,@Team char(1)
	   ,@TelNo varchar(20)
       ,@Contact varchar (104)
	   ,@eMail varchar(255)
	   ,@LeagueName varchar(50)

	   ,@StartSeq int

open TeamsCursor
fetch TeamsCursor into @Team, @LeagueID, @TelNo, @Contact, @eMail,@LeagueName
while @@fetch_status = 0
	begin

	insert @Report values ('','','','','','','','')
	select @StartSeq=max(seq)+2 from @Report
	
	insert @Report
		select 'League',@LeagueName,'Player','Handicap','Tag',case when @LeagueID=2 then 'Over80' else 'Over70' end,'eMail','TelNo'
	insert @Report
		select 'Team',@Team,'','','','','',''
	insert @Report
		select 'Contact',@Contact,'','','','','',''
	insert @Report
		select 'eMail',@eMail,'','','','','',''
	insert @Report
		select 'TelNo',@TelNo,'','','','','',''
	
	declare @player varchar (104)
	       ,@HCap varchar (5)
		   ,@Tag varchar(16)
		   ,@Over70 varchar(1)
		   ,@pEMail varchar(255)
		   ,@pTelNo varchar(20)

		   ,@SeqNo int
	declare PlayerssCursor cursor fast_forward for
		select dbo.FullPlayerName(Forename,Initials,Surname)
		      ,convert(varchar,Handicap)
			  ,dbo.TagDescription(Tagged)
			  ,case when Over70=1 then 'Y' else '' end
			  ,email
			  ,TelNo
			from EntryForm_Players
			where ClubID=@ClubID
			  and LeagueID=@LeagueID
			  and Team=@Team
			  and ReRegister = 1
	open PlayerssCursor
	fetch PlayerssCursor into @Player,@HCap,@tag,@Over70,@eMail,@TelNo
	set @SeqNo=	@StartSeq	  	   
	while @@Fetch_status=0
		begin
		If @SeqNo-@StartSeq < 4
			update @Report
				set col3=@Player,col4=@Hcap,col5=@tag,col6=@Over70,col7=@eMail,col8=@TelNo
				where seq=@SeqNo
		else
			insert @Report
				select '','',@Player,@HCap,@tag,@Over70,@eMail,@TelNo

		fetch PlayerssCursor into @Player,@HCap,@tag,@Over70,@eMail,@TelNo
		set @SeqNo=@SeqNo+1

		end

		close PlayerssCursor
		deallocate PlayerssCursor


	fetch TeamsCursor into @Team, @LeagueID, @TelNo, @Contact, @eMail, @LeagueName

	end

close TeamsCursor
deallocate TeamsCursor

select col1,col2,col3,col4,col5,col6,col7,col8 
	From @Report
	order by seq

GO
/****** Object:  StoredProcedure [dbo].[EntryForm_MergeClub]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[EntryForm_MergeClub]
	(@ClubID int           --if = -1 insert new record
	,@ClubName varchar(50) --if empty delete record with this ID
	,@Address1 varchar(50) = ''
	,@Address2 varchar(50) = ''
	,@PostCode char(8) = ''
	,@ContactName varchar(104) = ''
	,@ContactTelNo varchar(20) = ''
	,@ContactMobNo varchar(20) = ''
	,@MatchTables int = 0
	,@PrivacyAccepted bit = 0
	)

as
set nocount on     
set xact_abort on

begin tran

declare @NewClub bit
set @NewClub = 0

if @ClubName='' 
	begin
	
	update EntryForm_Players 
		set ClubID = 0
		where ClubID=@ClubID
	
	delete EntryForm_Teams   
		where ClubID=@ClubID
	
	end

else
	
	if @ClubID <= 0 --will insert a new club
		begin
		select @ClubID=dbo.InlineMax((select max(ClubID)+1 from EntryForm_Clubs)
			                        ,(select max(ID)+1 from Clubs))
		set @NewClub = 1
		end

MERGE EntryForm_Clubs AS target
    USING (SELECT @ClubID) AS source (ClubID)
    
    ON (target.ClubID = source.ClubID)
    
    WHEN MATCHED AND @ClubName='' THEN
		DELETE
    
    WHEN MATCHED THEN 
        UPDATE SET
            [Club Name]		= @ClubName
			,Address1		= @Address1
			,Address2		= @Address2
			,PostCode		= @PostCode
			,ContactName	= @ContactName
			,ContactTelNo	= @ContactTelNo
			,ContactMobNo	= @ContactMobNo
			,MatchTables    = @MatchTables
			,PrivacyAccepted = @PrivacyAccepted
					
    WHEN NOT MATCHED AND @ClubName <> '' THEN    
		INSERT ( ClubID
				,[Club Name]
				,Address1 
				,Address2
				,PostCode
				,ContactName
				,ContactTelNo
				,ContactMobNo
				,MatchTables
				,WIP
				,PrivacyAccepted)
			values(	 @ClubID
					,@ClubName
					,@Address1
					,@Address2
					,@PostCode
					,@ContactName
					,@ContactTelNo
					,@ContactMobNo
					,@MatchTables
					,1
					,0)
			;

if @NewClub = 1
	begin
	set identity_insert Clubs on
	insert Clubs
				( ID
				,[Club Name]
				,Address1 
				,Address2
				,PostCode
				,ContactName
				,ContactTelNo
				,ContactMobNo
				,MatchTables
				)
		select   ClubID
				,[Club Name]
				,Address1 
				,Address2
				,PostCode
				,ContactName
				,ContactTelNo
				,ContactMobNo
				,MatchTables
			from EntryForm_Clubs
			where @ClubID=ClubID


	set identity_insert Clubs on
	end
--return the (new) clubID
	select @ClubID
	
commit tran

GO
/****** Object:  StoredProcedure [dbo].[EntryForm_SummaryReport_All]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[EntryForm_SummaryReport_All]

as

set nocount on

	select
	   ClubID,[Club Name]
      ,NoOpenTeams
      ,NoVetsTeams
	  ,NoBilliardsTeams
	  ,[State]=dbo.EntryForm_State(WIP)
	  ,Fee='£' + convert(varchar (8),dbo.EntryForm_Fee(c.ClubID))
	  ,[Contact List]=convert(varchar(2000),case when isnull(ContactEMail,'') <> '' 
	                                             then case when isnull(ContactName,'') <> '' 
												           then '(' + ContactName + ')'
	                                                       else ''
                                                      end + ContactEMail
	                                              else ''
											end)
	into #tmpReport
	       
	from EntryForm_ClubsDetails c
	outer apply (select NoOpenTeams=sum(case when LeagueID=1 then 1 else 0 end)
                       ,NoVetsTeams=sum(case when LeagueID=2 then 1 else 0 end)
	                   ,NoBilliardsTeams=sum(case when LeagueID=3 then 1 else 0 end) 
					   ,OpenEMail=max(case when LeagueID=1 then case when Contact='' then '' else '(' + contact + ')' end + email else '' end)
					   ,VetsEMail=max(case when LeagueID=2 then case when Contact='' then '' else '(' + contact + ')' end + email else '' end)
					   ,BilliardsEMail=max(case when LeagueID=3 then case when Contact='' then '' else '(' + contact + ')' end + email else '' end)
					
					from EntryForm_TeamDetail 
					where ClubID=c.ClubID
					group by ClubID) T
	

	where WIP >= 0
	  and [Club Name]<> 'Bye'

	order by WIP, [Club Name]

declare ReportCursor cursor fast_forward for
	select ClubID, isnull([Contact List],'') from #tmpReport
declare @ClubID int, @ContactList varchar(2000)
open ReportCursor
fetch ReportCursor into @ClubID, @ContactList
while @@fetch_status = 0
	begin
	declare TeamsCursor cursor fast_forward for
		select Contact, eMail from EntryForm_TeamDetail  where ClubID=@ClubID
    declare @eMail varchar(250), @Contact varchar(104)
	open TeamsCursor
	fetch TeamsCursor into @Contact, @eMail
	while @@fetch_status=0
		begin
		if isnull(@eMail,'') <> ''
			begin

			if @ContactList <> '' 
				set @ContactList=@ContactList + ';'

			if isnull(@Contact,'') <> ''
				set @ContactList=@ContactList + '(' + @Contact + ')'

			set @ContactList=@ContactList+@eMail

			end
		
		fetch TeamsCursor into @Contact, @eMail
		
		end

		close TeamsCursor
		deallocate TeamsCursor

		update #tmpReport	
			set [Contact List]=@ContactList
			where ClubID=@ClubID

	fetch ReportCursor into @ClubID, @ContactList
	end

close ReportCursor
deallocate ReportCursor

select ClubID,[Club Name],NoOpenTeams,NoVetsTeams,NoBilliardsTeams,[State],[Contact List]  
	from #tmpReport
	order by [Club Name] 

drop table #tmpReport

GO
/****** Object:  StoredProcedure [dbo].[EntryForm_SummaryReport_ContactsByState]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[EntryForm_SummaryReport_ContactsByState]

as

set nocount on

declare @tmpContacts table
	(WIP int
	,Contact varchar(400)
	)


declare ReportCursor cursor fast_forward for
	select Distinct WIP from EntryForm_Clubs where WIP is not null

declare @WIP int
declare @tmp varchar(4000)

open ReportCursor
fetch ReportCursor into @WIP
while @@fetch_status = 0
	begin

	declare Clubs_Cursor cursor fast_forward for
	select clubID, isnull(ContactName,''), isnull(ContactEMail,'')
		from EntryForm_ClubsDetails
		where WIP = @WIP
    declare @ClubID int, @ContactName varchar(104), @ClubLoginEmail varchar(250)
	open Clubs_Cursor
	Fetch Clubs_Cursor into @ClubID, @ContactName, @ClubLoginEmail
	while @@fetch_status=0
		begin
		set @tmp=case when @ClubLoginEmail <> '' then case when @ContactName<>'' then '('+@ContactName+')' else '' end + @ClubLoginEmail else '' end
		if @tmp <> '' and @WIP is not null
			insert @tmpContacts select @WIP, @tmp

		declare TeamsCursor cursor fast_forward for
			select Contact, eMail 
				from EntryForm_Teams  
				outer apply (select Contact = dbo.FullPlayerName(Forename, Initials, Surname), eMail 
								From EntryForm_Players
								where PlayerID = Captain) X
				where ClubID=@ClubID
	    declare @eMail varchar(250), @Contact varchar(104)
		open TeamsCursor
		fetch TeamsCursor into @Contact, @eMail
		while @@fetch_status=0
			begin
			set @tmp=case when @eMail <> '' then case when @Contact<>'' then '('+@Contact+')' else '' end + @eMail else '' end
			if @tmp <> ''and  @WIP is not null
				insert @tmpContacts select @WIP, @tmp
		
			fetch TeamsCursor into @Contact, @eMail
		
			end

			close TeamsCursor
			deallocate TeamsCursor

		Fetch Clubs_Cursor into @ClubID, @ContactName, @ClubLoginEmail
		end

		close Clubs_Cursor
		deallocate Clubs_Cursor

	fetch ReportCursor into @WIP

	end
	  					 
close ReportCursor
deallocate ReportCursor

select WIP
      ,[Contact List]=convert(varchar(8000),'')	
	into #tmpReport
	from EntryForm_Clubs
	where WIP is not null
	group by WIP
	order by WIP
	
declare WIPCursor cursor fast_forward for
	select distinct WIP, Contact from @tmpContacts where WIP is not null
open WIPCursor
declare @prevWIP int
set @prevWIP=-1
fetch WIPCursor into @WIP, @Contact
while @@fetch_status=0
	begin
	update #tmpReport 
		set [Contact List]=[Contact List]+';'+@Contact 
		where WIP=@WIP
	fetch WIPCursor into @WIP, @Contact
	end

close WIPCursor
deallocate WIPCursor

update #tmpReport
	set [Contact List]=right([Contact List],len([Contact List])-1)

select   WIP
		,State=dbo.EntryForm_State(WIP)
		,[Contact List] 
	from #tmpReport
	where WIP is not null
	order by WIP

drop table #tmpReport

GO
/****** Object:  StoredProcedure [dbo].[FullReportAGM_Vote]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[FullReportAGM_Vote]
	@ClubID int = 0

as

set nocount on

create table #tmp
	(col1 varchar(1000)
	,col2 varchar(1000)
	,col3 varchar(1000)
	,col4 varchar(1000)
	,col5 varchar(1000)
	)
declare @ID int
       ,@ClubName varchar(50)
       ,@ContactDetails varchar(1000)

declare c cursor fast_forward for
	select distinct 
	    C.ID,
		[Club Name] ,
        ContactEMail + ', ' + case when ContactEMail <> eMailAddress then eMailAddress + ', ' else '' end +
		ContactMobNo + ', ' + ContactTelNo + 
		case when U.Telephone <> ContactMobNo and U.Telephone <> ContactTelNo then  + ', ' + U.Telephone else '' end
	from ClubsDetails C
	join AGM_Votes_Cast V on V.ClubID=ID
	cross apply (select top 1 * from Clubusers where ClubID=ID) U
	where @ClubID = 0
	   or @ClubID = ID
open c
fetch c into @ID, @ClubName, @ContactDetails
while @@FETCH_STATUS=0
	begin
	insert #tmp select @ClubName, @ContactDetails,'','',''
	insert #tmp select '','<b>Resolution</b>','<b>For</b>','<b>Against</b>','<b>Withheld</b>'
	insert #tmp
	select  '', 
		Resolution, 
		[For] = case when [For]=1 then 'Y' else '' end, 
		Against = case when Against=1 then 'Y' else '' end, 
		Withheld = case when Withheld=1 then 'Y' else '' end

		from AGM_Votes_Cast V
		left join AGM_Votes_Resolutions R on R.ID = ResolutionID
		cross apply (select * from Clubs where ID=ClubID) C
		cross apply (select * from Clubusers where ClubID=V.ClubID) U
		where @ID = V.ClubID
	insert #tmp select '','','','','' 	

	fetch c into @ID, @ClubName, @ContactDetails

	end
close c
deallocate c


select * from #tmp
drop table #tmp

GO
/****** Object:  StoredProcedure [dbo].[GetAllClubs]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[GetAllClubs]

as

set nocount on

select
	 ID	= isnull(ID,'')
	,[Club Name]	= isnull([Club Name],'')
	,Address1	= isnull(Address1,'')
	,Address2	= isnull(Address2,'')
	,PostCode	= isnull(PostCode,'')
	,ContactName	= isnull(ContactName,'')
	,ClubUserEMail	= isnull(ContactEMail,'')
	,ContactTelNo	= isnull(ContactTelNo,'')
	,ContactMobNo	= isnull(ContactMobNo,'')
	,AvailableTables=MatchTables

	from ClubsDetails 
	where [Club Name] <> 'Bye'
	ORDER BY [Club Name]
GO
/****** Object:  StoredProcedure [dbo].[GetPlayerDetailsByID]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[GetPlayerDetailsByID]
	(@PlayerID int
	)

as 

set nocount on

select  Forename,Initials,Surname,Handicap,[Club Name],Team,Played,Tagged,Over70,email,TelNo,[League Name],[Section Name],LeagueID,SectionID,ClubID,ID
       ,dateRegistered,TeamEmail=isnull(TeamEmail,''),TeamID=isnull(TeamID,0),ClubEmail
	   ,fullName=dbo.FullPlayerName(Forename,Initials,Surname)
	from PlayerDetails P
	outer apply (select TeamEmail=eMail, TeamID=ID 
					from teamsDetails where ClubID=P.ClubID and Team=P.Team and SectionID=P.sectionID)t
	cross apply (select ClubEmail=ContactEmail + isnull(';' + dbo.eMailsForTeamUsers(TeamID),'') from ClubsDetails where ID=P.ClubID)c  
	where ID = @PlayerID
	
	order by LeagueID,SectionID,ClubID, Team


GO
/****** Object:  StoredProcedure [dbo].[GetPlayerDetailsByName]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[GetPlayerDetailsByName]
	(@SurnameOperator int
	,@Surname varchar(50)
	,@ForenameOperator int
	,@Forename varchar(50)
	,@LeagueID int = 0
	)

as 

set nocount on

declare @SurnameExpression varchar(52)
declare @ForenameExpression varchar(52)

if @Surname=''
	set @SurnameExpression='%%'
else 
	set @SurnameExpression= case when @SurnameOperator=0 then '%' + @Surname + '%'
                                 when @SurnameOperator=1 then @Surname + '%'
                                 when @SurnameOperator=2 then '%' + @Surname
                                 when @ForenameOperator=3 then @Surname
                            end     
if @Forename=''
	set @ForenameExpression='%%'
else 
	set @ForenameExpression= case when @ForenameOperator=0 then '%' + @Forename + '%'
                                 when @ForenameOperator=1 then @Forename + '%'
                                 when @ForenameOperator=2 then '%' + @Forename
                                 when @ForenameOperator=3 then @Forename
                            end     

--select  Forename, Initials, Surname, Handicap, [Club Name],Team,Played,Tagged,[Over70(80 Vets)]=Over70,email,TelNo
--      ,[League Name],[Section Name],LeagueID,SectionID,ClubID,ID 
select  Forename,Initials,Surname,Handicap,[Club Name],Team,Played,Tagged,Over70,email,TelNo,[League Name],[Section Name],LeagueID,SectionID,ClubID,ID
       ,dateRegistered,TeamEmail=isnull(TeamEmail,''),TeamID=isnull(TeamID,0),ClubEmail
	   ,fullName=dbo.FullPlayerName(Forename,Initials,Surname)
	from PlayerDetails P
	outer apply (select TeamEmail=eMail, TeamID=ID from teamsDetails where ClubID=P.ClubID and Team=P.Team and SectionID=P.sectionID)t
	cross apply (select ClubEmail=ContactEmail + isnull(';' + dbo.eMailsForTeamUsers(TeamID),'') from clubsDetails where ID=P.ClubID)c  
	where Surname like @SurnameExpression
	  and Forename like @ForenameExpression  
	  and (@leagueID=0 or LeagueID=@LeagueID)
	
	order by LeagueID,SectionID,ClubID, Team


GO
/****** Object:  StoredProcedure [dbo].[GetPlayerDetailsByPlayer]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[GetPlayerDetailsByPlayer]
	(@LeagueID int = 0
	,@SectionID int = 0
	,@ClubID int = 0
	,@Player varchar(150) = ''
	)

as 

set nocount on

--get rid of multiple spaces
while charindex('  ',@Player) > 0
	begin
	print @Player
	set @Player=replace(@Player,'  ',' ')
	end

declare @Players table (Player varchar(100))

declare @word1 varchar(50)
declare @word2 varchar(50)
declare @word3 varchar(50)

select @word1 = word from dbo.WordsInString(@Player) where ordinal=1
select @word2 = word from dbo.WordsInString(@Player) where ordinal=2
select @word3 = word from dbo.WordsInString(@Player) where ordinal=3
select @word1=isnull(@word1,''),@word2=isnull(@word2,''),@word3=isnull(@word3,'')

if @Player <> ''
	insert @Players exec SuggestPlayers @LeagueID,0,0,10000,@word1,@word2,@word3

select  Forename,Initials,Surname,Handicap,[Club Name],Team,Played,Tagged,Over70,email,TelNo,[League Name],[Section Name],LeagueID,SectionID,ClubID,ID
       ,dateRegistered,TeamEmail=isnull(TeamEmail,''),TeamID=isnull(TeamID,0),ClubEmail
	from PlayerDetails P
	outer apply (select TeamEmail=eMail, TeamID=ID from teamsDetails where ClubID=P.ClubID and Team=P.Team and SectionID=P.sectionID)t
	cross apply (select ClubEmail=ContactEmail + isnull(';' + dbo.eMailsForTeamUsers(TeamID),'') from ClubsDetails where ID=P.ClubID)c  
	where (@leagueID=0 or P.LeagueID=@LeagueID)
	  and (@SectionID=0 or P.SectionID=@SectionID)
	  and (@ClubID=0 or P.ClubID=@ClubID)
	  and (@Player =  '' or Forename + case when Initials = '' then ' ' else ' '+Initials+'. ' end + Surname in (select Player from @Players))
	
	order by LeagueID,SectionID,ClubID, Team

GO
/****** Object:  StoredProcedure [dbo].[HandicapChangesReport]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[HandicapChangesReport]
	(@NoOfDays int
	)
as

set nocount on

if (select value from configuration where [key] = 'CloseSeason') = 'False' 
or (select value from configuration where [key] = 'CloseSeason') <> '1'  

begin

select distinct Player
	  ,Team = [Club Name] + case when isnull(Team,'') = '' then '' else ' ' + team end
	  ,Section = [League Name] + ' ' + [Section Name]
	  ,SectionID
	
	into #Players
	
	from PlayersHandicapChanges H
	outer apply (select Player=dbo.FullPlayerName (Forename, Initials, Surname) 
					   ,ClubID,SectionID,LeagueID, Team, eMail 	
						from Players where ID=PlayerID) P
    outer apply (select [Club Name] from ClubsDetails where ID=ClubID) C
	outer apply (select [League Name] from Leagues where ID=LeagueID) L
	outer apply (select [Section Name] from Sections where ID=sectionID) S

	where dateChanged > dateadd(d,-@NoOfDays,dbo.UKdateTime(getUTCdate()))

select  Player
	  ,[Effective Date]=Convert(varchar(11),dateChanged,113)
	  ,Team = [Club Name] + case when isnull(Team,'') = '' then '' else ' ' + team end
	  ,Section = [League Name] + ' ' + [Section Name]
	  ,OldHandicap=Handicap
	  ,NewHandicap 
	  ,dateTimeChanged=dateChanged
	
	into #Details

	from PlayersHandicapChanges H
	outer apply (select Player=dbo.FullPlayerName (Forename, Initials, Surname) 
					   ,ClubID,SectionID,LeagueID, Team, eMail 	
						from Players where ID=PlayerID) P
    outer apply (select [Club Name] from ClubsDetails where ID=ClubID) C
	outer apply (select [League Name] from Leagues where ID=LeagueID) L
	outer apply (select [Section Name] from Sections where ID=sectionID) S

	where dateChanged > dateadd(d,-@NoOfDays,dbo.UKdateTime(getUTCdate()))
	--order by Player,dateChanged

select Player, Team, Section, [Old HCap]= OldHandicap, [New HCap]=NewHandicap, [Effective from] 
	from #Players P
	cross apply (select top 1 OldHandicap from #Details 
							        where Player=P.Player
									  and Team=P.Team
									  and Section=p.Section
									order by dateTimeChanged asc)O
	cross apply (select top 1 NewHandicap, [Effective From]=convert(varchar(11),dateTimeChanged,113) from #Details 
							        where Player=P.Player
									  and Team=P.Team
									  and Section=p.Section
									order by dateTimeChanged desc)N
	--where OldHandicap <> NewHandicap
	order by SectionID, Team
drop table #Details
drop table #Players									   
end

GO
/****** Object:  StoredProcedure [dbo].[MergeClub]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[MergeClub]
	(@ClubID int           --if = -1 insert new record
	,@ClubName varchar(50) --if empty delete record with this ID
	,@Address1 varchar(50) = ''
	,@Address2 varchar(50) = ''
	,@PostCode char(8) = ''
	,@ContactName varchar(104) = ''
	,@ContactTelNo varchar(20) = ''
	,@ContactMobNo varchar(20) = ''
	,@MatchTables int = 0
	)

as
set nocount on    
set xact_abort on

begin tran

MERGE Clubs AS target
    USING (SELECT @ClubID) AS source (ID)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED AND @ClubName='' THEN
		DELETE
    
    WHEN MATCHED THEN 
        UPDATE SET
            [Club Name]		= @ClubName
			,Address1		= @Address1
			,Address2		= @Address2
			,PostCode		= @PostCode
			,ContactName	= @ContactName
			,ContactTelNo	= @ContactTelNo
			,ContactMobNo	= @ContactMobNo
			,MatchTables    = @MatchTables
					
    WHEN NOT MATCHED AND @ClubName <> '' AND @ClubID=-1 THEN    
		INSERT ( [Club Name]
				,Address1
				,Address2
				,PostCode
				,ContactName
				,ContactTelNo
				,ContactMobNo
				,MatchTables
				)
			values(	 @ClubName
					,@Address1
					,@Address2
					,@PostCode
					,@ContactName
					,@ContactTelNo
					,@ContactMobNo
					,@MatchTables)
		
		OUTPUT $action;

if @ClubID = -1
	begin
	declare @val varchar(1000)
	Select @val = [value] from [Configuration] where [key]='AllowLeaguesEntryForms'
	if @val = '1' or @val = 'true'
		insert EntryForm_Clubs
			    (ClubID
				,[Club Name]
				,Address1 
				,Address2
				,PostCode
				,ContactName
				,ContactTelNo
				,ContactMobNo
				,MatchTables
				,WIP
				,PrivacyAccepted
				)
		select top 1 
			*, 0, 0 
			from Clubs
			order by ID desc
	end

commit tran

GO
/****** Object:  StoredProcedure [dbo].[MergeFixtureDates]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[MergeFixtureDates]
	(@SectionID int           
	,@StartDate date
	,@CurfewStart date
	,@CurfewEnd date
	,@NoOfFixtures int
	)

as
set nocount on
set xact_abort on

if @CurfewStart = '1 Jan 1900' --No input from fixtureDates page
and @CurfewEnd  = '1 Jan 1900' --No input from fixtureDates page
	begin
	set @CurfewStart = @StartDate
	set @CurfewEnd   = @StartDate
	end
else
	if @StartDate > @CurfewStart
	or @CurfewStart > @CurfewEnd
		begin
		raiserror('dates must be ascending',15,15)
		return
		end
	
	begin tran

	MERGE FixtureDatesCurfew AS target
	    USING (SELECT @SectionID) AS source (SectionID)
    
	    ON (target.SectionID = source.SectionID)
	    
	    WHEN MATCHED THEN 
		    UPDATE SET
			    StartDate		= @CurfewStart
	           ,Enddate			= @CurfewEnd 
					
	    WHEN NOT MATCHED THEN    
			INSERT ( SectionID, Startdate, Enddate
					)
				values(	 @SectionID, @CurfewStart, @CurfewEnd
				      )
		
		OUTPUT $action;
	
	--rebuild the FixtureDates table
	delete FixtureDates 
		where SectionID=@SectionID

	insert FixtureDates	
		exec GetFixtureDates_Initial @SectionID, @StartDate, @NoOfFixtures

	commit tran

GO
/****** Object:  StoredProcedure [dbo].[PrivacyReport]    Script Date: 05/09/2020 21:45:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[PrivacyReport] 
	(@ClubID int = 0      -- 0 = all clubs
	,@Type int = 0        -- 0=League entries, 1 = Competition entries
	,@Privacy bit = NULL  -- NULL = either
	)
as

set nocount on

create table #PrivacyReportTable
	( ClubID int 
	 ,PrivacyAccepted varchar(15)
	 ,[No of League Players] int
	 ,[No of League Teams] int
	 ,[No of Competitions Entrants] int
    )

if @type = 0
--report clubs without PrivacyAccepted for league entries
	select [Club Name]
	      ,[Privacy Accepted]=case when PrivacyAccepted = 1 then 'Yes' else 'No' end
 	      ,Contact=ContactName
	      ,Mobile=ContactMobNo 
	      ,ClubLoginEMail=ContactEMail 
	      ,[Tel No]=case when isnull(ContactTelNo,'')='' 
							then case when isnull(ContactMobNo,'')=''
							              then Telephone
							              else ContactMobNo
                                 end
							else ContactTelNo 
					end 
		  ,[No of League Players]=playersCount
	      ,[No of League Teams]=teamsCount

	from EntryForm_ClubsDetails EntryForm_Clubs
	outer apply (select playersCount=count(*) from EntryForm_Players where ClubID=EntryForm_Clubs.ClubID)Players
	outer apply (select teamsCount=count(*) from EntryForm_Teams where ClubID=EntryForm_Clubs.ClubID)Teams
	outer apply (Select Telephone from ClubUsers where ClubID = EntryForm_Clubs.ClubID)Users
	where PrivacyAccepted=(case when @Privacy is NULL then PrivacyAccepted
	                            else @Privacy end)  
	  and (playersCount > 0 or teamsCount > 0)
	  and (@ClubID = 0 or @ClubID = ClubID)
	order by [Club Name]

else

	--report clubs without PrivacyAccepted for Competitions entries
	Select [Club Name]
	      ,[Privacy Accepted]=case when PrivacyAccepted = 1 then 'Yes' else 'No' end
 	      ,Contact=ContactName
	      ,Mobile=ContactMobNo 
	      ,eMail=ContactEMail 
	      ,[Tel No]=case when isnull(ContactTelNo,'')='' 
							then case when isnull(ContactMobNo,'')=''
							              then Telephone
							              else ContactMobNo
                                 end
							else ContactTelNo 
					end 
		  ,[No of Competitions Entrants]=EntrantsCount
		from Competitions_EntryFormsClubs E
		left join ClubsDetails Clubs on ID = ClubID
		outer apply (select EntrantsCount=count(*) from Competitions_EntryForms where ClubID=E.ClubID)Entrants
		outer apply (Select Telephone from ClubUsers where ClubID = Clubs.ID)Users
		where PrivacyAccepted=(case when @Privacy is NULL then PrivacyAccepted
	                                else @Privacy end)
			  and EntrantsCount > 0
			  and (@ClubID = 0 or @ClubID = ClubID)

GO

