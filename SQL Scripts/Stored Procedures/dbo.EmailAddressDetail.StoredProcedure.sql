USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EmailAddressDetail')
	drop procedure EmailAddressDetail
GO

CREATE procedure dbo.EmailAddressDetail
	(@TableName varchar(255)
	,@ColumnName varchar(255)
	,@eMailAddress varchar(255)
	)
as

set nocount on

declare @SQL varchar(2000)

set @SQL='select * from ' + @TableName + ' where ' + @ColumnName + ' = ''' + @EmailAddress + ''''  
exec (@SQL)

GO

exec EmailAddressDetail 'resultsUsers','eMailAddress','gilbertp@outlook.com'