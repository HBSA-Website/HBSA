USE HBSA
go

begin tran
drop table News
drop procedure UpdateNews

create table HomeContent
	(ID int identity (1,1)
	,Title varchar (64)
	,ArticleHTML varchar(max)
	,dtLodged datetime
	)

delete from Content where ContentName='Home'
commit tran

GO
SET IDENTITY_INSERT [dbo].[HomeContent] ON 
GO
INSERT [dbo].[HomeContent] ([ID], [Title], [ArticleHTML], [dtLodged]) VALUES (1, N'HELP needed on our website:', N'<span style="font-size: 11pt; line-height: 15.4px; font-family: arial, sans-serif; color: navy; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">We are at risk: should our web site technician become ill or unavailable for any reason our website could stagnate.&nbsp;</span><span style="font-size: 11pt; line-height: 15.4px; font-family: arial, sans-serif; color: navy;"><br />
<br />
<span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">Therefore we are still looking for an additional (voluntary) member to work with our web technician and help with the web site maintenance and development. &nbsp;The current technician is happy to act as a mentor to gradually hand over the reins. &nbsp;This is a superb opportunity for someone to develop and extend his or her IT skills. &nbsp;He or she could learn how to develop windows based computer web applications that use a database.&nbsp;<br />
<br />
If you are interested contact Pete Gilbert (email:&nbsp;</span></span><a href="mailto:gilbertp@outlook.com" style="font-size: 13.3333px;"><span style="font-size: 11pt; line-height: 15.4px; font-family: arial, sans-serif; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">gilbertp@outlook.com</span></a><span style="font-size: 11pt; line-height: 15.4px; font-family: arial, sans-serif; color: navy; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">) or phone 07890 032041</span>', CAST(N'2016-01-01T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[HomeContent] ([ID], [Title], [ArticleHTML], [dtLodged]) VALUES (2, N'Email address changes', N'<span style="color: #000080; font-family: arial, sans-serif; font-size: 14.6667px;">If you have changed your email address we can easily change all instances of it on our system. Simply use the Contact Us Page and supply us with the old email address and the new email address and we will change all instances from the old to the new. This includes team and club registrations.</span>', CAST(N'2018-09-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[HomeContent] ([ID], [Title], [ArticleHTML], [dtLodged]) VALUES (3, N'Contacting opponents in competitions', N'<span style="color: #000080; font-family: arial, sans-serif; font-size: 14.6667px;">This is easily possible using the web site. Navigate to Competitions &gt;&gt; The Draw, results, dates etc. Then select the competition you want to check. Then locate the opponent you are drawn against: move the mouse pointer to the opponent, or touch the opponent if you are using a touch screen: that will bring up a small box with your opponent''s email and/or phone number.</span>', CAST(N'2018-10-01T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[HomeContent] ([ID], [Title], [ArticleHTML], [dtLodged]) VALUES (5, N'Vets Age Qualification', N'<span style="color: #000080; font-family: arial, sans-serif; font-size: 14.6667px;">All players must be aged 60 or over before they can play. If a player''s 60</span><sup style="color: #000080; font-family: arial, sans-serif;">th</sup><span style="color: #000080; font-family: arial, sans-serif; font-size: 14.6667px;">&nbsp;birthday occurs during the season, he/she cannot play before his/her 60</span><sup style="color: #000080; font-family: arial, sans-serif;">th</sup><span style="color: #000080; font-family: arial, sans-serif; font-size: 14.6667px;">&nbsp;birthday.</span>', CAST(N'2018-10-01T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[HomeContent] ([ID], [Title], [ArticleHTML], [dtLodged]) VALUES (6, N'GDPR', N'<span style="font-size: 10pt;">In line with GDPR we have published our privacy policy.&nbsp; To view it go to H.B.S. &amp;&nbsp;</span><a href="https://huddersfieldsnooker.com/admin/InfoPage.aspx?Subject=Privacy%20Statement&Title=Privacy%20Policy" target="_self" style="font-size: 10pt;">Association &gt;&gt; Privacy Policy</a><span style="font-size: 10pt;">.</span>', CAST(N'2019-05-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[HomeContent] ([ID], [Title], [ArticleHTML], [dtLodged]) VALUES (7, N'Conduct and Behaviour of players', N'<div style="font-size: 13.3333px;"><span style="font-size: 10pt;">At the AGM on Monday 17th June held at Lindley Liberal Club; the subject of the conduct and behaviour of players in Competition &amp; League matches during recent years was discussed, as this was now giving cause for concern.&nbsp;Certain individuals and teams had resorted to inappropriate behaviour which was considered less than that expected by the Association.&nbsp;At a recent Competition Final one of the participants had to be warned that their conduct was totally unacceptable.&nbsp;The meeting unanimously agreed that a letter be sent to that individual regarding future conduct and should there be any further similar instances then this would lead to an automatic ‘ban’ from playing in any future Competitions and League matches promoted by the Huddersfield Billiards &amp; Snooker Association.<br />
<br />
</span></div>
<div style="font-size: 13.3333px;"><span style="font-size: 10pt;">Below is an extract from that letter and the Association would like all member clubs to post this on their Notice Boards and discuss it at their relevant Committee Meetings indicating that our Association will not tolerate this kind of conduct in the future.</span><br />
<br />
</div>
<div style="font-size: 13.3333px;"><span style="font-style: italic; font-size: 10pt;">During the course of that match you constantly made inappropriate comments regarding Refereeing decisions; together with showing lack of respect for your opponent and on occasions to the spectators present, with vulgar gestures and bad language.&nbsp;&nbsp;Eventually this became so bad that you were verbally warned by the Match Official present, that this behaviour was totally unacceptable.&nbsp;It also transpired later that this was not the first occasion; but that there had been a similar occurrence at a previous years Final, involving spectators. However you were not warned on that occasion and no action was taken.&nbsp;</span><span style="font-size: 12pt; font-style: italic; color: #0000ff;">We will, in future, give full support to all our Referees involved in H.B &amp; S.A matches, who have to take any necessary course of action to limit this behavior</span><span style="font-size: 10pt; font-style: italic;">.&nbsp;Therefore, the Association are sending you this written warning, that should your conduct fall below acceptable standards in any future Competition or League matches; we will have no alternative other than to impose a ‘</span><span style="font-size: 12pt; font-style: italic; color: #0000ff;">ban</span><span style="font-size: 10pt; font-style: italic;">’ on your involvement in any future matches promoted by the Huddersfield Billiards &amp; Snooker Association.</span></div>', CAST(N'2019-05-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[HomeContent] ([ID], [Title], [ArticleHTML], [dtLodged]) VALUES (4, N'Submitting and changing results', N'<span style="font-size: 11pt; font-family: arial, sans-serif; color: navy; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">There have been several instances of teams not being able to submit results because the&nbsp;</span><span style="font-size: 11pt; font-family: arial, sans-serif; color: red; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">member that enters results is unavailable. THIS CAN BE DONE BY SOMEONE ELSE</span><span style="font-size: 11pt; font-family: arial, sans-serif; color: navy; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">. Team logins can have several registrations to a team (as opposed to club logins). Provided you have an email address that you can use, go to the&nbsp;</span><a href="http://huddersfieldsnooker.com/LoginRegistration.aspx" style="font-size: 13.3333px;"><span style="font-size: 11pt; font-family: arial, sans-serif; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">team login page and click Register</span></a><span style="font-size: 11pt; font-family: arial, sans-serif; color: navy; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">, then follow on screen instructions.</span><span style="font-size: 11pt; font-family: arial, sans-serif; color: navy;"><br />
<br />
<span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">There have also been a few instances where the entered&nbsp;</span></span><span style="font-size: 11pt; font-family: arial, sans-serif; color: red; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">result contains a mistake. THIS CAN BE CORRECTED</span><span style="font-size: 13.3333px; color: navy; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">&nbsp;</span><span style="font-size: 11pt; font-family: arial, sans-serif; color: navy; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">by logging in and going to the result card page in exactly the same way as the result was originally submitted. When the match date is selected you will see the form completed with the information originally entered. Then change and data that is wrong, click ''</span><span style="font-size: 11pt; font-family: arial, sans-serif; color: green; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">Check your results</span><span style="font-size: 11pt; font-family: arial, sans-serif; color: navy; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">'' card, then click ''</span><span style="font-size: 11pt; font-family: arial, sans-serif; color: green; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">Send the results to HBSA</span><span style="font-size: 11pt; font-family: arial, sans-serif; color: navy; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">''.</span>', CAST(N'2019-05-22T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[HomeContent] ([ID], [Title], [ArticleHTML], [dtLodged]) VALUES (8, N'TOP HONOUR FOR PAUL SCHOFIELD', N'<span style="font-size: 13.3333px;">Paul Schofield who has become one of our top referees has been honoured by being chosen to referee this years Yorkshire snooker championship final at the Northern Snooker Centre in Leeds on May 31</span><sup>st</sup><span style="font-size: 13.3333px;">.&nbsp;<br style="font-size: 13.3333px;" />
<br style="font-size: 13.3333px;" />
This years final will be contested by Jonathan Bagley (Leeds) who has won this event for this last two years and Dave Portman (Sheffield ) who is also a previous winner of this competition.&nbsp;<br style="font-size: 13.3333px;" />
<br style="font-size: 13.3333px;" />
We would like To congratulate Paul on this achievement and wish him continued success in the future.</span>', CAST(N'2019-05-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[HomeContent] ([ID], [Title], [ArticleHTML], [dtLodged]) VALUES (9, N'John Bastow''s super stats', N'<p style="font-size: 13.3333px; margin: 0px;">John Bastow who is one of Huddersfield''s top Snooker &amp; Billiards players, and who is also a WPBSA qualified coach is developing a &quot;Super Stats&quot; feature for the HBSA league match results.&nbsp; These can be found on his website at&nbsp;</p><a href="https://www.johnbastowsnooker.co.uk/hbsa-stats" target="_self" style="font-size: 13.3333px;">https://www.johnbastowsnooker.co.uk/hbsa-stats</a><span style="font-size: 13.3333px;">.&nbsp; There will also be a link in the league drop down menu.</span>', CAST(N'2019-06-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[HomeContent] ([ID], [Title], [ArticleHTML], [dtLodged]) VALUES (10, N'John Bastow elected to the Committee', N'<span style="font-size: 14.6667px;">We are please to announce that&nbsp;</span><span style="font-size: 14.6667px; color: #0000ff;">John Bastow has been elected to the Committee</span><span style="font-size: 14.6667px; color: #3300ff;">&nbsp;</span><span style="font-size: 14.6667px;">to the post of Website Manager.&nbsp; For the foreseeable future he will be working with Peter Gilbert who has been responsible for the development of the Website during the past few years.&nbsp; John is a well known and respected figure within the Huddersfield Billiards &amp; Snooker Association and will bring a wealth of experience to our committee in the future.</span>', CAST(N'2019-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[HomeContent] ([ID], [Title], [ArticleHTML], [dtLodged]) VALUES (11, N'League Entry forms are available', N'<p style="font-size: 13.3333px; margin: 0px;"><span style="font-size: 13.3333px;">The online league entry forms are now available.&nbsp; Either click on On line leagues entry form and complete your entry, or click Leagues &gt;&gt; Entry Form Download, download the appropriate form(s), complete them and post them to the league secretary.</span></p>
<p style="font-size: 13.3333px; margin: 0px;"><br />
<span style="font-size: 14pt; color: #ff0000; font-weight: bold;">Entries must be received by midnight Sunday 28th July 2019.</span><span style="font-size: 13.3333px;">&nbsp; Online forms are received when the Submit button is clicked.</span></p>
<p style="font-size: 13.3333px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; margin-bottom: 0.0001pt;"><span style="font-size: 11pt; font-family: arial, sans-serif; color: navy; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">Fees should be paid when an entry is submitted/posted.&nbsp; To pay by cheque please make the cheque payable to HBSA, and write your club''s name on the back along with the reason for payment. Send the cheque to the league secretary, or treasurer.</span></p>
<p style="font-size: 13.3333px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; margin-bottom: 0.0001pt;"><span style="font-size: 11pt; font-family: arial, sans-serif; color: navy; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;"><br />
To pay by internet banking the details you need are as follows:&nbsp;</span></p>
<p style="font-size: 13.3333px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; margin-bottom: 0.0001pt;"><span style="font-size: 11pt; font-family: arial, sans-serif; color: navy; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;"><span style="color: #000000; font-size: 16px;">Bank:&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Barclays<br />
Account:&nbsp; &nbsp; &nbsp; &nbsp;HBSA<br />
Sort Code:&nbsp; &nbsp; 20-43-04<br />
Account No. 10523232<br />
Reference&nbsp; &nbsp;&nbsp;</span><span style="color: #000000; font-size: 16px; font-style: italic;">Use your own club''s name</span></span></p>
<p style="font-size: 13.3333px; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; margin-bottom: 0.0001pt;"><i><span style="font-size: 11pt; font-family: arial, sans-serif; color: red; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">When a payment is made please inform<a href="https://huddersfieldsnooker.com/InfoPage.aspx?Subject=Officials&Title=Officials" target="_self">&nbsp;the league secretary, or the treasurer</a>&nbsp;for the purpose of keeping the records up to date.)</span></i></p>', CAST(N'2019-07-01T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[HomeContent] OFF
GO


USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'HomePageArticle')
	drop procedure dbo.HomePageArticle
GO

create procedure dbo.HomePageArticle
	(@ID as integer
	)
as	

set nocount on

select * 
	from HomeContent
	where ID = @ID

GO

USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'HomePageMerge')
	drop procedure dbo.HomePageMerge
GO

create procedure dbo.HomePageMerge
	(@ID as integer
	,@Title as varchar(64)
	,@ArticleHTML as varchar(max)
	)
as	

set nocount on
set xact_abort on

MERGE HomeContent AS target
    USING (SELECT abs(@ID), @Title, @ArticleHTML) AS source (ID, Title, ArticleHTML)
    
    ON (target.ID = source.ID)
    
    WHEN MATCHED AND @ID < 0 THEN
		DELETE

	WHEN MATCHED THEN 
        UPDATE SET
			 Title=@Title
			,ArticleHTML=@ArticleHTML
			,dtLodged=getdate()
             		
    WHEN NOT MATCHED AND @ID=0 THEN    
		INSERT	(Title, ArticleHTML, dtLodged)
		VALUES (@Title, @ArticleHTML, getdate())
	;

GO

USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'HomePageArticles')
	drop procedure HomePageArticles
GO

create procedure dbo.HomePageArticles

as	

set nocount on

select ID, Title, [Date recorded]=convert (varchar(11),dtLodged,113) 
	from HomeContent
	order by ID desc

GO
USE [HBSA]
GO
if exists (select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'HomePageDeleteALL')
	drop procedure HomePageDeleteALL
GO

create procedure dbo.HomePageDeleteALL

as	

set nocount on

truncate table HomeContent

GO

