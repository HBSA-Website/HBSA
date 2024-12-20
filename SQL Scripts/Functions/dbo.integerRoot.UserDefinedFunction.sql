USE [HBSA]
GO
/****** Object:  UserDefinedFunction [dbo].[integerRoot]    Script Date: 12/12/2014 17:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[integerRoot] 
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
