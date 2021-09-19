select distinct email from Players where email like '%@ntlworld.com%'
union
select distinct emailaddress from ClubUsers where emailaddress like '%@ntlworld.com%'
union
select distinct emailaddress from ResultsUsers where emailaddress like '%@ntlworld.com%'
order by email
