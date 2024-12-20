USE [HBSA]
GO
/****** Object:  UserDefinedFunction [dbo].[eMailsForClub]    Script Date: 16/06/2020 14:02:17 ******/
if exists (select routine_name from INFORMATION_SCHEMA.ROUTINES where routine_name='InlineMax')
	drop function [dbo].InlineMax
GO

create function dbo.InlineMax(@val1 int, @val2 int)
returns int
as
begin
  if @val1 > @val2
    return @val1
  return isnull(@val2,@val1)
end

GO
select dbo.InlineMax(5,4)

