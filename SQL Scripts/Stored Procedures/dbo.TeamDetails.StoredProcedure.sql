USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'TeamDetails')
	drop procedure TeamDetails
GO

create procedure TeamDetails
	(@TeamID int = 0
	,@LeagueID int = 0
	,@ClubID int = 0
	,@team char(1) = ''
	)
as
set nocount on

	
if @TeamID=0
	if @LeagueID < 0
		select @TeamID=ID 
			from Teams
			where SectionID = @LeagueID
			  and ClubID=@ClubID
			  and team=@team
	else
		select @TeamID=ID 
			from Teams
			where SectionID in (select ID from Sections where LeagueID=@LeagueID)
			  and ClubID=@ClubID
			  and team=@team
else
	select 	 @LeagueID = case when SectionID < 0 then SectionID else S.LeagueID end
			,@ClubID = ClubID
			,@team = Team
		from Teams
		left join Sections S on S.ID = SectionID 
		where Teams.ID = @TeamID

select TeamID=@TeamID, ClubID=@ClubID, LeagueID=@LeagueID, Team=@Team

	
select LeagueID=isnull(LeagueID,0)
      ,[League Name]=isnull([League Name],'')
	  ,SectionID
	  ,[Section Name]=isnull([Section Name],'')
	  ,ClubID, [Club Name], TeamID=T.ID, Team, FixtureNo
	  ,Contact=isnull(Contact,'')
	  ,eMail=isnull(eMail,'')
	  ,TelNo=isnull(TelNo,'')
	  ,Captain

	from    TeamsDetails T 
	join Clubs C on C.ID=T.ClubID
	left join Sections S on S.ID=T.SectionID
	left join Leagues L on L.ID=S.LeagueID
	
	where T.ID=@TeamID

select * 
	from Players
	where SectionID <> 0
	  and ClubID = @ClubID
	  and LeagueID = ABS(@LeagueID)
	  and Team = case when @LeagueID < 0 then Team else @Team end
GO
