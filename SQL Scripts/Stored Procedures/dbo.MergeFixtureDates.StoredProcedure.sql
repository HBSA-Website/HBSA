USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[MergeFixtureDates]    Script Date: 12/12/2014 17:46:01 ******/
if exists(select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='MergeFixtureDates')
	drop procedure [dbo].[MergeFixtureDates]

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

if @CurfewStart = '1 Jan 1900' --No input from fixtureDates page
and @CurfewEnd  = '1 Jan 1900' --No input from fixtureDates page
	begin
	set @CurfewStart = @StartDate
	set @CurfewEnd   = @StartDate
	end
else
	if @StartDate > @CurfewStart
	or @CurfewStart > @CurfewEnd
		begin
		raiserror('dates must be ascending',15,15)
		return
		end
	
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

GO
exec MergeFixtureDates 1,'14 Jan 2021','','',13