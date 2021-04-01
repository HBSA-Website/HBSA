USE HBSA
GO

alter table EntryForm_Clubs
	add PrivacyAccepted bit
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_CreateTables')
	DROP procedure EntryForm_CreateTables
GO

create procedure EntryForm_CreateTables

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

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='EntryForm_Fees')
	DROP TABLE EntryForm_Fees

CREATE TABLE EntryForm_Clubs(
	ClubID int NOT NULL,
	[Club Name] varchar(50) NOT NULL,
	Address1 varchar(50),
	Address2 varchar(50),
	PostCode char(8),
	ContactName varchar(104),
	ContactEMail varchar(250),
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
	TelNo varchar(20),
	Contact varchar(104),
	eMail varchar(250),
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

CREATE TABLE EntryForm_Fees(
	Entity varchar(16) NULL,
	LeagueID int NULL,
	Fee money NULL
) 

insert EntryForm_Clubs
			select *, 0, 0, 0 from Clubs 
	
insert EntryForm_Teams
			select   ClubID
					,Team
					,LeagueID
					,TelNo
					,Contact
					,eMail
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



INSERT EntryForm_Fees (Entity, LeagueID, Fee) VALUES ('Club', NULL, 25.00)
INSERT EntryForm_Fees (Entity, LeagueID, Fee) VALUES ('Team', 1, 25.00)
INSERT EntryForm_Fees (Entity, LeagueID, Fee) VALUES ('Team', 2, 20.00)
INSERT EntryForm_Fees (Entity, LeagueID, Fee) VALUES ('Team', 3, 20.00)

--if not exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='PaymentsHistory')
--	select top 0 * into PaymentsHistory from Payments

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


exec EntryForm_CreateTables


use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'endOfSeason')
	drop procedure endOfSeason
GO


create procedure [dbo].[endOfSeason]

as

set nocount on
set xact_abort on

--This routine is used between seasons nto perform various housekeeping tasks
--to finish off a season, and prepare for the next season

declare @Season int
set @Season = datepart(year,getdate())

begin tran

--step 1:  create Historic Player Records for the season just past
create table #temp
	(HCapEffectice date
	,Section varchar(101)
	,Team varchar(52)
	,Player varchar(106)
	,Handicap int
	,tag varchar(15)
	,Over70 varchar(5)
	,Played int
	,Won int
	,Lost int
	,PlayerID int)

insert #temp
	exec [PlayingRecords]

delete PlayerRecords where Season=@Season	
insert PlayerRecords
	select 
       LeagueID=case when section like '%Open%' then 1
                     when section like '%Vet%' then 2
                     when section like '%bill%' then 3
                     else 0
                end
      ,[Player]
      ,[Season]=@Season
      ,[Hcap]=Handicap
      ,[P]=Played
      ,[W]=Won
      ,[L]=Lost
      ,[Team]=Team
      ,[Tag] = tag
	  ,PlayerID
	  ,Forename
	  ,Initials
	  ,Surname

	from #temp 
	outer apply (select Surname, Initials, Forename from Players where ID=PlayerID) p
	where Team is not null
	order by LeagueID,Player

drop table #temp	

--Step 2: create historic breaks table with last seasons recorded breaks
--        first time through will create table
IF  not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('Breaks_Historic') AND type in (N'U'))
	CREATE TABLE Breaks_Historic
		(ID int IDENTITY(1,1)
		,Season int
		,Section varchar(101)
		,Player varchar(104)
		,[Break] int
		,LeagueID int
		,SectionID int
		,PlayerID int
        ) 
delete Breaks_Historic
	where Season=@Season
insert Breaks_Historic
	select @Season
	      ,[League Name] + ' ' + [Section Name]
	      ,Player=Forename+case when isnull(Initials,'')='' then ' ' else ' ' + Initials+'. ' end + Surname
	      ,[Break]
	      ,P.LeagueID
	      ,P.SectionID
	      ,B.PlayerID
	from Breaks B
	join Players P on P.ID=B.PlayerID
	join Sections S on S.ID=P.SectionID
	join Leagues L on L.ID=P.LeagueID 
	order by P.LeagueID,P.SectionID,Player

