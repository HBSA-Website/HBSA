use hbsa
go

drop table Teams_Removed

select [League Name], [Club Name],T.ClubID,T.Team, T.LeagueID,
       [Team Contact] = T.Contact,
	   [Team eMail] = T.eMail,
	   [Team TelNo] = T.TelNo,
       [Player Contact] = isnull(dbo.FullPlayerName(P.ForeName, P.Initials, P.Surname),''),
	   [Player eMail] = isnull(P.eMail,''),
	   [Player TelNo] = isnull(P.TelNo,''),
	   PlayerID
into #tmp
	from EntryForm_teams T 
	outer apply (select top 1 * from  EntryForm_Players P
					where T.ClubID = ClubID
					 and T.Team=Team
					 and LeagueID = T.LeagueID
					 and (     case when T.eMail = '' then 'xxxxx' else T.email end = email
							or case when T.TelNo = '' then 'xxxxx' else T.Telno end  = TelNo
							or T.Contact = dbo.FullPlayerName(ForeName, Initials, Surname))
					  		) P
	outer apply (select [Club Name] from EntryForm_Clubs where ClubID=T.ClubID) C
	outer apply (select [League Name] from Leagues where ID = T.LeagueID) L

	order by [League Name], [Club Name], T.Team

update EntryForm_Players
	set email = case when [Player eMail]='' then [Team eMail] else [Player eMail]  end
       ,TelNo = case when [Player TelNo]='' then [Team TelNo] else [Player TelNo]  end
	from EntryForm_Players P
	join #tmp T on P.PlayerID=T.PlayerID

alter table EntryForm_Teams
	drop column Contact
	           ,email
			   ,TelNo
alter  table EntryForm_Teams
	add Captain int

update EntryForm_Teams
	set Captain = T.PlayerID
	from EntryForm_Teams E
	join #tmp T on T.ClubID = E.ClubID 
	           and T.LeagueID = E.LeagueID
			   and T.Team = E.Team 
drop table #tmp

select [League Name], [Club Name],T.ClubID,T.Team, T.SectionID,
       [Team Contact] = T.Contact,
	   [Team eMail] = T.eMail,
	   [Team TelNo] = T.TelNo,
       [Player Contact] = isnull(dbo.FullPlayerName(P.ForeName, P.Initials, P.Surname),''),
	   [Player eMail] = isnull(P.eMail,''),
	   [Player TelNo] = isnull(P.TelNo,''),
	   PlayerID=P.ID
into #tmp2
	from teams T 
	outer apply (select top 1 * from  Players P
					where T.ClubID = ClubID
					 and T.Team=Team
					 and SectionID = T.SectionID
					 and (     case when T.eMail = '' then 'xxxxx' else T.email end = email
							or case when T.TelNo = '' then 'xxxxx' else T.Telno end  = TelNo
							or T.Contact = dbo.FullPlayerName(ForeName, Initials, Surname))
					  		) P
	outer apply (select [Club Name] from Clubs where ID=T.ClubID) C
	outer apply (select [League Name] from Leagues where ID = (select LeagueID from Sections where ID = T.SectionID)) L
	where T.SectionID > 0
	  and [Club Name]<> 'Bye'
	order by [League Name], [Club Name], T.Team

update Players
	set email = case when [Player eMail]='' then [Team eMail] else [Player eMail]  end
       ,TelNo = case when [Player TelNo]='' then [Team TelNo] else [Player TelNo]  end
	from Players P
	join #tmp2 T on P.ID=T.PlayerID

alter table Teams
	drop column Contact
	           ,email
			   ,TelNo
alter  table Teams
	add Captain int

update Teams
	set Captain = T.PlayerID
	from Teams E
	join #tmp2 T on T.ClubID = E.ClubID 
	           and T.SectionID = E.SectionID
			   and T.Team = E.Team 
drop table #tmp2

GO
update EntryForm_Teams 
	set Captain=574
	where ClubID=35 and Team='B'
update Entryform_Players
	set TelNo='07584 669228'
	where PlayerID=574
GO
if exists(select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'TeamsDetails')
	drop view dbo.TeamsDetails
GO
create view	dbo.TeamsDetails

as

select ID, SectionID, FixtureNo, ClubID, Team, Contact, email, TelNo, Captain
	from Teams p
	outer apply (select Contact=dbo.FullPlayerName(Forename,Initials,Surname), eMail, TelNo 
					from Players 
					where ID=Captain)X
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_MergeTeam')
	drop procedure EntryForm_MergeTeam
GO

--EntryID	TeamID	SectionID	FixtureNo	ClubID	Team	TelNo	Contact	eMail

CREATE procedure [dbo].[EntryForm_MergeTeam]
	(@ClubID int
	,@LeagueID	int		--if = -1 delete record
	,@Team char(1)
	,@Captain int
	)
as
set nocount on     
set xact_abort on

MERGE EntryForm_Teams AS target
    USING (SELECT @ClubID,@LeagueID,@Team) AS source (ClubID, LeagueID,Team)
    
    ON (    target.ClubID   = source.ClubID 
	    AND target.LeagueID  = source.LeagueID
		AND target.Team      = source.team          )
    
    WHEN MATCHED and @LeagueID < 0 THEN
		DELETE
	 
	WHEN MATCHED THEN 
        UPDATE SET
             Team=@Team
			,Captain=@Captain
					
    WHEN NOT MATCHED THEN    
		INSERT	(ClubID
			    ,LeagueID
				,Team
				,Captain
				)
		values	(@ClubID
				,@LeagueID
				,@Team
				,@Captain
				)
		
		OUTPUT $action;

GO
create TRIGGER [HandicapChange]
   ON  [Players]
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
            outer apply (select ContactEMail from Clubs where ID=P.ClubID) C
			outer apply (select ID from teams where ClubID=P.ClubID and SectionID=deleted.SectionID) T

			where P.Handicap <> deleted.Handicap

END
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
	from EntryForm_Clubs C
	where ClubID=@ClubID 

select  League = [League Name]
       ,Team
 	   ,T.LeagueID
	   ,Captain = isnull(Captain,0)
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
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_SetTeamCaptain')
	drop procedure dbo.EntryForm_SetTeamCaptain
GO

create procedure dbo.EntryForm_SetTeamCaptain 
	(@PlayerID int
	,@Captain bit
	)

