use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_Details')
	drop procedure dbo.EntryForm_Details
GO

create procedure [dbo].[EntryForm_Details]
	(@ClubID int
	,@Refresh bit = 0
	)
as

set nocount on
set xact_abort on

begin tran


if @Refresh=1 and @ClubID <> 0
	begin
	delete from EntryForm_Clubs   where  ClubID=@ClubID
	delete from EntryForm_Teams   where  ClubID=@ClubID
	delete from EntryForm_Players where  ClubID=@ClubID
	
	insert EntryForm_Clubs
			select *,1,0, 0 from Clubs where ID=@ClubID
	
	insert EntryForm_Teams
			select   ClubID
					,Team
					,LeagueID
					,Captain
					,Teams.ID
				from Teams 
				join Sections on Sections.ID=SectionID
				where ClubID=@ClubID

	insert EntryForm_Players
		select   ID
				,ClubID
				,LeagueID
				,Team
				,Forename
				,Initials
				,Surname
				,Handicap
				,email
				,TelNo
				,Tagged
				,Over70
				,0 
			from Players
			where ClubID=@Clubid
	end

select ClubID, [Club Name], Address1, Address2, PostCode, ContactName, ContactEMail, ContactTelNo, ContactMobNo, MatchTables, WIP
		, Fee=isnull((Select Fee from EntryForm_Fees where Entity='club'),0)
        ,AmountPaid = ISNULL((select SUM(AmountPaid)
								from Payments
								where ClubID=@ClubID
								  and PaymentReason='League Entry Fee')
                           ,0)
        ,PrivacyAccepted
	from EntryForm_ClubsDetails C
	where ClubID=@ClubID 

select  League = [League Name]
       ,Team
 	   ,T.LeagueID
	   ,Captain
	   ,Fee=isnull(Fee,0)
	from EntryForm_Teams T
	join Leagues on Leagues.ID = T.LeagueID
	join EntryForm_Fees F on F.LeagueID=T.LeagueID
	where ClubID=@ClubID
	order by LeagueID, Team

select	 PlayerID
        ,P.LeagueID
		,Forename
		,Inits = Initials 
		,Surname
		,[H'cap]=Handicap
		,P.Team
		,eMail = ISNULL(eMail,'')
		,TelNo = ISNULL(TelNo,'')
		,Tag = dbo.TagDescription(Tagged)
        ,Over70
 	    ,Tagged
	    ,FullName = dbo.FullPlayerName(Forename,Initials,Surname)
 	    ,Captain = case when PlayerID = Captain then 1 else 0 end
	    ,ReRegister

	from EntryForm_Players P
	cross apply (Select Captain
						from EntryForm_Teams 
						where LeagueID = P.LeagueID 
						  and ClubID = P.ClubID 
						  and Team = P.Team ) T
	where P.ClubID=@ClubID
	order by P.LeagueID,Team,Forename,Surname

select [Date]=CONVERT(varchar(17),DateTimePaid,113)
      ,PaymentMethod
	  ,PaymentReason
	  ,Amount = '&pound;' + CONVERT (varchar, AmountPaid)
	  ,Note
	  ,PaidBy=ISNULL(PaidBy,'')
	from Payments
	where ClubID=@ClubID
	  and AmountPaid <> 0
	  and PaymentReason = 'League Entry Fee'
commit tran


GO
exec EntryForm_Details 51
