use HBSA
go
set identity_insert Players on
insert Players 
	(ID,Forename,Initials,Surname,Handicap,LeagueID,SectionID,ClubID,Team,email,TelNo,Tagged,Over70,Played)
	values
	(-1,'No','','Show',0,0,0,0,'',null,null,0,0,1)
insert Players 
	(ID,Forename,Initials,Surname,Handicap,LeagueID,SectionID,ClubID,Team,email,TelNo,Tagged,Over70,Played)
	values
	(-2,'No','','Opponent',0,0,0,0,'',null,null,0,0,1)
set identity_insert Players off

update MatchResults set HomePlayer4ID=-2, AwayPlayer4ID=-1 where ID = 606
update MatchResults set HomePlayer4ID=-1, AwayPlayer4ID=-2 where ID = 411

