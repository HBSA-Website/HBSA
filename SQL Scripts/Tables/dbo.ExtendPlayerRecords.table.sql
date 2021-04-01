alter table PlayerRecords
	add Forename varchar(50)
	   ,Initials varchar(4)
	   ,Surname varchar(50)  

USE [HBSA]
GO

CREATE NONCLUSTERED INDEX IX_PlayerNames ON PlayerRecords
(
	Forename ASC,
	Surname ASC
)
GO
update PlayerRecords	
	set Forename='Dean'
	   ,Initials='R'
       ,Surname='Poutney'
	   ,Player='Dean R Poutney'
	where Player='Dean Poutney'
GO

update PlayerRecords	
	set Forename=word1
	   ,Initials=left(replace(replace(word2,'(',''),')',''),4)
       ,Surname=word3
	from PlayerRecords 
	outer apply (select word1=word from dbo.WordsInString(Player) where ordinal=1) w1 
	outer apply (select word2=word from dbo.WordsInString(Player) where ordinal=2) w2
	outer apply (select word3=word from dbo.WordsInString(Player) where ordinal=3) w3 
	outer apply (select NoWords=count(*) from dbo.WordsInString(Player)) w4 
where NoWords=3
GO
update PlayerRecords	
	set Forename=word1
	   ,Initials=''
       ,Surname=word2
	from PlayerRecords 
	outer apply (select word1=word from dbo.WordsInString(Player) where ordinal=1) w1 
	outer apply (select word2=word from dbo.WordsInString(Player) where ordinal=2) w2
	outer apply (select NoWords=count(*) from dbo.WordsInString(Player)) w4 
where NoWords=2