as

set nocount on

update EntryForm_Teams
	set Captain = case when @Captain = 1 then @PlayerID else 0 end
	from EntryForm_Teams T
	join (select ClubID, LeagueID, Team from EntryForm_Players where PlayerID=@PlayerID) P
	  on T.ClubID   = P.ClubID
     and T.LeagueID = P.LeagueID
	 and T.Team     = P.team

GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_FullReportForClub')
	DROP procedure EntryForm_FullReportForClub
GO

create procedure EntryForm_FullReportForClub
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
	select 'Address 1', Address1,'eMail',ContactEMail,'','','',''
		from EntryForm_Clubs TeamsCursor
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
		from EntryForm_Teams T
		join Leagues on ID=LeagueID 
		outer apply (Select TelNo, Contact=dbo.FullPlayerName(Forename,Initials,Surname), eMail from EntryForm_Players where PlayerID=Captain) P
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
		select 'Captain/Contact',@Contact,'','','','','',''
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
if exists(select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'EntryForm_TeamDetail')
	drop view dbo.EntryForm_TeamDetail
GO

create view	dbo.EntryForm_TeamDetail

as

select ClubID,Team,LeagueID,TeamID,Contact,eMail,TelNo,Captain
	from EntryForm_Teams p
	outer apply (select Contact=dbo.FullPlayerName(Forename,Initials,Surname), eMail, TelNo 
					from EntryForm_Players 
					where PlayerID=Captain)X
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'TeamDetails')
	drop procedure TeamDetails
GO

create procedure TeamDetails
	(@TeamID int = 0
	,@LeagueID int = 0
	,@ClubID int = 0
	,@team char(1) = ''
	)
as
set nocount on
	
if @TeamID=0
	select @TeamID=ID 
		from Teams
		where SectionID in (select ID from Sections where LeagueID=@LeagueID)
		  and ClubID=@ClubID
		  and team=@team

select LeagueID=isnull(LeagueID,0)
      ,[League Name]=isnull([League Name],'')
	  ,SectionID
	  ,[Section Name]=isnull([Section Name],'')
	  ,ClubID, [Club Name], TeamID=T.ID, Team, FixtureNo
	  ,Contact=isnull(Contact,'')
	  ,eMail=isnull(eMail,'')
	  ,TelNo=isnull(TelNo,'')
	  ,Captain

	from    TeamsDetails T 
	join Clubs C on C.ID=T.ClubID
	left join Sections S on S.ID=T.SectionID
	left join Leagues L on L.ID=S.LeagueID
	
	where T.ID=@TeamID

select P.*
	from Teams T 
	join Clubs C on C.ID=T.ClubID
	--join Sections S on S.ID=T.SectionID
	join Players P on P.ClubID=C.ID and P.Team=T.Team and P.SectionID=T.sectionID
	
	where T.ID=@TeamID
	
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MergeTeam')
	drop procedure MergeTeam
GO

CREATE procedure [dbo].[MergeTeam]
	(@TeamID int        --if = -1 insert new record
	,@SectionID	int		--if = -100 delete record
	,@FixtureNo	int     --if = -1 set next available
	,@ClubID int
	,@Team char(1)
	,@Captain int
	,@User varchar(255) = ''
	)
as
set nocount on     
set xact_abort on

begin tran

declare @TeamName varchar (256)
select @TeamName = rtrim([Club Name] + ' ' + Team)
	from Teams 
	cross apply (select [Club Name]
					from clubs where ID = ClubID) C
	where ID=@TeamID

declare @FixtureNumber int
set @FixtureNumber=@FixtureNo

if @FixtureNumber = -1 and @SectionID > 0
	begin
	set @FixtureNumber=@FixtureNumber+1
	declare @fNo int
	declare TeamsCursor cursor fast_forward for
		select FixtureNo
			from Teams
			where SectionID=@SectionID
			order by FixtureNo
	open TeamsCursor
	fetch TeamsCursor into @fNo
	while @fNo = @FixtureNumber+1
		begin
		if @fNo = @FixtureNumber+1
			begin
			set @FixtureNumber=@FixtureNumber+1
			fetch TeamsCursor into @fNo
			end
		end
	
	close TeamsCursor
	deallocate TeamsCursor
	set @FixtureNumber=@FixtureNumber+1
	end

MERGE Teams AS target
    USING (SELECT @TeamID) AS source (ID)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED AND @SectionID=-100 THEN
		DELETE

	WHEN MATCHED THEN 
        UPDATE SET
             SectionID=@SectionID  --  negative implies delete as it becomes orphaned
			,FixtureNo=@FixtureNumber
			,ClubID=@ClubID
			,Team=@Team
			,Captain=@Captain
					
    WHEN NOT MATCHED AND @TeamID=-1 THEN    
		INSERT	(SectionID
				,FixtureNo
				,ClubID
				,Team
				,Captain
				)
		values	(@SectionID
				,@FixtureNumber
				,@ClubID
				,@Team
				,@Captain
				)
		
		OUTPUT $action,inserted.ID;

	--log it
	insert Activitylog values (dbo.UKdateTime(getUTCdate()),'Team merged(' + @TeamName + ')',@TeamID,isnull(@User,original_login()))

commit tran

GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'removeTeam')
	drop procedure dbo.removeTeam
GO

CREATE procedure [dbo].[removeTeam]
	(@TeamID int
	,@User varchar(255)
	)
as

-- this procedure removes a team from its league
-- along with its results, and disassociates players

set nocount on	
set xact_abort on

begin tran

	declare @TeamName varchar (256)
	select @TeamName = rtrim([Club Name] + ' ' + Team)
		from Teams 
		cross apply (select [Club Name]
						from clubs where ID = ClubID) C
		where ID=@TeamID
	
	--disassociate the players
	update Players set SectionID=0, Team=''
		from Teams T
		join Players P on P.ClubID=T.ClubID
			          and P.SectionID=T.SectionID
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
		
	--Change the team to a bye to retain the fixture structure
	update Teams 
		set ClubID=8, 
		    Captain=0
		where ID=@TeamID

	--remove logins for this team
	delete 
		from ResultsUsers 
		where TeamID=@TeamID

	--log it
	insert Activitylog values (dbo.UKdateTime(getUTCdate()),'Team removed(' + @TeamName + ')',@TeamID,isnull(@User,original_login()))
	
