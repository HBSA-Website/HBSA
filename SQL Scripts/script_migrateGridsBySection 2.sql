use HBSA
GO

/****** Object:  StoredProcedure [dbo].[GetFixtureDates_Initial]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[GetFixtureDates_Initial]
GO

/****** Object:  StoredProcedure [dbo].[MergeFixtureDates]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[MergeFixtureDates]
GO

/****** Object:  StoredProcedure [dbo].[GetFixtureDatesForSection]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[GetFixtureDatesForLeague]
GO

--/****** Object:  StoredProcedure [dbo].[DefaultNoOfFixtures]    Script Date: 11/12/2014 14:53:16 ******/
--DROP PROCEDURE [dbo].[DefaultNoOfFixtures]
--GO

/****** Object:  StoredProcedure [dbo].[MergeHomepages]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[MergeHomepages]
GO

/****** Object:  StoredProcedure [dbo].[GetFixtureGrid]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[GetFixtureGrid]
GO

/****** Object:  StoredProcedure [dbo].[GetFixtureMatrix]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[GetFixtureMatrix]
GO

/****** Object:  StoredProcedure [dbo].[FixtureMatrix]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[FixtureMatrix]
GO

/****** Object:  StoredProcedure [dbo].[MissingResults]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[MissingResults]
GO

/****** Object:  StoredProcedure [dbo].[checkForResultsCard]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[checkForResultsCard]
GO

/****** Object:  StoredProcedure [dbo].[EndOfSeasonPoints]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[EndOfSeasonPoints]
GO

/****** Object:  StoredProcedure [dbo].[FixtureDatesBySection]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[FixtureDatesBySection]
GO

/****** Object:  StoredProcedure [dbo].[GetFixtureDates]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[GetFixtureDates]
GO

/****** Object:  StoredProcedure [dbo].[LastFixtureDate]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[LastFixtureDate]
GO

/****** Object:  StoredProcedure [dbo].[TeamResultsSheet]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[TeamResultsSheet]
GO

/****** Object:  StoredProcedure [dbo].[listMatches]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[listMatches]
GO

/****** Object:  StoredProcedure [dbo].[NewRegistrations]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[NewRegistrations]
GO

/****** Object:  StoredProcedure [dbo].[WeeklyResultsForExaminer]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[WeeklyResultsForExaminer]
GO

/****** Object:  StoredProcedure [dbo].[LookForTooManyHomeFixtures]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[LookForTooManyHomeFixtures]
GO

/****** Object:  StoredProcedure [dbo].[GetAllClubs]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[GetAllClubs]
GO

/****** Object:  StoredProcedure [dbo].[ClubRecord]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[ClubRecord]
GO

/****** Object:  StoredProcedure [dbo].[MergeClubs]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[MergeClubs]
GO

/****** Object:  StoredProcedure [dbo].[MergeClub]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[MergeClub]
GO

/****** Object:  StoredProcedure [dbo].[ClubDetails]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[ClubDetails]
GO

/****** Object:  StoredProcedure [dbo].[FixturesBySection]    Script Date: 11/12/2014 14:53:16 ******/
DROP PROCEDURE [dbo].[FixturesBySection]
GO

/****** Object:  StoredProcedure [dbo].[listResults]    Script Date: 12/12/2014 17:46:00 ******/
drop procedure [dbo].[listResults]
GO

