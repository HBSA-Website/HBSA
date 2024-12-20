USE [HBSA]
GO
/****** Object:  UserDefinedFunction [dbo].[newHandicap]    Script Date: 12/12/2014 17:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter FUNCTION [dbo].[newHandicap] 
	(@Handicap int
	,@Played int
	,@Won int
	,@LeagueID int --3 = Billiards, otherwise Snooker
	,@Tagged int
	,@Over70 bit
)
RETURNS int
AS
BEGIN

declare @NewHandicap int
       ,@Delta int
       ,@Max int
       ,@Min int

--calculate the difference between won and lost (may well be negative)
set @Delta=@Won-(@Played-@Won)       

if @LeagueID = 3 
	--calculate the new billiards handicap as a change to the old handicap
	--if the difference is less than 3 there is no change
	--otherwise the difference is 2.5 points per difference, rounded down
	--   i.e. when the difference is negative the change is 2.5 more than the difference
	--        when the difference is positive the change is 2.5 less than the difference
	--            hence the use of the ceiling function.
	set @NewHandicap = case when abs(@Delta) < 3 then @Handicap
	                                             else @Handicap - (ceiling(convert(decimal,@Delta)/2)) * 5
	                   end
else
	--calculate the new snooker handicap as a change to the old handicap
	--if the difference is greater than 8 the change is the difference
	--if the difference is less than 3 there is no change
	--otherwise, if the player is seasoned the difference is half a point per difference, rounded down
	--   i.e. when the difference is negative the change is 0.5 more than the difference
	--        when the difference is positive the change is 0.5 less than the difference
	--            hence the use of the ceiling function.
	--otherwise, if the player is unseasoned the change is the difference
	set @NewHandicap = case when abs(@Delta) > 8 then @Handicap - @Delta
		                    when abs(@Delta) < 3 then @Handicap
			                                     else case when @Tagged <> 0 then @Handicap - @Delta 
																			else @Handicap - ceiling(convert(decimal,@Delta)/2)
                                                      end
				       end

--Over 70 cannot go down
if @Over70 = 1 and @Delta > 0 
	set @NewHandicap = @Handicap

--ensure the change does not exceed the handicap limits for it's league
select @Max=[MaxHandicap] 
	  ,@Min=[MinHandicap] 
	from Leagues
	where ID=@LeagueID   
	
if @NewHandicap > @Max 
	set @NewHandicap=@Max 
else 
if @NewHandicap < @Min 
		set @NewHandicap=@Min      
	
RETURN @NewHandicap

END



GO
