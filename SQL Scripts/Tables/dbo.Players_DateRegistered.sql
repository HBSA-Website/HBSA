alter table Players
	add dateRegistered date
alter table Players_Deleted
	add dateRegistered date
GO
update Players 
	set dateRegistered='1 Sep 2013'

update Players 
	set dateRegistered=dtlodged
from  Players
join  ActivityLog 
		on ID=KeyID
	where activity like '%player%'
	  and Keyid is not null

update Players_Deleted
	set dateRegistered='1 Sep 2013'

update Players_Deleted
	set dateRegistered=ActivityLog.dtlodged
from  Players_Deleted
join  ActivityLog 
		on ID=KeyID
	where activity like '%player%'
	  and Keyid is not null
