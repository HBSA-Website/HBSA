declare emailTablesCursor cursor fast_forward for
	select emailTablesCursor.table_name,column_name
		from information_schema.columns emailTablesCursor
		join information_schema.tables T on emailTablesCursor.table_name=T.table_name
		where column_name like '%email%' 
		  and character_maximum_length < 300
		  and table_type <> 'VIEW'
declare @table varchar(250), @Col varchar(250), @SQL varchar(4000)
open emailTablesCursor

create table emailList (eMail varchar(255))

fetch emailTablesCursor into @table, @col
while @@fetch_status=0
	begin
		set @SQL= '
			INSERT emailList select email=' + @col + '
				from [' + @table + '] '
	exec (@SQL)
	fetch emailTablesCursor into @table, @col

	end

close emailTablesCursor
deallocate emailTablesCursor

declare @ttt table (email varchar(max))
declare @list varchar (max)
declare c cursor fast_forward for 
	select distinct * from emailList where email is not null
declare @e varchar(256), @ctr int
set @list='' 
set @ctr=1 
open c
fetch c into @e
while @@fetch_status=0
	begin
	set @list = @list + @e + ';'
	if @ctr>99
		begin
		insert @ttt select @list
		set @list=''
		set @ctr=1
		end
	set @ctr=@ctr+1
	fetch c into @e
	end
close C
deallocate c
insert @ttt select @list

select * from @ttt

drop table emaillist
