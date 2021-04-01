USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ReplacePhoneNumber')
	drop procedure ReplacePhoneNumber
GO

CREATE procedure dbo.ReplacePhoneNumber
	(@OldPhoneNumber varchar(255)
	,@NewPhoneNumber varchar(255)
	)
as

set nocount on
set xact_abort on

begin tran

create table #phoneColumns
	(Table_name varchar(255)
	,Column_Name varchar(255)
	)
insert #phoneColumns
	exec FindPhoneNumber @OldPhoneNumber

if (select count(*) from #phoneColumns) < 1
	raiserror('Current phone number does not exist',17,0) -- severity 17 should avoid any more processing
else
	begin
	declare phoneColumns cursor fast_forward for
	select * from #phoneColumns
	
	declare @Table_Name varchar(255)
	       ,@Column_Name varchar (255)
		   ,@SQL varchar(4000)
	open phoneColumns
	fetch phoneColumns into @Table_Name, @Column_Name
	while @@fetch_status=0
		begin
		set @SQL='
			update ' + @Table_Name + '
				set ' + @Column_Name + ' = ''' + @NewPhoneNumber + '''  
 			    where Replace(' + @Column_Name + ','' '','''') = Replace(''' + @OldPhoneNumber + ''','' '','''')'  

	    exec (@SQL)
		fetch phoneColumns into @Table_Name, @Column_Name
		end

	close phoneColumns
	deallocate phoneColumns

	end

drop table #phoneColumns

commit tran

GO

exec ReplacePhoneNumber '07772 000147','07772000147'
exec FindPhoneNumber '07772 000147'