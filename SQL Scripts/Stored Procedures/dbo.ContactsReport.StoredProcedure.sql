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

go

exec ContactsReport