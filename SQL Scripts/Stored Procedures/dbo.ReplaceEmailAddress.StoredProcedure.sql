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
	exec FindEmailAddress @OldEmailAddress, 1

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

--Clean up any email keys (the admin may have replaced with blank)

delete from Resultsusers where eMailAddress=''
delete from Clubusers where eMailAddress=''


commit tran

GO
