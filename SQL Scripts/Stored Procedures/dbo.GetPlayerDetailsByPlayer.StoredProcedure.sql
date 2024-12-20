USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPlayerDetailsByPlayer')
	drop procedure GetPlayerDetailsByPlayer
GO

create procedure GetPlayerDetailsByPlayer
	(@LeagueID int = 0
	,@SectionID int = 0
	,@ClubID int = 0
	,@Player varchar(150) = ''
	,@Basic bit = 0
	,@Mobile bit = 0)

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

set @Player = replace (@Player, '.', '')

select @word1 = word from dbo.WordsInString(@Player) where ordinal=1
select @word2 = word from dbo.WordsInString(@Player) where ordinal=2
select @word3 = word from dbo.WordsInString(@Player) where ordinal=3
select @word1=isnull(@word1,''),@word2=isnull(@word2,''),@word3=isnull(@word3,'')

if @Player <> ''
	insert @Players exec SuggestPlayers @LeagueID,0,0,10000,@word1,@word2,@word3

 if @Mobile = 1
	select ID
	       ,Player=dbo.FullPlayerName(Forename,Initials,Surname)
	       ,Handicap
		   ,[Club/Team]=ltrim([Club Name] + ' ' + Team)
		   ,Division=ltrim([League Name] + ' ' + [Section Name])
		from PlayerDetails P
		outer apply (select TeamEmail=eMail, TeamID=ID from teamsDetails where ClubID=P.ClubID and Team=P.Team and SectionID=P.sectionID)t
		outer apply (select ClubEmail=ContactEmail + isnull(';' + dbo.eMailsForTeamUsers(TeamID),'') from ClubsDetails where ID=P.ClubID)c  
		where (@leagueID=0 or P.LeagueID=@LeagueID)
		  and (@SectionID=0 or P.SectionID=@SectionID)
		  and (@ClubID=0 or P.ClubID=@ClubID)
		  and (@Player =  '' or Forename + case when Initials = '' then ' ' else ' '+Initials+'. ' end + Surname in (select Player from @Players))
		  and [Club Name] <> '(Deleted)'
		  and [Section Name] <> '(Deleted)'
		order by Player,LeagueID,SectionID,[Club/Team]

else if @Basic = 1
	select  Player=dbo.FullPlayerName(Forename,Initials,Surname)
	       ,Handicap
		   ,[Club/Team]=ltrim([Club Name] + ' ' + Team)
		   ,Played=case when Played=1 then 'Yes' else 'No' end
		   ,Tag = case Tagged when 0 then ''
		                      when 1 then '1 season to go'
							  else convert(varchar,Tagged) + ' seasons to go'
                  end
		   ,Division=ltrim([League Name] + ' ' + [Section Name])
		   ,[Over 80(Vets)]=case when Over70=1 then 'Yes' else 'No' end
		   ,[Date Registered]=convert(varchar(11),dateRegistered,106)
		   ,email
		   ,TelNo
		from PlayerDetails P
		outer apply (select TeamEmail=eMail, TeamID=ID from teamsDetails where ClubID=P.ClubID and Team=P.Team and SectionID=P.sectionID)t
		outer apply (select ClubEmail=ContactEmail + isnull(';' + dbo.eMailsForTeamUsers(TeamID),'') from ClubsDetails where ID=P.ClubID)c  
		where (@leagueID=0 or P.LeagueID=@LeagueID)
		  and (@SectionID=0 or P.SectionID=@SectionID)
		  and (@ClubID=0 or P.ClubID=@ClubID)
		  and (@Player =  '' or Forename + case when Initials = '' then ' ' else ' '+Initials+'. ' end + Surname in (select Player from @Players))
		  and [Club Name] <> '(Deleted)'
		  and [Section Name] <> '(Deleted)'
		order by Player,LeagueID,SectionID,[Club/Team]

else
	select  Forename,Initials,Surname,Handicap,[Club Name],Team,Played,Tagged,Over70,email,TelNo,[League Name],[Section Name],LeagueID,SectionID,ClubID,ID
		   ,dateRegistered,TeamEmail=isnull(TeamEmail,''),TeamID=isnull(TeamID,0),ClubEmail
		from PlayerDetails P
		outer apply (select TeamEmail=eMail, TeamID=ID from teamsDetails where ClubID=P.ClubID and Team=P.Team and SectionID=P.sectionID)t
		outer apply (select ClubEmail=ContactEmail + isnull(';' + dbo.eMailsForTeamUsers(TeamID),'') from ClubsDetails where ID=P.ClubID)c  
		where (@leagueID=0 or P.LeagueID=@LeagueID)
		  and (@SectionID=0 or P.SectionID=@SectionID)
		  and (@ClubID=0 or P.ClubID=@ClubID)
		  and (@Player =  '' or Forename + case when Initials = '' then ' ' else ' '+Initials+'. ' end + Surname in (select Player from @Players))
		order by LeagueID,SectionID,ClubID, Team

GO

exec GetPlayerDetailsByPlayer 0,0,0,'A. Robinson',1,0
