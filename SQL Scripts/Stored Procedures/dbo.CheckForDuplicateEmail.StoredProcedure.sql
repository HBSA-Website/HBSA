USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'CheckForDuplicateEmail')
	drop procedure CheckForDuplicateEmail
GO

CREATE procedure CheckForDuplicateEmail
	(@Sender varchar(255)
	,@ToAddresses varchar(1024)
	,@Subject varchar(255)
	,@Body varchar(max)
	)
as

set nocount on

--select * from eMailLog order by dtlodged desc
select case when exists(
						select dtLodged 
							from eMailLog 
							where Sender=@Sender
							  and ToAddresses=@ToAddresses
							  and [subject]=@Subject
							  and body=@Body
							  and dtlodged > dateadd(day,-1, dbo.UKdateTime(getUTCdate()))
							  )
	        then 1 
			else 0 
		end
GO
