use HBSA
GO
-- Restore Deleted matches
set identity_insert MatchResults on
insert MatchResults
	(ID,MatchDate,HomeTeamID,AwayTeamID,HomePlayer1ID,HomePlayer1Score,HomeHandicap1,AwayPlayer1ID,AwayPlayer1Score,AwayHandicap1,HomePlayer2ID,HomePlayer2Score,HomeHandicap2,AwayPlayer2ID,AwayPlayer2Score,AwayHandicap2,HomePlayer3ID,HomePlayer3Score,HomeHandicap3,AwayPlayer3ID,AwayPlayer3Score,AwayHandicap3,HomePlayer4ID,HomePlayer4Score,HomeHandicap4,AwayPlayer4ID,AwayPlayer4Score,AwayHandicap4,DateTimeLodged,UserID)
	select * From MatchResults_Deleted where ID in (1,3,4,6)
set identity_insert MatchResults off
delete MatchResults_Deleted  where ID in (1,3,4,6)

-- new code

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'LastFixtureDateInMatrix')
	drop function dbo.LastFixtureDateInMatrix
GO

CREATE FUNCTION dbo.LastFixtureDateInMatrix 
	(@SectionID int
	)

RETURNS date

AS

BEGIN


return (select FixtureDate 
			from FixtureDates 
			where WeekNo = (select COUNT(*) 
								from FixtureGrids 
								where SectionID=@SectionID)
			  and SectionID=@SectionID)

END


GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'GridMatrixSize')
	drop function dbo.GridMatrixSize
GO

CREATE FUNCTION dbo.GridMatrixSize 
	(@SectionID int
	)

RETURNS integer

AS

BEGIN


return (select COUNT(*) from FixtureGrids where SectionID=@SectionID)

END


GO


