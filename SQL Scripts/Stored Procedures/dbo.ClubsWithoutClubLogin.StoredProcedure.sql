use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='ClubsWithoutClubLogin')
	drop procedure dbo.ClubsWithoutClubLogin
GO

create procedure dbo.ClubsWithoutClubLogin

as

set nocount on

select [Club Name], 
       Contact = ContactName, 
	   Telephone = ContactTelNo, 
	   Mobile = ContactMobNo, 
	   [Address] = isnull(Address1 + ', ','') + isnull(Address2 + ', ','') + isnull(PostCode,'')
	from Clubs
	left join Clubusers 
		on ClubID = ID
	where ClubID is null
	  and [Club Name] <> 'bye'
	order by [Club Name]
GO

exec ClubsWithoutClubLogin