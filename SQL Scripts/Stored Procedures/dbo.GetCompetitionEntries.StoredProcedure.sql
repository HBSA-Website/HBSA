USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetCompetitionEntries')
	drop procedure GetCompetitionEntries
GO

create procedure GetCompetitionEntries
	(@CompetitionID int
	)
as

set nocount on

declare @CompType int
select @CompType=CompType 
	from Competitions 
	where ID =@CompetitionID

if @CompType = 4
	select EntryID,Entrant=isnull(Entrant,'Bye')
		from Competitions_Entries
		outer apply (select Entrant = [Club Name] + ' ' + Team
						From Teams 
						join Clubs on ClubID=Clubs.ID 
						where Teams.ID=EntrantID
				    )TeamName
		where CompetitionID=@CompetitionID
		  and RoundNo = 0
		order by EntryID	    

else
if @comptype=3
	select EntryID,Entrant=isnull(Entrant,'Bye'),Entrant2	
		from Competitions_Entries
		outer apply (select Entrant	= dbo.FullPlayerName(Forename,Initials,Surname)
						From PlayerDetails 
						where ID=EntrantID
			        ) PlayerName
		outer apply (select Entrant2=dbo.FullPlayerName(Forename,Initials,Surname)
						From PlayerDetails 
						where ID=Entrant2ID
			        ) PlayerName2
		where CompetitionID = @CompetitionID 
		  and RoundNo = 0
		order by EntryID

else
if @CompType=2
	select EntryID,Entrant=isnull(Entrant,'Bye')
		from Competitions_Entries
		outer apply (select Entrant	= dbo.FullPlayerName(Forename,Initials,Surname) +
										'(' + CONVERT(varchar,Handicap)+ ')'
						From PlayerDetails 
						where ID=EntrantID
				    ) PlayerName
		where CompetitionID = @CompetitionID 
		  and RoundNo = 0
		order by EntryID
else

	select EntryID,Entrant=isnull(Entrant,'Bye')
			from Competitions_Entries
			outer apply (select Entrant	= dbo.FullPlayerName(Forename,Initials,Surname)
							From PlayerDetails 
							where ID=EntrantID
					    ) PlayerName
			where CompetitionID = @CompetitionID 
			  and RoundNo = 0
			order by EntryID

GO

exec GetCompetitionEntries 4

