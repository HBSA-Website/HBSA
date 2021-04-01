use HBSA
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'EntryForm_State')
	drop function EntryForm_State
GO

create function EntryForm_State
	(@WIP int
	)
returns varchar(16)

as

--Public Enum WIP
--            NotEntered
--            InProgress
--            Submitted
--            Fixed
--        End Enum

begin

return case when @WIP = 0 then 'Not Entered'
            when @WIP = 1 then 'In Progress'
            when @WIP = 2 then 'Submitted'
            when @WIP = 3 then 'Fixed'
       end
	   
end

GO

select dbo.EntryForm_State(0),dbo.EntryForm_State(1),dbo.EntryForm_State(2),dbo.EntryForm_State(3),dbo.EntryForm_State(5)
