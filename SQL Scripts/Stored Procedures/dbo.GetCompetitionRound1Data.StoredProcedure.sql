USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetCompetitionRound1Data')
	drop procedure GetCompetitionRound1Data
GO
create procedure GetCompetitionRound1Data
	(@CompetitionID int
	)
as

set nocount on

declare @CompType int

declare @TemporaryRound1Table table 
	(ID int identity (1,1)
	,EntryID int
	,DrawID int
	,Entrant varchar(1000)
	)

select @CompType=CompType 
	from Competitions where ID =@CompetitionID
	   
	if @CompType = 4
	  insert @TemporaryRound1Table
		select EntryID,DrawID,Entrant=isnull(Entrant,'Bye' + ' (' + convert(varchar,EntryId) + ')')
			from Competitions_Entries
			outer apply (select Entrant = [Club Name] + ' ' + Team
							From Teams 
							join Clubs on ClubID=Clubs.ID 
							where Teams.ID=EntrantID)TeamName
			  where CompetitionID=@CompetitionID
			    and RoundNo = 0
			order by EntryID	    
		    
	else
	if @comptype=3
	  insert @TemporaryRound1Table
		select EntryID,DrawID,Entrant=isnull(Entrant,'Bye' + ' (' + convert(varchar,EntryId) + ')') + case when Entrant2 is null then '' else ' / ' + Entrant2 end
			from Competitions_Entries
			outer apply (select Entrant	= dbo.FullPlayerName(Forename,Initials,Surname)
			                            + '[' + [Club Name] +']'
							From PlayerDetails 
							where ID=EntrantID
				        ) PlayerName
			outer apply (select Entrant2 = dbo.FullPlayerName(Forename,Initials,Surname)
			                             + '[' + [Club Name] +']'
							From PlayerDetails 
							where ID=Entrant2ID
				        ) PlayerName2
			where CompetitionID = @CompetitionID 
			  and RoundNo = 0
			order by EntryID

	else
	if @CompType=2
	  insert @TemporaryRound1Table
		select EntryID,DrawID,Entrant=isnull(Entrant,'Bye' + ' (' + convert(varchar,EntryId) + ')')
			from Competitions_Entries
			outer apply (select Entrant	= dbo.FullPlayerName(Forename,Initials,Surname) +
											' (' + CONVERT(varchar,Handicap)+ ')'
			                            + ' [' + [Club Name] +']'
							From PlayerDetails 
							where ID=EntrantID
					    ) PlayerName
			where CompetitionID = @CompetitionID 
			  and RoundNo = 0
			order by EntryID
	else

	  insert @TemporaryRound1Table
		select EntryID,DrawID,Entrant=isnull(Entrant,'Bye' + ' (' + convert(varchar,EntryId) + ')')
			from Competitions_Entries
			outer apply (select Entrant	= dbo.FullPlayerName(Forename,Initials,Surname)
			                            + ' [' + [Club Name] + ']'
							From PlayerDetails 
							where ID=EntrantID
					    ) PlayerName
			where CompetitionID = @CompetitionID 
			  and RoundNo = 0
			order by EntryID

-- These provide empty slots for the drag & drop operation
insert @TemporaryRound1Table select null,null,''
insert @TemporaryRound1Table select null,null,''
insert @TemporaryRound1Table select null,null,''
insert @TemporaryRound1Table select null,null,''

select EntryID, DrawID, Entrant 
	from @TemporaryRound1Table
	order by ID
GO

exec GetCompetitionRound1Data 4
