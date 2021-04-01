USE HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME='Fines_Summary')
	DROP procedure dbo.Fines_Summary
GO

create procedure dbo.Fines_Summary
	(@Owing bit = 1
	,@ClubID int = 0
	,@forMobile bit = 0)
	
as

set nocount on

begin tran
--delete payments and fines from previous season 
 Delete fines
	from fines F
	left join Payments P
		 on P.ClubID=F.ClubID
		and FineID=F.ID
	where (Fine-isnull(AmountPaid,0)) = 0
	  and dtLodged < (select [value] from [Configuration] where [key] = 'CloseSeasonEndDate')
Delete Payments
	from Payments P
	left outer join fines F
		 on P.ClubID=F.ClubID
		and FineID=F.ID
	where F.clubid is null
	  and F.ID is null
	  and FineID <> 0
commit tran

if @forMobile = 0
	select 
		 F.ClubID
		,[Club Name]
		,Fine
		,Outstanding=Fine-isnull(AmountPaid,0)
		,F.ID
		,Imposed=convert (varchar(11),dtLodged,113)
		,Offence
		,Comment
	from Fines F
	left join Clubs C 
			on C.ID=F.ClubID
	outer apply (select AmountPaid=sum(isnull(AmountPaid,0))
					from Payments
					where ClubID=F.ClubID
					  and FineID=F.ID) P
	where (@Owing=0 or (Fine-isnull(AmountPaid,0)) <> 0)
	  and (@ClubID=0 or F.ClubID = @ClubID)
	order by dtlodged desc
else
	select 
		 F.ID
		,Fine
		,Outstanding=Fine-isnull(AmountPaid,0)
		,Imposed=convert (varchar(11),dtLodged,113)
	from Fines F
	left join Clubs C 
			on C.ID=F.ClubID
	outer apply (select AmountPaid=sum(isnull(AmountPaid,0))
					from Payments
					where ClubID=F.ClubID
					  and FineID=F.ID) P
	where (@Owing=0 or (Fine-isnull(AmountPaid,0)) <> 0)
	  and (@ClubID=0 or F.ClubID = @ClubID)
	order by dtlodged desc

GO
exec Fines_Summary 1,51,1