USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MoveTeam')
	drop procedure MoveTeam
GO

CREATE procedure MoveTeam
	(@TeamID int
	,@NewClubID int    --Note that if this is the same as @ClubID it simply changes the team Letter
	,@NewSectionID int --Note that if this is the same as @SectionID it simply changes the team Letter
	,@NewTeam char(1)
	)
as

set nocount on	
set xact_abort on

begin tran

declare @SectionID int
       ,@ClubID int
	   ,@Team char(1)
	   ,@LeagueID int
select @SectionID = SectionID
       ,@ClubID   = ClubID
	   ,@Team     = team
	   ,@LeagueID = LeagueID 
	from teams
	cross apply (select LeagueID from Sections where ID = SectionID) l
	where ID=@TeamID

update Teams 
	set ClubID=@NewClubID
	   ,SectionID=@NewSectionID 
	   ,Team=@NewTeam
	where ID=@TeamID

update Players 
	set ClubID=@NewClubID
	   ,SectionID=@NewSectionID 
	   ,Team=@NewTeam
	 where SectionID = @SectionID
	  and ClubID=@ClubID 
	  and Team=@team   

update EntryForm_Teams 
	set ClubID=@NewClubID
	   ,Team=@NewTeam
	where TeamID=@TeamID
	 
update EntryForm_Players 
	set ClubID=@NewClubID
	   ,Team=@NewTeam
	 where LeagueID = @LeagueID
	  and ClubID=@ClubID 
	  and Team=@team   
	  
commit tran