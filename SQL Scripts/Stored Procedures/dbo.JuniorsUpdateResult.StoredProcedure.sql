USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'JuniorsUpdateResult')
	drop procedure [dbo].JuniorsUpdateResult
GO

create procedure  [dbo].JuniorsUpdateResult
	(   @ID int,
        @HomeFrame1 int,
        @AwayFrame1 int,
        @HomeFrame2 int,
        @AwayFrame2 int,
        @HomeFrame3 int,
        @AwayFrame3 int
	)
as
set nocount on

UPDATE JuniorResults
	set HomeFrame1=@HomeFrame1
       ,AwayFrame1=@AwayFrame1
       ,HomeFrame2=@HomeFrame2
       ,AwayFrame2=@AwayFrame2
       ,HomeFrame3=@HomeFrame3
       ,AwayFrame3=@AwayFrame3
       where ID=@ID
GO
