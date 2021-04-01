USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'PhoneNoDetail')
	drop procedure PhoneNoDetail
GO

CREATE procedure dbo.PhoneNoDetail
	(@TableName varchar(255)
	,@ColumnName varchar(255)
	,@PhoneNo varchar(255)
	)
as

set nocount on

declare @SQL varchar(2000)

set @SQL='select * from ' + @TableName + ' where Replace(' + @ColumnName + ','' '','''') = Replace(''' + @PhoneNo + ''','' '','''')'  
                                                
exec (@SQL)

GO

exec PhoneNoDetail 'Players','TelNo','07772000147'