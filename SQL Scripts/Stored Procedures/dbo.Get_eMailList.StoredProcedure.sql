USE [HBSA]
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES where routine_name = 'Get_eMailList')
	drop procedure Get_eMailList
GO

CREATE procedure Get_eMailList
	(@StartDate datetime
	,@EndDate  datetime
	,@SubjectFilter varchar(255) = ''
	)
as

set nocount on

--Note that the GoDaddy database is in Pacific Time so is 7 or 8 hours behind us
--therefore dates need that adjustment to get UTC (GMT) time

--Keep the table trim
delete eMailLog
	where dtLodged < dateadd(month,-2,dbo.UKdateTime(getUTCdate())) 

select   DateTimeSent=convert(varchar(17),dtLodged,113)
		,Sender
		,[Subject]
		,ReplyTo=isnull(ReplyTo,'')
		,ToAddresses=replace(ToAddresses,';','; ')
		,CCAddresses=isnull(CCAddresses,'')
		,BCCAddresses=isnull(BCCAddresses,'')
		,Body
	from eMailLog
	where dtLodged between @StartDate and @EndDate
	  and [Subject] like '%' + @SubjectFilter + '%'
	order by dtLodged desc

GO
exec Get_eMailList '1 may 2020','1 jun 2020'