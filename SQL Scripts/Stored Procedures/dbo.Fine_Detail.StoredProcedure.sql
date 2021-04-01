 use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Fine_Detail')
	drop procedure Fine_Detail
GO

create procedure dbo.Fine_Detail
	@FineID int

as

set nocount on

declare @ClubID as integer
select @ClubID=ClubID 
	from Fines 
	where ID=@FineID

select * 
	  ,AmountPaid=isnull((select sum(AmountPaid) from Payments 
	                  where ClubID=@ClubID
						and FineID=@FineID ), 0)
      ,[Club Name]=(select [Club Name] from clubs
	                  where ID=@ClubID)
	from Fines 
	where ID=@FineID
select * from Payments 
	where ClubID=@ClubID
	  and FineID=@FineID

GO

exec Fine_Detail 2