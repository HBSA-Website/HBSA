USE [HBSA]

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'UpdateContent')
	drop procedure UpdateContent
GO

CREATE procedure UpdateContent
	(@Contentname varchar(128)
	,@ContentHTML varchar(max)
	)
as

set nocount on

update ContentData
	set ContentHTML=@ContentHTML
	   ,dtLodged=dbo.UKdateTime(getUTCdate()) 
	where ContentName=@Contentname 

GO




select * from ContentData where ContentName='Home'

