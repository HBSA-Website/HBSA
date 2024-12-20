use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_SimilarPlayers')
	drop procedure EntryForm_SimilarPlayers
GO

CREATE procedure [dbo].[EntryForm_SimilarPlayers]
	(@LeagueID int
	,@ClubID int = 0
	,@Forename varchar(50) = '' 
	,@Inits varchar(4) = ''
	,@Surname varchar(50) = ''
	)
as

set nocount on

	Select distinct 
		PlayerID, Player=dbo.FullPlayerName(Forename,initials,Surname)
		,Club=isnull([Club Name],'Not registered to a club')
		,Team,Handicap,Tag=dbo.TagDescription(Tagged),Over70
		--,p.*, [Club Name]
		from EntryForm_Players P
		left join EntryForm_Clubs C on C.ClubID=P.ClubID
		where LeagueID=@LeagueID 
		  and (@ClubID=0 or P.ClubID=@ClubID)
		  and (Forename like (left(@Forename,2) + '%') and Initials like (left(@Inits,2) + '%') and Surname like (@Surname + '%'))
	     order by Player

GO

exec EntryForm_SimilarPlayers @Surname='Beaumont',@Leagueid=1