/****** Object:  StoredProcedure [dbo].[FixturesBySection]    Script Date: 11/12/2014 14:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[FixturesBySection] 
	(@SectionID int 
	,@FixtureDate date = NULL
	,@TeamName varchar(100) = NULL
	,@FixturesOnly bit = 0
	)
as

set nocount on	

declare @SectionSize int
select @SectionSize=count(*) from Teams where SectionID=@SectionID

declare @t table (mDate date, Home int, Away int, ID int identity)

declare FixtureListCursor cursor for
	select M.*, FixtureDate
		from FixtureGrids M
		join FixtureDates D
		  on D.SectionID=@SectionID
		 and M.WeekNo=D.WeekNo 
	 where M.SectionID=@SectionID
	 order by WeekNo
	 
Declare @sid int, @ss int, @Weekno int
	   ,@h1 int,@a1 int
	   ,@h2 int,@a2 int
	   ,@h3 int,@a3 int
	   ,@h4 int,@a4 int
	   ,@h5 int,@a5 int
	   ,@h6 int,@a6 int
	   ,@h7 int,@a7 int
	   ,@h8 int,@a8 int, @mDate date
open FixtureListCursor
fetch FixtureListCursor into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @mDate
while @@FETCH_STATUS=0
	begin
	if not @h1 is null insert @t values (@mDate, @h1, @a1)
	if not @h2 is null insert @t values (@mDate, @h2, @a2)
	if not @h3 is null insert @t values (@mDate, @h3, @a3)
	if not @h4 is null insert @t values (@mDate, @h4, @a4)
	if not @h5 is null insert @t values (@mDate, @h5, @a5)
	if not @h6 is null insert @t values (@mDate, @h6, @a6)
	if not @h7 is null insert @t values (@mDate, @h7, @a7)
	if not @h8 is null insert @t values (@mDate, @h8, @a8)
	fetch FixtureListCursor into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @mDate
	end
close FixtureListCursor
deallocate FixtureListCursor

select [Match Date]=T.mDate, 
       [Home Team]=HC.[Club Name] + ' ' + H.Team, 
       [Away Team]=AC.[Club Name] + ' ' + A.Team
	into #tmp	
	from @t T
	join Teams H on H.FixtureNo=T.Home and H.SectionID=@SectionID
		join Clubs HC on HC.ID=H.ClubID
	join Teams A on A.FixtureNo=T.Away  and A.SectionID=@SectionID
		join Clubs AC on AC.ID=A.ClubID
	order by T.ID

declare FixturesCursor cursor for 
	select * 
		from #tmp 
		where [Match Date] = isnull(@FixtureDate,[Match Date])
		  and NOT ([Home Team]='Bye' and [Away Team]='Bye')
		  and ([Home Team] = @TeamName or [Away Team] = @TeamName or @TeamName is null)

declare @MatchDate varchar(11), @HomeTeam varchar(100), @AwayTeam varchar(100)
declare @fT table (MatchDate varchar(11), HomeTeam varchar(100), AwayTeam varchar(100))
declare @pDate date
open FixturesCursor
fetch FixturesCursor into @MatchDate, @HomeTeam, @AwayTeam
while @@FETCH_STATUS=0
	begin
	if ISNULL(@pDate,'1/1/80') = @MatchDate
		insert @fT values ('',@HomeTeam,@AwayTeam)
	else
		begin
		if @pDate is not null
			if @TeamName is null 
				insert @fT values ('','','')
		insert @fT values (@MatchDate,@HomeTeam,@AwayTeam)
		set @pDate=@MatchDate
		end
	fetch FixturesCursor into @MatchDate, @HomeTeam, @AwayTeam
	end
close FixturesCursor
deallocate FixturesCursor

select MatchDate,HomeTeam,AwayTeam from @fT where HomeTeam <> 'Bye' or AwayTeam<>'Bye' 
if @FixturesOnly=0
	begin
	select distinct MatchDate as MatchDate from @fT where MatchDate <> '' order by MatchDate
	select Distinct Team=HomeTeam from @fT 
		where MatchDate <> '' and HomeTeam <> '' and HomeTeam <> 'Bye'
		order by HomeTeam
	end


GO

/****** Object:  StoredProcedure [dbo].[ClubDetails]    Script Date: 11/12/2014 14:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[ClubDetails]
	(@ID as integer
	)
as

set nocount on

select Club, Contact
	 from (
			select   Seq=1
					 ,Club	= isnull([Club Name],'')
					,Contact= isnull(ContactName,'')
				from Clubs 
				where ID = @ID
			union
			select   Seq=2
					 ,Club	= isnull(Address1,'')
					,Contact= isnull(ContactEmail,'')
				from Clubs 
				where ID = @ID
			union
			select   Seq=3
					 ,Club	= isnull(Address2,'')
					,Contact= isnull(ContactTelNo,'')
				from Clubs 
				where ID = @ID
			union
			select    Seq=4
					 ,Club	= isnull(PostCode,'')
					,Contact= isnull(ContactMobNo,'')
				from Clubs 
				where ID = @ID
			union
			select    Seq=5
					 ,Club	= '<Strong>Available Tables:</strong>'
					,Contact= isnull(convert(varchar,MatchTables),'')
				from Clubs 
				where ID = @ID
				) ClubAndContact
	order by Seq




select Team,League=[League Name],Section=[Section Name]
	from Teams 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	WHERE ClubID=@ID 
	order by LeagueID,Team
	
select Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
      ,handicap
	  ,League=[League Name],Section=[Section Name]
      ,Tagged=case when Tagged=3 then 'Unseasoned'
	               when Tagged=2 then '2 Seasons to go'
				   when Tagged=1 then '1 Season to go'
				                 else ''
			  end 
	  ,[Over70(80 Vets)]=Over70,[Played this season]=Played, eMail=isnull(eMail,''), TelNo=isnull(TelNo,'')
	from Players 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=Players.LeagueID
	where ClubID=@ID
	order by Players.LeagueID,Team, Forename,surname


GO

/****** Object:  StoredProcedure [dbo].[MergeClub]    Script Date: 11/12/2014 14:53:16 ******/
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
	,@MatchTables int = 0
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
			,MatchTables    = @MatchTables
					
    WHEN NOT MATCHED AND @ClubName <> '' AND @ClubID=-1 THEN    
		INSERT ( [Club Name]
				,Address1
				,Address2
				,PostCode
				,ContactName
				,ContactEMail
				,ContactTelNo
				,ContactMobNo
				,MatchTables
				)
			values(	 @ClubName
					,@Address1
					,@Address2
					,@PostCode
					,@ContactName
					,@ContactEMail
					,@ContactTelNo
					,@ContactMobNo
					,@MatchTables)
		
		OUTPUT $action;
	

GO

/****** Object:  StoredProcedure [dbo].[MergeClubs]    Script Date: 11/12/2014 14:53:16 ******/
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
	,@MatchTables int
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
			,MatchTables    = @MatchTables
					
    WHEN NOT MATCHED THEN    
		INSERT ( [Club Name]
				,Address1
				,Address2
				,PostCode
				,ContactName
				,ContactEMail
				,ContactTelNo
				,ContactMobNo
				,MatchTables
				)
			values(	 @ClubName
					,@Address1
					,@Address2
					,@PostCode
					,@ContactName
					,@ContactEMail
					,@ContactTelNo
					,@ContactMobNo
					,@MatchTables)
					;


GO

