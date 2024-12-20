USE [HBSA]
GO
/****** Object:  UserDefinedFunction [dbo].[normaliseTelephoneNumber]    Script Date: 12/12/2014 17:44:06 ******/
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
