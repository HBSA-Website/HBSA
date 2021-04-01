USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'HandicapChangesReport' and SPECIFIC_SCHEMA='dbo')
	drop procedure dbo.HandicapChangesReport
GO
create procedure dbo.HandicapChangesReport
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
exec HandicapChangesReport 7
