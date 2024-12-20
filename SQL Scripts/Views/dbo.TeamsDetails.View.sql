USE [HBSA]
GO
if exists(select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'TeamsDetails')
	drop view TeamsDetails
GO

create view	TeamsDetails

as

select ID, SectionID, FixtureNo, ClubID, Team, Contact, email, TelNo, Captain
	from Teams p
	outer apply (select Contact=dbo.FullPlayerName(Forename,Initials,Surname), eMail, TelNo 
					from Players 
					where ID=Captain)X
GO
select * from TeamsDetails
