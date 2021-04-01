USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'PrivacyReport')
	drop procedure PrivacyReport
GO

create procedure dbo.PrivacyReport 
	(@ClubID int = 0      -- 0 = all clubs
	,@Type int = 0        -- 0=League entries, 1 = Competition entries
	,@Privacy bit = NULL  -- NULL = either
	)
as

set nocount on

create table #PrivacyReportTable
	( ClubID int 
	 ,PrivacyAccepted varchar(15)
	 ,[No of League Players] int
	 ,[No of League Teams] int
	 ,[No of Competitions Entrants] int
    )

if @type = 0
--report clubs without PrivacyAccepted for league entries
	select [Club Name]
	      ,[Privacy Accepted]=case when PrivacyAccepted = 1 then 'Yes' else 'No' end
 	      ,Contact=ContactName
	      ,Mobile=ContactMobNo 
	      ,ClubLoginEMail=ContactEMail 
	      ,[Tel No]=case when isnull(ContactTelNo,'')='' 
							then case when isnull(ContactMobNo,'')=''
							              then Telephone
							              else ContactMobNo
                                 end
							else ContactTelNo 
					end 
		  ,[No of League Players]=playersCount
	      ,[No of League Teams]=teamsCount

	from EntryForm_ClubsDetails EntryForm_Clubs
	outer apply (select playersCount=count(*) from EntryForm_Players where ClubID=EntryForm_Clubs.ClubID)Players
	outer apply (select teamsCount=count(*) from EntryForm_Teams where ClubID=EntryForm_Clubs.ClubID)Teams
	outer apply (Select Telephone from ClubUsers where ClubID = EntryForm_Clubs.ClubID)Users
	where PrivacyAccepted=(case when @Privacy is NULL then PrivacyAccepted
	                            else @Privacy end)  
	  and (playersCount > 0 or teamsCount > 0)
	  and (@ClubID = 0 or @ClubID = ClubID)
	order by [Club Name]

else

	--report clubs without PrivacyAccepted for Competitions entries
	Select [Club Name]
	      ,[Privacy Accepted]=case when PrivacyAccepted = 1 then 'Yes' else 'No' end
 	      ,Contact=ContactName
	      ,Mobile=ContactMobNo 
	      ,eMail=ContactEMail 
	      ,[Tel No]=case when isnull(ContactTelNo,'')='' 
							then case when isnull(ContactMobNo,'')=''
							              then Telephone
							              else ContactMobNo
                                 end
							else ContactTelNo 
					end 
		  ,[No of Competitions Entrants]=EntrantsCount
		from Competitions_EntryFormsClubs E
		left join ClubsDetails Clubs on ID = ClubID
		outer apply (select EntrantsCount=count(*) from Competitions_EntryForms where ClubID=E.ClubID)Entrants
		outer apply (Select Telephone from ClubUsers where ClubID = Clubs.ID)Users
		where PrivacyAccepted=(case when @Privacy is NULL then PrivacyAccepted
	                                else @Privacy end)
			  and EntrantsCount > 0
			  and (@ClubID = 0 or @ClubID = ClubID)

GO

exec PrivacyReport @Type=1
