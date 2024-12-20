USE [HBSA]
GO

ALTER FUNCTION [dbo].[newTaggedHandicap] 
	(@Played int
	,@Won int
	,@Handicap int
	,@LeagueID int --3 = Billiards, otherwise Snooker
)
RETURNS int
AS
BEGIN

declare @newHandicap int
       ,@Delta int
	   ,@Max int
       ,@Min int

--calculate the change required 

if @Played <> 6 
	set @Delta = 0
else
if @LeagueID = 3 
	--calculate the billiards handicap change (@Delta)
	set @Delta = case when @Won = 0 then +15
	                  when @Won = 1 then +10
                      when @Won = 2 then +5
					  when @Won = 3 then 0
					  when @Won = 4 then -5
					  when @Won = 5 then -10
					  when @Won = 6 then -15
                 end
else
	--calculate the snooker handicap change (@Delta)
	set @Delta = case when @Won = 0 then +9
	                  when @Won = 1 then +6
                      when @Won = 2 then +3
					  when @Won = 3 then 0
					  when @Won = 4 then -3
					  when @Won = 5 then -6
					  when @Won = 6 then -9
	              end

set @NewHandicap = @Handicap + @Delta

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

--return the adjusted handicap
RETURN @NewHandicap 

END

GO

