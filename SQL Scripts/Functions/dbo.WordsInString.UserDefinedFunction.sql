USE [HBSA]
GO
/****** Object:  UserDefinedFunction [dbo].[WordsInString]    Script Date: 12/12/2014 17:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter FUNCTION [dbo].[WordsInString]
(
	@String varchar(2000)
)
RETURNS @Words table (Ordinal int,Word varchar(2000))
AS
BEGIN

declare @ix int, @iy int, @Ordinal int
select @ix=1, @iy=1, @Ordinal=1

set @String=ltrim(rtrim(replace(@String,'(Deceased)','')))  --ignore {Deceased) in name search
while @String like '%  %'
	set @String=replace(@String,'  ',' ')

if Len(@String)>0
	begin
	
	while @ix <= LEN(@String)
		begin
		if SUBSTRING(@String,@ix,1) = ' '
			begin
			insert @words values (@Ordinal,substring(@String,@iy,@ix-@iy))
			set @iy=@ix+1
			set @Ordinal=@Ordinal+1
			end
		set @ix=@ix+1
		end
	
	insert @words values (@Ordinal,substring(@String,@iy,@ix-@iy))
	end

return 

END


GO
