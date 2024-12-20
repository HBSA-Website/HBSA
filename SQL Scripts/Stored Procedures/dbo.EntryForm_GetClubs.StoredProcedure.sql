USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[EntryForm_GetClubs]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='EntryForm_GetClubs')
	drop procedure  EntryForm_GetClubs
GO

CREATE procedure [dbo].[EntryForm_GetClubs]

as

set nocount on

select * 
	from  ( select	 ClubID	= isnull(E.ClubID,C.ID)
					,[Club Name]= isnull(E.[Club Name],C.[Club name])
			from EntryForm_Clubs E
			full outer join  Clubs C on E.ClubID=C.ID
		  ) x
	where [Club Name] <> 'Bye'
	ORDER BY [Club Name]

GO
exec [EntryForm_GetClubs]