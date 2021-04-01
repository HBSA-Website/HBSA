USE [HBSA_Test]
GO

delete Players where ID=-3
set identity_insert Players on
insert Players 
	(ID,Forename,Initials,Surname,Handicap,LeagueID,SectionID,ClubID,Team,email,TelNo,Tagged,Over70,Played,dateRegistered)
	select -3, 'Frame','','Not Played',0,0,0,0,'',null,null,0,0,1,dbo.UKdateTime(getdate())
set identity_insert Players off

select * from Players where ID < 0
update Players set ID=-3 where ID=-1


