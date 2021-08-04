USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ApplyEntryForms')
	drop procedure ApplyEntryForms
GO

create procedure ApplyEntryForms 
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

if not exists(select ID from Clubs where [Club Name] = 'Bye')
	insert Clubs
				(ID
		        ,[Club Name]
				,Address1
				,Address2
				,PostCode
				,ContactName
				,ContactTelNo
				,ContactMobNo
				,MatchTables)
		select 8,'Bye','','','','','','',0

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
		update set ClubID		= case when source.ClubID=0 then target.ClubID else source.clubID end --If Club id is zero leave club alone.
				  ,SectionID    = case when source.ClubID=0 or ReRegister=0 then 0 -- set deleted if not register or deleted in entry form (clubid=0)
				                       else --calculate the section from the matching team
									        (isnull((select SectionID from teams 
														where ClubID=source.ClubID 
														  and SectionID in (select ID from Sections where LeagueID=source.LeagueID) 
														  and Team=source.team),
		                                            (select max(ID) from Sections where LeagueID=source.LeagueID)))
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
			,case when ReRegister=0 or ClubID = 0 
					then 0
					--calculate the section from the matching team
					else
						(isnull((select SectionID from teams 
									where ClubID=source.ClubID 
									  and SectionID in (select ID from Sections where LeagueID=source.LeagueID) 
									    and Team=source.team),
		                        (select max(ID) from Sections where LeagueID=source.LeagueID)))
             end  -- if ClubId is zero = entry form deleted.  If ReRegister is zero(false) flag the the player deleted

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

--exec ApplyEntryForms 'test'
--select * from Clubs where ID=8
