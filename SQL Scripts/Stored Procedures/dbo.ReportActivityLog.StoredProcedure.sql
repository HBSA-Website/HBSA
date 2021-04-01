USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ReportActivityLog')
	drop procedure ReportActivityLog
GO

CREATE procedure dbo.ReportActivityLog
       (@Activity varchar (3000) = ''
       ,@KeyID int               = -1
	   ,@byWhom varchar (3000)   = ''
	   ,@dtFrom datetime         = NULL
	   ,@dtTo   datetime         = NULL
	   )
as

if @dtFrom is NULL
	select @dtFrom = (select min(dtLodged) from ActivityLog)
if @dtTo is NULL
	select @dtTo = (select max(dtLodged) from ActivityLog)

select * 
	from ActivityLog A
	outer apply (select * from ActivityLogMetaData M where A.Activity like '%' + M.[Key words] + '%') MD 
	  
	where Activity like '%' + @Activity + '%'
	  and (KeyID = @KeyID or @KeyID = -1)
	  and byWhom like '%' + byWhom + '%'
	  and dtLodged between @dtFrom and @dtTo
	order by dtlodged desc

GO

exec ReportActivityLog -- @Activity='player'



