USE [HBSA]
GO

/****** Object:  UserDefinedFunction [dbo].[extract1stNumber]    Script Date: 04/29/2014 12:20:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[extract1stNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[extract1stNumber]
GO

USE [HBSA]
GO

/****** Object:  UserDefinedFunction [dbo].[extract1stNumber]    Script Date: 04/29/2014 12:20:01 ******/
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


USE [HBSA]
GO

/****** Object:  UserDefinedFunction [dbo].[normaliseTelephoneNumber]    Script Date: 03/24/2014 19:15:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[integerRoot]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].integerRoot
GO

CREATE FUNCTION integerRoot 
	(@number int
	,@integer int = 2
)
RETURNS int
AS
BEGIN

declare @power int
set @power=-1

while POWER (@integer,@power) < @number
	set @power=@power + 1			-- Return the result of the function
	
RETURN @power

END


GO

USE [HBSA]
GO
/****** Object:  UserDefinedFunction [dbo].[normaliseTelephoneNumber]    Script Date: 13/09/2013 10:37:03 ******/
DROP FUNCTION [dbo].[normaliseTelephoneNumber]
GO
/****** Object:  UserDefinedFunction [dbo].[normaliseTelephoneNumber]    Script Date: 13/09/2013 10:37:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[normaliseTelephoneNumber] 

(
	-- Add the parameters for the function here
	@telNo varchar(20)
)
RETURNS varchar(20)
AS
BEGIN
	declare @newNo varchar(20)
	declare @oldNo varchar(20)
	
	set @oldNo = isnull(@telNo,'')
	if @oldNo = '' 
		set @newNo = ''
	else
		begin
		set @oldNo = replace(isnull(@oldNo,''),' ','')
		set @oldNo = replace(isnull(@oldNo,''),'\','')
		
		if LEFT (@oldNo,2)='44' set @oldNo='0' + RIGHT(@OldNo,len(@OldNo)-2)
		if LEFT (@oldNo,3)='+44' set @oldNo='0' + RIGHT(@OldNo,len(@OldNo)-3)
		
		if len(@OldNo) between 1 and 7
			set @oldNo = '01484' + @oldNo
		set @newNo = LEFT(@OldNo,5) + ' ' + RIGHT(@oldNo,len(@OldNo)-5)
		end
			-- Return the result of the function
	RETURN @NewNo

END

GO