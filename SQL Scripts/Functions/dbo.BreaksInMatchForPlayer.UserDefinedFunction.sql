USE [HBSA]
GO

if exists (select * from INFORMATION_SCHEMA.ROUTINES where routine_name = 'BreaksInMatchForPlayer')
	drop function BreaksInMatchForPlayer
GO

CREATE FUNCTION BreaksInMatchForPlayer
	(@MatchresultID int
	,@PlayerID int
	)
RETURNS varchar(2000)
AS
BEGIN

declare @BreaksInMatchForPlayer varchar(2000)

declare c cursor fast_forward for
	select 	[Break]

		from Breaks 
		where MatchResultID=@MatchresultID
		  and PlayerID=@PlayerID

declare @Break int
set @BreaksInMatchForPlayer=''
open c
fetch c into @Break
while @@FETCH_STATUS=0
	begin
	set @BreaksInMatchForPlayer=@BreaksInMatchForPlayer + convert(varchar,@break) + ', '
	fetch c into @Break
	end
if len(@BreaksInMatchForPlayer) > 2
	set @BreaksInMatchForPlayer=left(@BreaksInMatchForPlayer,len(@BreaksInMatchForPlayer) - 1)

close c
deallocate c
	 
RETURN @BreaksInMatchForPlayer

END



GO
select dbo.BreaksInMatchForPlayer (994,1165)