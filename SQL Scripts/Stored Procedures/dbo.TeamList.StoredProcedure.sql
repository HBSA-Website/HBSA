USE [HBSA]
if exists (Select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='TeamList')
	drop procedure TeamList
GO

CREATE procedure TeamList
	(@SectionID int
	)

as

set nocount on	

select T.ID, Team= [Club Name] + ' ' + Team
	from    Teams T 
	join Clubs C on C.ID=T.ClubID

	where SectionID=@SectionID
	  and [Club Name] <> 'Bye'
order by Team

GO

exec TeamList 7