/****** Object:  StoredProcedure [dbo].[ClubRecord]    Script Date: 11/12/2014 14:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[ClubRecord]
	(@ID as integer
	)
as

set nocount on

select ID
      ,[Club Name]=isnull([Club Name],'')
	  ,Address1=isnull(Address1,'')
	  ,Address2=isnull(Address2,'')
	  ,PostCode=isnull(PostCode,'')
	  ,ContactName=isnull(ContactName,'')
	  ,ContactEMail=isnull(ContactEMail,'')
	  ,ContactTelNo=isnull(ContactTelNo,'')
	  ,ContactMobNo=isnull(ContactMobNo,'')
	  ,Matchtables

	 from Clubs
	 
	 where ID=@ID

	 select Team,League=[League Name],Section=[Section Name]
	from Teams 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=LeagueID
	WHERE ClubID=@ID 
	order by LeagueID,Team
	
select Team,Player=Forename+case when Initials='' then ' ' else ' '+Initials+'. ' end + Surname
      ,handicap
	  ,League=[League Name],Section=[Section Name]
      ,Tagged=case when Tagged=3 then 'Unseasoned'
	               when Tagged=2 then '2 Seasons to go'
				   when Tagged=1 then '1 Season to go'
				                 else ''
			  end 
	  ,[Over70(80 Vets)]=Over70,[Played this season]=Played, eMail=isnull(eMail,''), TelNo=isnull(TelNo,'')
	from Players 
	join Sections on Sections.ID=SectionID
	join Leagues on Leagues.ID=Players.LeagueID
	where ClubID=@ID
	order by Players.LeagueID,Team, Forename,surname

Select * from Teams where ClubID=@ID
	
Select * from Players where ClubID=@ID

GO

/****** Object:  StoredProcedure [dbo].[GetAllClubs]    Script Date: 11/12/2014 14:53:16 ******/
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
	,AvailableTables=MatchTables

	from Clubs 
	where [Club Name] <> 'Bye'
	ORDER BY [Club Name]



GO

