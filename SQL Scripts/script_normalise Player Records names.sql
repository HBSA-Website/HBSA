update PlayerRecords
	set Player = Word2 + ' ' + Word1

	from PlayerRecords
	cross apply (Select Word1=Word from dbo.WordsInString(Player) where Ordinal=1) f
	cross apply (Select Word2=Word from dbo.WordsInString(Player) where Ordinal=2) s
	where (select count(*) from dbo.WordsInString(Player))=2
	 and Season < 2014

update PlayerRecords
	set Player = Word2 + ' ' + Word3 + ' ' + Word1

	from PlayerRecords
	cross apply (Select Word1=Word from dbo.WordsInString(Player) where Ordinal=1) f
	cross apply (Select Word2=Word from dbo.WordsInString(Player) where Ordinal=2) s
	cross apply (Select Word3=Word from dbo.WordsInString(Player) where Ordinal=3) t
	where (select count(*) from dbo.WordsInString(Player))=3
	 and Season < 2014

update PlayerRecords
	set Player ='Kevin Jnr Baxter'
	where Player = 'Kevin Jnr. Baxter'
