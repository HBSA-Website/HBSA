USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FindPhoneNumber')
	drop procedure FindPhoneNumber
GO

CREATE procedure dbo.FindPhoneNumber
	(@phoneAddress varchar(255)
	)
as

set nocount on
set xact_abort on

declare phoneColumns cursor fast_forward for
select C.Table_name,Column_Name
		from Information_schema.columns C
		where (column_name like '%phone%' or column_name like '%telno%' or column_name like '%mobno%' )
		  and not column_name = 'isMobileDevice'
		  and C.TABLE_NAME not like '%entry%'	

declare @Table_Name varchar(255)
       ,@Column_Name varchar (255)
	   ,@SQL varchar(4000)
create table #phoneColumns
	(Table_name varchar(255)
	,Column_Name varchar(255)
	)
open phoneColumns
fetch phoneColumns into @Table_Name, @Column_Name
while @@fetch_status=0
	begin
	set @SQL='
		insert #phoneColumns
		  select Table_name = ''' + @Table_Name + ''', Column_Name = ''' + @Column_Name + '''
			from [' + @Table_Name + ']
			where Replace(' + @Column_Name + ','' '','''') = Replace(''' + @phoneAddress + ''','' '','''')'  
    exec (@SQL)
	fetch phoneColumns into @Table_Name, @Column_Name
	end

close phoneColumns
deallocate phoneColumns

select distinct * from #phoneColumns

drop table #phoneColumns

GO

exec FindPhoneNumber '07772000147'
