USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[MergeTeam]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'SequenceTeamsInSection')
	drop procedure SequenceTeamsInSection
GO

CREATE procedure SequenceTeamsInSection
	(@SectionID	int
	)
as

set nocount on

select rowNo=ROW_NUMBER() over (order by FixtureNo), * 
	into #temp from Teams 
	where sectionID=@SectionID

MERGE Teams AS target
    USING (SELECT ID,rowNo from #temp) AS source (ID,rowNo)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED THEN 
        UPDATE SET FixtureNo=source.rowNo
		;
drop table #temp

GO

exec SequenceTeamsInSection 9

select * from teams where sectionid=9 order by fixtureNo