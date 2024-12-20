USE [HBSA]
GO
/****** Object:  UserDefinedFunction [dbo].[extract1stNumber]    Script Date: 12/12/2014 17:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[extract1stNumber]
(
	-- Add the parameters for the function here
	@String varchar(2000)
)
RETURNS int
AS
BEGIN

declare @ix int, @numericCharacters varchar(10), @int int
set @ix=1
set @numericCharacters=''
while @ix <= LEN(@String)
	begin
	if SUBSTRING(@String,@ix,1) >= '0' and SUBSTRING(@String,@ix,1)<='9'
		begin
		set @numericCharacters=@numericCharacters+SUBSTRING(@String,@ix,1)
		end
	else
		begin
		if @numericCharacters <> ''
			begin
			set @int=CONVERT(int,@numericCharacters)
			set @ix=LEN(@String)
			end
		end	
	set @ix=@ix+1
	end

if @int is null and @numericCharacters <> ''	
	set @int=CONVERT(int,@numericCharacters)

return @int

END



GO
