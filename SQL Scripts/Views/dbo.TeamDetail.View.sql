USE [HBSA]
GO
if exists(select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'TeamDetail')
	drop view TeamDetail
GO

create view	TeamDetail

as

select p.ID, Division, Team = rtrim([Club Name] + ' ' + Team), Contact, email, TelNo
	from Teams p
	outer apply (select Contact=dbo.FullPlayerName(Forename,Initials,Surname), eMail, TelNo 
					from Players 
					where ID=Captain)X
    outer apply (select [Club Name] from Clubs where Clubs.ID = ClubID) Y
	outer apply (Select Division = [League Name] + ' ' + [Section Name] 
					from Sections 
					join Leagues on Leagues.ID=LeagueID
					where Sections.ID = SectionID) Z
GO
select * from TeamDetail
