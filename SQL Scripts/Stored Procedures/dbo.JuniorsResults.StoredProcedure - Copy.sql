USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'JuniorsResults')
	drop procedure JuniorsResults
GO

create procedure JuniorsResults

as
set nocount on

declare @div int
declare c cursor fast_forward for
	select distinct Division
		from JuniorLeagues
		order by Division
open c
fetch c into @div
while @@FETCH_STATUS=0
	begin 
	exec JuniorsResultsByDiv @div
	fetch c into @div
	end
close c
deallocate c
GO
exec JuniorsResults