--Step 3: create table of last season's ending handicaps with playing record
--        and calculated new handicaps
exec GenerateHandicapsReport

--Step 4: Set up Entry Forms
exec EntryForm_CreateTables

--Set config as in close season
update Configuration	
	set value=1
	where [key] = 'CloseSeason'	

--Set config as League entry forms not allowed
update Configuration	
	set value=0
	where [key]='AllowLeaguesEntryForms'

commit tran

GO

use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_UpdateWIP')
	drop procedure EntryForm_UpdateWIP
GO

create procedure [dbo].[EntryForm_UpdateWIP]
	(@ClubID int
	,@WIP int = 1  -- 0 = Untouched - from Clubs table
	               -- 1 = In progress - i.e. being prepared by user
				   -- 2 = Submitted - i.e. prepared & submitted by a user
				   -- 3 = Fixed - i.e. accepted by HBSA and not changeable
	,@user varchar(1024)
	)
as

set nocount on
set xact_abort on

begin tran

update EntryForm_Clubs
	set WIP = @WIP
	where ClubID=@ClubID

insert ActivityLog
	select getdate(),'EntryForm WIP Change to ' + convert(varchar,@WIP),@ClubID,@user

commit tran

GO

USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[EntryForm_MergeClub]    Script Date: 12/12/2014 17:46:00 ******/
if exists(select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_MergeClub')
	drop procedure EntryForm_MergeClub
GO

create procedure [dbo].[EntryForm_MergeClub]
	(@ClubID int           --if = -1 insert new record
	,@ClubName varchar(50) --if empty delete record with this ID
	,@Address1 varchar(50) = ''
	,@Address2 varchar(50) = ''
	,@PostCode char(8) = ''
	,@ContactName varchar(104) = ''
	,@ContactEMail varchar(250) = ''
	,@ContactTelNo varchar(20) = ''
	,@ContactMobNo varchar(20) = ''
	,@MatchTables int = 0
	,@PrivacyAccepted bit = 0
	)

as
set nocount on     
set xact_abort on

begin tran

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
		select @ClubID=max(ClubID)+1 from EntryForm_Clubs

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
			,ContactEMail	= @ContactEMail
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
				,ContactEMail
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
					,@ContactEMail
					,@ContactTelNo
					,@ContactMobNo
					,@MatchTables
					,1
					,0)
			;
	
--return the (new) clubID
	select @ClubID
	
commit tran

GO
use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_Details')
	drop procedure EntryForm_Details
GO

create procedure EntryForm_Details
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
					,TelNo
					,Contact
					,eMail
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
	from EntryForm_Clubs C
	where ClubID=@ClubID 

select  League = [League Name]
       ,Team
 	   ,T.LeagueID
	   ,Contact = isnull(Contact,'')
	   ,eMail = isnull(eMail,'')
	   ,telNo = isnull(telNo,'')
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
		,P.eMail
		,P.TelNo
		,Tag = dbo.TagDescription(Tagged)
       ,Over70
	   ,Tagged
	   ,ReRegister

	from EntryForm_Players P
	join EntryForm_Teams T on T.ClubID=P.ClubID and T.Team=P.Team and T.LeagueID=P.LeagueID
	where P.ClubID=@ClubID
	order by LeagueID,P.Team,Forename,Surname

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
select * from EntryForm_Clubs where PrivacyAccepted=0

--delete teams & players for clubs which have not accepted privacy
declare clubCursor  cursor fast_forward for
	select ClubID from EntryForm_Clubs
	              where PrivacyAccepted=0
declare @ClubID int
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
		exec removeTeam @teamID, @user

	
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
			,ContactEMail	= source.ContactEMail
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
				,ContactEMail
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
					,source.ContactEMail
					,source.ContactTelNo
					,source.ContactMobNo
					,source.MatchTables)
	;
set identity_insert Clubs off

