USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[LookForTooManyHomeFixtures]    Script Date: 12/12/2014 17:46:00 ******/
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
