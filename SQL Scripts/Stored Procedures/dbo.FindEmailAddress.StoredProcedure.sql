USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FindEmailAddress')
	drop procedure FindEmailAddress
GO

CREATE procedure dbo.FindEmailAddress
	(@eMailAddress varchar(255)
	)
as

set nocount on
set xact_abort on

declare eMailColumns cursor fast_forward for
select C.Table_name,Column_Name
		from Information_schema.columns C
		left join INFORMATION_SCHEMA.VIEWS V on V.TABLE_NAME = C.TABLE_NAME
		where column_name like '%email%'
		  and V.TABLE_NAME is null
		  and C.TABLE_NAME not like '%entry%'	

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
			where ' + @Column_Name + ' = ''' + @eMailAddress + ''''  
    exec (@SQL)
	fetch eMailColumns into @Table_Name, @Column_Name
	end

close eMailColumns
deallocate eMailColumns

select distinct * from #EmailColumns

drop table #EmailColumns

GO

exec FindEmailAddress 'johnwilson556@virginmedia.com'