--teams
--ID	SectionID	FixtureNo	ClubID	Team	TelNo	Contact	eMail
MERGE Teams AS target
    USING (SELECT * from EntryForm_Teams) AS source 
    
    ON (target.ID  = source.TeamID )
    
	WHEN MATCHED THEN 
        UPDATE SET
             Team=source.team
			,Contact=source.Contact
			,eMail=source.eMail
			,TelNo=source.TelNo
					
    WHEN NOT MATCHED THEN    
		INSERT	(SectionID
				,FixtureNo
				,ClubID
			    ,Team
				,TelNo
				,Contact
				,eMail
				)
		values	((Select max(ID) from sections where LeagueID=source.LeagueID)  --new team into lowest section of this league
				,0 -- FixtureNo
				,source.ClubID
				,source.Team
				,source.TelNo
				,source.Contact
				,source.eMail
				)
		;

--teams with no matching entry form teams need removing 
delete teams
	where Teams.ID not in (select TeamID from EntryForm_Teams)

--Players
--ID	Forename	Initials	Surname	Handicap	LeagueID	SectionID	ClubID	Team	email	TelNo	Tagged	Over70	Played	dateRegistered
--Entry Form
--PlayerID	ClubID	LeagueID	Team	Forename	Initials	Surname	Handicap	email	TelNo	Tagged	Over70  ReRegister
merge
	Players as target
	using (select * from EntryForm_Players) as source
		        
	on target.ID=source.PlayerID

	when matched then
		update set ClubID		= source.clubID 
				  ,SectionID    = case when source.ClubID=0 or ReRegister=0 then 0 
				                       when target.SectionID = 0 then (select max(ID) from sections where LeagueID=source.LeagueID) 
				                       else target.SectionID end  -- if ClubId is zero = entry form deleted.  If ReRegister is zero(false) flag the the player deleted
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
			,isnull((select SectionID from teams where sectionID in (select ID from sections where LeagueID=source.LeagueID) and ClubID=source.clubid and team=source.team)
					,(select max(ID) from sections where LeagueID=source.LeagueID))
			,source.ClubID
			,source.Team
			,source.email
			,source.Telno
			,source.Tagged
			,source.Over70
			,0
			, getdate())
	;

INSERT ActivityLog select getdate(),'Apply Entry Forms',0,@user

commit tran

GO

USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ClubDetails')
	drop procedure ClubDetails
GO

create procedure ClubDetails
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
	  ,TelNo=isnull(TelNo,'')	from Teams 
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
				from Clubs 
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
	  ,Contact=isnull(Contact,'')
	  ,eMail=isnull(eMail,'')
	  ,TelNo=isnull(TelNo,'')	from Teams 
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

USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[MergeTeam]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'removeTeam')
	drop procedure dbo.removeTeam
GO

CREATE procedure [dbo].[removeTeam]
	(@TeamID int
	,@User varchar(255)
	)
as

-- this procedure removes a team from its league
-- note there is no activity recorded or logged

set nocount on	
set xact_abort on

begin tran

	declare @TeamName varchar (256)
	select @TeamName = rtrim([Club Name] + ' ' + Team)
		from Teams 
		cross apply (select [Club Name]
						from clubs where ID = ClubID) C
		where ID=@TeamID
	
	update Players set SectionID=0, Team=''
		from Teams T
		join Clubs C on T.ClubID=C.ID
		join Players P on P.ClubID=C.ID
			          and P.SectionID=T.SectionID
				      --and Played=1
		where T.ID=@TeamID

	--remove recorded breaks
	delete Breaks
		from MatchResults 
		join Breaks on MatchResultID=MatchResults.ID
		where HomeTeamID=@TeamID or AwayTeamID=@TeamID

	--remove match results
	delete 
		from MatchResults 
		where HomeTeamID=@TeamID
		   or AwayTeamID=@TeamID

	--remove adjustments
	delete 
		from LeaguePointsAdjustment 
		where TeamID=@TeamID

	--remove the team keeping details in Teams_Removed
	select * From Teams where ID=@TeamID
	update Teams 
		set ClubID=8, 
		    team='',
			Contact='',
			TelNo=''
		where ID=@TeamID

	--remove logins for this team
	delete 
		from ResultsUsers 
		where TeamID=@TeamID

	--log it
	insert Activitylog values (getdate(),'Team removed(' + @TeamName + ')',@TeamID,isnull(@User,original_login()))
	
commit tran

GO
