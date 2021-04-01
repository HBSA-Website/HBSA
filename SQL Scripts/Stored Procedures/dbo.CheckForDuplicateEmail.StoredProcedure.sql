USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'CheckForDuplicateEmail')
	drop procedure CheckForDuplicateEmail
GO

CREATE procedure CheckForDuplicateEmail
	(@Sender varchar(255)
	,@ToAddresses varchar(1024)
	,@Subject varchar(255)
	,@Body varchar(max)
	)
as

set nocount on

--select * from eMailLog order by dtlodged desc
select case when exists(
						select dtLodged 
							from eMailLog 
							where Sender=@Sender
							  and ToAddresses=@ToAddresses
							  and [subject]=@Subject
							  and body=@Body
							  and dtlodged > dateadd(day,-1, dbo.UKdateTime(getUTCdate()))
							  )
	        then 1 
			else 0 
		end
GO
exec CheckForDuplicateEmail
'website@huddersfieldsnooker.com' ,
'johnwilson556@virginmedia.com;webmaster@huddersfieldsnooker.com'  ,
'Match result from New Mill Club B' ,
'Result Card from New Mill Club B<br /><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
</head>
<body>
   <table  width="789" style="border: 1px solid #000000">
   <tr>
   <td style="font-family: Arial, Helvetica, sans-serif; font-size: medium; font-weight: bold; text-align: center">Huddersfield Billiards and Snooker Association  League 
   </td>
   </tr>
    </table>
   <table  width="789" style="border: 1px solid #000000">
        <colgroup>
            <col width="79" />
            <col width="64" />
            <col width="233" />
            <col width="25" />
            <col width="233" />
            <col span="2" width="64" />
        </colgroup>

        <tr height="20">
            <td height="20" colspan="2" style="border: 1px solid #000000; text-align: center;">
                <strong>Fixture date</strong></td>
            <td width="233" style="border: 1px solid #000000; text-align: right;">
                SECTION &gt;</td>
            <td style="border: 1px solid #000000">Veterans Snooker 3         </td>
            <td width="233" style="border: 1px solid #000000">
                &lt;
                SECTION</td>
            <td height="20" colspan="2" style="border: 1px solid #000000; text-align: center;">
                <strong>Match date</strong></td>
        </tr>

        <tr height="20">
            <td colspan="2" rowspan="2" style="border: 1px solid #000000; text-align: center;">03 Oct 2016</td>
            <td style="border: 1px solid #000000; text-align: right;">Home Team</td>
            <td rowspan="7" style="border: 1px solid #000000; text-align: center;">&nbsp;</td>
            <td style="border: 1px solid #000000">Away Team</td>
            <td colspan="2" rowspan="2" style="border: 1px solid #000000; text-align: center;">
                03 Oct 2016</td>
        </tr>
        <tr height="40">
            <td style="border: 1px solid #000000; text-align: right;">New Mill Club B</td>
            <td style="border: 1px solid #000000">Moldgreen Con A</td>
        </tr>
        <tr height="20">
            <td height="20" style="border: 1px solid #000000; text-align: center;">H&#39;Cap</td>
            <td style="border: 1px solid #000000; text-align: center;">Score</td>
            <td style="border: 1px solid #000000; text-align: center;">Home Players&#39; Names</td>
            <td style="border: 1px solid #000000; text-align: center;">Away Players&#39; Names</td>
            <td style="border: 1px solid #000000; text-align: center;">H&#39;Cap</td>
            <td style="border: 1px solid #000000; text-align: center;">Score</td>
        </tr>
        <tr>
            <td height="20" style="border: 1px solid #000000; text-align: center;">6</td>
            <td style="border: 1px solid #000000; text-align: center;">41</td>
            <td style="border: 1px solid #000000; text-align: center;">John Ashworth (Not played yet)</td>
            <td style="border: 1px solid #000000; text-align: center;">Len Firth</td>
            <td style="border: 1px solid #000000; text-align: center;">19</td>
            <td style="border: 1px solid #000000; text-align: center;">74</td>
        </tr>
        <tr>
            <td height="20" style="border: 1px solid #000000; text-align: center;">20</td>
            <td style="border: 1px solid #000000; text-align: center;">45</td>
            <td style="border: 1px solid #000000; text-align: center;">Ted Ingham</td>
            <td style="border: 1px solid #000000; text-align: center;">Marten Hussain</td>
            <td style="border: 1px solid #000000; text-align: center;">14</td>
            <td style="border: 1px solid #000000; text-align: center;">53</td>
        </tr>
        <tr>
            <td height="20" style="border: 1px solid #000000; text-align: center;">10</td>
            <td style="border: 1px solid #000000; text-align: center;">46</td>
            <td style="border: 1px solid #000000; text-align: center;">Robert Barlow</td>
            <td style="border: 1px solid #000000; text-align: center;">Trevor Sykes</td>
            <td style="border: 1px solid #000000; text-align: center;">19</td>
            <td style="border: 1px solid #000000; text-align: center;">77</td>
        </tr>
        <tr>
            <td height="20" style="border: 1px solid #000000; text-align: center;"></td>
            <td style="border: 1px solid #000000; text-align: center;"></td>
            <td style="border: 1px solid #000000; text-align: center;"></td>
            <td style="border: 1px solid #000000; text-align: center;"></td>
            <td style="border: 1px solid #000000; text-align: center;"></td>
            <td style="border: 1px solid #000000; text-align: center;"></td>
        </tr>

        <tr>
            <td width="233" style="border: 1px solid #000000;" colspan="3">
                <strong>Breaks</strong><br />&nbsp;</td>
            <td style="border: 1px solid #000000"></td>
            <td width="233" style="border: 1px solid #000000;" colspan="3">
                <Strong>Breaks</Strong><br /> &nbsp;</td>
        </tr>
        <tr height="22">
            <td height="28" colspan="3" style="border: 1px solid #000000; text-align: right;">Frames&nbsp;&nbsp;0</td>
            <td style="border: 1px solid #000000"></td>
            <td colspan="3" style="border: 1px solid #000000">3&nbsp;&nbsp; Frames </td>
        </tr>
    </table>

</body>
</html>
<br/><br/>'  
	