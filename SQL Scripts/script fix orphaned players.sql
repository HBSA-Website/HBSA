use hbsa
go
update players
	set sectionID=T.SectionID
 from players P
		join clubs C on C.ID=P.ClubID
		join teams T on T.ClubID=P.ClubID and T.Team=P.Team and T.SectionID between 1 and 5
where p.sectionID=6


