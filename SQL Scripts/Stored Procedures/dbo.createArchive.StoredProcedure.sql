USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'createArchive')
	drop procedure createArchive
GO

create procedure createArchive
	(@TableName varchar(255)
	,@Year int
	)
as

set nocount on

declare @SQL varchar(4000)

set @SQL='if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME = ''' +  @TableName + '_' + convert(varchar,@Year) + ''')
	          drop table ' +  @TableName + '_' + convert(varchar,@Year) + '
          Select * into ' + @TableName + '_' + convert(varchar,@Year) + ' from ' + @TableName +'
          truncate table ' + @TableName

exec (@SQL)

GO

exec createArchive 'Competitions',2015