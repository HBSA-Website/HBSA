select * from MatchBreaks where MatchResultID = 153
select * from MatchResults where ID  = 153
exec ResultsCard 153

select   B.ID
        ,Player=Forename + case when Initials <> '' then Initials + '. ' else ' ' end + Surname
		,B.* 
	    ,HA=Case when PlayerID = HomePlayer1ID
		           or PlayerID = HomePlayer2ID
		           or PlayerID = HomePlayer3ID
		           or PlayerID = HomePlayer3ID 
				      then 'Home' else 'Away'
		    end		   		
	from Breaks B
	left join Players P on P.ID = B.PlayerID
	left join MatchResults R on R.ID=B.MatchResultID 
	order by HA desc
GO