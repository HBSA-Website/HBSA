USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='ClubLoginDetails')
	drop procedure ClubLoginDetails
GO

create procedure dbo.ClubLoginDetails
	(@eMailAddress varchar(255) = NULL
	,@ClubID       int = NULL
	)
as

set noCount on	

select eMailAddress
      ,[Password]
      ,Club=C.[Club Name]
      ,Confirmed=Confirmed  
      ,FirstName = ISNULL(Firstname,'')
      ,Surname=  ISNULL(Surname,'')
      ,Telephone = ISNULL(Telephone,'')
	  ,U.ClubID
	from Clubusers U
	join Clubs C on C.ID=U.ClubID
	
	where (eMailAddress=@eMailAddress)
	   or U.ClubID=@ClubID
	order by case when Confirmed <> 'Confirmed' then Confirmed else '' end

GO
exec ClubLoginDetails 'gilbertp@outlook.com'
exec ClubLoginDetails @ClubID=43
