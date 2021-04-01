update Pictures set Category = 'General' where Category='Gallery'

delete Pictures where extension is null

create Table PictureCategories
	(Sequence int
	,Category varchar (31)
	)

insert PictureCategories values (1,'General')
insert PictureCategories values (11,'Century Makers')
insert PictureCategories values (21,'Billiards Century Makers')
insert PictureCategories values (31,'2015 Presentation Night')

