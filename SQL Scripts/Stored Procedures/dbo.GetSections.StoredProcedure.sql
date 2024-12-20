USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetSections]    Script Date: 12/12/2014 17:46:00 ******/
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where Routine_Name='GetSections')
	drop procedure [dbo].[GetSections] 
GO

CREATE procedure [dbo].[GetSections] 
	@LeagueID int

as

set nocount on

if @LeagueID=0
	select S.ID, [Section Name]= [League Name]+' '+ [Section Name] 
		from Sections S
		join Leagues L on L.ID=S.LeagueID
		order by S.ID
else
	select ID, [Section Name] from Sections
		where LeagueID=@LeagueID
		order by ID


GO
exec getsections 2