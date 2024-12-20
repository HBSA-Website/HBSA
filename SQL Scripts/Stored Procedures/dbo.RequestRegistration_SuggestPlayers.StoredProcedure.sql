USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[RequestRegistration_SuggestPlayers]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'RequestRegistration_SuggestPlayers')
	drop procedure RequestRegistration_SuggestPlayers
GO

CREATE procedure [dbo].[RequestRegistration_SuggestPlayers]
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
	Player=dbo.FullPlayerName(Forename,Initials,Surname) +
	       ', Handicap ' + convert(varchar(4),handicap) +
			case when ClubID = 0 then '  (not registered to a club)'
			     else ' of ' + [Club Name] +
				       case when SectionID = 0 then ' (not registered to a team)' 
					        else rtrim(' ' + Team) + ' (REGISTERED)'
					   end		
            end
	from Players
	left join Clubs on Players.ClubID=Clubs.ID
	join Leagues on Players.LeagueID=Leagues.ID
    where LeagueID=@LeagueID 
	  and (Forename like (@Word1 + '%') or Surname like (@Word1 + '%'))
     order by Player
	
else 
if @word3=''
Select distinct TOP (select @count)
	Player=dbo.FullPlayerName(Forename,Initials,Surname) +
	       ', Handicap ' + convert(varchar(4),handicap) +
			case when ClubID = 0 then '  (not registered to a club)'
			     else ' of ' + [Club Name] +
				       case when SectionID = 0 then ' (not registered to a team)' 
					        else rtrim(' ' + Team) + ' (REGISTERED)'
					   end		
            end
		   
	from Players
	left join Clubs on Players.ClubID=Clubs.ID
	join Leagues on Players.LeagueID=Leagues.ID
    where LeagueID=@LeagueID 
	  and ( (Forename like (@Word1 + '%') and Surname like (@Word2 + '%')) or
	        (Forename like (@Word2 + '%') and Surname like (@Word1 + '%')))

else
Select distinct TOP (select @count)
	Player=dbo.FullPlayerName(Forename,Initials,Surname) +
	       ', Handicap ' + convert(varchar(4),handicap) +
			case when ClubID = 0 then '  (not registered to a club)'
			     else ' of ' + [Club Name] +
				       case when SectionID = 0 then ' (not registered to a team)' 
					        else rtrim(' ' + Team) + ' (REGISTERED)'
					   end		
            end
	from Players
	left join Clubs on Players.ClubID=Clubs.ID
	join Leagues on Players.LeagueID=Leagues.ID
    where LeagueID=@LeagueID 
	  and ( (Forename like (@Word1 + '%') and Initials like (@Word2 + '%') and Surname like (@Word3 + '%')) or
            (Forename like (@Word3 + '%') and Initials like (@Word2 + '%') and Surname like (@Word1 + '%'))) 

GO
exec RequestRegistration_SuggestPlayers 1,5,'Neil','',	'Bates'
exec RequestRegistration_SuggestPlayers 1,5,'S',	'woodh'
exec RequestRegistration_SuggestPlayers 0,5,'pete',	'gil'
