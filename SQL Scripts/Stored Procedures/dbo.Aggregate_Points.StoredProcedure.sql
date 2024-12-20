USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Aggregate_Points')
	drop procedure dbo.Aggregate_Points
GO

CREATE procedure dbo.Aggregate_Points
	(@SectionID int
	)
as

set nocount on

declare @tempPts table
	(TeamID int
	,Points decimal(9,1)
	,Comment varchar(max)
	)
declare c cursor fast_forward for
	select TeamID,points,Comment 
		from LeaguePointsAdjustment 
		cross apply (select SectionID from Teams where ID = TeamID) x
		where SectionID=@SectionID
		order by teamID, CreatedDate
declare @TeamID int,
		@prevTeamID int,
		@pts dec(9,1)
       ,@comment varchar(255)
	   ,@gpts dec(9,1)
       ,@gcomment varchar(max)
set @prevTeamID=0
open c
fetch c into @TeamID, @pts, @comment
while @@FETCH_STATUS=0
	begin
	if @TeamID <> @prevTeamID
		begin
		if @prevTeamID <> 0
			insert @tempPts
				select @prevTeamID, @gPts, right(@gcomment,len(@gcomment)-5)
		set @prevTeamID = @TeamID
		set @gpts=0
		set @gcomment=''
		end
	set @gpts = @gpts + @pts
	set @gcomment = @gcomment + '<br/>' + 
						case when @pts < 0 then convert(varchar(5),abs(@pts)) +  ' points deducted: ' + @Comment 
						                   else convert(varchar(5),abs(@pts)) + ' points added: ' + @Comment end
	fetch c into @teamID, @pts, @comment
	end

if @TeamID is not null
	insert @tempPts
		select @TeamID, @gPts, right(@gcomment,len(@gcomment)-5)
close c
deallocate c
select * from @tempPts order by teamID
GO
exec Aggregate_Points 7