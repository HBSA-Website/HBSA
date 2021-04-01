USE [HBSA]
GO

/****** Object: SqlProcedure [dbo].[PromoteCompetitionEntry] Script Date: 24/03/2014 11:48:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE [dbo].GetCompetitionDetails;


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

declare @SQL varchar(2000)
	   ,@table varchar(256)
set @table='Competition'+CONVERT(varchar,@CompetitionID)

declare @RoundNo int
set @RoundNo=0

while @RoundNo < @NoRounds
	begin

	   
if @CompType = 3
	set @SQL = '
	select ID,RoundNo,EntrantID,Entrant2ID,Entrant=isnull(Entrant,''Bye''),NULL
		from ' + @table + '
		outer apply (select Entrant = [Club Name] + '' '' + Team
						From Teams 
						join Clubs on ClubID=Clubs.ID 
						where Teams.ID=EntrantID
				    )TeamName
		where RoundNo = ' + CONVERT(varchar,@RoundNo) + '
		order by ID'	    
else
	set @SQL = '
	select ID,RoundNo,EntrantID,Entrant2ID,Entrant=isnull(Entrant,''Bye''),Entrant2
		from ' + @table + '
		outer apply (select Entrant	= Forename + case when isnull(Initials,'''') = '''' then '' '' else '' '' + initials + ''. '' end + Surname +
										''('' + CONVERT(varchar,Handicap)+ '')''
						From PlayerDetails 
						where ID=EntrantID
		            ) PlayerName
		outer apply (select Entrant2=Forename + case when isnull(Initials,'''') = '''' then '' '' else '' '' + initials + ''. '' end + Surname  +
										''('' + CONVERT(varchar,Handicap)+ '')''
						From PlayerDetails 
						where ID=Entrant2ID
		            ) PlayerName2
		where RoundNo = ' + CONVERT(varchar,@RoundNo) + '
		order by ID'	    
exec (@SQL)

	set @RoundNo=@RoundNo+1
	end
GO

exec GetCompetitionDetails 10