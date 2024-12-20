USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[EntryForm_SuggestPlayers]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_SuggestPlayers')
	drop procedure EntryForm_SuggestPlayers
GO

CREATE procedure [dbo].[EntryForm_SuggestPlayers]
	(@LeagueID int
	,@count int
	,@Word1 varchar(100) = '' 
	,@Word2 varchar(100) = ''
	,@Word3 varchar(100) = ''
	)
as

set nocount on

if @word2=''
Select distinct TOP (select @count)
	Player=Forename + case when initials='' then ' ' else ' ' + Initials +'. ' end + Surname +
	       isnull(' of ' + [Club Name] + ' ' + Team,' (not registered to a club)') + ', Handicap ' + convert(varchar(4),handicap) +
		   ' [' + convert(varchar,PlayerID) + ']'
	from EntryForm_Players
	left join EntryForm_Clubs on EntryForm_Players.ClubID=EntryForm_Clubs.ClubID
	join Leagues on EntryForm_Players.LeagueID=Leagues.ID
    where LeagueID=@LeagueID 
	  and (Forename like (@Word1 + '%') or Surname like (@Word1 + '%'))
     order by Player
	
else 
if @word3=''
Select distinct TOP (select @count)
	Player=Forename + case when initials='' then ' ' else ' ' + Initials +'. ' end + Surname +
	       isnull(' of ' + [Club Name] + ' ' + Team,' (not registered to a club)') + ', Handicap ' + convert(varchar(4),handicap) +
		   ' [' + convert(varchar,PlayerID) + ']'
	from EntryForm_Players
	left join EntryForm_Clubs on EntryForm_Players.ClubID=EntryForm_Clubs.ClubID
	join Leagues on EntryForm_Players.LeagueID=Leagues.ID
    where LeagueID=@LeagueID 
	  and ( (Forename like (@Word1 + '%') and Surname like (@Word2 + '%')) or
	        (Forename like (@Word2 + '%') and Surname like (@Word1 + '%')))

else
Select distinct TOP (select @count)
	Player=Forename + case when initials='' then ' ' else ' ' + Initials +'. ' end + Surname +
	       isnull(' of ' + [Club Name] + ' ' + Team,' (not registered to a club)') + ', Handicap ' + convert(varchar(4),handicap) +
		   ' [' + convert(varchar,PlayerID) + ']'
	from EntryForm_Players
	left join EntryForm_Clubs on EntryForm_Players.ClubID=EntryForm_Clubs.ClubID
	join Leagues on EntryForm_Players.LeagueID=Leagues.ID
    where LeagueID=@LeagueID 
	  and ( (Forename like (@Word1 + '%') and Initials like (@Word2 + '%') and Surname like (@Word3 + '%')) or
            (Forename like (@Word3 + '%') and Initials like (@Word2 + '%') and Surname like (@Word1 + '%'))) 

GO
exec EntryForm_SuggestPlayers 1,5,'r','beaumont'