commit tran

GO
if exists(select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GetAllTeams')
	drop procedure dbo.GetAllTeams
GO

create procedure [dbo].[GetAllTeams]
	(@LeagueID int = 0
	,@SectionID int = 0
	)

as

set nocount on

select
	 TeamsDetails.ID
	,[Club Name]=isnull([Club Name],'')
	,ClubID
	,Team
	,League=isnull([League Name],'')+' '+isnull([Section Name],'')
	,FixtureNo
	,[Captain/Contact]=isnull(Contact,'')
	,eMail=isnull(eMail,'')
	,TelNo=isnull(TelNo,'')
	,Captain

	from TeamsDetails 
	left join Sections on Sections.ID=SectionID
	left join Leagues on Leagues.ID=LeagueID
	join Clubs on Clubs.ID=ClubID
	
	where (@LeagueID=0 or LeagueID=@LeagueID)
	  and (@SectionID=0 or SectionID=@SectionID)
	  --and [Club Name] <> 'Bye'
	
	order by LeagueID,SectionID,FixtureNo

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

	from EntryForm_Clubs 
	outer apply (select playersCount=count(*) from EntryForm_Players where ClubID=EntryForm_Clubs.ClubID)Players
	outer apply (select teamsCount=count(*) from EntryForm_Teams where ClubID=EntryForm_Clubs.ClubID)Teams
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
if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ContactsReport')
	drop procedure dbo.ContactsReport
go

create procedure dbo.ContactsReport

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
	    ,Email = ContactEMail
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
	    ,Email = ContactEMail
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
	outer apply (select Contact=dbo.FullPlayerName(Forename,Initials,Surname), eMail, TelNo from EntryForm_Players where ID=Captain)X

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

go
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



INSERT EntryForm_Fees (Entity, LeagueID, Fee) VALUES ('Club', NULL, 25.00)
INSERT EntryForm_Fees (Entity, LeagueID, Fee) VALUES ('Team', 1, 25.00)
INSERT EntryForm_Fees (Entity, LeagueID, Fee) VALUES ('Team', 2, 20.00)
INSERT EntryForm_Fees (Entity, LeagueID, Fee) VALUES ('Team', 3, 20.00)

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
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_FullReportForClub')
	DROP procedure EntryForm_FullReportForClub
GO

create procedure EntryForm_FullReportForClub
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
	select 'Address 1', Address1,'eMail',ContactEMail,'','','',''
		from EntryForm_Clubs TeamsCursor
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
	select T.Team, T.LeagueID, TelNo, Contact=dbo.FullPlayerName(Forename, Initials, Surname), P.eMail, [League Name]
		from EntryForm_Teams T
		left join EntryForm_Players P on PlayerID=Captain 
		join Leagues on ID=P.LeagueID 
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
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_SummaryReport_ContactsByState')
	DROP procedure EntryForm_SummaryReport_ContactsByState
GO

create procedure EntryForm_SummaryReport_ContactsByState

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
		from EntryForm_Clubs
		where WIP = @WIP
    declare @ClubID int, @ContactName varchar(104), @ContactEMail varchar(250)
	open Clubs_Cursor
	Fetch Clubs_Cursor into @ClubID, @ContactName, @ContactEMail
	while @@fetch_status=0
		begin
		set @tmp=case when @ContactEMail <> '' then case when @ContactName<>'' then '('+@ContactName+')' else '' end + @ContactEMail else '' end
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

		Fetch Clubs_Cursor into @ClubID, @ContactName, @ContactEMail
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
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Competitions_EntrantsReport')
	drop procedure Competitions_EntrantsReport
GO

CREATE procedure Competitions_EntrantsReport 
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
	    outer apply (select top 1 * from Clubs where ID=E.ClubID) Clubs -- OR ID=P.ClubID OR ID=P2.ClubID OR ID=T.ClubID) Clubs
        OUTER apply (Select [Club Name] = ISNULL([Club Name],'') from Clubs where ID=  P.ClubID) L
        OUTER apply (Select [Club Name] = ISNULL([Club Name],'') from Clubs where ID=  T.ClubID) M

		where CompetitionID=@CompetitionID
		order by  [Entrant(s)]

GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='CompetitionPotentialEntrants')
	drop procedure CompetitionPotentialEntrants
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure dbo.CompetitionPotentialEntrants
	(@CompetitionID int
	,@ClubID int
	,@ALL bit
	,@sortBy bit = 0 --0 sort by surname, 1 sort by forename
    )

as

set nocount on

declare @LeagueID int
	   ,@CompType int
select @LeagueID = LeagueID
	  ,@CompType = CompType
	from Competitions
	where ID=@CompetitionID

if @CompType<>4
	begin
	select ID
	      ,Entrant=dbo.FullPlayerName(Forename,Initials,Surname) +
		           case when @CompType=2 then '(' + convert(varchar,Handicap) + ')' else '' end +
				   case when P.ClubID <> @ClubID then ' [' + [Club Name] + ']' else '' end
		
		from Players P
		left join Competitions_EntryForms C
		  on CompetitionID=@CompetitionID
         and LeagueID=@LeagueID 
		 and (ID=EntrantID or ID=Entrant2ID)
        cross apply (Select [Club Name] from Clubs where ID=P.ClubID) L
		where P.LeagueID=@LeagueID
		  and (P.ClubID=@ClubID or @ALL = 1)
		  and C.CompetitionID is null
		  --and P.sectionID <> 0
		order by case when P.ClubID=@ClubID then ' ' else P.ClubID end
		        ,case when @sortBy=0 then Surname else dbo.FullPlayerName(Forename,Initials,Surname) end

	select EntrantID 
	      ,Entrant=dbo.FullPlayerName(P.Forename,P.Initials,P.Surname) +
		           case when @CompType=2 then '(' + convert(varchar,P.Handicap) + ')' else '' end +
				   case when @CompType=3 then '/' + dbo.FullPlayerName(P2.Forename,P2.Initials,P2.Surname)
				                         else ''
                   end           ,P.TelNo
    	  ,P.eMail
		 
		from Competitions_EntryForms C
		join Players P
		  on P.ID=EntrantID
		left join Players P2
		  on P2.ID=Entrant2ID
		where P.LeagueID=@LeagueID
		  and CompetitionID=@CompetitionID
		  and C.ClubID=@ClubID
		order by P.Surname
	end
