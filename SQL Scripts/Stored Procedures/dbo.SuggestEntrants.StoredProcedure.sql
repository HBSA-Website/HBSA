USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[SuggestEntrants]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='SuggestEntrants')
	drop procedure SuggestEntrants
GO

CREATE procedure [dbo].[SuggestEntrants]
	(@CompetitionID int = 0
	,@count int
	,@Word1 varchar(100) = '' 
	,@Word2 varchar(100) = ''
	,@Word3 varchar(100) = ''
	)
as

set nocount on

declare @LeagueID int
	   ,@CompType int

select @LeagueID = LeagueID
	  ,@CompType = CompType
	from Competitions
	where ID=@CompetitionID

if @CompType=4 
	Select distinct TOP (select @count)
		Entrant=ltrim([Club Name] + ' ' + Team)
		from Clubs
		join teams on teams.Clubid=clubs.id
		join sections on sections.id=SectionID
		where [Club Name] like (@word1 + '%')
		  and LeagueID=@LeagueID
		order by Entrant
else
if @word2=''
	Select distinct TOP (select @count)
		Entrant=Forename + case when initials='' then ' ' else ' ' + Initials +'. ' end + Surname 
		from Players P
		where LeagueID=@LeagueID
		  and (Forename like (@Word1 + '%') or Surname like (@Word1 + '%'))
		 order by Entrant
	
else 
if @word3=''
Select distinct TOP (select @count)
	Entrant=Forename + case when initials='' then ' ' else ' ' + Initials +'. ' end + Surname 
	from Players P
	join Competitions C on P.LeagueID=C.LeagueID
    where (@CompetitionID=0 or C.ID=@CompetitionID) 
	  and ( (Forename like (@Word1 + '%') and Surname like (@Word2 + '%')) or
	        (Forename like (@Word2 + '%') and Surname like (@Word1 + '%')))
	order by Entrant
else
Select distinct TOP (select @count)
	Entrant=Forename + case when initials='' then ' ' else ' ' + Initials +'. ' end + Surname 
	from Players P
	join Competitions C on P.LeagueID=C.LeagueID
    where (@CompetitionID=0 or C.ID=@CompetitionID) 
	  and ( (Forename like (@Word1 + '%') and Initials like (@Word2 + '%') and Surname like (@Word3 + '%')) or
            (Forename like (@Word3 + '%') and Initials like (@Word2 + '%') and Surname like (@Word1 + '%'))) 
	order by Entrant

GO
