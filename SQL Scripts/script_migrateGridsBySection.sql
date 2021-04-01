USE [HBSA]
GO
EXEC sys.sp_rename 
    @objname = 'dbo.FixtureDates.LeagueID', 
    @newname = 'SectionID', 
    @objtype = 'COLUMN'
GO
EXEC sys.sp_rename 
    @objname = 'dbo.FixtureDatesCurfew.LeagueID', 
    @newname = 'SectionID', 
    @objtype = 'COLUMN'
GO

set xact_abort on
begin tran
select SectionID=S.ID, StartDate, EndDate
	into #tmpFixtureDatesCurfew
	from  FixtureDatesCurfew F
	join Sections S on S.LeagueID=F.SectionID
truncate table FixtureDatesCurfew
insert FixtureDatesCurfew
	select * from #tmpFixtureDatesCurfew
drop table #tmpFixtureDatesCurfew

select SectionID=S.ID, SectionSize,WeekNo,FixtureDate
	into #tmpFixtureDates
	from  FixtureDates F
	join Sections S on S.LeagueID=F.SectionID
truncate table FixtureDates
insert FixtureDates
	select * from #tmpFixtureDates
drop table #tmpFixtureDates

commit tran
GO

Alter table Clubs
	add MatchTables int
GO

begin tran

select ID, NoTables= max(NoTables)
	into #temp
	from
		(select Clubs.ID, NoTables=ceiling(convert(decimal,count(*))/2)
					from Clubs 
					join Teams on ClubID=Clubs.ID
					join Sections on Sections.ID=SectionID
					where [Club Name] <> 'Bye'
					group by LeagueID,Clubs.ID) x
					
	group by id

update Clubs
	set MatchTables=case when C.ID=9 then 3 else NoTables end
	from Clubs C
	join #temp T on T.ID=C.ID

update clubs
	set MatchTables=0
	where MatchTables is null

commit tran
/****** Object:  View [dbo].[MatchResultsDetails2]    Script Date: 11/12/2014 14:55:01 ******/
DROP VIEW [dbo].[MatchResultsDetails2]
GO

/****** Object:  View [dbo].[MatchResultsDetails2]    Script Date: 11/12/2014 14:55:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[MatchResultsDetails2]

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




GO


select * from FixturedatesCurfew