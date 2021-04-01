use HBSA_20141116
go
 
--Change tables
--EXEC sys.sp_rename 
--    @objname = 'dbo.FixtureDates.LeagueID', 
--    @newname = 'SectionID', 
--    @objtype = 'COLUMN'
--EXEC sys.sp_rename 
--    @objname = 'dbo.FixtureDatesCurfew.LeagueID', 
--    @newname = 'SectionID', 
--    @objtype = 'COLUMN'


--Repopulate tables
--begin tran
--select S.ID,SectionSize,WeekNo,FixtureDate 
--	into #tmp
--	from HBSA.dbo.FixtureDates F
--	join Sections S on S.LeagueID=F.LeagueID
--	order by S.ID, WeekNo
--truncate table FixtureDates
--insert FixtureDates select * from #tmp
--commit tran
--select * from FixtureDates
--drop table #tmp

--begin tran
--select S.ID,StartDate,EndDate 
--	into #tmp
--	from HBSA.dbo.FixtureDatesCurfew F
--	join Sections S on S.LeagueID=F.LeagueID
--	order by S.ID, StartDate
--truncate table FixtureDatesCurfew
--insert FixtureDatesCurfew select * from #tmp
--commit tran
--select * from FixtureDatesCurfew
--drop table #tmp


EXEC sp_depends @objname = N'HBSA_20141116.dbo.FixtureGrids'
EXEC sp_depends @objname = N'HBSA_20141116.dbo.FixtureDatesCurfew'
