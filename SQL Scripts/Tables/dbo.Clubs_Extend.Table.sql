alter table Clubs add
	 ContactName varchar(104)
	,ContactEMail varchar(250)
	,ContactTelNo varchar(20)
	,ContactMobNo varchar(20)

alter table Clubs drop column
	 ContactID
GO
update Clubs
	set	ContactName=FirstName + ' ' + Surname
	   ,ContactEMail= eMailAddress
	   ,ContactTelNo = case when left(dbo.normaliseTelephoneNumber(Telephone),2)='07' then '' else dbo.normaliseTelephoneNumber(Telephone) end
	   ,ContactMobNo = case when left(dbo.normaliseTelephoneNumber(Telephone),2)<>'07' then '' else dbo.normaliseTelephoneNumber(Telephone) end
	from Clubs
	join Teams on ClubID = Clubs.ID 
	cross apply (select top 1 * 
					from ResultsUsers 
					where TeamID=Teams.ID
					order by TeamID) x
GO