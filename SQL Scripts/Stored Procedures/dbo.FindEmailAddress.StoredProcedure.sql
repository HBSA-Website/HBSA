USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FindEmailAddress')
	drop procedure FindEmailAddress
GO

CREATE procedure dbo.FindEmailAddress
	(@eMailAddress varchar(255)
	,@fromReplace bit = 0)
as

set nocount on
set xact_abort on

declare eMailColumns cursor fast_forward for
select C.Table_name,Column_Name
		from Information_schema.columns C
		left join Information_schema.tables T on T.table_name = C.TABLE_NAME
		where column_name like '%email%'
		  and C.TABLE_NAME not like '%entry%'	
		  and (@fromReplace = 0 OR TABLE_TYPE <> 'VIEW')

declare @Table_Name varchar(255)
       ,@Column_Name varchar (255)
	   ,@SQL varchar(4000)
create table #EmailColumns
	(Table_name varchar(255)
	,Column_Name varchar(255)
	)
open eMailColumns
fetch eMailColumns into @Table_Name, @Column_Name
while @@fetch_status=0
	begin
	set @SQL='
		insert #EmailColumns
		  select Table_name = ''' + @Table_Name + ''', Column_Name = ''' + @Column_Name + '''
			from [' + @Table_Name + ']
			where ' + @Column_Name + ' like ''%' + @eMailAddress + '%'''  
    exec (@SQL)
	fetch eMailColumns into @Table_Name, @Column_Name
	end

close eMailColumns
deallocate eMailColumns

select distinct * from #EmailColumns

drop table #EmailColumns

GO

exec FindEmailAddress 'bastow',1
exec FindEmailAddress 'bastow',0
