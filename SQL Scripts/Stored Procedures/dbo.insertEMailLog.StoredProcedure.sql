USE [HBSA]
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES where routine_name = 'insertEMailLog')
	drop procedure insertEMailLog
GO

create procedure [dbo].[insertEMailLog]
	(@Sender	 varchar(255)
	,@ReplyTo varchar(512)
	,@ToAddresses varchar(1024)
	,@CCAddresses varchar(512)
	,@BCCAddresses varchar(512)
	,@Subject	 varchar(255)
	,@Body		 varchar(max)
	,@MatchResultID int
	,@UserID varchar(255)=NULL
	,@SMTPServer varchar(255)
	,@SMTPPort	int
	)
as

set nocount on
set xact_abort on

insert eMailLog 
	Select dbo.UKdateTime(getUTCdate())
	,@Sender
	,@ReplyTo
	,@ToAddresses
	,@CCAddresses
	,@BCCAddresses
	,@Subject	 
	,@Body
	,@MatchResultID
	,@UserID
	,@SMTPServer
	,@SMTPPort

GO
select top 1 * from emaillog order by dtlodged desc