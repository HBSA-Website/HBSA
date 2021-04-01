use HBSA
go

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='ClubsAndUsers')
	drop procedure dbo.ClubsAndUsers
GO

create procedure dbo.ClubsAndUsers

as

set nocount on

select	 Club = [Club Name]  
		,eMailAddress = isnull(eMailAddress,'')
	from Clubs
	outer apply (select eMailAddress from ClubUsers where ClubID = ID) u 
	where [Club Name] <> 'bye'
	order by [Club Name]
go
exec ClubsAndUsers