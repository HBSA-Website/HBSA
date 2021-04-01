USE [HBSA]
GO
/****** Object:  StoredProcedure [dbo].[DeletePlayer]    Script Date: 12/12/2014 17:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


alter procedure [dbo].[DeletePlayer]
	(@ID int
	,@User varchar(1024)=NULL
	)
as

set NoCount on

if (select top 1 1
	from MatchResults 
	where @ID=HomePlayer1ID
	   or @ID=HomePlayer2ID
	   or @ID=HomePlayer3ID
	   or @ID=HomePlayer4ID
	   or @ID=AwayPlayer1ID
	   or @ID=AwayPlayer2ID
	   or @ID=AwayPlayer3ID
	   or @ID=AwayPlayer4ID) = 1
	raiserror ('Cannot delete a player with a result card entry.',17,0)
else
	if (select Played from Players where ID=@ID)=1
		raiserror ('Cannot delete a player classed as having played.',17,0)	
	else	
		begin
		begin tran
		update Players 
			set ClubID=0, SectionID=0, Team=''
			where ID=@ID
		insert Activitylog values (dbo.UKdateTime(getUTCdate()),'Player deleted',@ID,isnull(@User,original_login()))
		commit tran
		end


GO
