use HBSA
go

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
	,ClubID int
	,League   varchar(50)
	,LeagueID int
	,Section  varchar(50)
	,SectionID int
	,Team     char(1)
	,TeamID int
	,[Player Name]  varchar(100)
	,PlayerID int
	,eMail    varchar(250)
	,[Tel No 1] varchar(20)
    ,[Tel No 2] varchar(20)
	)

insert #tmp
select	 [Source] = 'Base'
	   	,Entity = 'Club'
		,Club = [Club Name]
		,ID
		,League = ''
		,null
		,Section = ''
		,null
		,Team = ''
		,null
		,[Player Name] = ContactName
		,null
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
		,ClubID
		,League=''
		,null
		,Section = ''
		,null
		,Team=''
		,null
		,[Player Name]=dbo.FullPlayerName(FirstName,'',Surname) 
		,null
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
		,ClubID
		,League = [League Name]
		,L.ID
		,Section = [Section Name]
		,SectionID
		,Team = Team
		,T.ID
		,[Player Name] = Contact
		,Captain
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
		,ClubID
		,League = [League Name]
		,L.ID
		,Section = [Section Name]
		,SectionID
		,Team = Team
		,R.TeamID
		,[Player Name] = Contact
		,null
	    ,Email = R.eMailAddress
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
		,ClubID
		,League = [League Name] 
		,LeagueID
		,Section = isnull([Section Name],'_No section')
		,SectionID
		,Team = Team
		,T.ID
		,[Player Name] = dbo.FullPlayerName(Forename,Initials,Surname)  + case when SectionID < 1 then ' (deleted)' else '' end 
		,P.ID
	    ,Email = isnull(eMail,'')
	    ,[Tel No 1] = isnull(TelNo,'')
	    ,[Tel No 2] = ''
	
	from Players P
	outer apply (select ID, [League Name] from Leagues where ID = P.LeagueID)L
	outer apply (select [Section Name] from Sections where ID = P.SectionID)S
	outer apply (select [Club Name] from  Clubs where ID = P.ClubID)C	
	outer apply (select ID from Teams where Teams.SectionID=P.SectionID and Teams.ClubID=P.ClubID and Teams.Team=P.Team) T
	where P.ID > 0
	order by isnull([Club Name],'_No Club'), L.ID, Team, [Player Name]

insert into #tmp
select	 [Source] = 'Entry Form'
	   	,Entity = 'Club'
		,Club = [Club Name]
		,ClubID
		,League = ''
		,null
		,Section = ''
		,null
		,Team = ''
		,null
		,[Player Name] = ContactName
		,null
	    ,Email = ''
	    ,[Tel No 1] = ContactTelNo
	    ,[Tel No 2] = ContactMobNo
	
	from EntryForm_Clubs 
	where [Club Name] <> 'Bye'
	order by [Club Name]

insert into #tmp
select	 [Source] = 'Entry Form'
	   	,Entity = 'Team'
		,Club = [Club Name]
		,ClubID
		,League = [League Name]
		,L.ID
		,Section = ''
		,null
		,Team = Team
		,TeamID
		,[Player Name] = X.Contact
		,Captain
	    ,Email = X.eMail
	    ,[Tel No 1] = X.TelNo
	    ,[Tel No 2] = ''
	
	from EntryForm_Teams T
	outer apply (select ID, [League Name] from Leagues where ID=LeagueID)L
	outer apply (select [Club Name] from EntryForm_Clubs where ClubID = T.ClubID)C
	outer apply (select Contact=dbo.FullPlayerName(Forename,Initials,Surname), eMail, TelNo 
	                   from EntryForm_Players where PlayerID=Captain)X

	order by [Club Name], L.ID, Team 

insert into #tmp
select	 [Source] = 'Entry Form'
	   	,Entity = 'Player'
		,Club = isnull([Club Name],'_No Club')
		,ClubID 
		,League = [League Name]
		,LeagueID  
		,Section = ''
		,null
		,Team = Team
		,T.TeamID
		,[Player Name] = dbo.FullPlayerName(Forename,Initials,Surname) + case when LeagueID < 0 then ' (deleted)' else '' end
		,PlayerID
	    ,Email = isnull(eMail,'')
	    ,[Tel No 1] = isnull(TelNo,'')
	    ,[Tel No 2] = ''
	
	from Entryform_Players P
	outer apply (select [League Name] from  Leagues where ID = LeagueID)L
	outer apply (select [Club Name] from Entryform_Clubs C where ClubID = P.ClubID) C
	outer apply (select TeamID from EntryForm_Teams where LeagueID=P.LeagueID and ClubID=P.ClubID and Team=P.Team and TeamID is not null) T
	where P.PlayerID > 0
	order by isnull([Club Name],'_No Club'), LeagueID, Team, [Player Name]

select * 
	from #tmp
	order by Seq

drop table #tmp

go

exec ContactsReport
