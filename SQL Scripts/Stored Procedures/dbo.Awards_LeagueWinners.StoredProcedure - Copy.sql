if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Awards_LeagueWinners')
	drop procedure dbo.Awards_LeagueWinners
GO

create procedure dbo.Awards_LeagueWinners

as

set nocount ON

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
		                                    ,sum(case when T.ID=M.HomeTeamID then case when HomePoints=4 then 1 else 0 end
		                                                                     else case when AwayPoints=4 then 1 else 0 end
	                                         end) desc)
	     ,T.ID--, [Club Name] + ' ' + T.Team 
		 ,Points=sum(case when T.ID=M.HomeTeamID then HomePoints else AwayPoints end)
		 ,Wins0= sum(case when T.ID=M.HomeTeamID then case when HomePoints=4 then 1 else 0 end
		                                         else case when AwayPoints=4 then 1 else 0 end
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

delete awards where awardtype=1

insert Awards
	select 1
		  ,W.SectionID
		  ,Posn
		  ,LeagueID=L.ID
		  ,TeamID
		  ,NULL
	from @tmpWinners W
	left join teams T on T.ID=W.TeamID
	left join clubs C on C.ID=T.ClubID
	left join Sections S on S.ID=T.SectionID
	left join Leagues L on L.ID=S.LeagueID 

GO

exec dbo.Awards_LeagueWinners
exec Awards_Report 1
