USE [HBSA]
GO
/****** Object:  UserDefinedFunction [dbo].[BreaksInMatch]    Script Date: 12/12/2014 17:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[BreaksInMatch] 
	(@MatchresultID int
	)
RETURNS varchar(2000)
AS
BEGIN

declare @BreaksInMatch varchar(2000)

declare c cursor fast_forward for
	select 	Player, [Break]

		from Breaks 
		cross apply(select Player=Forename + case when Initials='' then ' ' else ' ' + Initials + '. ' end + Surname
						 from PlayerDetails 
						 where PlayerID=PlayerDetails.ID) P
		where MatchResultID=@MatchresultID
declare @Player varchar(110)
       ,@Break int
set @BreaksInMatch=''
open c
fetch c into @player, @Break
while @@FETCH_STATUS=0
	begin
	set @BreaksInMatch=@BreaksInMatch + @Player + ' ' + convert(varchar,@break) + ', '
	fetch c into @player, @Break
	end
if len(@BreaksInMatch) > 2
	set @BreaksInMatch=left(@BreaksInMatch,len(@BreaksInMatch) - 1)

close c
deallocate c
	 
RETURN @BreaksInMatch

END



GO
