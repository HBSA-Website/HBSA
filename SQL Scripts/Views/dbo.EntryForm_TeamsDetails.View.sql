USE [HBSA]
GO
if exists(select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'EntryForm_TeamsDetail')
	drop view EntryForm_TeamsDetail
GO

create view	EntryForm_TeamsDetail

as

select ClubID,Team,LeagueID,TeamID,Contact,eMail,TelNo,Captain
	from EntryForm_Teams p
	outer apply (select Contact=dbo.FullPlayerName(Forename,Initials,Surname), eMail, TelNo 
					from EntryForm_Players 
					where PlayerID=Captain)X
GO
select * from EntryForm_TeamsDetail
