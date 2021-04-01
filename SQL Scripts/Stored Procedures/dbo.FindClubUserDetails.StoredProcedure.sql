use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FindClubUserDetails')
	drop procedure FindClubUserDetails
GO

create procedure FindClubUserDetails
	 (@ClubName varchar(50) = ''
	 )
as

set nocount on

select [Club Name], R.* 
	from ClubUsers R
	cross apply (select [Club Name] from Clubs where R.ClubID=ID)C
    where (@ClubName='any' or [Club Name] like '%' + @Clubname + '%')
	order by [Club Name]
	   
GO

exec FindClubUserDetails 'slait'