USE [HBSA]
GO
if exists(select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'ResultsUsersDetail')
	drop view dbo.ResultsUsersDetail
GO

create view	dbo.ResultsUsersDetail

as

select eMailAddress, Confirmed, Name=dbo.FullPlayerName(FirstName,'',Surname), Telephone
      ,Division, Team = rtrim([Club Name] + ' ' + Team)
	from ResultsUsers R
	join teams T on T.ID = TeamID
    outer apply (select [Club Name] from Clubs where Clubs.ID = ClubID) Y
	outer apply (Select Division = [League Name] + ' ' + [Section Name] 
					from Sections 
					join Leagues on Leagues.ID=LeagueID
					where Sections.ID = SectionID) Z
GO
exec EmailAddressDetail 'ResultsUsersDetail','eMailAddress','gilbertp@outlook.com'
select * from ResultsUsers where eMailAddress like '%gilbert%'
select * from ResultsUsersDetail where eMailAddress like '%gilbert%'