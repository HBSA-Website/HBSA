USE [HBSA]
GO
if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='NewRegistrations')
	drop procedure NewRegistrations
GO

create procedure NewRegistrations
	(@LeagueID int = 0
	,@SectionID int = 0
	,@ClubID int = 0
	,@Player varchar(100)=''
	,@NoOfdays int = 0
	)

as

set nocount on

declare @Players table (Player varchar(100))
declare @word1 varchar(50)
declare @word2 varchar(50)
declare @word3 varchar(50)
select @word1 = word from dbo.WordsInString(@Player) where ordinal=1
select @word2 = word from dbo.WordsInString(@Player) where ordinal=2
select @word3 = word from dbo.WordsInString(@Player) where ordinal=3
select @word1=isnull(@word1,''),@word2=isnull(@word2,''),@word3=isnull(@word3,'')

Declare @ReportStartDate DateTime
If @NoOfDays = 0
	select @ReportStartDate=convert(date,value) from configuration where [key]='CloseSeasonEndDate'
else
	select @ReportStartDate = dateadd (day,-@NoOfdays,dbo.UKdateTime(getUTCdate()))

insert @Players exec SuggestPlayers @LeagueID,@SectionID,@ClubID,10000,@word1,@word2,@word3 

select 
	   Player=Forename+case when isnull(Initials,'')='' then ' ' else ' ' + Initials+'. ' end + Surname
	  ,Team=[Club Name]+' '+isnull(convert(varchar,Teams.Team),'(No team letter match)')
      ,Section= [League Name]+' '+[Section Name]
      ,[Tag]=case when P.Tagged=3 then 'unseasoned'
	              when P.Tagged=2 then '2 seasons to go'
				  when P.Tagged=1 then '1 season to go'
				  else ''
              end
      ,[Over 70(80 Vets)]=P.Over70
      ,[HCap]=p.Handicap
      ,[Date Registered]=convert(varchar(11),dateRegistered,113)
	from Players P

	join Sections on Sections.ID=P.SectionID
	join Leagues on Leagues.ID=Sections.LeagueID
	join Clubs on Clubs.ID=P.ClubID
	left join Teams on teams.SectionID=P.SectionID and  Teams.ClubID=P.ClubID and Teams.Team=P.team
	join @Players sP on sP.Player=Forename + case when Initials = '' then ' ' else ' '+Initials+'. ' end + Surname

	where dateRegistered>@ReportStartDate
	  and (@LeagueID = 0 or Sections.LeagueID=@LeagueID)
	  and (@SectionID = 0 or P.SectionID=@SectionID)
	  and (@ClubID = 0 or Clubs.ID=@ClubID)
	
	order by p.SectionID, [Date Registered] desc, Team, Player



GO
exec NewRegistrations @NoOfDays=7
