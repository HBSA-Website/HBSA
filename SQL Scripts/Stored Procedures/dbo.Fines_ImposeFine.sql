USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Fines_ImposeFine')
	DROP procedure dbo.Fines_ImposeFine
GO

create procedure dbo.Fines_ImposeFine
	(@ClubID int
	,@Offence varchar(255)
	,@Comment varchar(255)
	,@Amount decimal (9,2)
	)

as

set nocount on

insert Fines
	select dbo.UKdateTime(getUTCdate())
	      ,@ClubID int
	      ,@Offence 
	      ,@Comment 
	      ,@Amount 

select eMailAddressList = dbo.eMailsForClub(@ClubID)

GO
exec Fines_ImposeFine 31,'TestOffence','TestComment',32.00
