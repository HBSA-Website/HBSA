use HBSA
go

set xact_Abort on

begin tran

truncate table Players
set identity_insert players on
insert Players
	(ID,Forename,Initials,Surname,Handicap,LeagueID,SectionID,ClubID,Team,email,TelNo,Tagged,Over70,Played)
	select ID,Forename,Initials,Surname,Handicap,LeagueID,SectionID,ClubID,Team,email,TelNo,Tagged,Over70,Played
	 from [HBSA.db.11715514.hostedresource.com].HBSA.dbo.Players  
set identity_insert players off

commit tran