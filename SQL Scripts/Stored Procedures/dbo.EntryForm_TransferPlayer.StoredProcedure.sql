USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_TransferPlayer')
	drop procedure EntryForm_TransferPlayer
GO

CREATE procedure [dbo].[EntryForm_TransferPlayer]
	(@PlayerID int 
	,@ClubID int
	,@LeagueID int
	,@Team char(1)
	)
as

set nocount on     

UPDATE EntryForm_Players
	SET
		 ClubID	  = @Clubid
		,LeagueID = @LeagueID	
		,Team	  = @Team
		,ReRegister = 1
	
	where PlayerID=@PlayerID

GO
