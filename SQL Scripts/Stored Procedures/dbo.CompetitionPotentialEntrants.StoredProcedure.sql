USE [HBSA]
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='CompetitionPotentialEntrants')
	drop procedure CompetitionPotentialEntrants
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure dbo.CompetitionPotentialEntrants
	(@CompetitionID int
	,@ClubID int
	,@ALL bit
	,@sortBy bit = 0 --0 sort by surname, 1 sort by forename
    )

as

set nocount on

declare @LeagueID int
	   ,@CompType int
select @LeagueID = LeagueID
	  ,@CompType = CompType
	from Competitions
	where ID=@CompetitionID

if @CompType<>4
	begin
	select ID
	      ,Entrant=dbo.FullPlayerName(Forename,Initials,Surname) +
		           case when @CompType=2 then '(' + convert(varchar,Handicap) + ')' else '' end +
				   case when P.ClubID <> @ClubID then ' [' + [Club Name] + ']' else '' end
		
		from Players P
		left join Competitions_EntryForms C
		  on CompetitionID=@CompetitionID
         and LeagueID=@LeagueID 
		 and (ID=EntrantID or ID=Entrant2ID)
        cross apply (Select [Club Name] from Clubs where ID=P.ClubID) L
		where P.LeagueID=@LeagueID
		  and (P.ClubID=@ClubID or @ALL = 1)
		  and C.CompetitionID is null
		  --and P.sectionID <> 0
		order by case when P.ClubID=@ClubID then ' ' else P.ClubID end
		        ,case when @sortBy=0 then Surname else dbo.FullPlayerName(Forename,Initials,Surname) end

	select EntrantID 
	      ,Entrant=dbo.FullPlayerName(P.Forename,P.Initials,P.Surname) +
		           case when @CompType=2 then '(' + convert(varchar,P.Handicap) + ')' else '' end +
				   case when @CompType=3 then '/' + dbo.FullPlayerName(P2.Forename,P2.Initials,P2.Surname)
				                         else ''
                   end           ,P.TelNo
    	  ,P.eMail
		 
		from Competitions_EntryForms C
		join Players P
		  on P.ID=EntrantID
		left join Players P2
		  on P2.ID=Entrant2ID
		where P.LeagueID=@LeagueID
		  and CompetitionID=@CompetitionID
		  and C.ClubID=@ClubID
		order by P.Surname
	end
else
	begin
	select T.ID
	      ,Entrant=[Club Name] + ' ' + Team
		from TeamsDetails T
		left Join Clubs on Clubs.ID=ClubID 
		left join Competitions_EntryForms C
		  on CompetitionID=@CompetitionID
		 and T.ID=EntrantID
		where (SectionID in (Select ID from sections where LeagueID=@LeagueID) or SectionID=-1)
		  and T.ClubID=@ClubID
		  and C.CompetitionID is null
		order by Team

	select EntrantID 
	      ,Entrant=[Club Name] + ' ' + Team
          ,TelNo=T.TelNo
    	  ,eMail=T.eMail
		from Competitions_EntryForms C
		join TeamsDetails t on T.ID=EntrantID
		join Clubs on Clubs.ID=T.ClubID
		where CompetitionID=@CompetitionID
		  and C.ClubID=@ClubID
		order by Team
	end

	GO

exec CompetitionPotentialEntrants 10,13,0,1