/****** Object:  StoredProcedure [dbo].[LookForTooManyHomeFixtures]    Script Date: 11/12/2014 14:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[LookForTooManyHomeFixtures] 
	(@LeagueID int 
	)
as

set nocount on	

declare
	 @SectionSize int

select @SectionSize=SectionSize from FixtureDates where SectionID in (select ID from Sections where LeagueID=@LeagueID)

declare @t table (mDate date, WeekNo int, Home int, Away int, SectionID int)

declare FixtureListCursor cursor for
	select M.*, FixtureDate
		from FixtureGrids M
		join FixtureDates D
		  on D.SectionID = M.SectionID
		 and M.WeekNo=D.WeekNo 
	 where M.SectionID in (select ID from Sections where leagueID=@LeagueID)
	 order by WeekNo, SectionID
	 
Declare @sid int, @ss int, @Weekno int
	   ,@h1 int,@a1 int
	   ,@h2 int,@a2 int
	   ,@h3 int,@a3 int
	   ,@h4 int,@a4 int
	   ,@h5 int,@a5 int
	   ,@h6 int,@a6 int
	   ,@h7 int,@a7 int
	   ,@h8 int,@a8 int, @mDate date
open FixtureListCursor
fetch FixtureListCursor into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @mDate
while @@FETCH_STATUS=0
	begin
	if not @h1 is null insert @t values (@mDate, @WeekNo, @h1, @a1, @sid)
	if not @h2 is null insert @t values (@mDate, @WeekNo, @h2, @a2, @sid)
	if not @h3 is null insert @t values (@mDate, @WeekNo, @h3, @a3, @sid)
	if not @h4 is null insert @t values (@mDate, @WeekNo, @h4, @a4, @sid)
	if not @h5 is null insert @t values (@mDate, @WeekNo, @h5, @a5, @sid)
	if not @h6 is null insert @t values (@mDate, @WeekNo, @h6, @a6, @sid)
	if not @h7 is null insert @t values (@mDate, @WeekNo, @h7, @a7, @sid)
	if not @h8 is null insert @t values (@mDate, @WeekNo, @h8, @a8, @sid)
	fetch FixtureListCursor into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @mDate
	end
close FixtureListCursor
deallocate FixtureListCursor

select    T.mDate, T.WeekNo
		, HC.ID 
		, NoHomeTeams=count(*)
		, NoTables=HC.MatchTables
	into #tmpDups
	from @t T
	join Teams H on H.FixtureNo=T.Home and H.SectionID=T.SectionID
	join Clubs HC on HC.ID=H.ClubID
	
	join Teams A on A.FixtureNo=T.Away and A.SectionID=T.SectionID
	join Clubs AC on AC.ID=A.ClubID

	Where HC.[Club Name] <> 'Bye'
	  and AC.[Club Name] <> 'Bye'
	  --and HC.ID <> AC.ID

	Group By 
		 T.mDate, T.WeekNo
		, HC.ID, HC.[Club Name], HC.MatchTables
	having count(*) > HC.MatchTables
	order by  mDate, HC.ID

select [Match Date]=convert(varchar(11),TD.mDate,113), [Week No]=TD.WeekNo, [Home Club]=C.[Club Name], [Home Team]=T.Team, [Available Tables]=NoTables

	,[Away Club]=xC.[Club Name], [Away Team]=xT.Team

	from #tmpDups TD
	join Clubs C on TD.ID=C.ID 
	join Teams T on T.ClubID=C.ID
	join Sections S on S.ID=T.SectionID
	join FixtureGrids FG
	  on FG.sectionID=S.ID and FG.WeekNo=TD.WeekNo

		and (isnull(h1,0)=FixtureNo or isnull(h2,0)=FixtureNo or isnull(h3,0)=FixtureNo or isnull(h4,0)=FixtureNo or
		     isnull(h5,0)=FixtureNo or isnull(h6,0)=FixtureNo or isnull(h7,0)=FixtureNo or isnull(h8,0)=FixtureNo)


	join @t at on at.SectionID=S.ID and at.Weekno=TD.WeekNo and at.Home=FixtureNo
	join teams xt on xt.SectionID=S.ID and  xt.FixtureNo=Away
	join clubs xc on xc.ID=xt.ClubID

	where LeagueID=@LeagueID
	  and xC.[Club Name] <> 'Bye'
	
	order by TD.mDate, C.[Club Name], T.Team


GO

/****** Object:  StoredProcedure [dbo].[WeeklyResultsForExaminer]    Script Date: 11/12/2014 14:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[WeeklyResultsForExaminer]
	(@LeagueID int
	,@WeekNo int = 0
	)
as		

set nocount on

If @WeekNo = 0
	select @WeekNo=max(weekNo)
		from FixtureDates 
		where SectionID in (Select ID from Sections where LeagueID=@LeagueID) 
		  and FixtureDate between dateadd(week,-1,getdate()) and getdate()

select Section=0,Result=convert(varchar(4000),'<strong> ' + [League Name] + ' League Scores:<br/>')
	into #tempresults
	from Leagues 
	where ID=@LeagueID

insert #tempresults
select distinct 
	Section=H.SectionID,
	result='<strong>' +
		HC.[Club Name]+' '+H.Team + ' ' + convert(varchar(50),
	              (case when HomePlayer1Score > AwayPlayer1Score then 1 else 0 end +
	               case when HomePlayer2Score > AwayPlayer2Score then 1 else 0 end +
	               case when HomePlayer3Score > AwayPlayer3Score then 1 else 0 end +
	               case when HomePlayer4Score > AwayPlayer4Score then 1 else 0 end)) + ' ' +
        AC.[Club Name]+' '+A.Team + ' ' + convert(varchar(50),
	              (case when AwayPlayer1Score > HomePlayer1Score then 1 else 0 end +
	               case when AwayPlayer2Score > HomePlayer2Score then 1 else 0 end +
	               case when AwayPlayer3Score > HomePlayer3Score then 1 else 0 end +
	               case when AwayPlayer4Score > HomePlayer4Score then 1 else 0 end)) + '</strong> ' +
	   
	   case when l.ID=3 then '' else '(' + replace(convert(varchar(50),[Section Name]),' ','') + ')' end +
	  
	   '<br/>' +
	  
	   HomePlayer1 + ' (' + convert(varchar(50),HomeHandicap1)+') ' + convert(varchar(50),HomePlayer1Score) + ' ' +
			AwayPlayer1 + ' (' + convert(varchar(50),AwayHandicap1)+') ' + convert(varchar(50),AwayPlayer1Score) + ', ' +
	   HomePlayer2 + ' (' + convert(varchar(50),HomeHandicap2)+') ' + convert(varchar(50),HomePlayer2Score) +  ' ' +
			AwayPlayer2 + ' (' + convert(varchar(50),AwayHandicap2)+') ' + convert(varchar(50),AwayPlayer2Score) + ', ' +
	   HomePlayer3 + ' (' + convert(varchar(50),HomeHandicap3)+') ' + convert(varchar(50),HomePlayer3Score) + ' ' +
			AwayPlayer3 + ' (' + convert(varchar(50),AwayHandicap3)+') ' + convert(varchar(50),AwayPlayer3Score) + 
	   case when leagueID <> 1 then '' else
		   HomePlayer4 + ', (' + convert(varchar(50),HomeHandicap4)+') ' + convert(varchar(50),HomePlayer4Score) +  ' ' +
		  		', ' + AwayPlayer4 + ' (' + convert(varchar(50),AwayHandicap4)+') ' + convert(varchar(50),AwayPlayer4Score) end +
		   case when dbo.BreaksInMatch(R.ID) = '' then '' else '<br/><strong>Breaks:</strong> ' + dbo.BreaksInMatch(R.ID) 
	   end
	  	 
	from MatchResultsDetails R
	join Teams H on H.ID=HomeTeamID
		join Clubs HC on HC.ID=H.ClubID 
	join Teams A on A.ID=AwayTeamID 
		join Clubs AC on AC.ID = A.ClubID
	join Sections s on s.ID=h.SectionID
	join Leagues l on l.ID = s.LeagueID	
	outer apply ( select D.FixtureDate, WeekNo
					from FixtureGrids F
					cross apply (select FixtureNo, SectionID from Teams where ID=(select HomeTeamID from MatchResultsDetails where ID=R.ID)) H
					cross apply	(select FixtureNo from Teams where ID=(select AwayTeamID from MatchResultsDetails where ID=R.ID)) A
					cross apply (Select FixtureDate from FixtureDates where SectionSize=F.SectionSize and WeekNo = F.WeekNo) D
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
				)FD

	where l.ID=@LeagueID
	  and WeekNo=@WeekNo 
	
	order by H.SectionID, result

select result from #tempresults order by Section, Result

drop table #tempresults



GO

/****** Object:  StoredProcedure [dbo].[NewRegistrations]    Script Date: 11/12/2014 14:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create procedure [dbo].[NewRegistrations]
	(@LeagueID int = 0
	,@SectionID int = 0
	,@ClubID int = 0
	,@Player varchar(100)=''
	)

as

set nocount on

declare @Players table (Player varchar(100))
declare @word1 varchar(50)
declare @word2 varchar(50)
declare @word3 varchar(50)
select @word1 = word from dbo.WordsInString(@Player) where ordinal=1
select @word2 = word from dbo.WordsInString(@Player) where ordinal=2
select @word3 = word from dbo.WordsInString(@Player) where ordinal=3
select @word1=isnull(@word1,''),@word2=isnull(@word2,''),@word3=isnull(@word3,'')

insert @Players exec SuggestPlayers @LeagueID,@SectionID,@ClubID,10000,@word1,@word2,@word3 

select 
	   Section= [League Name]+' '+[Section Name]
      ,Team=[Club Name]+' '+Teams.Team
      ,Player=Forename+case when isnull(Initials,'')='' then ' ' else ' ' + Initials+'. ' end + Surname
	  ,[Date Registered]=convert(varchar(11),dateRegistered,113)
      ,[Tag]=case when P.Tagged=3 then 'unseasoned'
	              when P.Tagged=2 then '2 seasons to go'
				  when P.Tagged=1 then '1 season to go'
				  else ''
              end
      ,[Over 70(80 Vets)]=P.Over70
      ,[Current Handicap]=p.Handicap
	from Players P
	outer apply (select SeasonStart=min(Fixturedate) from FixtureDates where SectionID in (select ID from Sections where LeagueID=P.LeagueID) and weekno=1) d

	join Sections on Sections.ID=P.SectionID
	join Leagues on Leagues.ID=Sections.LeagueID
	join Clubs on Clubs.ID=P.ClubID
	join Teams on teams.SectionID=P.SectionID and  Teams.ClubID=P.ClubID and Teams.Team=P.team
	join @Players sP on sP.Player=Forename + case when Initials = '' then ' ' else ' '+Initials+'. ' end + Surname

	where dateRegistered>SeasonStart
	  and (@LeagueID = 0 or Sections.LeagueID=@LeagueID)
	  and (@SectionID = 0 or P.SectionID=@SectionID)
	  and (@ClubID = 0 or Clubs.ID=@ClubID)
	
	order by p.SectionID, [Club Name], Player


GO

/****** Object:  StoredProcedure [dbo].[listMatches]    Script Date: 11/12/2014 14:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[TeamResultsSheet]    Script Date: 11/12/2014 14:53:16 ******/
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
	select	Player= Case when HomeTeamID=@TeamID then HomePlayer1 else AwayPlayer1 end
		from MatchResultsDetails 
		where HomeTeamID=@TeamID or awayteamid=@TeamID 
