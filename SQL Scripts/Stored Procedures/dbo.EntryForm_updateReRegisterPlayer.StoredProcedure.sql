USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_updateReRegisterPlayer')
	drop procedure EntryForm_updateReRegisterPlayer
GO

create procedure dbo.EntryForm_updateReRegisterPlayer 
	(@PlayerID int
	,@ReRegister bit
	)

as

set nocount on

update EntryForm_Players
	set ReRegister=@ReRegister
	where PlayerID=@PlayerID

GO

select * from EntryForm_Players where PlayerID = 260
exec EntryForm_updateReRegisterPlayer 260, 0
select * from EntryForm_Players where PlayerID = 260
