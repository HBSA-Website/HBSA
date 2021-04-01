SELECT
DB_NAME(DB_ID()) [DB_Name],
TYPE,
COUNT(*)  AS Object_Count,
SUM(LinesOfCode) AS LinesOfCode
into #ymp
FROM (
SELECT
TYPE,
LEN(definition)- LEN(REPLACE(definition,CHAR(10),'')) AS LinesOfCode,
OBJECT_NAME(OBJECT_ID) AS NameOfObject
FROM sys.all_sql_modules a
JOIN sysobjects s
ON a.OBJECT_ID = s.id
-- AND xtype IN('TR', 'P', 'FN', 'IF', 'TF', 'V')
WHERE OBJECTPROPERTY(OBJECT_ID,'IsMSShipped') = 0
) SubQuery
GROUP BY TYPE
select * from #ymp
select SUM(LinesOfCode) from #ymp
drop table #ymp

declare @crlf nchar(2)
set @crlf = char(0x0d) + char(0x0a);
select [Schema]=schema_name(p.schema_id), [Proc_Name]=p.name
, Num_of_LineCode=(len(m.definition) -len(replace(m.definition, @crlf, ''))) /2
into  #tmp
from sys.sql_modules m
inner join sys.procedures p
on m.object_id = p.object_id;
select * from #tmp
select SUM(Num_of_LineCode) from #tmp
drop table #tmp

GO
select t.sp_name, sum(t.lines_of_code) - 1 as lines_ofcode, t.type_desc
into #t
from
(
    select o.name as sp_name, 
    (len(c.text) - len(replace(c.text, char(10), ''))) as lines_of_code,
    case when o.xtype = 'P' then 'Stored Procedure'
    when o.xtype in ('FN', 'IF', 'TF') then 'Function'
    end as type_desc
    from sysobjects o
    inner join syscomments c
    on c.id = o.id
    where o.xtype in ('P', 'FN', 'IF', 'TF')
    and o.category = 0
    and o.name not in ('fn_diagramobjects', 'sp_alterdiagram', 'sp_creatediagram', 'sp_dropdiagram', 'sp_helpdiagramdefinition', 'sp_helpdiagrams', 'sp_renamediagram', 'sp_upgraddiagrams', 'sysdiagrams')
) t
group by t.sp_name, t.type_desc
order by 1
select * from #t
select SUM(lines_ofcode) from #t
drop table #t