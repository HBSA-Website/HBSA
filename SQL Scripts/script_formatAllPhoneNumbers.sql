USE [HBSA]
GO

if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'FormatPhoneNo')
	drop function dbo.FormatPhoneNo
GO

CREATE FUNCTION dbo.FormatPhoneNo 
	(@phoneNo varchar(20)
	)
RETURNS varchar(20)
AS
--UK Phone No. Formatting:   
--Note all numbers start with 0 access code followed by 9 or 10 digits
--Number starts	Type	                                         	Recommended format
-- 	01	Landlines (geographic)		    01x1 xxx xxxx   (11)	Most other major cities
--										011x xxx xxxx   (11)	Other major cities	
--										01xxx xxxxxx    (11)	Smaller cities, provincial towns and rural areas	
--										01xxx xxxxx     (10)	Smaller cities, provincial towns and rural areas
--										01xxxx xxxxx    (11)	Rural north west England and Borders	
--										01xxxx xxxx     (10)	Rural north west England and Borders	
--	02	Landlines (geographic)		    02x xxxx xxxx   (11) Cardiff, Coventry, London, Portsmouth, Southampton and all of Northern Ireland
--	03	Landlines (non-geographic)	    03xx xxx xxxx   (11)
--	04	Not used	-
--	05	Corporate numbering and VOIP    05xxx xxxxxx    (11)
--	06	Not used	- 
--	07	Mobiles, pagers and personal    07xxx xxxxxx    (11)
--	08	Service numbers (special rates)	08xx xxx xxxx   (11)
--	09	Service numbers (premium rates)	09xx xxx xxxx   (11)
--  xxxxxx 6 digit numbers assume huddersfield landline, return as 01484 xxxxxx

BEGIN
declare @work varchar(20)

-- remove spaces
set @work = replace (@phoneNo,' ','')
if @work LIKE '%[^0-9+]%'
	set @work='inv num ' + @phoneNo
else
begin
--normalise the number to international or UK
if len(@work) = 6
	set @work = '01484' + @work
else if substring(@work,1,3) = '+44'
	set @work='0' + substring(@work,4,len(@work) - 3)
else if substring(@work,1,4) = '0044'
	set @work='0' + substring(@work,5,len(@work) - 4)
else if substring(@work,1,1) = '+'
	set @work=@work
else if substring(@work,1,2) = '00'
	set @work='+' + substring(@work,3,len(@work) - 2)
else if substring(@work,1,1) <> '0'
	set @work = '0' + @work

--check length
if substring (@work,1,1) <> '+'  --ignore international, leave alone
	begin

	if substring(@work,2,1) = '1'  --UK landline
		if substring(@work,3,1) = '1' or  substring(@work,4,1) = '1'
			if len(@work) <> 11
				set @work = 'inv len ' + @phoneNo
            else
			    set @work = substring(@work,1,4) +' '+ substring(@work,5,3) +' '+ substring(@work,8,3)
        else 
	        if len(@work) between 10 and 11
				set @work = substring(@work,1,5) +' '+ substring(@work,6,len(@work)-5)
			else
				set @work = 'inv len ' + @phoneNo
	else
	if len(@work) <> 11 -- all other numbers must be 11 long
		set @work = 'inv len ' + @phoneNo
    else
	if substring(@work,2,1) = '2'
		set @work = substring(@work,1,3) +' '+ substring(@work,4,4) +' '+ substring(@work,8,4)
    else
	if substring(@work,2,1) = '3'
		set @work = substring(@work,1,4) +' '+ substring(@work,5,3) +' '+ substring(@work,8,4)
    else
	if substring(@work,2,1) = '4' -- not used
		set @work = 'not used ' + @phoneNo
    else
	if substring(@work,2,1) = '5'
		set @work = substring(@work,1,5) +' '+ substring(@work,6,6)
    else
	if substring(@work,2,1) = '6' -- not ised
		set @work = 'not used ' + @phoneNo
    else
	if substring(@work,2,1) = '7'
		set @work = substring(@work,1,5) +' '+ substring(@work,6,6)
    else
	if substring(@work,2,1) = '8'
		set @work = substring(@work,1,4) +' '+ substring(@work,5,3) +' '+ substring(@work,8,4)
    else
	if substring(@work,2,1) = '9'
		set @work = substring(@work,1,4) +' '+ substring(@work,5,3) +' '+ substring(@work,8,4)
	else
		set @work = 'not known ' + @phoneNo

	end
else
	set @work = substring(@work,1,4) +' '+ substring(@work,5,3) +' '+ substring(@work,8,4)

end

return @work

END

GO

		update Clubs
			set ContactMobNo = dbo.FormatPhoneNo(ContactMobNo)
			where ContactMobNo <> '' 
			  and dbo.FormatPhoneNo(ContactMobNo) not like 'i%' 

		update Clubs
			set ContactTelNo = dbo.FormatPhoneNo(ContactTelNo)
			where ContactTelNo <> '' 
			  and dbo.FormatPhoneNo(ContactTelNo) not like 'i%' 

		update ClubUsers
			set Telephone = dbo.FormatPhoneNo(Telephone)
			where Telephone <> '' 
			  and dbo.FormatPhoneNo(Telephone) not like 'i%' 

		update Players
			set TelNo = dbo.FormatPhoneNo(TelNo)
			where TelNo <> '' 
			  and dbo.FormatPhoneNo(TelNo) not like 'i%' 

		update ResultsUsers
			set Telephone = dbo.FormatPhoneNo(Telephone)
			where Telephone <> '' 
			  and dbo.FormatPhoneNo(Telephone) not like 'i%' 

		update Teams
			set TelNo = dbo.FormatPhoneNo(TelNo)
			where TelNo <> '' 
			  and dbo.FormatPhoneNo(TelNo) not like 'i%' 

		update Teams_Removed
			set TelNo = dbo.FormatPhoneNo(TelNo)
			where TelNo <> '' 
			  and dbo.FormatPhoneNo(TelNo) not like 'i%' 
