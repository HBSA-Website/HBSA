USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Awards_GenerateWinners')
	drop procedure Awards_GenerateWinners
GO

CREATE procedure dbo.Awards_GenerateWinners
	(@AwardType int = 0)
as

set nocount on
set xact_abort on

begin tran

declare Awards_Procedures_Cursor cursor fast_forward for
	select StoredProcedureName 
		from Awards_Types
		where AwardType=@AwardType or @AwardType=0
declare @SQL varchar(255)
open Awards_Procedures_Cursor
fetch Awards_Procedures_Cursor into @SQL
while @@fetch_status=0
	begin
	if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = @SQL)
		begin
		set @SQL = 'exec ' + @SQL
		exec (@SQL)
		end
	fetch Awards_Procedures_Cursor into @SQL
	end
close Awards_Procedures_Cursor
deallocate Awards_Procedures_Cursor

exec Awards_GenerateReportTable

commit tran

GO

exec Awards_GenerateWinners
select * from Awards_Report_Table


