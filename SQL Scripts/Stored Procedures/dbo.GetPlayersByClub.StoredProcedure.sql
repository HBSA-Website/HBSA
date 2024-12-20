USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetPlayersByClubAndTeam]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='GetPlayersByClub')
	drop procedure [dbo].[GetPlayersByClub]
GO

create procedure [dbo].[GetPlayersByClub]
	@ClubId int = 0
as

set nocount on

select distinct
		 PlayerID=ID
		,Player=dbo.FullPlayerName(ForeName,Initials,Surname)
	from Players
	where ClubID=@ClubId or @ClubId=0
	order by Player

GO