union
select	 Case when HomeTeamID=@TeamID then HomePlayer2 else AwayPlayer2 end
	from MatchResultsDetails 
	where HomeTeamID=@TeamID or awayteamid=@TeamID 
union
select	 Case when HomeTeamID=@TeamID then HomePlayer3 else AwayPlayer3 end
	from MatchResultsDetails 
	where HomeTeamID=@TeamID or awayteamid=@TeamID 
union
select	 Case when HomeTeamID=@TeamID then HomePlayer4 else AwayPlayer4 end
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
		  @Player1 = replace(case when HomeTeamID=@TeamID then HomePlayer1 else AwayPlayer1 end,'''','`')
		 ,@Player1ScoreFor = case when HomeTeamID=@TeamID then HomePlayer1Score else AwayPlayer1Score end 
		 ,@Player1ScoreAgn = case when HomeTeamID=@TeamID then AwayPlayer1Score else HomePlayer1Score end 
		 ,@Player2 = replace(case when HomeTeamID=@TeamID then HomePlayer2 else AwayPlayer2 end,'''','`')
		 ,@Player2ScoreFor = case when HomeTeamID=@TeamID then HomePlayer2Score else AwayPlayer2Score end 
		 ,@Player2ScoreAgn = case when HomeTeamID=@TeamID then AwayPlayer2Score else HomePlayer2Score end 
		 ,@Player3 = replace(case when HomeTeamID=@TeamID then HomePlayer3 else AwayPlayer3 end,'''','`')
		 ,@Player3ScoreFor = case when HomeTeamID=@TeamID then HomePlayer3Score else AwayPlayer3Score end 
		 ,@Player3ScoreAgn = case when HomeTeamID=@TeamID then AwayPlayer3Score else HomePlayer3Score end 
		 ,@Player4 = replace(case when HomeTeamID=@TeamID then HomePlayer4 else AwayPlayer4 end,'''','`')
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

/****** Object:  StoredProcedure [dbo].[LastFixtureDate]    Script Date: 11/12/2014 14:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




create procedure [dbo].[LastFixtureDate]
	(@LeagueID int
	)
as		

set nocount on

select WeekNo=max(WeekNo),FixtureDate=max(FixtureDate) 
	from FixtureDates 
	where SectionID in (Select ID from Sections where LeagueID=@LeagueID) 
	  and FixtureDate between dateadd(week,-1,getdate()) and getdate()


GO

/****** Object:  StoredProcedure [dbo].[GetFixtureDates]    Script Date: 11/12/2014 14:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[GetFixtureDates] 
	 @TeamID int
as

set nocount on

declare @StartYear int
       ,@SectionID int
select @SectionID=SectionID from Teams where ID=@TeamID
select top 1 
	@StartYear=datepart(Year,FixtureDate) 
	from FixtureDates 
	where SectionID=@SectionID
	order by FixtureDate

select G.WeekNo, [Date]=convert(varchar(11),FixtureDate,113)
      ,AwayTeamID=A.ID, AwayTeam=C.[Club Name] + ' ' + A.Team 
	  ,HalfWay=convert(bit,case when FixtureDate > (select Fixturedate from FixtureDates where SectionID=@SectionID and weekNo = SectionSize-1) then 1 else 0 end)
	from Teams T
	
	Join FixtureGrids G
	  on G.SectionID=T.SectionID
	  
	join FixtureDates D
		on D.WeekNo=G.WeekNo
	   and D.SectionID = @SectionID
	   
	join Teams A --AwayTeam
	  on A.SectionID=T.SectionID
	 and A.FixtureNo=case when h1=T.FixtureNo then a1   
	                      when h2=T.FixtureNo then a2
	                      when h3=T.FixtureNo then a3
	                      when h4=T.FixtureNo then a4
	                      when h5=T.FixtureNo then a5
	                      when h6=T.FixtureNo then a6
	                      when h7=T.FixtureNo then a7
	                      when h8=T.FixtureNo then a8
	                 end     
   	 join Clubs C
   	   on C.ID=A.ClubID 
   	   
	where T.ID=@TeamID
	  and   ((h1 = T.FixtureNo and a1 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h2 = T.FixtureNo and a2 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h3 = T.FixtureNo and a3 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h4 = T.FixtureNo and a4 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h5 = T.FixtureNo and a5 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h6 = T.FixtureNo and a6 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h7 = T.FixtureNo and a7 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) or
	         (h8 = T.FixtureNo and a8 not in (select FixtureNo from Teams join Clubs on ClubID=Clubs.ID where SectionID=T.SectionID and  [Club Name] = 'Bye' )) )	         

	order by WeekNo


GO

/****** Object:  StoredProcedure [dbo].[FixtureDatesBySection]    Script Date: 11/12/2014 14:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[FixtureDatesBySection] 
	(@SectionID int 
	)
as

set nocount on	

declare @SectionSize int
select @SectionSize=count(*) from Teams where SectionID=@SectionID

declare @Fixtures table (MatchDate date, HomeFixtureNo int, AwayFixtureNo int, SectionID int)

declare c cursor for
	select M.*, FixtureDate
		from FixtureGrids M
		join FixtureDates D
		  on D.SectionID=@SectionID
		 and M.WeekNo=D.WeekNo 
		 
	 where M.SectionID=@SectionID
	 order by WeekNo
	 
Declare @sid int, @ss int, @Weekno int
	   ,@h1 int,@a1 int
	   ,@h2 int,@a2 int
	   ,@h3 int,@a3 int
	   ,@h4 int,@a4 int
	   ,@h5 int,@a5 int
	   ,@h6 int,@a6 int
	   ,@h7 int,@a7 int
	   ,@h8 int,@a8 int, @MatchDate date
open c
fetch c into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @MatchDate
while @@FETCH_STATUS=0
	begin
	if not @h1 is null insert @Fixtures values (@MatchDate, @h1, @a1, @sid)
	if not @h2 is null insert @Fixtures values (@MatchDate, @h2, @a2, @sid)
	if not @h3 is null insert @Fixtures values (@MatchDate, @h3, @a3, @sid)
	if not @h4 is null insert @Fixtures values (@MatchDate, @h4, @a4, @sid)
	if not @h5 is null insert @Fixtures values (@MatchDate, @h5, @a5, @sid)
	if not @h6 is null insert @Fixtures values (@MatchDate, @h6, @a6, @sid)
	if not @h7 is null insert @Fixtures values (@MatchDate, @h7, @a7, @sid)
	if not @h8 is null insert @Fixtures values (@MatchDate, @h8, @a8, @sid)
	fetch c into @sid, @ss, @Weekno,@h1,@a1,@h2,@a2,@h3,@a3,@h4,@a4,@h5,@a5,@h6,@a6,@h7,@a7,@h8,@a8, @MatchDate
	end
close c
deallocate c

select * 
	from @Fixtures



GO

/****** Object:  StoredProcedure [dbo].[EndOfSeasonPoints]    Script Date: 11/12/2014 14:53:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

CREATE procedure [dbo].[EndOfSeasonPoints]
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
	  
into #temp2
	
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
						                                where SectionID=h.SectionID
						                                  and WeekNo = F.WeekNo
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

	where (l.ID=@LeagueID)
	
	order by R.MatchDate, S.ID, HC.[Club Name]+' '+H.Team
--select * from #temp2

select ID, Matchdate, TeamID=HomeTeamID, Team=Home, Points=H_Pts 
	into  #temp22
	from #temp2
insert into #temp22
	select ID, Matchdate, TeamID=AwayTeamID, Team=Away, Points=A_Pts 
	from #temp2

--select * from #temp22
--		order by TeamID, MatchDate Desc

create table #temp23
	(teamID int
	,Team varchar(50)
	,Points int
	)
declare c cursor fast_forward for
	select * from #temp22
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
			insert #temp23
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

insert #temp23
	select @prevID, @prevTeam, @accumPoints

declare @LeagueName varchar(50)
select @LeagueName= [League Name] 
	from Leagues
	where ID=@LeagueID

select League=@LeagueName, Team, Points from #temp23 order by Team

close c
deallocate c

drop table #temp2
DROP TABLE #temp22
drop table #temp23



GO

/****** Object:  StoredProcedure [dbo].[checkForResultsCard]    Script Date: 11/12/2014 14:53:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create Procedure [dbo].[checkForResultsCard]
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

/****** Object:  StoredProcedure [dbo].[MissingResults]    Script Date: 11/12/2014 14:53:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[MissingResults]

as

set nocount on

select [Fixture Date]=convert(varchar(11),D.FixtureDate,113)
	,Section=[League Name]+' ' + [Section Name]
	,[Home Team]=Clubs.[Club Name] + ' ' + homeTeam.team
	,[Away Team]=awayClub.[Club Name] + ' ' + awayTeam.Team

	from FixtureGrids G
	join FixtureDates D
	  on D.WeekNo=G.WeekNo
	 and D.SectionID=G.SectionID
	join Teams homeTeam
	  on homeTeam.sectionID=G.SectionID
	 and (homeTeam.FixtureNo=G.h1 or
	      homeTeam.FixtureNo=G.h2 or
	      homeTeam.FixtureNo=G.h3 or
	      homeTeam.FixtureNo=G.h4 or
	      homeTeam.FixtureNo=G.h5 or
	      homeTeam.FixtureNo=G.h6 or
	      homeTeam.FixtureNo=G.h7 or
	      homeTeam.FixtureNo=G.h8)

	left join MatchResultsDetails2 R
	  on R.FixtureDate=D.FixtureDate
	 and (R.HomeTeamID = homeTeam.ID)
	left join Teams awayTeam
		on awayTeam.SectionID=G.SectionID
	   and awayTeam.FixtureNo=case when homeTeam.FixtureNo=G.h1 then a1
		             when homeTeam.FixtureNo=G.h2 then a2
		             when homeTeam.FixtureNo=G.h3 then a3
		             when homeTeam.FixtureNo=G.h4 then a4
		             when homeTeam.FixtureNo=G.h5 then a5
		             when homeTeam.FixtureNo=G.h6 then a6
		             when homeTeam.FixtureNo=G.h7 then a7
		             when homeTeam.FixtureNo=G.h8 then a8
			    end

	join clubs on Clubs.ID=hometeam.ClubID
	join Sections on Sections.ID=G.SectionID
	join Leagues on Leagues.ID=Sections.LeagueID
	join Clubs awayClub on awayClub.ID=awayTeam.ClubID

	where homeTeam.ClubID<> (select ID from Clubs where [Club Name]='Bye')
	  and awayteam.ClubID<> (select ID from Clubs where [Club Name]='Bye')
	  and R.ID is null
	  and D.FixtureDate < dateadd(day,-1,getdate())

	order by D.FixtureDate,G.SectionID,Clubs.[Club Name]
 


GO

/****** Object:  StoredProcedure [dbo].[FixtureMatrix]    Script Date: 11/12/2014 14:53:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[FixtureMatrix] 
	 @SectionID int
as

set nocount on

declare @SectionSize int
select @SectionSize=count(*)/2 from Teams where SectionID=@SectionID
declare @SQL varchar(4000)
set @SQL='
select [Date]=convert(varchar(11),FixtureDate,113)'
declare @ix int
set @ix=0
while @ix < @SectionSize  
	begin
    set @ix=@ix+1  
	set @SQL=@SQL + '
      ,[' + CHAR(@ix+96) + '] = convert(varchar,h' + convert(varchar,@ix) + ')+'' v ''+convert(varchar,a' + convert(varchar,@ix) + ')'
    end  
set @SQL=@SQL + '      
from FixtureGrids M
join FixtureDates D
  on D.SectionID=' + convert(varchar,@SectionID) + '
 and M.WeekNo=D.WeekNo 
where M.SectionID=' + convert(varchar,@SectionID)
exec (@SQL)


GO

/****** Object:  StoredProcedure [dbo].[GetFixtureMatrix]    Script Date: 11/12/2014 14:53:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[GetFixtureMatrix]
	(@SectionID int
	)
as

set nocount on

	declare @SectionSize int
	       ,@NoOfFixtures int
	select @SectionSize=count(*) from Teams where SectionID=@SectionID
	select @NoOfFixtures = count(*) from FixtureDates  where SectionID=@SectionID
	select SectionID=@SectionID
	      ,SectionSize=@SectionSize
	      ,D.WeekNo
	      ,h1,a1
	      ,h2,a2
	      ,h3,a3
	      ,h4,a4
	      ,h5,a5
	      ,h6,a6
	      ,h7,a7
	      ,h8,a8
		from FixtureDates D
		join FixtureMatrices M on D.SectionID=@SectionID and (D.WeekNo=M.WeekNo or (D.WeekNo % ((@SectionSize-1)*2))=M.WeekNo)
		where M.SectionSize=@SectionSize
		order by D.WeekNo

GO

/****** Object:  StoredProcedure [dbo].[GetFixtureGrid]    Script Date: 11/12/2014 14:53:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[GetFixtureGrid]
	(@SectionID int
	)
as

set nocount on

--if the number of fixture dates differs from the fixture grid we must rebuild the grid
if (select count(*) from Fixturedates where sectionid=@SectionID) <> (select count(*) from FixtureGrids  where sectionid=@SectionID)
	delete FixtureGrids where SectionID=@SectionID

--if grid exists return it
if (select count(*)
	from FixtureGrids
	where SectionID=@SectionID) > 0
		select *
			from FixtureGrids
			where SectionID=@SectionID
			order by WeekNo
--if grid does not exist get one from base matrix
else
	exec GetFixtureMatrix @SectionID

GO

/****** Object:  StoredProcedure [dbo].[MergeHomepages]    Script Date: 11/12/2014 14:53:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create Procedure [dbo].[MergeHomepages]
	(@Pagename varchar(255)
	,@HitCounter int
	)
as

set nocount on

MERGE Homepages AS target
    USING (SELECT @Pagename) AS source (Pagename)
    
    ON (target.Pagename = source.Pagename)
    
    WHEN MATCHED AND @Pagename='' THEN
		DELETE
    
    WHEN MATCHED THEN 
        UPDATE SET
            HitCounter = @HitCounter
					
    WHEN NOT MATCHED AND @Pagename <> '' THEN    
		INSERT ( Pagename, HitCounter)
			values(	 @Pagename, @HitCounter);


GO

/****** Object:  StoredProcedure [dbo].[DefaultNoOfFixtures]    Script Date: 11/12/2014 14:53:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[DefaultNoOfFixtures]
	@SectionID int

as

set nocount on

select count(*)*2-2 
	from Teams 
	where sectionid=@SectionID


GO

create procedure [dbo].[GetFixtureDatesForLeague]
	(@LeagueID int
	)
as

select top 1 StartDate=convert(varchar(11),FixtureDate,113)
           , CurfewStart=convert(varchar(11),StartDate,113)
           , CurfewEnd=convert(varchar(11),Enddate,113)
	from FixtureDates
	left join FixtureDatesCurfew on FixtureDates.SectionID=FixtureDatesCurfew.SectionID
	where FixtureDates.SectionID in (Select ID from sections where LeagueID=@LeagueID)
	order by WeekNo
	
select distinct
	   WeekNo
     , FixtureDate=convert(varchar(11),FixtureDate,113)
	from FixtureDates
	where SectionID in (Select ID from sections where LeagueID=@LeagueID)
	order by WeekNo


GO
/****** Object:  StoredProcedure [dbo].[GetFixtureDatesForSection]    Script Date: 11/12/2014 14:53:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[GetFixtureDatesForSection]
	(@SectionID int
	)
as

select top 1 StartDate=convert(varchar(11),FixtureDate,113)
           , CurfewStart=convert(varchar(11),StartDate,113)
           , CurfewEnd=convert(varchar(11),Enddate,113)
	from FixtureDates
	left join FixtureDatesCurfew on FixtureDates.SectionID=FixtureDatesCurfew.SectionID
	where FixtureDates.SectionID=@SectionID
	order by WeekNo
	
select SectionID
     , SectionSize
     , WeekNo
     , FixtureDate=convert(varchar(11),FixtureDate,113)
	from FixtureDates
	where SectionID=@SectionID
	order by WeekNo

GO


/****** Object:  StoredProcedure [dbo].[GetFixtureDates_Initial]    Script Date: 11/12/2014 14:53:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[GetFixtureDates_Initial]
	(@SectionID int
	,@FirstDate date
	,@NoOfFixtures int
	)
as

declare @FixtureDate date
	   ,@WeekNo int
	   ,@CurfewStart date
       ,@CurfewEnd date
	   ,@SectionSize int
	
set @FixtureDate=@FirstDate

select @SectionSize=count(*) from Teams where SectionID=@SectionID

set @WeekNo = 1
select @CurfewStart= Startdate
      ,@CurfewEnd  = EndDate
	from FixtureDatesCurfew
	where SectionID=@SectionID

if @CurfewEnd < @CurfewStart
	set @CurfewEnd=dateadd(year,1,@CurfewEnd)

select top 0 * into #tempDates from FixtureDates
	
while @WeekNo <= @NoOfFixtures
	begin
	insert #tempDates 
		select @SectionID,@SectionSize,@WeekNo,@FixtureDate
	set @WeekNo=@WeekNo+1
	set @FixtureDate=dateadd(week,1,@FixtureDate)
	while @FixtureDate between @CurfewStart and @CurfewEnd
		set @FixtureDate=dateadd(week,1,@FixtureDate)
	end
select *
	from #tempDates
drop table #tempDates


GO


/****** Object:  StoredProcedure [dbo].[MergeFixtureDates]    Script Date: 11/12/2014 14:53:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[MergeFixtureDates]
	(@SectionID int           
	,@StartDate date
	,@CurfewStart date
	,@CurfewEnd date
	,@NoOfFixtures int
	)

as
set nocount on
set xact_abort on

if @StartDate > @CurfewStart
or @CurfewStart > @CurfewEnd
	raiserror('dates must be ascending',15,15)
else

	begin
	
	begin tran

	MERGE FixtureDatesCurfew AS target
	    USING (SELECT @SectionID) AS source (SectionID)
    
	    ON (target.SectionID = source.SectionID)
	    
	    WHEN MATCHED THEN 
		    UPDATE SET
			    StartDate		= @CurfewStart
	           ,Enddate			= @CurfewEnd 
					
	    WHEN NOT MATCHED THEN    
			INSERT ( SectionID, Startdate, Enddate
					)
				values(	 @SectionID, @CurfewStart, @CurfewEnd
				      )
		
		OUTPUT $action;
	
	--rebuild the FixtureDates table
	delete FixtureDates 
		where SectionID=@SectionID

	insert FixtureDates	
		exec GetFixtureDates_Initial @SectionID, @StartDate, @NoOfFixtures

	commit tran

	end
	

GO

/****** Object:  StoredProcedure [dbo].[listResults]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
						                                  and WeekNo = F.WeekNo
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