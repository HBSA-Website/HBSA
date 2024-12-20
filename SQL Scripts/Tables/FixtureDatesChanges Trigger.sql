USE [HBSA]
GO
/****** Object:  Trigger [dbo].[HandicapChange]    Script Date: 25/10/2016 10:47:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create TRIGGER SectionSizeChange
   ON  FixtureDates
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--get caller info
	DECLARE @ExecStr varchar(50), @Qry nvarchar(255)
 
	CREATE TABLE #inputbuffer 
		 (EventType nvarchar(30)
		 ,[Parameters] int 
		 ,EventInfo nvarchar(255)
	     )
	SET @ExecStr = 'DBCC INPUTBUFFER(' + STR(@@SPID) + ')'
 
	INSERT INTO #inputbuffer 
	EXEC (@ExecStr)


	--log changes to SectionSize
	Insert FixtureDatesChanges
		select getdate(), SectionID, SectionSize, WeekNo, FixtureDate, 'B' 
			  ,'','','','',''
		from DELETED
		cross apply (select top 1 * from #inputbuffer) IB

	Insert FixtureDatesChanges
		select getdate(), SectionID, SectionSize, WeekNo, FixtureDate, 'A' 
			  ,EventType, [Parameters], EventInfo, SYSTEM_USER, USER
		from inserted
		cross apply (select top 1 * from #inputbuffer) IB



END

