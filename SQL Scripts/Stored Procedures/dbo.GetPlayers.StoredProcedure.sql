USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[GetPlayers]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetPlayers')
	drop procedure GetPlayers
GO

CREATE procedure GetPlayers
	@TeamID int
as
set nocount on

select Player=rtrim(ltrim(Forename)) + case when isnull(rtrim(ltrim(Initials)),'')='' then ' ' else ' ' + rtrim(ltrim(Initials))+'. ' end + rtrim(ltrim(Surname))
      ,Handicap, PlayerID=P.ID, Team=P.Team, OtherTeam=case when T.Team=P.Team then 0 
	                                                        when P.Team='U'    then 2
															                   else 1 end 
	from teams T
	join Sections S on S.ID=T.SectionID
	join Players P on P.ClubID=T.ClubID and P.LeagueID=S.LeagueID and P.SectionID <> 0
	where T.ID=@teamID
	  and (P.Played=0 or T.Team=P.Team or P.Team='U')
	order by OtherTeam, Player


GO
exec getplayers 90