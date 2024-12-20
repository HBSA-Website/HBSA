USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='SuggestAwardWinners')
	drop procedure dbo.SuggestAwardWinners
GO

CREATE procedure [dbo].[SuggestAwardWinners]
	(@AwardType int
	,@AwardID int
	,@LeagueID int
	,@count int
	,@Word1 varchar(100) = '' 
	,@Word2 varchar(100) = ''
	,@Word3 varchar(100) = ''
	)
as

set nocount on

declare @CompType int

if @AwardType = 2
	select
	  @CompType = CompType
	from Competitions
	where ID=@AwardID

If @AwardType in (3,4,6) or (@AwardType=2 and @CompType in (1,2,3)) -- get a player
	begin
	if @word2=''
		Select distinct TOP (select @count)
			 Entrant=dbo.FullPlayerName( Forename,initials,Surname) + ' (' + isnull([Club Name],clubID) +')'
			,P.ID
			from Players P
			outer apply (select [Club Name] from Clubs where ID=ClubID) C
			outer apply (select [League Name] from Leagues where ID=P.LeagueID)L
			where (LeagueID=@LeagueID or @awardType in (6))
			  and (Forename like (@Word1 + '%') or Surname like (@Word1 + '%'))
			 order by Entrant
	else 
	if @word3=''
		Select distinct TOP (select @count)
				Entrant=dbo.FullPlayerName( Forename,initials,Surname) + ' (' + isnull([Club Name],clubID) +')'
				,P.ID
			from Players P
			outer apply (select [Club Name] from Clubs where ID=ClubID) C
			outer apply (select [League Name] from Leagues where ID=P.LeagueID)L
			where LeagueID=@LeagueID
			  and ( (Forename like (@Word1 + '%') and Surname like (@Word2 + '%')) or
				    (Forename like (@Word2 + '%') and Surname like (@Word1 + '%')))
			order by Entrant
	else
		Select distinct TOP (select @count)
			 Entrant=dbo.FullPlayerName( Forename,initials,Surname) + ' (' + isnull([Club Name],clubID) +')'
			,P.ID
			from Players P
			outer apply (select [Club Name] from Clubs where ID=ClubID) C
			outer apply (select [League Name] from Leagues where ID=P.LeagueID)L
			where LeagueID=@LeagueID
	  and ( (Forename like (@Word1 + '%') and Initials like (@Word2 + '%') and Surname like (@Word3 + '%')) or
            (Forename like (@Word3 + '%') and Initials like (@Word2 + '%') and Surname like (@Word1 + '%'))) 
	order by Entrant

	end

else --- get a team
	Select distinct TOP (select @count)
		Entrant=[Club Name] +' '+ Team ,Teams.ID

		from Teams
		cross apply (select [Club Name] from Clubs where ID=teams.Clubid) C
		cross apply (select LeagueID from Sections where ID=Teams.SectionID) S
		where [Club Name] like (@word1 + '%')
		  and LeagueID=@LeagueID
		  and [Club Name] not like 'Bye%'
		order by Entrant	
GO

exec SuggestAwardWinners 3,2,1,50,'ker'
exec SuggestAwardWinners 1,null,2,10,'sl'
exec SuggestAwardWinners 2,1,1,10,'gil'
exec SuggestAwardWinners 6,NULL,1,10,'gil'
exec SuggestAwardWinners 1,10,3,20,'B'

