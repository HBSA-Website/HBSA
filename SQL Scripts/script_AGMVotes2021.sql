USE [HBSA]
GO
/****** Object:  Table [dbo].[AGM_Votes_Resolutions]    Script Date: 04/07/2021 11:36:50 ******/
DROP TABLE [dbo].[AGM_Votes_Resolutions]
GO
/****** Object:  Table [dbo].[AGM_Votes_Cast]    Script Date: 04/07/2021 11:36:50 ******/
DROP TABLE [dbo].[AGM_Votes_Cast]
GO
/****** Object:  Table [dbo].[AGM_Votes_Cast]    Script Date: 04/07/2021 11:36:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AGM_Votes_Cast](
	[ClubID] [int] NOT NULL,
	[ResolutionID] [int] NOT NULL,
	[For] [bit] NOT NULL,
	[Against] [bit] NOT NULL,
	[Withheld] [bit] NOT NULL,
 CONSTRAINT [PK_AGM_Votes_Cast] PRIMARY KEY CLUSTERED 
(
	[ClubID] ASC,
	[ResolutionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AGM_Votes_Resolutions]    Script Date: 04/07/2021 11:36:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AGM_Votes_Resolutions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ResolutionType] [varchar](60) NULL,
	[Resolution] [varchar](1000) NOT NULL
) ON [PRIMARY]
GO
truncate table [dbo].[AGM_Votes_Cast]
GO

SET IDENTITY_INSERT [dbo].[AGM_Votes_Resolutions] ON 

INSERT [dbo].[AGM_Votes_Resolutions] ([ID], [ResolutionType], [Resolution]) VALUES (1, N'Ordinary Resolutions', N'1. Acceptance of minutes of 2020 AGM')
INSERT [dbo].[AGM_Votes_Resolutions] ([ID], [ResolutionType], [Resolution]) VALUES (2, N'Ordinary Resolutions', N'2. Approve the Annual Report and Accounts ')
INSERT [dbo].[AGM_Votes_Resolutions] ([ID], [ResolutionType], [Resolution]) VALUES (3, N'Special Resolutions', N'<b>1.  Qualifying criteria for entering competitions.</b><br />Competition entrants must have played a minimum of 3 games in the current season OR 5 games in the current and last season combined.  (The ''3/5 rule''). This applies to all competitions, the only exception being where the entrant is under 18 years of age (and does not play in other leagues or competitions outside of HBSA). In this scenario the ''3/5 rule'' is waived.')
INSERT [dbo].[AGM_Votes_Resolutions] ([ID], [ResolutionType], [Resolution]) VALUES (4, N'Special Resolutions', N'<b>2.  AGM and meetings attendance.</b><br />If a Club is not represented at the November or March meetings, points deductions will not apply to their Vets team(s). <br /><br />
                            <i>{Clarification: (i) If a Club is not represented at the AGM, points deductions will continue to apply to every team in that Club, including Vets. (ii) This rule is for face to face meetings in ''normal'' times } </i>')
INSERT [dbo].[AGM_Votes_Resolutions] ([ID], [ResolutionType], [Resolution]) VALUES (5, N'Special Resolutions', N'<b>3.  Match postponements/cancellations.</b><br />Matches must be cancelled a minimum of 90 minutes prior to the match start time, otherwise the opposing team has the right to claim the match in full')
INSERT [dbo].[AGM_Votes_Resolutions] ([ID], [ResolutionType], [Resolution]) VALUES (6, N'Election or re-Election of Officers', N'2. Secretary – B Keenan')
INSERT [dbo].[AGM_Votes_Resolutions] ([ID], [ResolutionType], [Resolution]) VALUES (7, N'Election or re-Election of Officers', N'3. League Secretary – J Bastow')
INSERT [dbo].[AGM_Votes_Resolutions] ([ID], [ResolutionType], [Resolution]) VALUES (8, N'Election or re-Election of Officers', N'4. Competition Secretary – P Schofield')
INSERT [dbo].[AGM_Votes_Resolutions] ([ID], [ResolutionType], [Resolution]) VALUES (9, N'Election or re-Election of Officers', N'5. Treasurer – D Poutney')
INSERT [dbo].[AGM_Votes_Resolutions] ([ID], [ResolutionType], [Resolution]) VALUES (10, N'Election or re-Election of Officers', N'6. Auditors – B Keenan / R Taylor')
SET IDENTITY_INSERT [dbo].[AGM_Votes_Resolutions] OFF