else
	begin
	select T.ID
	      ,Entrant=[Club Name] + ' ' + Team
		from TeamsDetails T
		left Join Clubs on Clubs.ID=ClubID 
		left join Competitions_EntryForms C
		  on CompetitionID=@CompetitionID
		 and T.ID=EntrantID
		where (SectionID in (Select ID from sections where LeagueID=@LeagueID) or SectionID=-1)
		  and T.ClubID=@ClubID
		  and C.CompetitionID is null
		order by Team

	select EntrantID 
	      ,Entrant=[Club Name] + ' ' + Team
          ,TelNo=T.TelNo
    	  ,eMail=T.eMail
		from Competitions_EntryForms C
		join TeamsDetails t on T.ID=EntrantID
		join Clubs on Clubs.ID=T.ClubID
		where CompetitionID=@CompetitionID
		  and C.ClubID=@ClubID
		order by Team
	end

	GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetCompetitionDetails')
	drop procedure GetCompetitionDetails
GO
create procedure GetCompetitionDetails
	(@CompetitionID int
	)
as

set nocount on

declare @CompType int
	   ,@NoRounds int
select @CompType=CompType 
	  ,@NoRounds = NoRounds
	from Competitions where ID =@CompetitionID

declare @PlayBydates table
	(RoundNo int
	,PlayByDate date
	,Comment varchar(256)
	)

declare @RoundNo int
set @RoundNo=0

while @RoundNo <= @NoRounds
	begin
	   
	if @CompType = 4
		select EntryID,RoundNo,EntrantID,Entrant2ID,Entrant=isnull(Entrant,'Bye'),Entrant2=NULL,eMail,TelNo
			from Competitions_Entries
			outer apply (select Entrant = [Club Name] + ' ' + Team,eMail, TelNo
							From TeamsDetails Teams
							join Clubs on ClubID=Clubs.ID 
							where Teams.ID=EntrantID)TeamName
			  where CompetitionID=@CompetitionID
			    and RoundNo = @RoundNo
			order by EntryID	    
		    
	else
	if @comptype=3
		select EntryID,RoundNo,EntrantID,Entrant2ID,Entrant=isnull(Entrant,'Bye'),Entrant2,eMail,TelNo
			from Competitions_Entries
			outer apply (select Entrant	= dbo.FullPlayerName(Forename,Initials,Surname)
			                            + '[' + [Club Name] +']'
			                  ,eMail,TelNo
							From PlayerDetails 
							where ID=EntrantID
				        ) PlayerName
			outer apply (select Entrant2 = dbo.FullPlayerName(Forename,Initials,Surname)
			                             + '[' + [Club Name] +']'
							From PlayerDetails 
							where ID=Entrant2ID
				        ) PlayerName2
			where CompetitionID = @CompetitionID 
			  and RoundNo = @RoundNo
			order by EntryID

	else
	if @CompType=2
		select EntryID,RoundNo,EntrantID,Entrant2ID,Entrant=isnull(Entrant,'Bye'),Entrant2=NULL,eMail,TelNo
			from Competitions_Entries
			outer apply (select Entrant	= dbo.FullPlayerName(Forename,Initials,Surname) +
											' (' + CONVERT(varchar,Handicap)+ ')'
			                            + '<br/>' + [Club Name]
							   ,eMail,TelNo
							From PlayerDetails 
							where ID=EntrantID
					    ) PlayerName
			where CompetitionID = @CompetitionID 
			  and RoundNo = @RoundNo
			order by EntryID
	else

		select EntryID,RoundNo,EntrantID,Entrant2ID,Entrant=isnull(Entrant,'Bye'),Entrant2=NULL,eMail,TelNo
			from Competitions_Entries
			outer apply (select Entrant	= dbo.FullPlayerName(Forename,Initials,Surname)
			                            + '<br/>' + [Club Name]
                               ,eMail,TelNo
							From PlayerDetails 
							where ID=EntrantID
					    ) PlayerName
			where CompetitionID = @CompetitionID 
			  and RoundNo = @RoundNo
			order by EntryID

	-- May look strange, but ensures we get NULL values for rounds with no record yet
	insert @PlayBydates
		select @RoundNo
			  ,(select PlayByDate from Competitions_Rounds where CompetitionID=@CompetitionID and @RoundNo=RoundNo and EntryID is null)
		      ,(select Comment from Competitions_Rounds    where CompetitionID=@CompetitionID and @RoundNo=RoundNo and EntryID is null)

	set @RoundNo=@RoundNo+1

	end

select * from @PlayBydates

GO
If exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GetFixtureDates')
	drop procedure dbo.GetFixtureDates
GO

CREATE procedure [dbo].[GetFixtureDates] 
	 @TeamID int
as

set nocount on

declare @StartYear int
       ,@SectionID int
select @SectionID=SectionID from Teams where ID=@TeamID
select top 1 
	@StartYear=datepart(Year,FixtureDate) 
	from FixtureDates 
	where SectionID=@SectionID
	order by FixtureDate

select G.WeekNo, [Date]=convert(varchar(11),FixtureDate,113)
      ,AwayTeamID=A.ID, AwayTeam=C.[Club Name] + ' ' + A.Team
	  ,HalfWay=convert(bit,case when FixtureDate > (select Fixturedate from FixtureDates where SectionID=@SectionID and weekNo = SectionSize-1) then 1 else 0 end)
	from Teams T
	
	Join FixtureGrids G
	  on G.SectionID=T.SectionID
	  
	join FixtureDates D
		on D.WeekNo=G.WeekNo
	   and D.SectionID = @SectionID
	   
	join Teams A --AwayTeam
	  on A.SectionID=T.SectionID
	 and A.FixtureNo=case when h1=T.FixtureNo then a1   
	                      when h2=T.FixtureNo then a2
	                      when h3=T.FixtureNo then a3
	                      when h4=T.FixtureNo then a4
	                      when h5=T.FixtureNo then a5
	                      when h6=T.FixtureNo then a6
	                      when h7=T.FixtureNo then a7
	                      when h8=T.FixtureNo then a8
	                 end     
   	 join Clubs C
   	   on C.ID=A.ClubID 
   	   
	where T.ID=@TeamID
	  and   ((h1 = T.FixtureNo and a1 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h2 = T.FixtureNo and a2 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h3 = T.FixtureNo and a3 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h4 = T.FixtureNo and a4 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h5 = T.FixtureNo and a5 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h6 = T.FixtureNo and a6 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h7 = T.FixtureNo and a7 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h8 = T.FixtureNo and a8 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) )	         

	order by WeekNo

GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPlayerDetailsByID')
	drop procedure GetPlayerDetailsByID
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
	cross apply (select ClubEmail=ContactEmail + isnull(';' + dbo.eMailsForTeamUsers(TeamID),'') from clubs where ID=P.ClubID)c  
	where ID = @PlayerID
	
	order by LeagueID,SectionID,ClubID, Team


GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPlayerDetailsByName')
	drop procedure GetPlayerDetailsByName
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
	cross apply (select ClubEmail=ContactEmail + isnull(';' + dbo.eMailsForTeamUsers(TeamID),'') from clubs where ID=P.ClubID)c  
	where Surname like @SurnameExpression
	  and Forename like @ForenameExpression  
	  and (@leagueID=0 or LeagueID=@LeagueID)
	
	order by LeagueID,SectionID,ClubID, Team


GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPlayerDetailsByPlayer')
	drop procedure GetPlayerDetailsByPlayer
GO

create procedure GetPlayerDetailsByPlayer
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
	cross apply (select ClubEmail=ContactEmail + isnull(';' + dbo.eMailsForTeamUsers(TeamID),'') from clubs where ID=P.ClubID)c  
	where (@leagueID=0 or P.LeagueID=@LeagueID)
	  and (@SectionID=0 or P.SectionID=@SectionID)
	  and (@ClubID=0 or P.ClubID=@ClubID)
	  and (@Player =  '' or Forename + case when Initials = '' then ' ' else ' '+Initials+'. ' end + Surname in (select Player from @Players))
	
	order by LeagueID,SectionID,ClubID, Team

GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'IntegrityCheck')
	drop procedure IntegrityCheck
GO

create procedure IntegrityCheck

as

select Category='Player with invalid ClubID',P.ID,P.ClubID,P.Forename,P.Initials,P.Surname,[League Name],P.Handicap,P.email,P.TelNo,P.Tagged,P.Over70 
	from Players P
	outer apply (Select ClubID from Clubs where ID=P.ClubID) Clubs
	outer apply (Select [League Name] from Leagues where ID=P.LeagueID) L
	where P.ClubID <> 0
	  and Clubs.ClubID is null

select Category='Player with invalid Team letter',P.ID,P.Forename,P.Initials,P.Surname,[League Name],[Club Name],P.Team,P.Handicap,P.email,P.TelNo,P.Tagged,P.Over70 
	from Players P
	cross apply (Select ClubID, [Club Name] from Clubs where ID=P.ClubID) C
	outer apply (Select Team from Teams where  ClubID=P.ClubID and Team=P.Team and LeagueID=P.LeagueID) T
	outer apply (Select [League Name] from Leagues where ID=P.LeagueID) L
	where P.ClubID <> 0
	  and T.Team is null
   order by [Club Name],P.LeagueID,Surname,Forename

select Category='Team with invalid ClubID',T.ClubID,[League Name],[Section Name],T.Team,T.Contact,T.email,T.TelNo 
	from TeamsDetails T
	outer apply (Select ClubID from Clubs where ID=T.ClubID) C
	outer apply (Select LeagueID,[Section Name] from Sections where ID=T.SectionID) S
	outer apply (Select [League Name] from Leagues where ID=S.LeagueID) L
	where C.ClubID is null

Select Category='Club with no team',C.*
	from Clubs C
	outer apply (Select ClubID from Teams where ClubID=C.ID) T
	where T.clubID is null
	  and [Club Name]<>'Bye'

Select Category='Club with no players',C.*
	from Clubs C
	outer apply (Select ClubID from Players where ClubID=C.ID) P
	where P.clubID is null
	  and [Club Name]<>'Bye'

Select Category='Team with no players',C.[Club Name],T.Team,L.[League Name],[Section Name],T.TelNo,T.Contact,t.eMail
	from TeamsDetails T
	outer apply (Select ClubID, Team from Players where ClubID=T.ClubID and Team=T.Team) P
	outer apply (Select [Club Name] from Clubs where ID=T.ClubID) C
	outer apply (Select LeagueID,[Section Name] from Sections where ID=T.SectionID) S
	outer apply (Select [League Name] from Leagues where ID=S.LeagueID) L
	where P.Team is null
	  and [Club Name]<>'Bye'

select Category='Breaks with invalid PlayerID',B.*
	from Breaks B
	outer apply (Select ID from Players where ID=PlayerID) P
	where P.ID is null
   order by B.ID

select Category='Match with invalid HomePlayer1ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Homeplayer1ID) P
	where P.ID is null
   order by M.ID
select Category='Match with invalid HomePlayer2ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Homeplayer2ID) P
	where P.ID is null
   order by M.ID
select Category='Match with invalid HomePlayer3ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Homeplayer3ID) P
	where P.ID is null
   order by M.ID
select Category='Match with invalid HomePlayer4ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Homeplayer4ID) P
	where isnull(M.Homeplayer4id,0) <> 0
	  and P.ID is null
   order by M.ID
select Category='Match with invalid AwayPlayer1ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Awayplayer1ID) P
	where P.ID is null
   order by M.ID
select Category='Match with invalid AwayPlayer2ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Awayplayer2ID) P
	where P.ID is null
   order by M.ID
select Category='Match with invalid AwayPlayer3ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Awayplayer3ID) P
	where P.ID is null
   order by M.ID
select Category='Match with invalid AwayPlayer4ID',M.*
	from MatchResults M
	outer apply (Select ID from Players where ID=Awayplayer4ID) P
	where isnull(M.Awayplayer4id,0) <> 0
	  and P.ID is null
   order by M.ID

select Category='LeaguePointsAdjustment with invalid TeamID',L.*
	from LeaguePointsAdjustment L
	outer apply (Select ID from Teams where ID=teamID) T
	where T.ID is null
   order by T.ID

select Category='PlayerRecords with invalid PlayerID',L.*
	from PlayerRecords L
	outer apply (Select ID,surname,initials,forename from Players where ID=PlayerID) P
	where P.ID is null
	  and isnull(L.PlayerID,0)<>0
   order by Season,Team

GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'LeagueTable')
	drop procedure LeagueTable
GO

CREATE procedure LeagueTable
	(@SectionID int
	,@Recursive bit = 0
	)
as

set nocount on

if @SectionID > 99  --call me recursively for each section in the league
	
	begin

	declare @tmpLeagues table
		(Team varchar (256)
		,Played int
		,Won int
		,Drawn int
		,Lost int
		,Pts int
		,Win0 INT
		,Win1 int
		
		,Adjustment varchar(130)
		)

	declare c cursor fast_forward for
	select ID from sections where LeagueID=(@SectionID % 100)
	Declare @sID int
	open c
	fetch c into @sID
	while @@FETCH_STATUS=0
		begin
		insert @tmpLeagues
			select [League Name]+' '+[Section Name]
			      ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL 
			   from Sections 
			   join Leagues on LeagueID=Leagues.ID
			   where Sections.ID= @sID
		insert @tmpLeagues exec LeagueTable @sID,1
		insert @tmpLeagues
			select NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL 

		fetch c into @sID
		end
	close c
	deallocate c
	if @SectionID=101
		select [ ]=Team,Played,Won,Drawn,Lost,Pts
		          ,[4-0 Wins]=Win0
			      ,[3-1 Wins]=Win1
			      ,[  ]=Adjustment
			from @tmpLeagues
	else
		select [ ]=Team,Played,Won,Lost,Pts
		          ,[3-0 Wins]=Win0
			      ,[2-1 Wins]=Win1
			      ,[  ]=Adjustment
			from @tmpLeagues
	end

else

	begin
	declare @WinFrames int

	select @WinFrames = case when L.ID = 1 then 3 else 2 end 
		from Sections S
		join Leagues L on L.ID=S.LeagueID
		where S.ID=@SectionID

	declare @tmpLeague table
		(Team varchar (250)
		,Played int
		,Won int
		,Drawn int
		,Pts int
		,TeamID int
		,Win0 int
		,Win1 int
		)
	
	insert @tmpLeague
	select	 Team = [Club Name] + ' ' + T.Team + case when Contact='WITHDRAWN' then ' (WITHDRAWN)' else '' end
			,Played = count(*)
			,Won = sum(
					   case when 
						case when M.HomeTeamID = T.ID
							then case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
								 case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
								 case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
			                     case when @Winframes <> 3 then 0 else case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end end
				            else 0
						end >= @WinFrames 
							then 1 else 0 
					   end +
					   case when 
						case when M.AwayTeamID = T.ID
				            then case when HomePlayer1Score < AwayPlayer1Score then 1 else 0 end +
			                     case when HomePlayer2Score < AwayPlayer2Score then 1 else 0 end +
				                 case when HomePlayer3Score < AwayPlayer3Score then 1 else 0 end +
					             case when @Winframes <> 3 then 0 else case when HomePlayer4Score < AwayPlayer4Score then 1 else 0 end end
						    else 0
						end >= @WinFrames 
							then 1 else 0 
					   end)
					                
			,Drawn = sum(case when @WinFrames < 3 then 0 else
					   case when 
						case when M.HomeTeamID = T.ID
							then case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
								 case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
						         case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
							     case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end 
				            else 0
						end = @WinFrames-1
							then 1 else 0 
					   end +
					   case when 
						case when M.AwayTeamID = T.ID
				            then case when HomePlayer1Score < AwayPlayer1Score then 1 else 0 end +
			                     case when HomePlayer2Score < AwayPlayer2Score then 1 else 0 end +
				                 case when HomePlayer3Score < AwayPlayer3Score then 1 else 0 end +
					             case when HomePlayer4Score < AwayPlayer4Score then 1 else 0 end 
						    else 0
						end = @WinFrames-1
							then 1 else 0 
					   end end)
		

		
			,Pts = sum(
						case when M.HomeTeamID = T.ID
				        then case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
					         case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
						     case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
							 case when @Winframes <> 3 then 0 else case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end end
		                else 0
		           end +
			       case when M.AwayTeamID = T.ID
				        then case when HomePlayer1Score < AwayPlayer1Score then 1 else 0 end +
					         case when HomePlayer2Score < AwayPlayer2Score then 1 else 0 end +
						     case when HomePlayer3Score < AwayPlayer3Score then 1 else 0 end +
							 case when @Winframes <> 3 then 0 else case when HomePlayer4Score < AwayPlayer4Score then 1 else 0 end end
		                else 0
		           end )
			,TeamID=max(case when M.HomeTeamID=T.ID then T.ID else 0 end)  
			
			,Wins0= sum(case when M.HomeTeamID = T.ID
							  then case when AwayPoints=0 then 1 else 0 end
						      else case when HomePoints=0 then 1 else 0 end
			             end)       
			,Wins1= sum(case when M.HomeTeamID = T.ID
							  then case when AwayPoints=1 then 1 else 0 end
						      else case when HomePoints=1 then 1 else 0 end
			             end)       
				           
		from MatchResultsDetails3 M
		left join TeamsDetails T on M.HomeTeamID = T.ID or M.AwayTeamID = T.ID
		join Clubs C on T.ClubID = C.ID
		where T.SectionID=@SectionID 
		group by [Club Name] + ' ' + T.Team + case when Contact='WITHDRAWN' then ' (WITHDRAWN)' else '' end
		order by Pts desc, Played, Won desc, Wins0 Desc

	
	if @WinFrames = 3 or @Recursive=1 or @SectionID > 99
		select [ ]= Team, Played, Won, Drawn, Lost = Played - Won - Drawn
	 	     , Pts = convert(int, case when adj.Points is not null then Pts+Points else Pts end)
 			 ,[4-0 Wins]=Win0
			 ,[3-1 Wins]=Win1
			 , [  ] = case when adj.Points is null then null
			                 else case when abs(Points) < 1 then ''  + Comment
				                       when Points < 0 then convert(varchar(5),abs(Points)) +  ' points deducted: ' + Comment 
					                   else convert(varchar(5),abs(Points)) + ' points added: ' + Comment end 
						 end                                     
			
			from @tmpLeague t
			outer apply (select Points, Comment 
							from LeaguePointsAdjustment
							where TeamID=t.TeamID) adj
			order by case when Pts is null then 1000 else case when adj.Points is not null then Pts+Points else Pts end end desc
			       , Played, Won desc, Win0 desc, Win1 desc, Comment desc
	else
		select [ ]=Team, Played, Won, Lost = Played - Won - Drawn
 			 , Pts = convert(int, case when adj.Points is not null then Pts+Points else Pts end)
 			 ,[3-0 Wins]=Win0
			 ,[2-1 Wins]=Win1
	 		 , [  ] = case when adj.Points is null then null
			                 else case when abs(Points) < 1 then ''  + Comment
			                           when Points < 0 then convert(varchar,abs(Points)) +  ' points deducted: ' + Comment 
				                       else convert(varchar,abs(Points)) + ' points added: ' + Comment end 
					  end		              	 

			from @tmpLeague t
			outer apply (select Points, Comment 
							from LeaguePointsAdjustment
							where TeamID=t.TeamID) adj

			order by case when Pts is null then 1000 else case when adj.Points is not null then Pts+Points else Pts end end desc
			       , Played, Won desc, Win0 desc, Win1 desc, Comment desc

	end

GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'LeagueTable')
	drop procedure LeagueTable
GO

CREATE procedure LeagueTable
	(@SectionID int
	,@Recursive bit = 0
	)
as

set nocount on

if @SectionID > 99  --call me recursively for each section in the league
	
	begin

	declare @tmpLeagues table
		(Team varchar (256)
		,Played int
		,Won int
		,Drawn int
		,Lost int
		,Pts int
		,Win0 INT
		,Win1 int
		
		,Adjustment varchar(130)
		)

	declare c cursor fast_forward for
	select ID from sections where LeagueID=(@SectionID % 100)
	Declare @sID int
	open c
	fetch c into @sID
	while @@FETCH_STATUS=0
		begin
		insert @tmpLeagues
			select [League Name]+' '+[Section Name]
			      ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL 
			   from Sections 
			   join Leagues on LeagueID=Leagues.ID
			   where Sections.ID= @sID
		insert @tmpLeagues exec LeagueTable @sID,1
		insert @tmpLeagues
			select NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL 

		fetch c into @sID
		end
	close c
	deallocate c
	if @SectionID=101
		select [ ]=Team,Played,Won,Drawn,Lost,Pts
		          ,[4-0 Wins]=Win0
			      ,[3-1 Wins]=Win1
			      ,[  ]=Adjustment
			from @tmpLeagues
	else
		select [ ]=Team,Played,Won,Lost,Pts
		          ,[3-0 Wins]=Win0
			      ,[2-1 Wins]=Win1
			      ,[  ]=Adjustment
			from @tmpLeagues
	end

else

	begin
	declare @WinFrames int

	select @WinFrames = case when L.ID = 1 then 3 else 2 end 
		from Sections S
		join Leagues L on L.ID=S.LeagueID
		where S.ID=@SectionID

	declare @tmpLeague table
		(Team varchar (250)
		,Played int
		,Won int
		,Drawn int
		,Pts int
		,TeamID int
		,Win0 int
		,Win1 int
		)
	
	insert @tmpLeague
	select	 Team = [Club Name] + ' ' + T.Team
			,Played = count(*)
			,Won = sum(
					   case when 
						case when M.HomeTeamID = T.ID
							then case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
								 case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
								 case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
			                     case when @Winframes <> 3 then 0 else case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end end
				            else 0
						end >= @WinFrames 
							then 1 else 0 
					   end +
					   case when 
						case when M.AwayTeamID = T.ID
				            then case when HomePlayer1Score < AwayPlayer1Score then 1 else 0 end +
			                     case when HomePlayer2Score < AwayPlayer2Score then 1 else 0 end +
				                 case when HomePlayer3Score < AwayPlayer3Score then 1 else 0 end +
					             case when @Winframes <> 3 then 0 else case when HomePlayer4Score < AwayPlayer4Score then 1 else 0 end end
						    else 0
						end >= @WinFrames 
							then 1 else 0 
					   end)
					                
			,Drawn = sum(case when @WinFrames < 3 then 0 else
					   case when 
						case when M.HomeTeamID = T.ID
							then case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
								 case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
						         case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
							     case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end 
				            else 0
						end = @WinFrames-1
							then 1 else 0 
					   end +
					   case when 
						case when M.AwayTeamID = T.ID
				            then case when HomePlayer1Score < AwayPlayer1Score then 1 else 0 end +
			                     case when HomePlayer2Score < AwayPlayer2Score then 1 else 0 end +
				                 case when HomePlayer3Score < AwayPlayer3Score then 1 else 0 end +
					             case when HomePlayer4Score < AwayPlayer4Score then 1 else 0 end 
						    else 0
						end = @WinFrames-1
							then 1 else 0 
					   end end)
		

		
			,Pts = sum(
						case when M.HomeTeamID = T.ID
				        then case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
					         case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
						     case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
							 case when @Winframes <> 3 then 0 else case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end end
		                else 0
		           end +
			       case when M.AwayTeamID = T.ID
				        then case when HomePlayer1Score < AwayPlayer1Score then 1 else 0 end +
					         case when HomePlayer2Score < AwayPlayer2Score then 1 else 0 end +
						     case when HomePlayer3Score < AwayPlayer3Score then 1 else 0 end +
							 case when @Winframes <> 3 then 0 else case when HomePlayer4Score < AwayPlayer4Score then 1 else 0 end end
		                else 0
		           end )
			,TeamID=max(case when M.HomeTeamID=T.ID then T.ID else 0 end)  
			
			,Wins0= sum(case when M.HomeTeamID = T.ID
							  then case when AwayPoints=0 then 1 else 0 end
						      else case when HomePoints=0 then 1 else 0 end
			             end)       
			,Wins1= sum(case when M.HomeTeamID = T.ID
							  then case when AwayPoints=1 then 1 else 0 end
						      else case when HomePoints=1 then 1 else 0 end
			             end)       
				           
		from MatchResultsDetails3 M
		left join Teams T on M.HomeTeamID = T.ID or M.AwayTeamID = T.ID
		join Clubs C on T.ClubID = C.ID
		where T.SectionID=@SectionID 
		group by [Club Name] + ' ' + T.Team
		order by Pts desc, Played, Won desc, Wins0 Desc

	
	if @WinFrames = 3 or @Recursive=1 or @SectionID > 99
		select [ ]= Team, Played, Won, Drawn, Lost = Played - Won - Drawn
	 	     , Pts = convert(int, case when adj.Points is not null then Pts+Points else Pts end)
 			 ,[4-0 Wins]=Win0
			 ,[3-1 Wins]=Win1
			 , [  ] = case when adj.Points is null then null
			                 else case when abs(Points) < 1 then ''  + Comment
				                       when Points < 0 then convert(varchar(5),abs(Points)) +  ' points deducted: ' + Comment 
					                   else convert(varchar(5),abs(Points)) + ' points added: ' + Comment end 
						 end                                     
			
			from @tmpLeague t
			outer apply (select Points, Comment 
							from LeaguePointsAdjustment
							where TeamID=t.TeamID) adj
			order by case when Pts is null then 1000 else case when adj.Points is not null then Pts+Points else Pts end end desc
			       , Played, Won desc, Win0 desc, Win1 desc, Comment desc
	else
		select [ ]=Team, Played, Won, Lost = Played - Won - Drawn
 			 , Pts = convert(int, case when adj.Points is not null then Pts+Points else Pts end)
 			 ,[3-0 Wins]=Win0
			 ,[2-1 Wins]=Win1
	 		 , [  ] = case when adj.Points is null then null
			                 else case when abs(Points) < 1 then ''  + Comment
			                           when Points < 0 then convert(varchar,abs(Points)) +  ' points deducted: ' + Comment 
				                       else convert(varchar,abs(Points)) + ' points added: ' + Comment end 
					  end		              	 

			from @tmpLeague t
			outer apply (select Points, Comment 
							from LeaguePointsAdjustment
							where TeamID=t.TeamID) adj

			order by case when Pts is null then 1000 else case when adj.Points is not null then Pts+Points else Pts end end desc
			       , Played, Won desc, Win0 desc, Win1 desc, Comment desc

	end

GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'SectionList')
	drop procedure SectionList
GO

CREATE procedure SectionList
	 @SectionID int = NULL
	,@LeagueID int = NULL
	,@IncludeBye bit = 0

as

set nocount on

select top 0 * into #tmp
	from TeamsDetails 
	cross apply (select [Club Name]=convert(varchar(2000),[Club Name]),ContactTelNo, ContactMobNo from Clubs c where ID=ClubID) c

if @sectionID is not null
	insert #tmp 
		select *
			from TeamsDetails 
			cross apply (select [Club Name]=[Club Name]  + ' ' + Team + 
			                                    case when Address1 is null then '' else ', ' + Address1 end + 
												case when Address2 is null then '' else ', ' + Address2 end + 
												case when PostCode is null then '' else ', ' + PostCode end
								,ContactTelNo=replace(ContactTelNo,' ','')
								,ContactMobNo=replace(ContactMobNo,' ','')
							from Clubs c 
							where ID=ClubID) c

		where SectionID = @SectionID
		order by FixtureNo
else
	insert #tmp 
		select *
			from TeamsDetails 
			cross apply (select [Club Name]=[Club Name]  + ' ' + Team +  
			                                    case when Address1 is null then '' else ', ' + Address1 end + 
												case when Address2 is null then '' else ', ' + Address2 end + 
												case when PostCode is null then '' else ', ' + PostCode end
								,ContactTelNo=replace(ContactTelNo,' ','')
								,ContactMobNo=replace(ContactMobNo,' ','')
							from Clubs c 
							where ID=ClubID) c

		where SectionID IN  (select ID from Sections where LeagueID=@LeagueID)
	
		order by SectionID, FixtureNo


alter table #tmp add Players varchar(4000)

--select ID, SectionID, ClubID, Team from #tmp

declare c cursor fast_forward for
select ID, SectionID, ClubID, Team from #tmp
declare @ID int, @SectnID int, @ClubID int, @Team char(1)
declare @PlayerList varchar(2000)

open c
fetch c into @ID, @SectnID, @ClubID, @Team
while @@fetch_status = 0
	begin
	
	declare d cursor fast_forward for
		select Forename + ' ' + case when Initials = '' then '' else Initials + ' ' end + Surname + ' ' +
	  	   convert(varchar,Handicap) + 
	  	   case when Tagged>0 then ' *' else '' end +
	  	   case when over70 =1 then ' F' else '' end
			from Players 
			where SectionID=@SectnID
			  and ClubID=@ClubID 
			  and Team=@team
		   order by Forename + ' ' + case when Initials = '' then '' else Initials + ' ' end + Surname
	open d
	fetch d into @PlayerList
	while @@fetch_status=0
		begin
		update #tmp set Players = isnull(Players,'') + @PlayerList + ', '	where ID=@ID

		fetch d into @PlayerList
		end
	close d
	deallocate d
	update #tmp set Players = left(Players,Len(Players)-1) where ID=@ID
	fetch c into @ID, @SectnID, @ClubID, @Team
	end

close c
deallocate c	

if @sectionID is not null
	begin
	if @IncludeBye=1
		select [ ]=FixtureNo, [Club/Team]= [Club Name], 
		       ClubTelNo = isnull(ContactTelNo,''), TeamTelNo = case when isnull(TelNo,'')='' then isnull(ContactMobNo,'') else TelNo end, Players--, T.ID
			from #tmp T
			order by FixtureNo				  
	else
		select [ ]=FixtureNo, [Club/Team]= [Club Name], 
		       ClubTelNo = isnull(ContactTelNo,''), TeamTelNo = case when isnull(TelNo,'')='' then isnull(ContactMobNo,'') else TelNo end, Players--, T.ID
			from #tmp T
			where [Club Name]<>'Bye'	
			order by [Club Name]					  
	end
else
	select [ ]=FixtureNo, [Section]=s.[Section Name],[Club/Team]= [Club Name], 
	       ClubTelNo = isnull(ContactTelNo,''), TeamTelNo = case when isnull(TelNo,'')='' then isnull(ContactMobNo,'') else TelNo end, Players--, T.ID
		from #tmp T
		outer apply (select [Section Name]
		                from Sections		
		                where ID=T.SectionID) s
		where @IncludeBye=1 or [Club Name]<>'Bye'                				  

		order by SectionID, [Club Name]

drop table #tmp


GO
