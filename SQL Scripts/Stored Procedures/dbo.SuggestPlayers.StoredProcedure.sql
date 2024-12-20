USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'SuggestPlayers' and SPECIFIC_SCHEMA='HBSA')
	drop procedure HBSA.SuggestPlayers
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'SuggestPlayers' and SPECIFIC_SCHEMA='dbo')
	drop procedure dbo.SuggestPlayers
GO

CREATE procedure dbo.SuggestPlayers
	(@LeagueID int = 0
	,@SectionID int = 0
	,@ClubID int = 0
	,@count int
	,@Word1 varchar(100) = '' 
	,@Word2 varchar(100) = ''
	,@Word3 varchar(100) = ''
	)
as

set nocount on

if @word2=''
Select distinct TOP (select @count)
	Player=Forename + case when initials='' then ' ' else ' ' + Initials +'. ' end + Surname 
	from Players
    where (@LeagueID=0 or LeagueID=@LeagueID) 
	  and (@SectionID=0 or SectionID=@SectionID)
	  and (@ClubID=0 or ClubID=@ClubID)
	  and (Forename like (@Word1 + '%') or Surname like (@Word1 + '%'))
     order by Player
	
else 
if @word3=''
Select distinct TOP (select @count)
	Player=Forename + case when initials='' then ' ' else ' ' + Initials +'. ' end + Surname 
	from Players
    where (@LeagueID=0 or LeagueID=@LeagueID) 
	  and (@SectionID=0 or SectionID=@SectionID)
	  and (@ClubID=0 or ClubID=@ClubID)
	  and ( (Forename like (@Word1 + '%') and Surname like (@Word2 + '%')) or
	        (Forename like (@Word2 + '%') and Surname like (@Word1 + '%')))

else
Select distinct TOP (select @count)
	Player=Forename + case when initials='' then ' ' else ' ' + Initials +'. ' end + Surname 
	from Players
    where (@LeagueID=0 or LeagueID=@LeagueID) 
	  and (@SectionID=0 or SectionID=@SectionID)
	  and (@ClubID=0 or ClubID=@ClubID)
	  and ( (Forename like (@Word1 + '%') and Initials like (@Word2 + '%') and Surname like (@Word3 + '%')) or
            (Forename like (@Word3 + '%') and Initials like (@Word2 + '%') and Surname like (@Word1 + '%'))) 

GO
exec suggestplayers 0,0,0,20,'pe','gi'