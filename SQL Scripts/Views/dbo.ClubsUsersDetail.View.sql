USE [HBSA]
GO
if exists(select TABLE_NAME from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'ClubsUsersDetail')
	drop view dbo.ClubsUsersDetail
GO

create view	dbo.ClubsUsersDetail

as

select eMailAddress, Confirmed, PlayerName=dbo.FullPlayerName(FirstName,'',Surname), Telephone
      ,[Club Name]
	from ClubUsers C
    outer apply (select [Club Name] from Clubs where Clubs.ID = ClubID) Y
GO

exec EmailAddressDetail 'ClubsUsersDetail','eMailAddress','gilbertp@outlook.com'
