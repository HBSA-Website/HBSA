USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GetCompetitionDetails')
	drop procedure GetCompetitionDetails
GO
create procedure GetCompetitionDetails
	(@CompetitionID int
	)
as

set nocount on

declare @CompType int
	   ,@NoRounds int
select @CompType=CompType 
	  ,@NoRounds = NoRounds
	from Competitions where ID =@CompetitionID

declare @PlayBydates table
	(RoundNo int
	,PlayByDate date
	,Comment varchar(256)
	)

declare @RoundNo int
set @RoundNo=0

while @RoundNo <= @NoRounds
	begin
	   
	if @CompType = 4
		select EntryID,RoundNo,EntrantID,Entrant2ID,Entrant=isnull(Entrant,'Bye'),Entrant2=NULL,eMail,TelNo
			from Competitions_Entries
			outer apply (select Entrant = [Club Name] + ' ' + Team,eMail, TelNo
							From TeamsDetails Teams
							join Clubs on ClubID=Clubs.ID 
							where Teams.ID=EntrantID)TeamName
			  where CompetitionID=@CompetitionID
			    and RoundNo = @RoundNo
			order by EntryID	    
		    
	else
	if @comptype=3
		select EntryID,RoundNo,EntrantID,Entrant2ID,Entrant=isnull(Entrant,'Bye'),Entrant2,eMail,TelNo
			from Competitions_Entries
			outer apply (select Entrant	= dbo.FullPlayerName(Forename,Initials,Surname)
			                            + '[' + [Club Name] +']'
			                  ,eMail,TelNo
							From PlayerDetails 
							where ID=EntrantID
				        ) PlayerName
			outer apply (select Entrant2 = dbo.FullPlayerName(Forename,Initials,Surname)
			                             + '[' + [Club Name] +']'
							From PlayerDetails 
							where ID=Entrant2ID
				        ) PlayerName2
			where CompetitionID = @CompetitionID 
			  and RoundNo = @RoundNo
			order by EntryID

	else
	if @CompType=2
		select EntryID,RoundNo,EntrantID,Entrant2ID,Entrant=isnull(Entrant,'Bye'),Entrant2=NULL,eMail,TelNo
			from Competitions_Entries
			outer apply (select Entrant	= dbo.FullPlayerName(Forename,Initials,Surname) +
											' (' + CONVERT(varchar,Handicap)+ ')'
			                            + '<br/>' + [Club Name]
							   ,eMail,TelNo
							From PlayerDetails 
							where ID=EntrantID
					    ) PlayerName
			where CompetitionID = @CompetitionID 
			  and RoundNo = @RoundNo
			order by EntryID
	else

		select EntryID,RoundNo,EntrantID,Entrant2ID,Entrant=isnull(Entrant,'Bye'),Entrant2=NULL,eMail,TelNo
			from Competitions_Entries
			outer apply (select Entrant	= dbo.FullPlayerName(Forename,Initials,Surname)
			                            + '<br/>' + [Club Name]
                               ,eMail,TelNo
							From PlayerDetails 
							where ID=EntrantID
					    ) PlayerName
			where CompetitionID = @CompetitionID 
			  and RoundNo = @RoundNo
			order by EntryID

	-- May look strange, but ensures we get NULL values for rounds with no record yet
	insert @PlayBydates
		select @RoundNo
			  ,(select PlayByDate from Competitions_Rounds where CompetitionID=@CompetitionID and @RoundNo=RoundNo and EntryID is null)
		      ,(select Comment from Competitions_Rounds    where CompetitionID=@CompetitionID and @RoundNo=RoundNo and EntryID is null)

	set @RoundNo=@RoundNo+1

	end

select * from @PlayBydates


GO

exec GetCompetitionDetails 3