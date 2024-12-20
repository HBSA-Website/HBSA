USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[SuggestPlayerRecord]    Script Date: 12/12/2014 17:46:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[SuggestPlayerRecord]
	(@LeagueID int = 0
	,@count int
	,@Word1 varchar(100) = '' 
	,@Word2 varchar(100) = ''
	,@Word3 varchar(100) = ''
	)
as

set nocount on

if @word2=''
select distinct top (select @count) Player
	from PlayerRecords 
where (@LeagueID=0 or LeagueID= @LeagueID)
  and (Surname like (@Word1 + '%') or Forename like (@Word1 + '%'))
	
else 
if @word3=''
select distinct top (select @count) Player
	from PlayerRecords 
where (@LeagueID=0 or LeagueID= @LeagueID)
  and ( (Forename like (@Word1 + '%')) and (Surname like (@Word2 + '%')) or 
        (Forename like (@Word2 + '%')) and (Surname like (@Word1 + '%')) or
		(Forename like (@Word1 + '%')) and (Initials like (@Word2 + '%')) 
	  )
		
else
select distinct top (select @count) Player
	from PlayerRecords 
where (@LeagueID=0 or LeagueID= @LeagueID)
  and ( (Forename like (@Word1 + '%') and Initials like (@Word2 + '%') and Surname like (@Word3 + '%')) or
        (Surname like (@Word1 + '%') and Initials like (@Word2 + '%') and Forename like (@Word3 + '%')) )

GO
