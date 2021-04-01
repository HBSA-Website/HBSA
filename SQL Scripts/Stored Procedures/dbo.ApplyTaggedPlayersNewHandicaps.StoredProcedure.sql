USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ApplyTaggedPlayersNewHandicaps')
	drop procedure dbo.ApplyTaggedPlayersNewHandicaps
GO

create Procedure [dbo].[ApplyTaggedPlayersNewHandicaps]
	(@LeagueID int = 0
	,@SectionID int = 0
	,@ClubID int = 0
	)
as

set nocount on
set xact_abort on

begin tran

create table #TaggedPlayersReport
	  ([Last Date] varchar(11)
	  ,PlayerID int
      ,Player varchar(150)
      ,Handicap int
	  ,Played bit
	  ,Won int
	  ,Lost int      
      ,ActionNeeded	varchar(25)
      ,NewHandicap int
	  ,Section varchar(100)
      ,Team varchar(100)
	  ,ClubID int
	  ,TeamID int
	  )

insert #TaggedPlayersReport
	exec TaggedPlayersReport @LeagueID, @SectionID, @ClubID, 1, 1

update Players
	set Handicap=T.NewHandicap 
	from Players P
	join #TaggedPlayersReport T 
	  on T.PlayerID=P.ID
	where ActionNeeded in ('Raise','Reduce')

select [Last Date],PlayerID,Player,T.Handicap,T.Played,Won,Lost,ActionNeeded='None(Changed)',NewHandicap,Section,T.Team
		,ClubLoginEmail=isnull(Clubs.ContactEMail + ';' + dbo.eMailsForTeamUsers(TeamID),'')
		,TeamEmail=isnull(TD.eMail,'')
		,PlayerEMail=isnull(Players.email,'')
	from #TaggedPlayersReport T
	join ClubsDetails Clubs on Clubs.ID = ClubID
	left join TeamsDetails TD  on TD.ID=TeamID
	left join Players on Players.ID=PlayerID
	where ActionNeeded in ('Raise','Reduce')

--update AppliedTaggedPlayersHandicaps set dtUpdated=dbo.UKdateTime(getUTCdate())

commit tran

GO
exec ApplyTaggedPlayersNewHandicaps
