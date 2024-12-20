USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[MergeLeague]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



alter procedure [dbo].[MergeLeague]
	(@LeagueID int           --if = -1 insert new record
	,@LeagueName varchar(50) --if empty delete record with this ID
	,@MaxHandicap int
	,@MinHandicap int
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
			,MaxHandicap		= @MaxHandicap
			,MinHandicap		= @MinHandicap

					
    WHEN NOT MATCHED AND @LeagueName <> '' AND @LeagueID=-1 THEN    
		INSERT ( [League Name]
				,MaxHandicap
				,MinHandicap
				)
			values(	 @LeagueName
					,@MaxHandicap
					,@MinHandicap
			      )
		
		OUTPUT $action;
	
--resequence the table and it's IDs
select * into #tmpLeagues from Leagues
truncate table Leagues
insert Leagues
	select [League Name], MaxHandicap, MinHandicap 
		from #tmpLeagues
		order by ID
drop table #tmpLeagues	

commit tran

GO
	
--exec MergeLeague
