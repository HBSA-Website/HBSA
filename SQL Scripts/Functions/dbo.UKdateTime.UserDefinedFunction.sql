USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UKdateTime')
	drop function dbo.UKdateTime
GO

CREATE FUNCTION dbo.UKdateTime 
	(@date datetime
	)

RETURNS datetime

AS

BEGIN

declare @lastDayOfMarch date
      , @lastDayOfOctober date
      , @startOfBST datetime
	  , @endOfBST datetime

set @lastDayOfMarch = datefromparts(datepart(year,@date), 03, 31) 
set @lastDayOfOctober = datefromparts(datepart(year,@date), 10, 31) 
set @startOfBST=dateadd(ss,(-22*60*60)+1,(DATEADD(dd,-(DATEPART( WEEKday , DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,@lastDayOfMarch,112))+1,0)))-1),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,@lastDayOfMarch,112))+1,0)))))
set @endOfBST=dateadd(ss,(-22*60*60)+1,DATEADD(dd,-(DATEPART( WEEKday , DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,@lastDayOfOctober,112))+1,0)))-1),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,convert(datetime,@lastDayOfOctober,112))+1,0))))

if @date between @startOfBST and @endOfBST 
	set @date = dateadd(hh,1,@date)

return @date

END


GO

select dbo.UKdateTime (getutcdate())
select getutcdate()
