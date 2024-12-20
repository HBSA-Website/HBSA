USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_UpdatePlayer')
	drop procedure EntryForm_UpdatePlayer
GO

--EntryID	TeamID	SectionID	FixtureNo	ClubID	Team	TelNo	Contact	eMail

CREATE procedure [dbo].[EntryForm_UpdatePlayer]
	(@ClubID int
	,@PlayerID int
	,@Forename varchar(50)
	,@Inits varchar(4)
	,@Surname varchar(50)
	,@Handicap int
	,@LeagueID int
	,@Team char(1)
	,@eMail varchar(250)
	,@TelNo varchar(20)	
	,@Tagged int
	,@Over70 bit
	)
as
set nocount on     

update EntryForm_Players
	set    Forename=@Forename
	  	  ,Initials=@Inits 
		  ,Surname=@Surname 
		  ,Handicap=@Handicap 
		  ,LeagueID=@LeagueID 
		  ,Team=@Team 
		  ,eMail=@eMail 
		  ,TelNo=@TelNo 
		  ,Tagged=@Tagged
		  ,Over70=@Over70 
	
	where  ClubID=@ClubID
	  and  PlayerID=@PlayerID
		  
GO
