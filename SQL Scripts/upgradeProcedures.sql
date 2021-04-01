USE HBSA
GO

/****** Object:  StoredProcedure [dbo].[PlayingRecords]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PlayingRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PlayingRecords]
GO

/****** Object:  StoredProcedure [dbo].[endOfSeason]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[endOfSeason]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[endOfSeason]
GO

/****** Object:  StoredProcedure [dbo].[MergeTeam]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MergeTeam]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MergeTeam]
GO

/****** Object:  StoredProcedure [dbo].[GetClubs]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetClubs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetClubs]
GO

/****** Object:  StoredProcedure [dbo].[GetAllClubs]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAllClubs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetAllClubs]
GO

/****** Object:  StoredProcedure [dbo].[checkForResultsCard2]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[checkForResultsCard2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[checkForResultsCard2]
GO

/****** Object:  StoredProcedure [dbo].[TeamDetails]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TeamDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TeamDetails]
GO

/****** Object:  StoredProcedure [dbo].[GetAllTeams]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAllTeams]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetAllTeams]
GO

/****** Object:  StoredProcedure [dbo].[SectionDetails]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SectionDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SectionDetails]
GO

/****** Object:  StoredProcedure [dbo].[GetAllSections]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAllSections]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetAllSections]
GO

/****** Object:  StoredProcedure [dbo].[MergeLeague]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MergeLeague]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MergeLeague]
GO

/****** Object:  StoredProcedure [dbo].[MergeSection]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MergeSection]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MergeSection]
GO

/****** Object:  StoredProcedure [dbo].[GetAllLeagues]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAllLeagues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetAllLeagues]
GO

/****** Object:  StoredProcedure [dbo].[LeagueDetails]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LeagueDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LeagueDetails]
GO

/****** Object:  StoredProcedure [dbo].[ClubDetails]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClubDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ClubDetails]
GO

/****** Object:  StoredProcedure [dbo].[MergeClub]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MergeClub]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MergeClub]
GO

/****** Object:  StoredProcedure [dbo].[MergeClubs]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MergeClubs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MergeClubs]
GO

/****** Object:  StoredProcedure [dbo].[GetCompetitionDetails]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompetitionDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompetitionDetails]
GO

/****** Object:  StoredProcedure [dbo].[RemoveCompetitionEntry]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RemoveCompetitionEntry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RemoveCompetitionEntry]
GO

/****** Object:  StoredProcedure [dbo].[DeleteCompetitionEntry]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteCompetitionEntry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteCompetitionEntry]
GO

/****** Object:  StoredProcedure [dbo].[GetCompetitions]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompetitions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompetitions]
GO

/****** Object:  StoredProcedure [dbo].[AddCompetitionEntry]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddCompetitionEntry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddCompetitionEntry]
GO

/****** Object:  StoredProcedure [dbo].[MakeCompetition1stRound]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MakeCompetition1stRound]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MakeCompetition1stRound]
GO

/****** Object:  StoredProcedure [dbo].[GetCompetitionEntries]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompetitionEntries]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompetitionEntries]
GO

/****** Object:  StoredProcedure [dbo].[GetCompetitionEntrants]    Script Date: 04/30/2014 11:22:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCompetitionEntrants]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCompetitionEntrants]
GO

/****** Object:  StoredProcedure [dbo].[TeamResultsSheet]    Script Date: 04/30/2014 11:36:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TeamResultsSheet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TeamResultsSheet]
GO

/****** Object:  StoredProcedure [dbo].[UpdateCompetition]    Script Date: 04/30/2014 11:36:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateCompetition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateCompetition]
GO

/****** Object:  StoredProcedure [dbo].[DeleteCompetition]    Script Date: 04/30/2014 11:36:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteCompetition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteCompetition]
GO

/****** Object:  StoredProcedure [dbo].[PromoteCompetitionEntry]    Script Date: 04/30/2014 11:36:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PromoteCompetitionEntry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PromoteCompetitionEntry]
GO

/****** Object:  StoredProcedure [dbo].[MakeCompetitionDraw]    Script Date: 04/30/2014 11:36:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MakeCompetitionDraw]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MakeCompetitionDraw]
GO

/****** Object:  StoredProcedure [dbo].[NewCompetition]    Script Date: 04/30/2014 11:36:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NewCompetition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[NewCompetition]
GO

/****** Object:  StoredProcedure [dbo].[CompetitionDetails]    Script Date: 04/30/2014 11:36:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompetitionDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CompetitionDetails]
GO

/****** Object:  StoredProcedure [dbo].[BreaksReport]    Script Date: 04/30/2014 11:36:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BreaksReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[BreaksReport]
GO

/****** Object:  StoredProcedure [dbo].[insertMatchBreak]    Script Date: 04/30/2014 11:36:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[insertMatchBreak]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[insertMatchBreak]
GO

/****** Object:  StoredProcedure [dbo].[lastSixMatchesAllLeagues]    Script Date: 04/30/2014 11:36:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lastSixMatchesAllLeagues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[lastSixMatchesAllLeagues]
GO

/****** Object:  StoredProcedure [dbo].[lastSixMatches]    Script Date: 04/30/2014 11:36:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[lastSixMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[lastSixMatches]
GO

/****** Object:  StoredProcedure [dbo].[PlayingRecords]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[PlayingRecords]
	(@SectionID int = 0
	,@ClubID int = 0
	,@Team char(1) = ''
	,@PlayerID int = 0
	,@Tagged bit = 0
	,@Over70 bit = 0
	)

as

set nocount on	

declare @WinLosses table 
	(MatchDate date
	,PlayerID int
	,Player varchar(106)
	,Handicap int
	,WinLose tinyint
	)
declare @LeagueID int
if @SectionID > 100
	begin
	set @LeagueID=@SectionID % 100
	set @SectionID=0
	end
else
	set @LeagueID=0
		 	
insert @WinLosses
	select
		 MatchDate
		,HomePlayer1ID
		,HomePlayer1
		,HomeHandicap1
		,WinLose=case when HomePlayer1Score>AwayPlayer1Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer1ID <> 0 and AwayPlayer1ID <> 0

insert @WinLosses
	select
		 MatchDate
		,HomePlayer2ID
		,HomePlayer2
		,HomeHandicap2
		,WinLose=case when HomePlayer2Score>AwayPlayer2Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer2ID <> 0 and AwayPlayer2ID <> 0

insert @WinLosses
	select
		 MatchDate
		,HomePlayer3ID
		,HomePlayer3
		,HomeHandicap3
		,WinLose=case when HomePlayer3Score>AwayPlayer3Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer3ID <> 0 and AwayPlayer3ID <> 0

insert @WinLosses
	select
		 MatchDate
		,HomePlayer4ID
		,HomePlayer4
		,HomeHandicap4
		,WinLose=case when HomePlayer4Score>AwayPlayer4Score then 1 else 0 end
	from MatchResultsDetails
	where HomePlayer4ID <> 0 and AwayPlayer4ID <> 0

insert @WinLosses
	select
		 MatchDate
		,AwayPlayer1ID
		,AwayPlayer1
		,AwayHandicap1
		,WinLose=case when AwayPlayer1Score>HomePlayer1Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer1ID <> 0 and AwayPlayer1ID <> 0

insert @WinLosses
	select
		 MatchDate
		,AwayPlayer2ID
		,AwayPlayer2
		,AwayHandicap2
		,WinLose=case when AwayPlayer2Score>HomePlayer2Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer2ID <> 0 and AwayPlayer2ID <> 0

insert @WinLosses
	select
		 MatchDate
		,AwayPlayer3ID
		,AwayPlayer3
		,AwayHandicap3
		,WinLose=case when AwayPlayer3Score>HomePlayer3Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer3ID <> 0 and AwayPlayer3ID <> 0

insert @WinLosses
	select
		 MatchDate
		,AwayPlayer4ID
		,AwayPlayer4
		,AwayHandicap4
		,WinLose=case when AwayPlayer4Score>HomePlayer4Score then 1 else 0 end
	from MatchResultsDetails
	where AwayPlayer4ID <> 0 and AwayPlayer4ID <> 0

select [Handicap Effective From]=convert(varchar(11),min(Matchdate),113)
      ,Section=max([League Name] + ' ' + [Section Name])
      ,Team=[Club Name] + ' ' + Team
      ,Player
      ,Handicap
      ,Tagged=case when max(convert(tinyint,Tagged))=1 then 'Yes' else '' end
      ,Over70=case when max(convert(tinyint,Over70))=1 then 'Yes' else '' end
      ,Played=count(WinLose)
      ,Won=sum(WinLose)
      ,Lost=count(WinLose)-sum(WinLose)
      
	from @WinLosses
	outer apply (select LeagueID,SectionID,ClubID,Tagged,Over70, Team from Players where ID=PlayerID) p
	outer apply (Select [League Name] from Leagues where ID=p.LeagueID) l
	outer apply (Select [Section Name] from Sections where ID=p.SectionID) s
	outer apply (Select [Club Name] from Clubs where ID=p.ClubID) c

	where [League Name] + ' ' + [Section Name] is not null 
	  and [Club Name] + ' ' + Team is not null
	  and (@LeagueID = 0  or @LeagueID = LeagueID)
	  and (@SectionID = 0 or @SectionID = SectionID)
	  and (@ClubID = 0    or @ClubID = ClubID)
	  and (@Team = ''     or @Team = Team)
	  and (@PlayerID = 0  or @PlayerID = PlayerID)
	  and (@Tagged = 0    or @Tagged = Tagged)
	  and (@Over70 = 0    or @Over70 = Over70)

	group by SectionID, [Club Name] + ' ' + Team, Player, Handicap

	order by SectionID, [Club Name] + ' ' + Team, Player



GO

/****** Object:  StoredProcedure [dbo].[endOfSeason]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[endOfSeason]

as

set nocount on
set xact_abort on

declare @Season int
set @Season = datepart(year,getdate())

begin tran

create table #temp
	(HCapEffectice date
	,Section varchar(100)
	,Team varchar(50)
	,Player varchar(100)
	,Handicap int
	,tag varchar(5)
	,Over70 varchar(5)
	,Played int
	,Won int
	,Lost int
	)

insert #temp
	exec [PlayingRecords]

delete PlayerRecords where Season=@Season	
insert PlayerRecords
	select 
       LeagueID=case when section like '%Open%' then 1
                     when section like '%Vet%' then 2
                     when section like '%bill%' then 3
                     else 0
                end
      ,[Player]
      ,[Season]=@Season
      ,[Hcap]=Handicap
      ,[P]=Played
      ,[W]=Won
      ,[L]=Lost
      ,[Team]=Team
      ,[Tag] = tag

	from #temp where Team is not null
	order by LeagueID,Player

drop table #temp	

commit tran


GO

/****** Object:  StoredProcedure [dbo].[MergeTeam]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[MergeTeam]
	(@TeamID int        --if = -1 insert new record
	,@SectionID	int		--if = -1 delete record
	,@FixtureNo	int     --if = -1 set next available
	,@ClubID int
	,@Team char(1)
	,@Contact varchar(104)
	,@eMail varchar(250)
	,@TelNo varchar(20)	
	)
as
set nocount on     
set xact_abort on

begin tran

declare @FixtureNumber int
set @FixtureNumber=@FixtureNo

if @FixtureNumber = -1
	begin
	set @FixtureNumber=@FixtureNumber+1
	declare @fNo int
	declare TeamsCursor cursor fast_forward for
		select FixtureNo
			from Teams
			where SectionID=@SectionID
			order by FixtureNo
	open TeamsCursor
	fetch TeamsCursor into @fNo
	while @fNo = @FixtureNumber+1
		begin
		if @fNo = @FixtureNumber+1
			begin
			set @FixtureNumber=@FixtureNumber+1
			fetch TeamsCursor into @fNo
			end
		end
	
	close TeamsCursor
	deallocate TeamsCursor
	set @FixtureNumber=@FixtureNumber+1
	end

MERGE Teams AS target
    USING (SELECT @TeamID) AS source (ID)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED AND @SectionID=-1 THEN
		DELETE
    
    WHEN MATCHED THEN 
        UPDATE SET
             SectionID=@SectionID
			,FixtureNo=@FixtureNumber
			,ClubID=@ClubID
			,Team=@Team
			,Contact=@Contact
			,eMail=@eMail
			,TelNo=@TelNo
					
    WHEN NOT MATCHED AND @TeamID=-1 THEN    
		INSERT	(SectionID
				,FixtureNo
				,ClubID
				,Team
				,Contact
				,eMail
				,TelNo
				)
		values	(@SectionID
				,@FixtureNumber
				,@ClubID
				,@Team
				,@Contact
				,@eMail
				,@TelNo
				)
		
		OUTPUT $action,inserted.ID;

commit tran


GO

/****** Object:  StoredProcedure [dbo].[GetClubs]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[GetClubs]
	(@SectionID int
	,@IncludeBye bit = 0
	)

as

set nocount on

if @SectionID > 99 
	select distinct c.ID, c.[Club Name]
		from Teams t
		join Clubs c on ClubID = c.ID
		where SectionID in (Select ID from Sections where LeagueID=@SectionID % 100)
		  and (@IncludeBye = 1 or c.[Club Name] <> 'Bye')
		order by c.[Club Name]
else
	select distinct c.ID, c.[Club Name]
		from Teams t
		join Clubs c on ClubID = c.ID
		where (@SectionID=0 or sectionid=@SectionID)
		   and (@IncludeBye = 1 or c.[Club Name] <> 'Bye')
		order by c.[Club Name]



GO

/****** Object:  StoredProcedure [dbo].[GetAllClubs]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[GetAllClubs]

as

set nocount on

select
	 ID	= isnull(ID,'')
	,[Club Name]	= isnull([Club Name],'')
	,Address1	= isnull(Address1,'')
	,Address2	= isnull(Address2,'')
	,PostCode	= isnull(PostCode,'')
	,ContactName	= isnull(ContactName,'')
	,ContactEMail	= isnull(ContactEMail,'')
	,ContactTelNo	= isnull(ContactTelNo,'')
	,ContactMobNo	= isnull(ContactMobNo,'')

	from Clubs 
	where [Club Name] <> 'Bye'
	ORDER BY [Club Name]



GO

/****** Object:  StoredProcedure [dbo].[checkForResultsCard2]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create Procedure [dbo].[checkForResultsCard2]-- 43, 40
	(@HomeTeamID int
	,@AwayTeamID int
	)
as

set nocount on


declare @MatchResultID int
Select @MatchResultID=ID from MatchResults where HomeTeamID=@HomeTeamID and AwayTeamID=@AwayTeamID 

declare @FixtureDate date
select @FixtureDate=D.FixtureDate
	from FixtureGrids F
	cross apply (select FixtureNo, SectionID from Teams where ID=@HomeTeamID) H
	cross apply	(select FixtureNo from Teams where ID=@AwayTeamID) A
	Cross apply (select LeagueID from Sections where ID=F.SectionID) L
	cross apply (Select FixtureDate from FixtureDates where LeagueID= L.LeagueID and WeekNo = F.WeekNo) D
	where F.SectionID=H.SectionID
	  and ((h1=H.FixtureNo and a1=A.FixtureNo)
 	    or (h2=H.FixtureNo and a2=A.FixtureNo)
	    or (h3=H.FixtureNo and a3=A.FixtureNo)
	    or (h4=H.FixtureNo and a4=A.FixtureNo)
	    or (h5=H.FixtureNo and a5=A.FixtureNo)
	    or (h6=H.FixtureNo and a6=A.FixtureNo)
	    or (h7=H.FixtureNo and a7=A.FixtureNo)
	    or (h8=H.FixtureNo and a8=A.FixtureNo)
	       )


select R.ID
      ,[Match Date]=convert(varchar(11),R.MatchDate,113)
      ,League=[League Name],Section=[Section Name] 
	  ,[Home]=HC.[Club Name]+' '+H.Team
	  ,H_Pts= case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
	               case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
	               case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
	               case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end
	  ,A_Pts= case when AwayPlayer1Score > HomePlayer1Score then 1 else 0 end +
	               case when AwayPlayer2Score > HomePlayer2Score then 1 else 0 end +
	               case when AwayPlayer3Score > HomePlayer3Score then 1 else 0 end +
	               case when AwayPlayer4Score > HomePlayer4Score then 1 else 0 end
      ,[Away]=AC.[Club Name]+' '+A.Team
	  ,FixtureDate=CONVERT (varchar(11), @FixtureDate,113)
	  
	from MatchResults R
	left join Teams H on H.ID=HomeTeamID
		join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
		join Clubs AC on AC.ID = A.ClubID
	join Sections s on s.ID=h.SectionID
	join Leagues l on l.ID = s.LeagueID
	
	where R.ID = @MatchResultID

select FN=4, [Home H'cap]=isnull(HomeHandicap4,0),HomeScore=HomePlayer4Score,HomePlayer=HomePlayer4ID,AwayPlayer=AwayPlayer4ID,AwayScore=AwayPlayer4Score,[Away H'cap]=isnull(AwayHandicap4,0) 
	into #tmpFrames
	from MatchResultsDetails 
	where ID = @MatchResultID


insert #tmpframes
select FN=3, HomeHandicap3,HomePlayer3Score,HomePlayer3ID,AwayPlayer3ID,AwayPlayer3Score,AwayHandicap3 from MatchResultsDetails where ID = @MatchResultID
insert #tmpframes
select FN=2, HomeHandicap2,HomePlayer2Score,HomePlayer2ID,AwayPlayer2ID,AwayPlayer2Score,AwayHandicap2 from MatchResultsDetails where ID = @MatchResultID
insert #tmpframes
select FN=1, HomeHandicap1,HomePlayer1Score,HomePlayer1ID,AwayPlayer1ID,AwayPlayer1Score,AwayHandicap1 from MatchResultsDetails where ID = @MatchResultID
select * from #tmpFrames
	order by FN

select   Player=Forename + case when Initials <> '' then Initials + '. ' else ' ' end + Surname
		,B.* 
	from Breaks B
	left join Players P on P.ID = B.PlayerID
	left join MatchResults R on R.ID=B.MatchResultID 
	where @MatchResultID = MatchResultID
	  and (PlayerID = HomePlayer1ID
	    or PlayerID = HomePlayer2ID
	    or PlayerID = HomePlayer3ID
	    or PlayerID = HomePlayer4ID) 
select   Player=Forename + case when Initials <> '' then Initials + '. ' else ' ' end + Surname
		,B.* 
	from Breaks B
	left join Players P on P.ID = B.PlayerID
	left join MatchResults R on R.ID=B.MatchResultID 
	where @MatchResultID = MatchResultID
	  and (PlayerID = AwayPlayer1ID
	    or PlayerID = AwayPlayer2ID
	    or PlayerID = AwayPlayer3ID
	    or PlayerID = AwayPlayer4ID)


GO

/****** Object:  StoredProcedure [dbo].[TeamDetails]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[TeamDetails]
	@TeamID int
as
set nocount on
	
select LeagueID, [League Name], SectionID, [Section Name], ClubID, [Club Name], TeamID=T.ID, Team, FixtureNo
	  ,Contact=isnull(Contact,'')
	  ,eMail=isnull(eMail,'')
	  ,TelNo=isnull(TelNo,'')
	
	from    Teams T 
	join Clubs C on C.ID=T.ClubID
	join Sections S on S.ID=T.SectionID
	join Leagues L on L.ID=S.LeagueID
	
	where T.ID=@TeamID

select P.*
	from Teams T 
	join Clubs C on C.ID=T.ClubID
	--join Sections S on S.ID=T.SectionID
	join Players P on P.ClubID=C.ID and P.Team=T.Team and P.SectionID=T.sectionID
	
	where T.ID=@TeamID

	

GO

/****** Object:  StoredProcedure [dbo].[GetAllTeams]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[GetAllTeams]
	(@LeagueID int = 0
	,@SectionID int = 0
	)

as

set nocount on

select
	 Teams.ID
	,[Club Name]=isnull([Club Name],'')
	,ClubID
	,Team
	,League=isnull([League Name],'')+' '+isnull([Section Name],'')
	,FixtureNo
	,Contact=isnull(Contact,'')
	,eMail=isnull(eMail,'')
	,TelNo=isnull(TelNo,'')
	
	from Teams 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	join Clubs on Clubs.ID=ClubID
	
	where (@LeagueID=0 or LeagueID=@LeagueID)
	  and (@SectionID=0 or SectionID=@SectionID)
	  --and [Club Name] <> 'Bye'
	
	order by LeagueID,SectionID,FixtureNo


GO

/****** Object:  StoredProcedure [dbo].[SectionDetails]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[SectionDetails]
	(@ID as integer
	)
as

set nocount on

select 
	 ID
	,LeagueID 
	,[Section Name]	= isnull([Section Name],'')
	,ReversedMatrix
	
	from Sections 
	
	where ID = @ID

select Team,[Section Name],[Section Name], [Club Name]
	from Teams 
	join Clubs on Clubs.ID=Clubid
	join Sections on Sections.ID=SectionID
	WHERE SectionID=@ID 
	order by sectionid
	
select Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
	from Players 
	where SectionID=@ID
	order by Team, Forename,surname


GO

/****** Object:  StoredProcedure [dbo].[GetAllSections]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[GetAllSections]

as

set nocount on

select
	 Sections.ID	
	,[Section Name]	= isnull([Section Name],'')
	,League	= isnull([League Name],0)
	,ReversedMatrix	= isnull(ReversedMatrix,0)
	
	from Sections 
	join Leagues on LeagueID=Leagues.ID
	
	ORDER BY ID


GO

/****** Object:  StoredProcedure [dbo].[MergeLeague]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[MergeLeague]
	(@LeagueID int           --if = -1 insert new record
	,@LeagueName varchar(50) --if empty delete record with this ID
		)

as
set nocount on
set xact_abort on

begin tran

MERGE Leagues AS target
    USING (SELECT @LeagueID) AS source (ID)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED AND @LeagueName='' THEN
		DELETE
    
    WHEN MATCHED THEN 
        UPDATE SET
            [League Name]		= @LeagueName
					
    WHEN NOT MATCHED AND @LeagueName <> '' AND @LeagueID=-1 THEN    
		INSERT ( [League Name]
				)
			values(	 @LeagueName
			      )
		
		OUTPUT $action;
	
--resequence the table
select * into #tmpLeagues from Leagues
truncate table Leagues
insert Leagues
	select [League Name] 
		from #tmpLeagues
		order by ID
drop table #tmpLeagues	

commit tran
	


GO

/****** Object:  StoredProcedure [dbo].[MergeSection]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[MergeSection]
	(@SectionID int           --if = -1 insert new record
	,@SectionName varchar(50) --if = remove delete record with this ID
	,@LeagueID	int = 0
	,@ReversedMatrix	tinyint = 0
	)
as
set nocount on     
set xact_abort on

begin tran

MERGE Sections AS target
    USING (SELECT @SectionID) AS source (ID)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED AND @SectionName='remove' THEN
		DELETE
    
    WHEN MATCHED THEN 
        UPDATE SET
            [Section Name]		= @SectionName
           ,LeagueID	= @LeagueID
		   ,ReversedMatrix	= @ReversedMatrix
					
    WHEN NOT MATCHED AND @SectionID=-1 THEN    
		INSERT ( LeagueID
				,[Section Name]
				,ReversedMatrix
				)
			values(@LeagueID
				  ,@SectionName
				  ,@ReversedMatrix
			      )
		
		OUTPUT $action;

--resequence the table
select * into #tmpSections from Sections
truncate table sections
insert Sections
	select LeagueID,[Section Name],ReversedMatrix 
		from #tmpSections
		order by ID
drop table #tmpSections	

commit tran
	

GO

/****** Object:  StoredProcedure [dbo].[GetAllLeagues]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[GetAllLeagues]

as

set nocount on

select
	 ID	= isnull(ID,'')
	,[League Name]	= isnull([League Name],'')

	from Leagues 
	ORDER BY ID


GO

/****** Object:  StoredProcedure [dbo].[LeagueDetails]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[LeagueDetails]
	(@ID as integer
	)
as

set nocount on

select 
	 ID
	,[League Name]	= isnull([League Name],'')
	
	from Leagues 
	
	where ID = @ID

select * 
	From Sections 
	where LeagueID=@ID

select Team,[League Name],[Section Name], [Club Name]
	from Teams 
	join Clubs on Clubs.ID=Clubid
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	WHERE LeagueID=@ID 
	order by sectionid
	
select Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
	from Players 
	where LeagueID=@ID
	order by Team, Forename,surname


GO

/****** Object:  StoredProcedure [dbo].[ClubDetails]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[ClubDetails]
	(@ID as integer
	)
as

set nocount on

select 
	 ID	= isnull(ID,'')
	,[Club Name]	= isnull([Club Name],'')
	,Address1	= isnull(Address1,'')
	,Address2	= isnull(Address2,'')
	,PostCode	= isnull(PostCode,'')
	,ContactName	= isnull(ContactName,'')
	,ContactEMail	= isnull(ContactEMail,'')
	,ContactTelNo	= isnull(ContactTelNo,'')
	,ContactMobNo	= isnull(ContactMobNo,'')
	
	from Clubs 
	
	where ID = @ID

select Team,[League Name],[Section Name]
	from Teams 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	WHERE ClubID=@ID 
	order by sectionid
	
select Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
	from Players 
	where ClubID=@ID
	order by Team, Forename,surname


GO

/****** Object:  StoredProcedure [dbo].[MergeClub]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[MergeClub]
	(@ClubID int           --if = -1 insert new record
	,@ClubName varchar(50) --if empty delete record with this ID
	,@Address1 varchar(50) = ''
	,@Address2 varchar(50) = ''
	,@PostCode char(8) = ''
	,@ContactName varchar(104) = ''
	,@ContactEMail varchar(250) = ''
	,@ContactTelNo varchar(20) = ''
	,@ContactMobNo varchar(20) = ''
	)

as
set nocount on     

MERGE Clubs AS target
    USING (SELECT @ClubID) AS source (ID)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED AND @ClubName='' THEN
		DELETE
    
    WHEN MATCHED THEN 
        UPDATE SET
            [Club Name]		= @ClubName
			,Address1		= @Address1
			,Address2		= @Address2
			,PostCode		= @PostCode
			,ContactName	= @ContactName
			,ContactEMail	= @ContactEMail
			,ContactTelNo	= @ContactTelNo
			,ContactMobNo	= @ContactMobNo
					
    WHEN NOT MATCHED AND @ClubName <> '' AND @ClubID=-1 THEN    
		INSERT ( [Club Name]
				,Address1
				,Address2
				,PostCode
				,ContactName
				,ContactEMail
				,ContactTelNo
				,ContactMobNo
				)
			values(	 @ClubName
					,@Address1
					,@Address2
					,@PostCode
					,@ContactName
					,@ContactEMail
					,@ContactTelNo
					,@ContactMobNo)
		
		OUTPUT $action;
	

GO

/****** Object:  StoredProcedure [dbo].[MergeClubs]    Script Date: 04/30/2014 11:22:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[MergeClubs]
	(@ID int
	,@ClubName varchar(50)
	,@Address1 varchar(50)
	,@Address2 varchar(50)
	,@PostCode char(8)
	,@ContactName varchar(104)
	,@ContactEMail varchar(250)
	,@ContactTelNo varchar(20)
	,@ContactMobNo varchar(20)
	)

as
set nocount on     

  MERGE Clubs AS target
    USING (SELECT @ID) AS source (ID)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED THEN 
        UPDATE SET
            [Club Name]		= @ClubName
			,Address1		= @Address1
			,Address2		= @Address2
			,PostCode		= @PostCode
			,ContactName	= @ContactName
			,ContactEMail	= @ContactEMail
			,ContactTelNo	= @ContactTelNo
			,ContactMobNo	= @ContactMobNo
					
    WHEN NOT MATCHED THEN    
		INSERT ( [Club Name]
				,Address1
				,Address2
				,PostCode
				,ContactName
				,ContactEMail
				,ContactTelNo
				,ContactMobNo
				)
			values(	 @ClubName
					,@Address1
					,@Address2
					,@PostCode
					,@ContactName
					,@ContactEMail
					,@ContactTelNo
					,@ContactMobNo)
					;

GO

/****** Object:  StoredProcedure [dbo].[GetCompetitionDetails]    Script Date: 04/30/2014 11:22:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[GetCompetitionDetails]
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

while @RoundNo <= @NoRounds
	begin

	   
if @CompType = 4
	set @SQL = '
	select ID,RoundNo,EntrantID,Entrant2ID,Entrant=isnull(Entrant,''Bye''),Entrant2=NULL
		from ' + @table + '
		outer apply (select Entrant = [Club Name] + '' '' + Team
						From Teams 
						join Clubs on ClubID=Clubs.ID 
						where Teams.ID=EntrantID
				    )TeamName
		where RoundNo = ' + CONVERT(varchar,@RoundNo) + '
		order by ID'	    
else
	begin
	set @SQL = '
	select ID,RoundNo,EntrantID,Entrant2ID,Entrant=isnull(Entrant,''Bye''),Entrant2
		from ' + @table + '
		outer apply (select Entrant	= Forename + case when isnull(Initials,'''') = '''' then '' '' else '' '' + initials + ''. '' end + Surname'
	if @CompType <> 1
		set @SQL=@SQL + ' +
										''('' + CONVERT(varchar,Handicap)+ '')'''
	set @SQL=@SQL + '
						From PlayerDetails 
						where ID=EntrantID
		            ) PlayerName
		outer apply (select Entrant2=Forename + case when isnull(Initials,'''') = '''' then '' '' else '' '' + initials + ''. '' end + Surname'
	if @CompType <> 1
		set @SQL=@SQL + ' +
										''('' + CONVERT(varchar,Handicap)+ '')'''
	set @SQL=@SQL + '
						From PlayerDetails 
						where ID=Entrant2ID
		            ) PlayerName2
		where RoundNo = ' + CONVERT(varchar,@RoundNo) + '
		order by ID'	
	end	    
	
	exec (@SQL)

	set @RoundNo=@RoundNo+1
	end

GO

/****** Object:  StoredProcedure [dbo].[RemoveCompetitionEntry]    Script Date: 04/30/2014 11:22:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[RemoveCompetitionEntry]
	(@CompetitionID int
	,@EntryID int
	,@RoundNo int
	)

as

set nocount on
	
declare @table varchar(250)
select @table = 'Competition' + convert(varchar,@CompetitionID)

declare @SQL varchar(4000)
if @RoundNo > 0
	begin
	set @SQL= '
	delete ' + @table + ' 
		where ID = ' + convert(varchar,@EntryID) + '
		  and RoundNo = '+ convert(varchar,@RoundNo)
	end
else
	begin
	set @SQL= '
	update ' + @table + ' 
		set EntrantID=NULL, Entrant2ID=NULL
		where ID = ' + convert(varchar,@EntryID) + '
		  and RoundNo = '+ convert(varchar,@RoundNo)
	end
	
exec(@SQL)


GO

/****** Object:  StoredProcedure [dbo].[DeleteCompetitionEntry]    Script Date: 04/30/2014 11:22:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[DeleteCompetitionEntry]
	(@CompetitionID int
	,@EntryID int
	)

as

set nocount on
set xact_abort on
	
declare @table varchar(250)
select @table = 'Competition' + convert(varchar,@CompetitionID)

declare @SQL varchar(1000)

begin tran

--can only delete from baseline
exec MakeCompetition1stRound @CompetitionID
	set @SQL= '
	delete ' + @table + ' 
		where ID = ' + convert(varchar,@EntryID)
	
exec(@SQL)

commit tran


GO

/****** Object:  StoredProcedure [dbo].[GetCompetitions]    Script Date: 04/30/2014 11:22:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[GetCompetitions]
	(@Drawn bit = 0
	)

as

set nocount on

select ID=Competitions.ID
	 , Name
	 , League=[League Name]
	 , CompetitionType=case when CompType=1 then 'Open'
	                        when CompType=2 then 'Handicaps'
	                        when CompType=3 then 'Pairs'
	                        when CompType=4 then 'Teams'
	                   end
	 , NoRounds                       
	
	From Competitions
	join Leagues on Leagues.ID=LeagueID
	
	where @Drawn=0
	   or NoRounds is not null

GO

/****** Object:  StoredProcedure [dbo].[AddCompetitionEntry]    Script Date: 04/30/2014 11:22:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[AddCompetitionEntry]
	(@CompetitionID int
	,@EntrantID int
	,@Entrant2ID int = NULL
	)
as		

set nocount on
set xact_abort on

declare @SQL varchar(2000)
	   ,@table varchar(250)
	   ,@CompType int
select @table = 'Competition' + convert(varchar,@CompetitionID)
	   ,@CompType = CompType
	from competitions where ID=@CompetitionID
	
if @table is null
	raiserror ('There is no competition with ID %i',15,0,@CompetitionID)
else
	begin	


	begin tran

	--ensure the competition is at base level before adding any entrants
	exec MakeCompetition1stRound @CompetitionID

	set @SQL = '
	if (select COUNT(*) from ' + @table + ' 
			where EntrantID=' + convert(varchar,@EntrantID) + '
	           or (Entrant2ID is not null and Entrant2ID=' + convert(varchar,@EntrantID) + ')) > 0
		begin
		declare @Entrant varchar(55)'
		if @CompType<>3
			set @SQL=@SQL + '
				select @Entrant = Forename + case when isnull(Initials,'''') = '''' then '' '' else Initials + ''. '' end + Surname 
					from Players where ID=' + convert(varchar,@EntrantID)
		else		
			set @SQL=@SQL + '
				select @Entrant = [Club Name] + case when Team <> '''' then '' '' + team else '''' end 
					from Teams 
					join Clubs on Clubs.ID=ClubID
					where Teams.ID=' + convert(varchar,@EntrantID)
		set @SQL=@SQL + '
		raiserror (''This Entrant (%s) already exists'',15,0,@Entrant)
		end '
	if @Entrant2ID is not null
		begin
		set @SQL= @SQL + '
		else
		if (select COUNT(*) from ' + @table + ' 
				where EntrantID=' + convert(varchar,@Entrant2ID) + '
				   or (Entrant2ID is not null and Entrant2ID=' + convert(varchar,@Entrant2ID) + ')) > 0
			begin
			declare @Entrant2 varchar(55)'
			if @CompType<>3
				set @SQL=@SQL + '
					select @Entrant2 = Forename + case when isnull(Initials,'''') = '''' then '' '' else Initials + ''. '' end + Surname 
						from Players where ID=' + convert(varchar,@Entrant2ID)
			else		
				set @SQL=@SQL + '
					select @Entrant2 = [Club Name] + case when Team <> '''' then '' '' + team else '''' end 
						from Teams 
						join Clubs on Clubs.ID=ClubID
						where Teams.ID=' + convert(varchar,@Entrant2ID)
			set @SQL=@SQL + '
			raiserror (''This Entrant (%s) already exists'',15,0,@Entrant2)
			end'
		end	
	set @SQL= @SQL + '
	else
		begin
		declare @ID int
		select top 1 @ID=ID from ' + @table + ' where EntrantID is null order by DrawID
		if @ID is null
			insert ' + @table + ' select NULL,0,' + 
									convert(varchar,@EntrantID) + ',' + 
									case when @Entrant2ID is null then 'NULL' else convert(varchar,@Entrant2ID) end + '
		else
			update ' + @table + ' set EntrantID=' + convert(varchar,@EntrantID) +
			                       ', Entrant2ID=' + case when @Entrant2ID is null then 'NULL' else convert(varchar,@Entrant2ID) end + ' where ID=@ID
		end	
	'
	exec (@SQL)

	commit tran

	end

GO

/****** Object:  StoredProcedure [dbo].[MakeCompetition1stRound]    Script Date: 04/30/2014 11:22:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[MakeCompetition1stRound]
	(@CompetitionID int
	)

as

set nocount on
	
declare @table varchar(250)
select @table = 'Competition' + convert(varchar,@CompetitionID)


declare @SQL varchar(4000)
set @SQL= '
set xact_abort on

begin tran

delete ' + @table + ' where EntrantID is null or RoundNo > 0

update Competitions set NoRounds=NULL where ID = ' + convert(varchar, @CompetitionID) + '

commit tran'

exec(@SQL)


GO

/****** Object:  StoredProcedure [dbo].[GetCompetitionEntries]    Script Date: 04/30/2014 11:22:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[GetCompetitionEntries]
	(@CompetitionID int
	)
as

set nocount on

declare @CompType int
select @CompType=CompType 
	from Competitions where ID =@CompetitionID

declare @SQL varchar(2000)
	   ,@table varchar(256)
set @table='Competition'+CONVERT(varchar,@CompetitionID)

if @CompType = 4
	set @SQL = '
	select ID,Entrant=isnull(Entrant,''Bye'')
		from ' + @table + '
		outer apply (select Entrant = [Club Name] + '' '' + Team
						From Teams 
						join Clubs on ClubID=Clubs.ID 
						where Teams.ID=EntrantID
				    )TeamName
		where RoundNo = 0
		order by ID'	    
else
	begin
	set @SQL = '
	select ID,Entrant=isnull(Entrant,''Bye'')'
	if @CompType=3
		set @SQL=@SQL+',Entrant2'
	set @SQL=@SQL + '	
		from ' + @table + '
		outer apply (select Entrant	= Forename + case when isnull(Initials,'''') = '''' then '' '' else '' '' + initials + ''. '' end + Surname'
	if @CompType <> 1
		set @SQL=@SQL + ' +
										''('' + CONVERT(varchar,Handicap)+ '')'''
	set @SQL=@SQL + '
						From PlayerDetails 
						where ID=EntrantID
		            ) PlayerName
		outer apply (select Entrant2=Forename + case when isnull(Initials,'''') = '''' then '' '' else '' '' + initials + ''. '' end + Surname'
	if @CompType <> 1
		set @SQL=@SQL + ' +
										''('' + CONVERT(varchar,Handicap)+ '')'''
	set @SQL=@SQL + '
						From PlayerDetails 
						where ID=Entrant2ID
		            ) PlayerName2
		where RoundNo = 0
		order by ID'
	end

exec (@SQL)

GO

/****** Object:  StoredProcedure [dbo].[GetCompetitionEntrants]    Script Date: 04/30/2014 11:22:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[GetCompetitionEntrants]
	(@CompetitionID int
	)
as

set nocount on

declare @CompType int
	   ,@LeagueID int

select   @CompType = CompType 
		,@LeagueID=LeagueID
	from Competitions where ID=@CompetitionID

create table #EntrantIDs (EntrantID int)
declare @SQL varchar(1000)
--get IDs already entered
set @SQL = 
   'insert #EntrantIDs select EntrantID from Competition' + CONVERT(varchar,@CompetitionID) + '
	insert #EntrantIDs select Entrant2ID from Competition' + CONVERT(varchar,@CompetitionID) + ' where Entrant2ID is not null'
exec (@SQL)

if @CompType=4 
	select EntrantID = Teams.ID, 
	       Entrant = [Club Name] + ' ' + Team
		from Teams
		join Clubs on Clubs.ID=ClubID
		join Sections on Sections.ID=SectionID 
		left join #EntrantIDs on #EntrantIDs.EntrantID = Teams.ID
		where LeagueID=@LeagueID
		  and #EntrantIDs.EntrantID is null
		  and [Club Name] <> 'Bye'
		order by [Club Name], Team
else
	select
       EntrantID = Players.ID, 
       Entrant = Forename + case when isnull(Initials,'') = '' then ' ' else ' ' + Initials + '. ' end + Surname +
				            case when @CompType <> 1 then ' (' + convert(varchar,Handicap) + ')' else '' end 
		from Players 	
		left join #EntrantIDs on #EntrantIDs.EntrantID = Players.ID
		where LeagueID=@LeagueID
		  and #EntrantIDs.EntrantID is null
		order by Entrant

drop table #EntrantIDs

GO

/****** Object:  StoredProcedure [dbo].[TeamResultsSheet]    Script Date: 04/30/2014 11:36:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[TeamResultsSheet] 
	@TeamID int

as


set nocount on

declare @Matches table
	(ID	int
	,MatchDate date
	,Home varchar(55)
	,hFrames int
	,aFrames int
	,Away varchar(55)
	,FixtureDate date
	)
insert @Matches exec listMatches @TeamID

declare @HomeTeam varchar(55) 
select @HomeTeam=[Club Name] + ' ' + Team
	from Teams
	cross apply (select [Club Name] from Clubs where id=ClubID) x
	where ID=@TeamID 

create table #TeamResults
	(ID int
	,MatchDate date
	,Opposition varchar(55)
	,[v] char (1)
	,Result varchar(10)
	,[For] int
	,[Agn] int
	)

insert #TeamResults
	select
		 ID, MatchDate
		,case when Home = @HomeTeam then Away else Home end
		,case when Home = @HomeTeam then 'H' else 'A' end
		,case when case when Home = @HomeTeam then hFrames else aFrames end > case when Home = @HomeTeam then aFrames else hFrames end then 'Win' 
		      when case when Home = @HomeTeam then hFrames else aFrames end < case when Home = @HomeTeam then aFrames else hFrames end then 'Lose' 
		                                                                                                                               else 'Draw'
         end		                                                                                                                                
		,case when Home = @HomeTeam then hFrames else aFrames end
		,case when Home = @HomeTeam then aFrames else hFrames end 
	from @Matches

declare @Players table (Player varchar(55))	
insert @Players
	select	Player= case when (Case when HomeTeamID=@TeamID then HomePlayer1 else AwayPlayer1 end) = 'Not Specified' 
						 then 'Not Specified1' 
						 else Case when HomeTeamID=@TeamID then HomePlayer1 else AwayPlayer1 end 
					end	 
		from MatchResultsDetails 
		where HomeTeamID=@TeamID or awayteamid=@TeamID 
union
select	 case when (Case when HomeTeamID=@TeamID then HomePlayer2 else AwayPlayer2 end) = 'Not Specified' 
						 then 'Not Specified2' 
						 else Case when HomeTeamID=@TeamID then HomePlayer2 else AwayPlayer2 end 
					end
	from MatchResultsDetails 
	where HomeTeamID=@TeamID or awayteamid=@TeamID 
union
select	 case when (Case when HomeTeamID=@TeamID then HomePlayer3 else AwayPlayer3 end) = 'Not Specified' 
						 then 'Not Specified3' 
						 else Case when HomeTeamID=@TeamID then HomePlayer3 else AwayPlayer3 end 
					end
	from MatchResultsDetails 
	where HomeTeamID=@TeamID or awayteamid=@TeamID 
union
select	case when (Case when HomeTeamID=@TeamID then HomePlayer4 else AwayPlayer4 end) = 'Not Specified' 
						 then 'Not Specified4' 
						 else Case when HomeTeamID=@TeamID then HomePlayer4 else AwayPlayer4 end 
					end
	from MatchResultsDetails 
	where HomeTeamID=@TeamID or awayteamid=@TeamID 
order by 	Player

declare cPlayers cursor fast_forward for
	select Player=Replace(Player,'''','`') 
		from @Players
		where Player is not null

open cPlayers
declare  @Player varchar(55)
		,@SQL varchar(8000)
		,@selectSQL varchar(8000)
		,@dataSQL varchar(8000)
		,@total1SQL varchar (8000)
        ,@total2SQL varchar (8000)
        ,@total3SQL varchar (8000)
        ,@total4SQL varchar (8000)
        ,@total5SQL varchar (8000)
       

set @total1SQL='insert #TeamResults
select Null,null,null,null,''Points'',null,null'
set @total2SQL='insert #TeamResults
select Null,null,null,null,''Frames'',null,null'
set @total3SQL='insert #TeamResults
select Null,null,null,null,''Avg Points'',null,null'
set @total4SQL='insert #TeamResults
select Null,null,null,null,''% Points'',null,null'
set @total5SQL='insert #TeamResults
select Null,null,null,null,Result=''% Frames'',null,null'

set @selectSQL = 
'select	 MatchDate = convert(varchar(11),Matchdate,113)
		,Opposition
		,[v] 
		,Result = Result + case when [For] is not null then '' '' + Convert(char(2),[For]) + Convert(char(2),[Agn]) else '''' end'
set @dataSQL = 
'select	 MatchDate = convert(varchar(11),Matchdate,113)
		,Opposition
		,[v] 
		,Result
		,[For]
		,[Agn]'

fetch cPlayers into @Player
while @@fetch_status=0
	begin
	set @SQL = 
			'alter table #TeamResults add [' + @Player + ' F] int, [' + @Player + ' A] int'
	exec (@SQL)		
	set @selectSQL=@selectSQL + '
		,[' + @Player + ']=convert(varchar,[' + @Player + ' F]) + '' - '' + convert(varchar,[' + @Player + ' A])'
	
	set @dataSQL=@dataSQL + '
		,[' + @Player + ' F], [' + @Player + ' A]'

	set @total1SQL=@total1SQL + '
		, sum([' + @Player + ' F]), sum([' + @Player + ' A])'
	set @total2SQL=@total2SQL + '
		, sum(case when [' + @Player + ' F]>[' + @Player + ' A] then 1 else 0 end)
        , sum(case when [' + @Player + ' F]<[' + @Player + ' A] then 1 else 0 end)'
	set @total3SQL=@total3SQL + '
		, convert(int,sum([' + @Player + ' F])/count([' + @Player + ' F]))
        , convert(int,sum([' + @Player + ' A])/count([' + @Player + ' A]))'
	set @total4SQL=@total4SQL + '
		, (sum([' + @Player + ' F]) * 100)/(sum([' + @Player + ' F]) + sum([' + @Player + ' A]))
        , 100-(sum([' + @Player + ' F]) * 100)/(sum([' + @Player + ' F]) + sum([' + @Player + ' A]))'
	set @total5SQL=@total5SQL + '
		, round(sum(case when [' + @Player + ' F]>[' + @Player + ' A] then 1 else 0 end) * 100/count([' + @Player + ' F]),2)
        , 100-round(sum(case when [' + @Player + ' F]>[' + @Player + ' A] then 1 else 0 end) * 100/count([' + @Player + ' A]),2)'
    
	fetch cPlayers into @Player
	end
close cPlayers
deallocate cPlayers
set @selectSQL=@selectSQL + '
	from #TeamResults'
set @dataSQL=@dataSQL + '
	from #TeamResults'
set @total1SQL=@total1SQL + '
	from #TeamResults where ID is not null'
set @total2SQL=@total2SQL + '
	from #TeamResults where ID is not null'
set @total3SQL=@total3SQL + '
	from #TeamResults where ID is not null'
set @total4SQL=@total4SQL + '
	from #TeamResults where ID is not null'
set @total5SQL=@total5SQL + '
	from #TeamResults where ID is not null'

declare cMatches cursor fast_forward for
	select ID from #TeamResults
declare @ID int

declare   @Player1 varchar(55)
		 ,@Player1ScoreFor int
		 ,@Player1ScoreAgn int
		 ,@Player2 varchar(55)
		 ,@Player2ScoreFor int
		 ,@Player2ScoreAgn int
		 ,@Player3 varchar(55)
		 ,@Player3ScoreFor int
		 ,@Player3ScoreAgn int
		 ,@Player4 varchar(55)
		 ,@Player4ScoreFor int
		 ,@Player4ScoreAgn int

open 	cMatches
fetch cMatches into @ID
while @@fetch_status=0
	begin
	
	select
		  @Player1 = replace(case when (Case when HomeTeamID=@TeamID then HomePlayer1 else AwayPlayer1 end) = 'Not Specified' 
						 then 'Not Specified1' 
						 else Case when HomeTeamID=@TeamID then HomePlayer1 else AwayPlayer1 end 
					end,'''','`')
		 ,@Player1ScoreFor = case when HomeTeamID=@TeamID then HomePlayer1Score else AwayPlayer1Score end 
		 ,@Player1ScoreAgn = case when HomeTeamID=@TeamID then AwayPlayer1Score else HomePlayer1Score end 
		 ,@Player2 = replace(case when (Case when HomeTeamID=@TeamID then HomePlayer2 else AwayPlayer2 end) = 'Not Specified' 
						 then 'Not Specified2' 
						 else Case when HomeTeamID=@TeamID then HomePlayer2 else AwayPlayer2 end 
					end,'''','`')
		 ,@Player2ScoreFor = case when HomeTeamID=@TeamID then HomePlayer2Score else AwayPlayer2Score end 
		 ,@Player2ScoreAgn = case when HomeTeamID=@TeamID then AwayPlayer2Score else HomePlayer2Score end 
		 ,@Player3 = replace(case when (Case when HomeTeamID=@TeamID then HomePlayer3 else AwayPlayer3 end) = 'Not Specified' 
						 then 'Not Specified3' 
						 else Case when HomeTeamID=@TeamID then HomePlayer3 else AwayPlayer3 end 
					end,'''','`')
		 ,@Player3ScoreFor = case when HomeTeamID=@TeamID then HomePlayer3Score else AwayPlayer3Score end 
		 ,@Player3ScoreAgn = case when HomeTeamID=@TeamID then AwayPlayer3Score else HomePlayer3Score end 
		 ,@Player4 = replace(case when (Case when HomeTeamID=@TeamID then HomePlayer4 else AwayPlayer4 end) = 'Not Specified' 
						 then 'Not Specified4' 
						 else Case when HomeTeamID=@TeamID then HomePlayer4 else AwayPlayer4 end 
					end,'''','`')
		 ,@Player4ScoreFor = case when HomeTeamID=@TeamID then HomePlayer4Score else AwayPlayer4Score end 
		 ,@Player4ScoreAgn = case when HomeTeamID=@TeamID then AwayPlayer4Score else HomePlayer4Score end 
	
		from MatchResultsDetails where ID=@ID

	set @SQL =
	'update #teamresults set 
			 [' + @Player1 + ' F] = ' + convert(varchar,@Player1ScoreFor) + '
		    ,[' + @Player1 + ' A] = ' + convert(varchar,@Player1ScoreAgn) + '
			,[' + @Player2 + ' F] = ' + convert(varchar,@Player2ScoreFor) + '
		    ,[' + @Player2 + ' A] = ' + convert(varchar,@Player2ScoreAgn) + '
			,[' + @Player3 + ' F] = ' + convert(varchar,@Player3ScoreFor) + '
		    ,[' + @Player3 + ' A] = ' + convert(varchar,@Player3ScoreAgn)
	if @Player4 is not null	    
		set @SQL=@SQL + '
			,[' + @Player4 + ' F] = ' + convert(varchar,@Player4ScoreFor) + '
		    ,[' + @Player4 + ' A] = ' + convert(varchar,@Player4ScoreAgn)
		
	set @SQL=@SQL + '
		where ID = ' + convert(varchar,@ID)   
	exec (@SQL)
	fetch cMatches into @ID
	end
close cMatches
deallocate cMatches	

--Points analysis
select Played= count(Matchdate)
      ,Won= sum(case when Result='Win' then 1 else 0 end)
      ,Drawn=sum(case when Result='Draw' then 1 else 0 end)
      ,Lost=sum(case when Result='Lose' then 1 else 0 end)
	  ,Points=sum([For])
	from #TeamResults

--Get player analyses
insert #TeamResults (ID) values (null)
exec (@total1SQL)
exec (@total2SQL)
exec (@total3SQL)
exec (@total4SQL)
exec (@total5SQL)

--print @selectSQL
exec (@selectSQL) 

--Raw data for use by program
exec (@dataSQL)

drop table #TeamResults

GO

/****** Object:  StoredProcedure [dbo].[UpdateCompetition]    Script Date: 04/30/2014 11:36:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[UpdateCompetition]
	(@CompetitionID int
	,@Name varchar(50)
	)
as		

set nocount on

	    update Competitions
			set Name = @Name
			where ID = @CompetitionID


GO

/****** Object:  StoredProcedure [dbo].[DeleteCompetition]    Script Date: 04/30/2014 11:36:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[DeleteCompetition]
	(@CompetitionID int
	)
as		

set nocount on

declare @SQL varchar(2000)
	   ,@table varchar(250)

select @table = 'Competition' + convert(varchar,@CompetitionID)
	from competitions where ID=@CompetitionID
	
if @table is null
	raiserror ('There is no competition with ID %i',15,0,@CompetitionID)
else
	begin	

	begin tran
	
	set @SQL = '
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''' + @table + '''))
		drop table ' + @table 

	exec (@SQL)
	
	delete Competitions
		where ID=@CompetitionID
	
	commit tran

	end

GO

/****** Object:  StoredProcedure [dbo].[PromoteCompetitionEntry]    Script Date: 04/30/2014 11:36:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[PromoteCompetitionEntry]
	(@CompetitionID int
	,@EntryID int
	,@RoundNo int
	)

as

set nocount on
	
declare @table varchar(250)
select @table = 'Competition' + convert(varchar,@CompetitionID)

--determine next Entrant ID
declare @nextID int
set @nextID=floor((@EntryID / power(2,@RoundNo))/2)*power(2,@RoundNo+1)
-- @nextID
declare @SQL varchar(4000)
set @SQL= '
set xact_abort on

begin tran

if (select count(*) 
		from ' + @table + ' 
		where ID = ' + convert(varchar,@nextID) + '
		  and RoundNo = '+ convert(varchar,@RoundNo+1) + ') > 0
	raiserror (''Cannot promote an entry that has already has a winner.'',15,0)
else
	begin	 
	set identity_insert ' + @table + ' on
	insert ' + @table + '
		(ID,DrawID,RoundNo,EntrantID,Entrant2ID)
		select '+ convert(varchar,@nextID) + ',DrawID,RoundNo+1,EntrantID,Entrant2ID
			from ' + @table + ' 
			where ID = ' + convert(varchar,@EntryID) + '
			  and RoundNo = '+ convert(varchar,@RoundNo) + '
	set identity_insert ' + @table + ' off	
	end

commit tran'
exec(@SQL)


GO

/****** Object:  StoredProcedure [dbo].[MakeCompetitionDraw]    Script Date: 04/30/2014 11:36:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[MakeCompetitionDraw]
	(@CompetitionID int
	)

as

set nocount on
	
declare @table varchar(250)
select @table = 'Competition' + convert(varchar,@CompetitionID)


declare @SQL varchar(4000)
set @SQL= '
set xact_abort on

begin tran

delete ' + @table + ' where EntrantID is null or RoundNo > 0

declare MakeCompetitionDrawCursor cursor fast_forward for
	select ID from ' + @table + '
declare @ID int
       ,@Norecs int
select @Norecs=COUNT(*) from ' + @table + '       
open MakeCompetitionDrawCursor
fetch MakeCompetitionDrawCursor into @ID
while @@FETCH_STATUS=0
	begin
	update ' + @table + ' set DrawID= convert(int,RAND()*100000000)*10 where ID=@ID
	fetch MakeCompetitionDrawCursor into @ID
	end
close MakeCompetitionDrawCursor
deallocate MakeCompetitionDrawCursor

declare @RequiredRecs int
       ,@DrawID int
select @Norecs=COUNT(*) from ' + @table + '

set @RequiredRecs=1
while @RequiredRecs<@Norecs
	set @RequiredRecs=@RequiredRecs*2

declare OrderCompetitionDrawCursor cursor fast_forward for
	select DrawID from ' + @table + ' order BY DrawID desc
open OrderCompetitionDrawCursor
fetch OrderCompetitionDrawCursor into @DrawID
while @RequiredRecs> (select COUNT(*) from ' + @table + ')
	begin
	insert ' + @table + ' 
		select @DrawID+5,0,NULL,NULL
	fetch OrderCompetitionDrawCursor into @DrawID
	end
close OrderCompetitionDrawCursor
deallocate OrderCompetitionDrawCursor		

select DrawID,RoundNo,EntrantID,Entrant2ID into #tempComp from ' + @table + '
truncate table ' + @table + '
insert ' + @table + '
	select * from #tempComp order by DrawID
drop table #tempComp	

set identity_insert ' + @table + ' on
insert ' + @table + '
	(ID,DrawID,RoundNo,EntrantID,Entrant2ID)
	select winner.ID,winner.DrawID,winner.RoundNo+1,winner.EntrantID,winner.Entrant2ID
		from ' + @table + ' loser
		JOIN ' + @table + ' winner
		  on loser.drawid=winner.DrawID+5 and loser.RoundNo=winner.RoundNo
		left join ' + @table + ' next
			on winner.ID=next.ID and winner.DrawID=next.DrawID and winner.RoundNo+1=next.RoundNo 
		where loser.EntrantID is null
		  and next.ID is null
		  
set identity_insert ' + @table + ' off	

update Competitions
	set NoRounds = (select dbo.integerRoot((select count(*) from ' + @table + ' where RoundNo=0),2))
	where ID = ' + convert(varchar,@CompetitionID) + '

commit tran'

exec(@SQL)


GO

/****** Object:  StoredProcedure [dbo].[NewCompetition]    Script Date: 04/30/2014 11:36:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[NewCompetition]
	(@Name varchar(50)
	,@LeagueID int
	,@CompType int    --1 = Individual, 2 = Pair, 3 = Team
	,@Remove bit = 0 --set to 1 to delete from Competitions table
	)
as		

set nocount on
set xact_abort on 

declare @CompetitionID int
select @CompetitionID=ID from Competitions where Name=@Name

if @remove = 0 and @CompetitionID is not null
	raiserror ('This competition (%s) already exists',15,0,@name)
else
    begin
    declare @SQL varchar(1000)
    begin tran
    
    if @Remove = 1
		if @CompetitionID is not null
		begin
		set @SQL=
			'if exists(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(''Competition' + convert(varchar,@CompetitionID) + ''')) drop table Competition' + convert(varchar,@CompetitionID)
		exec (@SQL)
		end
		delete Competitions  where Name=@Name
    
    insert Competitions 
		select @Name,@LeagueID,@CompType,null
	
    set @CompetitionID=SCOPE_IDENTITY()
    set @SQL=
		'if exists(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(''Competition' + convert(varchar,@CompetitionID) + ''')) drop table Competition' + convert(varchar,@CompetitionID)
	exec (@SQL)
	
	set @SQL = '
	    create table Competition' + convert(varchar,@CompetitionID) + '
			(ID int identity (0,1)
			,DrawID int
			,RoundNo int
			,EntrantID int
			,Entrant2ID int
			)'
	exec (@SQL)
	commit tran
	end

GO

/****** Object:  StoredProcedure [dbo].[CompetitionDetails]    Script Date: 04/30/2014 11:36:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[CompetitionDetails]
	(@ID as integer
	)
as

set nocount on

select * From Competitions where ID = @ID

GO

/****** Object:  StoredProcedure [dbo].[BreaksReport]    Script Date: 04/30/2014 11:36:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[BreaksReport]
	(@LeagueID int
	)
as	

set nocount on

select	 PlayerID,Name= Forename + case when Initials = '' then ' ' else ' ' + Initials + '. ' end + Surname
		,PlayerDetails.LeagueID, Leagues.[League Name]
		,Handicap = 
		 case when PlayerID=HomePlayer1ID then HomeHandicap1
		      when PlayerID=HomePlayer2ID then HomeHandicap2
		      when PlayerID=HomePlayer3ID then HomeHandicap3
		      when PlayerID=HomePlayer4ID then HomeHandicap4
		      when PlayerID=AwayPlayer1ID then AwayHandicap1
		      when PlayerID=AwayPlayer2ID then AwayHandicap2
		      when PlayerID=AwayPlayer3ID then AwayHandicap3
		      when PlayerID=AwayPlayer4ID then AwayHandicap4
		      --else matchresultid
		 end     
		,[Break], Category=BreaksCategories.ID
		--,*
	into #tempBreaks	
	from Breaks
         join PlayerDetails on PlayerDetails.ID=PlayerID
         join MatchResults on MatchResults.ID=MatchResultID
         join Leagues on Leagues.ID = LeagueID
         join BreaksCategories on BreaksCategories.[LeagueID]=PlayerDetails.LeagueID and Handicap between LowHandicap and HighHandicap
         
    where PlayerDetails.LeagueID=@LeagueID

select *, [Type]='Std'	into #tempBreaks2
	from #tempBreaks    

insert #tempBreaks2
	select 0,'Highest break (' + tb.Name + ')',tb.LeagueID,tb.[League Name],tb.Handicap,tb.[Break],tb.Category 
	      ,[Type]='Top'
		from #tempBreaks tb
		join (select [Break]=MAX([Break]),Category
				from #tempBreaks
				group by Category) MB
		  on tb.[Break] = MB.[Break]		
		 and tb.Category=MB.Category 

create table #BreaksReport
	(ID int identity (1,1)
	)
declare CategoriesCursor cursor fast_forward for
	select ID, Category=case when LowHandicap < 0  then '-' else '+' end + convert(varchar,abs(LowHandicap)) + ' to ' +
                        case when HighHandicap < 0 then '-' else '+' end + convert(varchar,abs(HighHandicap))
	 from BreaksCategories where LeagueID=@LeagueID 

declare @CategoryID int, @Category	varchar(50)
declare @SQL varchar (2000)
declare @selectSQL varchar(2000)
set @selectSQL='select '

open CategoriesCursor
fetch CategoriesCursor into @CategoryID,@Category
while @@FETCH_STATUS=0
	begin
	set @SQL = 
		'alter table #BreaksReport
			add [Player ' + @Category +  '] varchar(120), [Breaks ' + @Category + '] varchar(2000)'
	exec (@SQL)	
	
	set @selectSQL = @selectSQL + 
		'[' + @Category + '] = [Player ' + @Category +  '], Breaks = [Breaks ' + @Category + '],' 

	declare BreaksCursor cursor fast_forward for
	select PlayerID, Name, [Break]
		from #tempBreaks2
		where Category=@CategoryID
		order by Category,[Type] Desc,Name,playerid

	declare @prevPlayerID int
		   ,@prevName varchar(120)
	       ,@PlayerID int
		   ,@Name varchar(120)
		   ,@Break int
	       ,@Breaks varchar(2000)
	       ,@RecID int
       
	open BreaksCursor
	select @prevPlayerID=-1,@prevName=''

	fetch BreaksCursor into @PlayerID,@name,@Break
	set @RecID=1
	while @@fetch_status=0
		begin
		if @PlayerID <> @prevPlayerID
			begin
			if @prevPlayerID <> -1
				begin
				if (select ID from #BreaksReport where ID=@RecID) is not null
					set @SQL = 
						'update #BreaksReport 
							set [Player ' +  + @Category +  ']=''' + @prevName + ''' 
							   ,[Breaks ' + @Category + ']=''' + left(@Breaks,len(@Breaks)-1) + '''
							where ID=' + CONVERT(varchar,@RecID)
				else 
					set @SQL = 
						'insert #BreaksReport
							([Player ' +  + @Category +  ']
			                ,[Breaks ' + @Category + ']) 
				         VALUES
							(''' + @prevName + ''',''' + left(@Breaks,len(@Breaks)-1) + ''')'  

				exec (@SQL)
				set @RecID = @RecID + 1
				end
			select @prevPlayerID=@PlayerID,@prevName=@Name, @Breaks=convert(varchar,@Break)+', '
			end
		else
			select @Breaks = @Breaks+convert(varchar,@Break)+', '
	
		fetch BreaksCursor into @PlayerID,@name,@Break
		end

		if (select ID from #BreaksReport where ID=@RecID) is not null
			set @SQL = 
				'update #BreaksReport 
					set [Player ' +  + @Category +  ']=''' + @prevName + ''' 
					   ,[Breaks ' + @Category + ']=''' + left(@Breaks,len(@Breaks)-1) + '''
					where ID=' + CONVERT(varchar,@RecID)
		else 
			set @SQL = 
				'insert #BreaksReport
					([Player ' +  + @Category +  ']
		            ,[Breaks ' + @Category + ']) 
		         VALUES
					(''' + @prevName + ''',''' + left(@Breaks,len(@Breaks)-1) + ''')'  

		exec (@SQL)

	close BreaksCursor
	deallocate BreaksCursor

	fetch CategoriesCursor into @CategoryID,@Category

	end

close CategoriesCursor
deallocate CategoriesCursor

set @selectSQL = left(@selectSQL,len(@selectSQL)-1) + '
	from #BreaksReport'
print(@selectSQL)	
exec(@selectSQL)	

drop table #tempBreaks	
drop table #tempBreaks2
drop table #BreaksReport


GO

/****** Object:  StoredProcedure [dbo].[insertMatchBreak]    Script Date: 04/30/2014 11:36:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[insertMatchBreak]
	(@MatchResultID int
	,@PlayerID int
	,@Break int
	,@UserID varchar(255) = ''
	)
as

set nocount on

insert Breaks
	select @MatchResultID,@PlayerID,@Break 	
	
insert ActivityLog values
	(getdate(),'insert Match Break',SCOPE_IDENTITY(),@UserID)  


GO

/****** Object:  StoredProcedure [dbo].[lastSixMatchesAllLeagues]    Script Date: 04/30/2014 11:36:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[lastSixMatchesAllLeagues]

as

set nocount on

declare @LeagueID int
set @LeagueID=1
while @LeagueID < 4
	begin
	exec lastSixMatches @LeagueID
	set @LeagueID=@LeagueID+1
	end

GO

/****** Object:  StoredProcedure [dbo].[lastSixMatches]    Script Date: 04/30/2014 11:36:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[lastSixMatches]
	(@LeagueID int
	)
as

set nocount on

select R.ID
      ,MatchDate
	  ,HomeTeamID=H.ID, [Home]=HC.[Club Name]+' '+H.Team
	  ,H_Pts= case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
	          case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
	          case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
	          case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end
	  ,A_Pts= case when AwayPlayer1Score > HomePlayer1Score then 1 else 0 end +
	          case when AwayPlayer2Score > HomePlayer2Score then 1 else 0 end +
	          case when AwayPlayer3Score > HomePlayer3Score then 1 else 0 end +
	          case when AwayPlayer4Score > HomePlayer4Score then 1 else 0 end
      ,AwayTeamID=A.ID ,[Away]=AC.[Club Name]+' '+A.Team
	  ,FixtureDate
	  
into #temp
	
	from MatchResultsDetails R
	join Teams H on H.ID=HomeTeamID
		join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
		join Clubs AC on AC.ID = A.ClubID
	join Sections s on s.ID=h.SectionID
	join Leagues l on l.ID = s.LeagueID	
	cross apply (
					select D.FixtureDate
						from FixtureGrids F
						cross apply (select FixtureNo, SectionID from Teams where ID=R.HomeTeamID) H
						cross apply	(select FixtureNo from Teams where ID=R.AwayTeamID) A
						cross apply (Select FixtureDate from FixtureDates 
						                                where SectionSize=F.SectionSize
						                                  and WeekNo = F.WeekNo
						                                  and LeagueID = l.ID) D
						
						where F.SectionID=H.SectionID
						  and ((h1=H.FixtureNo and a1=A.FixtureNo)
					 	    or (h2=H.FixtureNo and a2=A.FixtureNo)
						    or (h3=H.FixtureNo and a3=A.FixtureNo)
						    or (h4=H.FixtureNo and a4=A.FixtureNo)
						    or (h5=H.FixtureNo and a5=A.FixtureNo)
						    or (h6=H.FixtureNo and a6=A.FixtureNo)
						    or (h7=H.FixtureNo and a7=A.FixtureNo)
						    or (h8=H.FixtureNo and a8=A.FixtureNo)
						       )
			  ) FD			       

	where (l.ID=@LeagueID)
	
	order by R.MatchDate, S.ID, HC.[Club Name]+' '+H.Team
--select * from #temp

select ID, Matchdate, TeamID=HomeTeamID, Team=Home, Points=H_Pts 
	into  #temp2
	from #temp
insert into #temp2
	select ID, Matchdate, TeamID=AwayTeamID, Team=Away, Points=A_Pts 
	from #temp

--select * from #temp2
--		order by TeamID, MatchDate Desc

create table #temp3
	(teamID int
	,Team varchar(50)
	,Points int
	)
declare c cursor fast_forward for
	select * from #temp2
		order by TeamID, MatchDate Desc
declare @prevID int
       ,@prevTeam varchar(50)
       ,@teamID int
	   ,@Team varchar(50)
	   ,@Points int
	   ,@accumPoints int
	   ,@counter int
	   ,@mDate date

select @prevID=-1
	  ,@accumPoints=0
	  ,@counter=0

open c
fetch c into @teamID, @mDate, @teamID, @Team, @Points
while @@fetch_status = 0
	begin
	if @teamID <> @previd
		begin
		if @previd>-1
			insert #temp3
				select @prevID, @prevTeam, @accumPoints
		select @prevID=@teamID
		      ,@prevTeam=@Team
			  ,@accumPoints=0
			  ,@counter=0
		end
	
	if @counter < 6 
		select @accumPoints = @accumPoints + @Points
		      ,@counter = @counter + 1		

	fetch c into @teamID, @mDate, @teamID, @Team, @Points
	end

insert #temp3
	select @prevID, @prevTeam, @accumPoints

declare @LeagueName varchar(50)
select @LeagueName= [League Name] 
	from Leagues
	where ID=@LeagueID

select League=@LeagueName, Team, Points from #temp3 order by Team

close c
deallocate c

drop table #temp
DROP TABLE #TEMP2
drop table #temp3


GO



