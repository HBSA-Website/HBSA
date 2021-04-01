create table PlayersAdjustedTags20151103 (ID int,Tag int)
declare c cursor fast_forward for
	select ID,Tagged from Players where ID > 0 order by ID
open c
declare @ID int
	  , @Tagged int
	  , @NewTag int

fetch c into @ID, @Tagged
while @@FETCH_STATUS=0
	begin

	if not exists (select * 
					   from PlayerRecords
					   where PlayerID=@ID
					     and season=2015
					     and P > 5)
		set @NewTag = 3
	else
	if not exists (select * 
					   from PlayerRecords
					   where PlayerID=@ID
					     and season=2014
					     and P > 5)
		set @NewTag = 2
	else
	if not exists (select * 
					   from PlayerRecords
					   where PlayerID=@ID
					     and season=2013
					     and P > 5)
		set @NewTag = 1
	else
		set @NewTag = 0

	if @Tagged<>@NewTag
		insert PlayersAdjustedTags20151103 values (@ID, @NewTag)

	fetch c into @ID, @Tagged

	end

close c
deallocate c

select t.Tag,P.Tagged,P.*
	from PlayersAdjustedTags20151103 T
	join Players P on P.ID=T.ID
	order by surname desc,forename desc, T.ID

update Players
	set Tagged=T.Tag
	from PlayersAdjustedTags20151103 T
	join Players P on P.ID=T.ID

