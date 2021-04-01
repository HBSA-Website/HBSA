USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[MergeTeam]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'removeTeam')
	drop procedure dbo.removeTeam
GO

CREATE procedure [dbo].[removeTeam]
	(@TeamID int
	,@User varchar(255)
	)
as

-- this procedure removes a team from its league
-- along with its results, and disassociates players

set nocount on	
set xact_abort on

begin tran

	declare @TeamName varchar (256)
	select @TeamName = rtrim([Club Name] + ' ' + Team)
		from Teams 
		cross apply (select [Club Name]
						from clubs where ID = ClubID) C
		where ID=@TeamID
	
	--disassociate the players
	update Players set SectionID=0, Team=''
		from Teams T
		join Players P on P.ClubID=T.ClubID
			          and P.SectionID=T.SectionID
		where T.ID=@TeamID

	--remove recorded breaks
	delete Breaks
		from MatchResults 
		join Breaks on MatchResultID=MatchResults.ID
		where HomeTeamID=@TeamID or AwayTeamID=@TeamID

	--remove match results
	delete 
		from MatchResults 
		where HomeTeamID=@TeamID
		   or AwayTeamID=@TeamID

	--remove adjustments
	delete 
		from LeaguePointsAdjustment 
		where TeamID=@TeamID

	--remove the team keeping details in Teams_Removed
	select * From Teams where ID=@TeamID
		
	--Change the team to a bye to retain the fixture structure
	update Teams 
		set ClubID=8, 
		    Captain=0
		where ID=@TeamID

	--remove logins for this team
	delete 
		from ResultsUsers 
		where TeamID=@TeamID

	--log it
	insert Activitylog values (dbo.UKdateTime(getUTCdate()),'Team removed(' + @TeamName + ')',@TeamID,isnull(@User,original_login()))
	
commit tran

GO
