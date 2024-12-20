USE [HBSA]
GO

if exists (select TABLE_NAME from INFORMATION_SCHEMA.TABLES where TABLE_NAME='ActivityLogMetadata')
	DROP TABLE [dbo].[ActivityLogMetadata]
GO
/****** Object:  Table [dbo].[ActivityLogMetadata]    Script Date: 04/03/2018 18:06:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ActivityLogMetadata](
	[Procedure] [varchar](255) NULL,
	[Key words] [varchar](255) NULL,
	[Action] [varchar](255) NULL,
	[KeyIDUse] [varchar](255) NULL,
	[Comment] [varchar](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'AddPayment', N'Payment Added', N'Payment added', N'ClubID', N'')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'ApplyEntryForms', N'Apply Entry Forms', N'Apply Entry Forms', N'N/A', N'')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'confirmClubLogin', N'ConfirmClubUser', N'Club User Confirmation', N'N/A', N'byWhom indicates user')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'confirmLogin', N'ConfirmUser', N'Team User Confirmation', N'N/A', N'byWhom indicates user')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'CreateUser', N'insert user', N'Team user Registered', N'N/A', N'byWhom indicates user')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'DeleteBreak', N'delete Match Break', N'Break deleted', N'BreakID', N'Maybe the result of result card change')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'deleteLogin', N'DeleteUser', N'Team User deregistered', N'N/A', N'byWhom indicates user')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'deleteMatchResult', N'delete match result', N'Match Result deleted', N'MatchResultID', N'Activity contains team IDs. Maybe the result of result card change')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'DeletePlayer', N'Player deleted', N'Player deleted', N'PlayerID', N'')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'EntryForm_TransferPlayer', N'EntryForm transfer player', N'EntryForm transfer player', N'ClubID', N'Activity contains PlayerID, ClubIDs and teamIDs')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'EntryForm_UpdateFeePaid', N'EntryForm Feepaid Changed', N'EntryForm Feepaid Changed', N'ClubID', N'')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'EntryForm_UpdateWIP', N'EntryForm WIP Change to', N'EntryForm WIP Change to', N'ClubID', N'Indicates status on an entry form')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'insertMatchBreak', N'insert Match Break', N'Break added', N'BreakID', N'Usually in result card submission')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'insertMatchResult', N'insert match result', N'Match Result Entered', N'MatchResultID', N'')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'LogActivity', N' email to ', N'Send email', N'N/A', N'Activity contains email type plus recipients')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'MergeClubUser', N'Merge Club user', N'Change to Club User', N'N/A', N'byWhom indicates user')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'MergePlayer', N'Player merged from Admin', N'Player Maintenance', N'PlayerID', N'merged = changed or added')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'updateLogin', N'Update password', N'Team login password change', N'N/A', N'byWhom indicates user')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'UpdatePayment', N'Amount paid merged', N'Amount paid changed or added', N'ClubID', N'Activity contains PaymentID')
GO
INSERT [dbo].[ActivityLogMetadata] ([Procedure], [Key words], [Action], [KeyIDUse], [Comment]) VALUES (N'WebRegisterPlayer', N'Player registered from Web', N'New player registered', N'PlayerID', N'From a result card')
GO

select * from ActivityLogMetadata