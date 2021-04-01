USE [HBSA]
GO

/****** Object:  StoredProcedure [dbo].[MergeTeam]    Script Date: 12/12/2014 17:46:01 ******/
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'MergeTeam')
	drop procedure MergeTeam
GO

CREATE procedure [dbo].[MergeTeam]
	(@TeamID int        --if = -1 insert new record
	,@SectionID	int		--if = -100 delete record
	,@FixtureNo	int     --if = -1 set next available
	,@ClubID int
	,@Team char(1)
	,@Captain int
	,@User varchar(255) = ''
	)
as
set nocount on     
set xact_abort on

begin tran

declare @TeamName varchar (256)
select @TeamName = rtrim([Club Name] + ' ' + Team)
	from Teams 
	cross apply (select [Club Name]
					from clubs where ID = ClubID) C
	where ID=@TeamID

declare @FixtureNumber int
set @FixtureNumber=@FixtureNo

if @FixtureNumber = -1 and @SectionID > 0
	begin
	set @FixtureNumber=@FixtureNumber+1
	declare @fNo int
	declare TeamsCursor cursor fast_forward for
		select FixtureNo
			from Teams
			where SectionID=@SectionID
			order by FixtureNo
	open TeamsCursor
	fetch TeamsCursor into @fNo
	while @fNo = @FixtureNumber+1
		begin
		if @fNo = @FixtureNumber+1
			begin
			set @FixtureNumber=@FixtureNumber+1
			fetch TeamsCursor into @fNo
			end
		end
	
	close TeamsCursor
	deallocate TeamsCursor
	set @FixtureNumber=@FixtureNumber+1
	end

MERGE Teams AS target
    USING (SELECT @TeamID) AS source (ID)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED AND @SectionID=-100 THEN
		DELETE

	WHEN MATCHED THEN 
        UPDATE SET
             SectionID=@SectionID  --  negative implies delete as it becomes orphaned
			,FixtureNo=@FixtureNumber
			,ClubID=@ClubID
			,Team=@Team
			,Captain=@Captain
					
    WHEN NOT MATCHED AND @TeamID=-1 THEN    
		INSERT	(SectionID
				,FixtureNo
				,ClubID
				,Team
				,Captain
				)
		values	(@SectionID
				,@FixtureNumber
				,@ClubID
				,@Team
				,@Captain
				)
		
		OUTPUT $action,inserted.ID;

	--log it
	insert Activitylog values (dbo.UKdateTime(getUTCdate()),'Team merged(' + @TeamName + ')',@TeamID,isnull(@User,original_login()))

commit tran

GO
