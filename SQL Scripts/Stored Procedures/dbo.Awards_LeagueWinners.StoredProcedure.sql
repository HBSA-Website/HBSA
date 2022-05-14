USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_LeagueWinners')
	drop procedure dbo.Awards_LeagueWinners
GO

create procedure dbo.Awards_LeagueWinners

as

set nocount ON
set xact_abort on

begin tran

declare @AwardType int
select @AwardType=AwardType 
	from Awards_Types 
	where StoredProcedureName = object_name(@@procid)

declare @SectionID int

Declare @tmpWinners table
		  	(Posn int, TeamID int, SectionID int)
declare	@Posn int
	   ,@TeamID int
	   ,@Pts int
	   ,@Wins0 int

declare SectionsCursor cursor fast_forward for
	select ID from sections order by ID

open SectionsCursor
fetch SectionsCursor into @SectionID
while @@FETCH_STATUS = 0
	begin

	declare c cursor fast_forward for
		select top 2
		  Posn = ROW_NUMBER() over (order by sum(case when T.ID=M.HomeTeamID then HomePoints else AwayPoints end) desc
		                                    ,sum(case when T.ID=M.HomeTeamID then case when AwayPoints=0 then 1 else 0 end
		                                                                     else case when HomePoints=0 then 1 else 0 end
	                                         end) desc)
	     ,T.ID--, [Club Name] + ' ' + T.Team 
		 ,Points=sum(case when T.ID=M.HomeTeamID then HomePoints else AwayPoints end)
		 ,Wins0= sum(case when T.ID=M.HomeTeamID then case when AwayPoints=0 then 1 else 0 end
		                                         else case when HomePoints=0 then 1 else 0 end
	                 end)
		from MatchResultsDetails3 M
		left join Teams T on M.HomeTeamID = T.ID or M.AwayTeamID = T.ID
		left join Clubs C on C.ID=T.ClubID
		where T.SectionID=@SectionID
		group by T.ID, [Club Name] + ' ' + T.Team 
		order by points desc,wins0 desc

	open c
	fetch c into @Posn, @TeamID, @Pts, @Wins0

	while @@FETCH_STATUS = 0
		begin
		insert @tmpWinners
			select @Posn, @TeamID, @SectionID
		fetch c into @Posn, @TeamID, @Pts, @Wins0
		end

	close c
	deallocate c

	fetch SectionsCursor into @SectionID

	end

close SectionsCursor
deallocate SectionsCursor
delete Awards where AwardType=1

insert Awards
	select @AwardType	--Award type
		  ,SectionID	--ID
		  ,Posn			--SubId
		  ,LeagueID		--LeagueID
          ,W.teamID	    --EntrantID
		  ,NULL         --Entrant2ID

	from @tmpWinners W
	outer apply (select LeagueID from  Sections where ID=SectionID) L

if exists(select table_name from INFORMATION_SCHEMA.TABLES 
                            where TABLE_NAME='Awards_League_Winners'
							  and TABLE_SCHEMA='dbo')
	truncate table dbo.Awards_League_Winners
else
	create table dbo.Awards_League_Winners
		(Posn integer, TeamID int, SectionID int, LeagueID int)

--store league winners to be excluded from best last 6 trophies
insert Awards_League_Winners
	select * from @tmpWinners W
		outer apply (select LeagueID from  Sections where ID=SectionID) L
		where Posn=1

commit tran

GO

exec dbo.Awards_LeagueWinners
exec Awards_Report 1

select * from Awards_League_Winners
