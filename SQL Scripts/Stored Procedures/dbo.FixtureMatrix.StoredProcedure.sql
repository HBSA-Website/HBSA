USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FixtureMatrix')
	drop procedure FixtureMatrix
GO

create procedure [dbo].[FixtureMatrix] 
	 @SectionID int
as

set nocount on

declare @SectionSize int
select @SectionSize=count(*)/2 from Teams where SectionID=@SectionID
declare @SQL varchar(4000)
set @SQL='
declare @MatrixSize int
	select @MatrixSize = Count(*) from FixtureGrids where SectionID=' + convert(varchar,@SectionID) + '
select [Date]=convert(varchar(11),FixtureDate,113)'
declare @ix int
set @ix=0
while @ix < @SectionSize  
	begin
    set @ix=@ix+1  
	set @SQL=@SQL + '
      ,[' + CHAR(@ix+96) + '] = convert(varchar,h' + convert(varchar,@ix) + ')+'' v ''+convert(varchar,a' + convert(varchar,@ix) + ')'
    end  
set @SQL=@SQL + '      
from FixtureGrids M
join FixtureDates D
  on D.SectionID=' + convert(varchar,@SectionID) + '
 and M.WeekNo=case when D.WeekNo % @MatrixSize = 0 then convert(varchar,@MatrixSize) else D.WeekNo % @MatrixSize end
where M.SectionID=' + convert(varchar,@SectionID) + '
order by FixtureDate'
exec (@SQL)

GO
[FixtureMatrix] 7