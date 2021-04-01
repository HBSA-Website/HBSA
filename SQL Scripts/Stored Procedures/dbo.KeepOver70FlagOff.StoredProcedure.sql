USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='KeepOver70FlagOff')
	DROP procedure KeepOver70FlagOff
GO

create procedure KeepOver70FlagOff

AS 

update Players 
	set Over70=0 
	where Over70<>0
	  and LeagueID=1

GO
update Players set Over70 = Over70