/****** Object:  StoredProcedure [dbo].[insertMatchResult]    Script Date: 12/12/2014 17:46:00 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='insertMatchResult')
	drop procedure dbo.insertMatchResult
GO

create procedure dbo.insertMatchResult
	(@MatchDate date
	,@HomeTeamID int
	,@AwayTeamID int
	,@HomePlayer1 varchar(55)
	,@HomeHandicap1 int
	,@HomeScore1 int
	,@AwayPlayer1 varchar(55)
	,@AwayHandicap1 int
	,@AwayScore1 int
	,@HomePlayer2 varchar(55)
	,@HomeHandicap2 int
	,@HomeScore2 int
	,@AwayPlayer2 varchar(55)
	,@AwayHandicap2 int
	,@AwayScore2 int
	,@HomePlayer3 varchar(55)
	,@HomeHandicap3 int
	,@HomeScore3 int
	,@AwayPlayer3 varchar(55)
	,@AwayHandicap3 int
	,@AwayScore3 int
	,@HomePlayer4 varchar(55)
	,@HomeHandicap4 int
	,@HomeScore4 int
	,@AwayPlayer4 varchar(55)
	,@AwayHandicap4 int
	,@AwayScore4 int
	,@FixtureDate date
	,@UserID varchar(255)
	)
as

set nocount on
set xact_abort on

begin tran

--indicate players have played to fix them to their team
declare @Team char(1)

select @Team=Team from Teams where ID=@HomeTeamID
update Players set Played=1, Team=@Team where ID=@HomePlayer1 
update Players set Played=1, Team=@Team where ID=@HomePlayer2 
update Players set Played=1, Team=@Team where ID=@HomePlayer3
update Players set Played=1, Team=@Team where ID=@HomePlayer4

select @Team=Team from Teams where ID=@AwayTeamID
update Players set Played=1, Team=@Team where ID=@AwayPlayer1 
update Players set Played=1, Team=@Team where ID=@AwayPlayer2 
update Players set Played=1, Team=@Team where ID=@AwayPlayer3
update Players set Played=1, Team=@Team where ID=@AwayPlayer4


if exists(select ID from MatchResultsDetails2 where HomeTeamID=@HomeTeamID and AwayTeamID=@AwayTeamID and FixtureDate = @FixtureDate)
	exec deleteMatchResult @HomeTeamID,@AwayTeamID,@UserID 

declare @MatchResultID int
	
insert matchResults values 
	(@MatchDate 
	,@HomeTeamID
	,@AwayTeamID
	,@HomePlayer1
	,@HomeScore1
	,@HomeHandicap1
	,@AwayPlayer1
	,@AwayScore1
	,@AwayHandicap1
	,@HomePlayer2
	,@HomeScore2
	,@HomeHandicap2
	,@AwayPlayer2
	,@AwayScore2
	,@AwayHandicap2
	,@HomePlayer3
	,@HomeScore3
	,@HomeHandicap3
	,@AwayPlayer3
	,@AwayScore3
	,@AwayHandicap3
	,@HomePlayer4
	,@HomeScore4
	,@HomeHandicap4
	,@AwayPlayer4
	,@AwayScore4
	,@AwayHandicap4
	,dbo.UKdateTime(getUTCdate())
	,@UserID
	)

select @MatchResultID=scope_identity()

--convert userID to the resultuser login if it's numereic
if isnumeric(@userID) = 1 
	select @UserID=eMailAddress from resultsusers where id=@UserID

insert ActivityLog values
		(dbo.UKdateTime(getUTCdate()),'insert match result',@MatchResultID,convert(varchar,@Userid))

commit tran

select @MatchResultID

GO

If exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='listResults')
	drop procedure [dbo].[listResults]
GO

CREATE procedure [dbo].[listResults]
	(@SectionID int
	,@MatchDate date = NULL
	,@TeamID int = 0
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
	--join Leagues l on l.ID = s.LeagueID	
	cross apply (
					select D.FixtureDate
						from FixtureGrids F
						cross apply (select FixtureNo, SectionID from Teams where ID=R.HomeTeamID) H
						cross apply	(select FixtureNo from Teams where ID=R.AwayTeamID) A
						cross apply (Select FixtureDate from FixtureDates 
						                                where SectionSize=F.SectionSize
														  and WeekNo = F.WeekNo + case when MatchDate > dbo.LastFixtureDateInMatrix(SectionID) then  dbo.GridMatrixSize(SectionID) else 0 end
						                                  and SectionID = s.ID) D
						
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

	where (s.ID=@SectionID or @SectionID=0)
	  and (r.MatchDate=@MatchDate or @MatchDate is null)
	  and (@TeamID = 0 or (H.ID=@TeamID or A.ID=@TeamID))
	
	order by R.MatchDate, S.ID, HC.[Club Name]+' '+H.Team
--select * from #temp
select ID, [Match Date]=convert(varchar(11),Matchdate,113)
      ,[Home],[hFrames]=H_Pts,[aFrames]=A_Pts,Away
      ,FixtureDate=CONVERT(varchar(11),FixtureDate,113)
	from #temp order by convert(date,FixtureDate), Home

select distinct MatchDate into #tmpD from #temp order by MatchDate
select [Match Date] = CONVERT(varchar(11),Matchdate,113) from #tmpD

select Distinct TeamID=HomeTeamID,Team=[Home] from #temp 
union
select distinct AwayTeamID,[Away] from #temp
order by Team

GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'listMatches')
	drop procedure listMatches
GO

CREATE procedure [dbo].[listMatches]
	(@TeamID int
	)
as

set nocount on

declare @SectionID int
select @SectionID=SectionID from Teams where ID=@TeamID

select distinct
       R.ID
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
	  
into #temp1
	
	from MatchResultsDetails R
	join Teams H on H.ID=HomeTeamID
		join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
		join Clubs AC on AC.ID = A.ClubID
	join Sections s on s.ID=h.SectionID
	--join Leagues l on l.ID = s.LeagueID	
	cross apply (
					select D.FixtureDate
						from FixtureGrids F
						cross apply (select FixtureNo, SectionID from Teams where ID=R.HomeTeamID) H
						cross apply	(select FixtureNo from Teams where ID=R.AwayTeamID) A
						cross apply (Select FixtureDate from FixtureDates 
						                                where SectionSize=F.SectionSize
						                                  and WeekNo = F.WeekNo
						                                  and SectionID = @SectionID) D
						
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

	where (s.ID=@SectionID)
	  and ((H.ID=@TeamID or A.ID=@TeamID))
	
	--order by R.MatchDate, S.ID, HC.[Club Name]+' '+H.Team

select 
	   ID, [Match Date]=convert(varchar(11),Matchdate,113)
      ,[Home],[hFrames]=H_Pts,[aFrames]=A_Pts,Away
      ,FixtureDate=CONVERT(varchar(11),FixtureDate,113)
	from #temp1 
	order by convert(date,FixtureDate), Home


GO

if exists (select * from INFORMATION_SCHEMA.VIEWS where TABLE_NAME = 'MatchResultsDetails2')
	drop view dbo.MatchResultsDetails2
GO

CREATE view dbo.MatchResultsDetails2

as

SELECT *
	from MatchResults R
	outer apply (select HomePlayer1=Surname + ' ' + Forename + ' ' + Initials from Players where ID=HomePlayer1ID) h1	
	outer apply (select HomePlayer2=Surname + ' ' + Forename + ' ' + Initials from Players where ID=HomePlayer2ID) h2	
	outer apply (select HomePlayer3=Surname + ' ' + Forename + ' ' + Initials from Players where ID=HomePlayer3ID) h3	
	outer apply (select HomePlayer4=Surname + ' ' + Forename + ' ' + Initials from Players where ID=HomePlayer4ID) h4
	outer apply (select AwayPlayer1=Surname + ' ' + Forename + ' ' + Initials from Players where ID=AwayPlayer1ID) a1	
	outer apply (select AwayPlayer2=Surname + ' ' + Forename + ' ' + Initials from Players where ID=AwayPlayer2ID) a2	
	outer apply (select AwayPlayer3=Surname + ' ' + Forename + ' ' + Initials from Players where ID=AwayPlayer3ID) a3	
	outer apply (select AwayPlayer4=Surname + ' ' + Forename + ' ' + Initials from Players where ID=AwayPlayer4ID) a4
		cross apply (
					select D.FixtureDate
						from FixtureGrids F
						cross apply (select FixtureNo, SectionID from Teams where ID=R.HomeTeamID) H
						cross apply	(select FixtureNo from Teams where ID=R.AwayTeamID) A
						cross apply (Select FixtureDate from FixtureDates 
						                                where SectionID = H.SectionID
														  and WeekNo = F.WeekNo + case when MatchDate > dbo.LastFixtureDateInMatrix(SectionID) then  dbo.GridMatrixSize(SectionID) else 0 end
						                                  ) D
						
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

GO

print 'finished'