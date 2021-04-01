USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'ReplaceEmailAddress')
	drop procedure ReplaceEmailAddress
GO

CREATE procedure dbo.ReplaceEmailAddress
	(@OldEmailAddress varchar(255)
	,@NewEmailAddress varchar(255)
	)
as

set nocount on
set xact_abort on

begin tran

create table #EmailColumns
	(Table_name varchar(255)
	,Column_Name varchar(255)
	)
insert #EmailColumns
	exec FindEmailAddress @OldEmailAddress

if (select count(*) from #EmailColumns) < 1
	raiserror('Current eMail address does not exist',17,0) -- severity 17 should avoid any more processing
else
	begin
	declare eMailColumns cursor fast_forward for
	select * from #EmailColumns
	
	declare @Table_Name varchar(255)
	       ,@Column_Name varchar (255)
		   ,@SQL varchar(4000)
	open eMailColumns
	fetch eMailColumns into @Table_Name, @Column_Name
	while @@fetch_status=0
		begin
		set @SQL='
			update ' + @Table_Name + '
				set ' + @Column_Name + ' = ''' + @NewEmailAddress + '''  
				where ' + @Column_Name + ' = ''' + @OldEmailAddress + ''''  
	    exec (@SQL)
		fetch eMailColumns into @Table_Name, @Column_Name
		end

	close eMailColumns
	deallocate eMailColumns

	end

drop table #EmailColumns

commit tran

GO

exec ReplaceEmailAddress 'gilbertp@outlook.com','gilbertp@outlook.com'
exec FindEmailAddress 'petegilbert7@gmail.com'
exec FindEmailAddress 'gilbertp@outlook.com'