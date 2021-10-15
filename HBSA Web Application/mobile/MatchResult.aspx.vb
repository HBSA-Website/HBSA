Imports HBSAcodeLibrary
Public Class MatchResult1
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'GoDaddy will terminate the application on a 5 minute timeout
        'despite web.config settings. It has become apparent that some users are
        'experiencing this so:
        'preserve session user values in the client page
        If Not IsPostBack Then

            SessionEmail.Value = Session("Email")
            SessionPassword.Value = Session("Password")
            SessionUserID.Value = Session("UserID")
            SessionUserName.Value = Session("UserName")
            If Not IsNothing(Session("adminDetails")) AndAlso Session("adminDetails").Rows.count > 0 Then
                SessionAdminEmail.Value = Session("adminDetails").rows(0).item("email")
                AdminActionsDiv.Visible = True
            Else
                SessionAdminEmail.Value = ""
                AdminActionsDiv.Visible = False
            End If

            SessionTeamID.Value = Session("TeamID")
            SessionUser.Value = If(Session("user") Is Nothing, Session("AdminUser"), Session("user"))

        End If

        Dim adminLoggedIn As Boolean = (Not SessionAdminEmail.Value = "")
        Dim userLoggedIn As Boolean = False

        If Not adminLoggedIn Then
            Dim TodaysDate As Date = Utilities.UKDateTimeNow
            Using Season As New HBSAcodeLibrary.FixturesData
                Dim DaySinceSeasonEnd As Integer = DateDiff(DateInterval.Day, Season.EndOfSeason, TodaysDate)
                If DaySinceSeasonEnd > 7 Then 'cannot enter match result more than a weeks after the season end
                    MessageDiv.InnerHtml = "<br/><span style='color:red;text-size:larger'>" &
                          "<b>The match cannot be entered or changed more than a week after the season finishes.<br/><br/>" &
                          "If you believe the match was played within within this restriction, or was sanctioned by the " &
                          "league secretary you should send the full result to the league secretary. " &
                          "The secretary will verify, And if OK, enter the result on your behalf.</span></b><br /><br />"

                    MessageDiv.Visible = True
                    Match_Panel.Visible = False
                    Exit Sub

                End If

            End Using


        End If

        If HBSAcodeLibrary.HBSA_Configuration.CloseSeason OrElse HBSAcodeLibrary.HBSA_Configuration.AllowLeaguesEntryForms Then
            If Not adminLoggedIn Then
                Session("LoginCaller") = "Home.aspx"
                Response.Redirect("Home.aspx")
            End If

        ElseIf SessionTeamID.Value = "" Then
            If Not adminLoggedIn Then
                Session("LoginCaller") = "mobile/MatchResult.aspx"
                Response.Redirect("Login.aspx")
            End If

        Else
            Using User As New HBSAcodeLibrary.UserData(SessionEmail.Value, SessionPassword.Value)
                If Not User.Confirmed Then
                    If Not adminLoggedIn Then
                        Session("LoginCaller") = "mobile/MatchResult.aspx"
                        Response.Redirect("Login.aspx")
                    End If
                Else
                    userLoggedIn = True
                End If
            End Using

        End If

        If Not IsPostBack Then

            PopulateSections()

            If userLoggedIn Then
                Using TeamData As New HBSAcodeLibrary.TeamData(SessionTeamID.Value)
                    With TeamData
                        Section_DropDownList.SelectedValue = .SectionID
                        Section_DropDownList_SelectedIndexChanged(sender, e)
                        HomeTeam_DropDownList.SelectedValue = TeamData.ID
                    End With

                End Using

                PopulateFixtureDates(SessionTeamID.Value)

            End If

            Section_DropDownList.Enabled = adminLoggedIn
            HomeTeam_DropDownList.Enabled = adminLoggedIn

            InitBoxes()

            status_Literal.Text = ""
            Send_Button.Text = "Check your results card"

        End If

    End Sub

    Protected Sub PopulateSections()

        Section_DropDownList.Items.Clear()
        HomeTeam_DropDownList.Items.Clear()
        AwayTeam_Literal.Text = ""

        Using SectionsTable As DataTable = HBSAcodeLibrary.LeagueData.GetSections(0)

            With Section_DropDownList
                .Items.Clear()
                .Visible = True

                If SectionsTable.Rows.Count > 1 Then
                    .Items.Add("**Select a division/section**")
                End If

                For Each row As DataRow In SectionsTable.Rows
                    .Items.Add(New ListItem(row.Item("Section Name"), row.Item("ID")))
                Next

                If SectionsTable.Rows.Count < 2 Then
                    .Enabled = False
                    Section_DropDownList_SelectedIndexChanged(New Object, New Object)
                Else
                    .Enabled = True
                End If

                .SelectedIndex = 0

            End With

        End Using


    End Sub

    Sub EnablePanel(formPanel As Object)

        For Each ctl As Control In PanelsDiv.Controls
            If TypeOf ctl Is Panel Then
                If ctl.ClientID = formPanel.ID Then
                    ctl.Visible = True
                    If ctl.ClientID.ToLower Like "*frame*" Then
                        Dim PlayerID As Integer = 0
                        For Each box As Control In ctl.Controls
                            If box.ClientID.ToLower Like "*player*" Then
                                If CType(box, DropDownList).SelectedValue.Split("|")(0) = " " Then
                                    PlayerID = 0
                                Else
                                    PlayerID = CType(box, DropDownList).SelectedValue.Split("|")(0)
                                End If
                            End If
                            If box.ClientID.ToLower Like "*score*" Then
                                If PlayerID < 0 Then
                                    CType(box, TextBox).Text = PlayerID Mod 2 + 2
                                    CType(box, TextBox).Enabled = False
                                End If
                            End If
                        Next
                    End If
                Else
                    ctl.Visible = False
                End If
            End If
        Next

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        InitBoxes()

        If Section_DropDownList.SelectedValue.StartsWith("**") Then

            HomeTeam_DropDownList.Items.Clear()
            AwayTeam_Literal.Text = ""

            MatchDetails_Literal.Text = ""
            EnablePanel(Match_Panel)


        Else

            Using TeamList As DataTable = HBSAcodeLibrary.SharedRoutines.TeamList(Section_DropDownList.SelectedValue)
                With HomeTeam_DropDownList
                    .Items.Clear()
                    .Items.Add(New ListItem("** Select a home team **", 0))
                    For Each row As DataRow In TeamList.Rows
                        .Items.Add(New ListItem(row!Team, row!ID))
                    Next
                End With

            End Using

        End If

    End Sub

    Protected Sub HomeTeam_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) _
        Handles HomeTeam_DropDownList.SelectedIndexChanged

        PopulateFixtureDates(HomeTeam_DropDownList.SelectedValue)
        InitBoxes()

    End Sub

    Sub PopulateFixtureDates(ByVal TeamID As Integer)

        With FixtureDate_DropDownList

            .Items.Clear()
            .Items.Add(New ListItem("** Select a fixture date **", 0))

            Using FixtureDates As DataTable = HBSAcodeLibrary.FixturesData.GetFixtureDatesForTeam(TeamID)
                For Each FixtureDate As DataRow In FixtureDates.Rows
                    .Items.Add(New ListItem(CDate(FixtureDate!Date).ToString("dd MMM yyyy"),
                                            If(FixtureDate!Halfway, 100 + FixtureDate!WeekNo, FixtureDate!WeekNo)))
                Next
            End Using

            FixtureDate_DropDownList.Visible = (.Items.Count > 1)

        End With

    End Sub

    Protected Sub FixtureDate_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles FixtureDate_DropDownList.SelectedIndexChanged

        InitBoxes()
        Fixture_Literal.Text = ""
        Next_Button0.Visible = False

        If FixtureDate_DropDownList.SelectedIndex > 0 Then

            Using dr As New HBSAcodeLibrary.TeamData(Section_DropDownList.SelectedValue, FixtureDate_DropDownList.SelectedValue Mod 100, HomeTeam_DropDownList.SelectedValue)
                AwayTeam_Literal.Text = (dr.ClubName & " " & dr.Team).Trim
                SessionAwayTeamID.Value = dr.ID
            End Using

            Using MatchResult As New HBSAcodeLibrary.MatchResult(HomeTeam_DropDownList.SelectedValue, SessionAwayTeamID.Value)


                ' If not an administrator ensure it is not outside the 4 week limit
                If SessionAdminEmail.Value = "" Then
                    Dim TodaysDate As Date = Utilities.UKDateTimeNow
                    Dim FixtureDate As Date = CDate(FixtureDate_DropDownList.SelectedItem.Text)
                    Dim DaySinceFixture As Integer = DateDiff(DateInterval.Day, FixtureDate, TodaysDate)
                    If DaySinceFixture > 32 Then 'cannot enter match result more than 4 weeks & 4 days (grace) after the fixture
                        'date, allowing 2 days grace to enter it. 
                        Fixture_Literal.Text = "<br/><span style='color:red;text-size:larger'>" &
                      "<b>The match cannot be entered or changed more than 4 weeks before or after the fixture date.<br/><br/>" &
                      "If you believe the match was played within within this restriction, or was sanctioned by the " &
                      "league secretary you should send the full result to the league secretary. " &
                      "The secretary will verify, And if OK, enter the result on your behalf.</span></b><br /><br />"

                        Exit Sub

                    End If

                End If

                Next_Button0.Visible = True

                Setup_TextBoxes()

                PopulateMatchResult(MatchResult)

            End Using

        End If


    End Sub

    Sub InitBoxes()

        'sets some boxes not visible

        Dim HCapTextBoxes() As TextBox = {HomeHcap1_TextBox, HomeHcap2_TextBox, HomeHcap3_TextBox, HomeHcap4_TextBox,
                                          AwayHcap1_TextBox, AwayHcap2_TextBox, AwayHcap3_TextBox, AwayHcap4_TextBox}
        Dim PlayerLists() As DropDownList = {HomePlayer1_DropDownList, HomePlayer2_DropDownList, HomePlayer3_DropDownList, HomePlayer4_DropDownList,
                                             AwayPlayer1_DropDownList, AwayPlayer2_DropDownList, AwayPlayer3_DropDownList, AwayPlayer4_DropDownList}
        Dim ScoresBoxes() As TextBox = {HomeScore1_TextBox, HomeScore2_TextBox, HomeScore3_TextBox, HomeScore4_TextBox,
                                        AwayScore1_TextBox, AwayScore2_TextBox, AwayScore3_TextBox, AwayScore4_TextBox}

        AwayTeam_Literal.Text = ""
        MatchDate_Textbox.Text = ""

        MatchDetails_Literal.Text = ""
        Frame_Literal1.Text = ""
        Frame_Literal2.Text = ""
        Frame_Literal3.Text = ""
        Frame_Literal4.Text = ""
        MatchBreaks_Literal.Text = ""
        Result_Literal.Text = ""
        Next_Button0.Visible = False

        'matchDate_CalendarExtender.SelectedDate = DateTime.MinValue

        'HomeFrames_Literal.Text = ""
        'AwayFrames_Literal.Text = ""

        For ix As Integer = 0 To 7
            ScoresBoxes(ix).Text = ""
            HCapTextBoxes(ix).Text = ""
            PlayerLists(ix).Items.Clear()
            'HCapTextBoxes(ix).Visible = False
            ScoresBoxes(ix).Visible = False
            PlayerLists(ix).Visible = False
        Next

        'status_Literal.Text = "<br />To submit your match results enter the details, then click 'Check your results card'<br />"

    End Sub

    Protected Sub Setup_TextBoxes()

        Dim HCapTextBoxes() As TextBox = {HomeHcap1_TextBox, HomeHcap2_TextBox, HomeHcap3_TextBox, HomeHcap4_TextBox,
                                          AwayHcap1_TextBox, AwayHcap2_TextBox, AwayHcap3_TextBox, AwayHcap4_TextBox}
        Dim HCapImgs() As HtmlImage = {HomeHCapImg1, HomeHCapImg2, HomeHCapImg3, HomeHCapImg4,
                                       AwayHCapImg1, AwayHCapImg2, AwayHCapImg3, AwayHCapImg4}
        Dim PlayerLists() As DropDownList = {HomePlayer1_DropDownList, HomePlayer2_DropDownList, HomePlayer3_DropDownList, HomePlayer4_DropDownList,
                                             AwayPlayer1_DropDownList, AwayPlayer2_DropDownList, AwayPlayer3_DropDownList, AwayPlayer4_DropDownList}
        Dim ScoresBoxes() As TextBox = {HomeScore1_TextBox, HomeScore2_TextBox, HomeScore3_TextBox, HomeScore4_TextBox,
                                        AwayScore1_TextBox, AwayScore2_TextBox, AwayScore3_TextBox, AwayScore4_TextBox}

        For ix As Integer = 0 To 7
            If ix > 3 Then
                PopulatePlayers(PlayerLists(ix), SessionAwayTeamID.Value)
            Else
                PopulatePlayers(PlayerLists(ix), HomeTeam_DropDownList.SelectedValue)
            End If

            If SessionAdminEmail.Value <> "" Then
                HCapTextBoxes(ix).Enabled = True
                HCapImgs(ix).Visible = False
            Else
                HCapTextBoxes(ix).Enabled = False
                HCapImgs(ix).Visible = True
            End If

            ScoresBoxes(ix).Visible = True
            PlayerLists(ix).Visible = True

            If (ix = 3 OrElse ix = 7) AndAlso Section_DropDownList.SelectedValue > 6 Then 'hide 4th player for vets & billiards
                HCapTextBoxes(ix).Visible = False
                ScoresBoxes(ix).Visible = False
                PlayerLists(ix).Visible = False
            End If

        Next

        Breaks_GridView.DataSource = Nothing
        Breaks_GridView.DataBind()
        BreakPlayers_DropDownList.Items.Clear()
        BreakPlayers_DropDownList.Items.Add("** Select a Player **")

    End Sub

    Sub PopulatePlayers(ByVal playerDD As DropDownList, teamID As Integer)

        Using TeamPlayers As DataTable = HBSAcodeLibrary.SharedRoutines.PlayersForTeam(teamID)

            With playerDD

                .Items.Clear()
                .Items.Add(New ListItem("** Select a player **", " | "))

                .Items.Add(New ListItem("** No Opponent **", "-2|0"))
                .Items.Add(New ListItem("** No Show **", "-1|0"))
                .Items.Add(New ListItem("** Frame Not Played **", "-3|0"))

                For Each TeamPlayer As DataRow In TeamPlayers.Rows
                    .Items.Add(New ListItem(TeamPlayer!Player & If(TeamPlayer!OtherTeam = 1, " (*)",
                                                                If(TeamPlayer!OtherTeam = 2, " (deRegistered)", "")),
                                            TeamPlayer!PlayerID & "|" & TeamPlayer!HandiCap))
                Next

                .SelectedIndex = True
                .Visible = True

            End With

        End Using

    End Sub

#Region "Next/Prev buttons"

    Protected Sub Next_Button0_Click(sender As Object, e As EventArgs) Handles Next_Button0.Click
        ShowMatch()
        EnablePanel(Frame1_Panel)
    End Sub

    Protected Sub Next_Button1_Click(sender As Object, e As EventArgs) Handles Next_Button1.Click
        ShowFrame(1)
        EnablePanel(Frame2_Panel)
    End Sub
    Protected Sub Next_Button2_Click(sender As Object, e As EventArgs) Handles Next_Button2.Click
        ShowFrame(2)
        EnablePanel(Frame3_Panel)
    End Sub
    Protected Sub Next_Button3_Click(sender As Object, e As EventArgs) Handles Next_Button3.Click
        ShowFrame(3)
        If Section_DropDownList.SelectedValue >= 7 Then
            EnablePanel(Breaks_Panel)
            PopulateBreaks()
        Else
            EnablePanel(Frame4_Panel)
        End If
    End Sub
    Protected Sub Next_Button4_Click(sender As Object, e As EventArgs) Handles Next_Button4.Click
        ShowFrame(4)
        EnablePanel(Breaks_Panel)
        PopulateBreaks()
    End Sub
    Protected Sub Next_Button5_Click(sender As Object, e As EventArgs) Handles Next_Button5.Click
        If BreakPlayers_DropDownList.SelectedIndex > 0 AndAlso Break_TextBox.Text <> "" Then
            BreakAdd_Button_Click(sender, e)
            If Breaks_Literal.Text <> "" Then Exit Sub
        End If
        ShowBreaks()
        EnablePanel(SubmitResult_Panel)
        status_Literal.Text = ""

    End Sub

    Sub ShowBreaks()

        MatchBreaks_Literal.Text = ""

        Dim breaks As DataTable = HBSAcodeLibrary.Utilities.DeSerialiseDataTable(SessionBreaksTable.Value)

        If breaks.Rows.Count > 0 Then
            For ix As Integer = 0 To breaks.Rows.Count - 1
                If ix = 0 Then
                    MatchBreaks_Literal.Text = "<br>Breaks: "
                Else
                    MatchBreaks_Literal.Text += ", "
                End If
                MatchBreaks_Literal.Text += breaks.Rows(ix)("Player") & ": " & breaks.Rows(ix)("Break")
            Next
        End If

    End Sub
    Sub ShowMatch()
        MatchDetails_Literal.Text = HomeTeam_DropDownList.SelectedItem.Text.Trim & " v " & AwayTeam_Literal.Text.Trim & "<br/>" &
                                    Section_DropDownList.SelectedItem.Text.Trim & " - " &
                                    FixtureDate_DropDownList.SelectedItem.Text
        Try
            If CDate(MatchDate_Textbox.Text) <> CDate(FixtureDate_DropDownList.SelectedItem.Text) Then
                MatchDetails_Literal.Text += " Played " & MatchDate_Textbox.Text

            End If
        Catch ex As Exception
        End Try

    End Sub
    Sub ShowFrame(FrameNo As Integer)
        Dim PlayerLists() As DropDownList = {HomePlayer1_DropDownList, HomePlayer2_DropDownList, HomePlayer3_DropDownList, HomePlayer4_DropDownList,
                                             AwayPlayer1_DropDownList, AwayPlayer2_DropDownList, AwayPlayer3_DropDownList, AwayPlayer4_DropDownList}
        Dim ScoresBoxes() As TextBox = {HomeScore1_TextBox, HomeScore2_TextBox, HomeScore3_TextBox, HomeScore4_TextBox,
                                        AwayScore1_TextBox, AwayScore2_TextBox, AwayScore3_TextBox, AwayScore4_TextBox}
        Dim FrameLiteral() As Literal = {Frame_Literal1, Frame_Literal2, Frame_Literal3, Frame_Literal4}

        Dim FrameIx As Integer = FrameNo - 1

        If ScoresBoxes(FrameIx).Text.Trim <> "" AndAlso ScoresBoxes(FrameIx + 4).Text.Trim <> "" Then

            FrameLiteral(FrameIx).Text = "<br>Frame " & FrameNo & ": " & PlayerLists(FrameIx).SelectedItem.Text.Replace(" (*)", "") & " " & ScoresBoxes(FrameIx).Text.Trim & " - " &
                                                    PlayerLists(FrameIx + 4).SelectedItem.Text.Replace(" (*)", "") & " " & ScoresBoxes(FrameIx + 4).Text.Trim
        Else
            FrameLiteral(FrameIx).Text = ""
        End If

    End Sub

    Protected Sub Prev_Button1_Click(sender As Object, e As EventArgs) Handles Prev_Button1.Click
        ShowFrame(1)
        EnablePanel(Match_Panel)
    End Sub
    Protected Sub Prev_Button2_Click(sender As Object, e As EventArgs) Handles Prev_Button2.Click
        ShowFrame(2)
        EnablePanel(Frame1_Panel)
    End Sub
    Protected Sub Prev_Button3_Click(sender As Object, e As EventArgs) Handles Prev_Button3.Click
        ShowFrame(3)
        EnablePanel(Frame2_Panel)
    End Sub
    Protected Sub Prev_Button4_Click(sender As Object, e As EventArgs) Handles Prev_Button4.Click
        ShowFrame(4)
        EnablePanel(Frame3_Panel)
    End Sub
    Protected Sub Prev_Button5_Click(sender As Object, e As EventArgs) Handles Prev_Button5.Click
        If Section_DropDownList.SelectedValue >= 7 Then
            ShowFrame(4)
            EnablePanel(Frame3_Panel)
        Else
            ShowBreaks()
            EnablePanel(Frame4_Panel)
        End If
    End Sub
    Protected Sub Prev_Button6_Click(sender As Object, e As EventArgs) Handles Prev_Button6.Click
        Result_Literal.Text = ""
        Send_Button.Text = "Check your results card"
        EnablePanel(Breaks_Panel)
        PopulateBreaks()
    End Sub

#End Region

    Sub PopulateBreaks()

        Dim PlayerLists() As DropDownList = {HomePlayer1_DropDownList, HomePlayer2_DropDownList, HomePlayer3_DropDownList, HomePlayer4_DropDownList,
                                             AwayPlayer1_DropDownList, AwayPlayer2_DropDownList, AwayPlayer3_DropDownList, AwayPlayer4_DropDownList}

        With BreakPlayers_DropDownList
            .Items.Clear()
            .Items.Add("**Select a player**")
            For ix = 0 To 7
                If PlayerLists(ix).SelectedValue.Split("|")(0) <> " " AndAlso PlayerLists(ix).SelectedValue.Split("|")(0) > 0 Then
                    .Items.Add(New ListItem(PlayerLists(ix).SelectedItem.Text, PlayerLists(ix).SelectedValue.Split("|")(0)))
                End If
            Next

        End With

        Break_TextBox.Text = ""

        'Fill Breaks gridview,  remove any with no matching selectable player
        With Breaks_GridView

            Dim breaks As DataTable = HBSAcodeLibrary.Utilities.DeSerialiseDataTable(SessionBreaksTable.Value)
            For Each break As DataRow In breaks.Rows
                If Not PlayerInDropDown(break.Item("PlayerID")) Then
                    break.Delete()
                    breaks.AcceptChanges()
                End If
            Next

            SessionBreaksTable.Value = HBSAcodeLibrary.Utilities.SerialiseDataTable(breaks)
            .DataSource = breaks
            .DataBind()

        End With

    End Sub

    Function PlayerInDropDown(PlayerID As Integer) As Boolean

        For Each player As ListItem In BreakPlayers_DropDownList.Items
            If player.Value = CStr(PlayerID) Then
                Return True
            End If
        Next

        Return False

    End Function

    Sub PopulateMatchResult(ByVal MatchResult As HBSAcodeLibrary.MatchResult)

        Setup_TextBoxes()

        If MatchResult.MatchResultID > 0 Then

            Dim Match As DataRow = MatchResult.Match.Rows(0)

            Try
                MatchDate_Textbox.Text = Match("Match Date")
            Catch ex As Exception
                MatchDate_Textbox.Text = FixtureDate_DropDownList.SelectedItem.Text
            End Try

            Dim Frames As DataTable = MatchResult.Frames

            FillPlayerDetails(HomePlayer1_DropDownList, Frames.Rows(0).Item("HomePlayer"),
                              HomeScore1_TextBox, Frames.Rows(0).Item("HomeScore"),
                              HomeHcap1_TextBox, Frames.Rows(0).Item("Home H'cap"))
            FillPlayerDetails(HomePlayer2_DropDownList, Frames.Rows(1).Item("HomePlayer"),
                              HomeScore2_TextBox, Frames.Rows(1).Item("HomeScore"),
                              HomeHcap2_TextBox, Frames.Rows(1).Item("Home H'cap"))
            FillPlayerDetails(HomePlayer3_DropDownList, Frames.Rows(2).Item("HomePlayer"),
                              HomeScore3_TextBox, Frames.Rows(2).Item("HomeScore"),
                              HomeHcap3_TextBox, Frames.Rows(2).Item("Home H'cap"))
            If Section_DropDownList.SelectedValue < 7 Then
                FillPlayerDetails(HomePlayer4_DropDownList, Frames.Rows(3).Item("HomePlayer"),
                              HomeScore4_TextBox, Frames.Rows(3).Item("HomeScore"),
                              HomeHcap4_TextBox, Frames.Rows(3).Item("Home H'cap"))
            End If
            FillPlayerDetails(AwayPlayer1_DropDownList, Frames.Rows(0).Item("AwayPlayer"),
                              AwayScore1_TextBox, Frames.Rows(0).Item("AwayScore"),
                              AwayHcap1_TextBox, Frames.Rows(0).Item("Away H'cap"))
            FillPlayerDetails(AwayPlayer2_DropDownList, Frames.Rows(1).Item("AwayPlayer"),
                              AwayScore2_TextBox, Frames.Rows(1).Item("AwayScore"),
                              AwayHcap2_TextBox, Frames.Rows(1).Item("Away H'cap"))
            FillPlayerDetails(AwayPlayer3_DropDownList, Frames.Rows(2).Item("AwayPlayer"),
                              AwayScore3_TextBox, Frames.Rows(2).Item("AwayScore"),
                              AwayHcap3_TextBox, Frames.Rows(2).Item("Away H'cap"))
            If Section_DropDownList.SelectedValue < 7 Then
                FillPlayerDetails(AwayPlayer4_DropDownList, Frames.Rows(3).Item("AwayPlayer"),
                              AwayScore4_TextBox, Frames.Rows(3).Item("AwayScore"),
                              AwayHcap4_TextBox, Frames.Rows(3).Item("Away H'cap"))
            End If

            Recover_Button.Visible = False
            If SessionAdminEmail.Value <> "" Then
                Delete_Result_Div.Visible = True
            Else
                Delete_Result_Div.Visible = False
            End If

            ShowMatch()
            ShowFrame(1)
            ShowFrame(2)
            ShowFrame(3)
            If Section_DropDownList.SelectedValue < 7 Then
                ShowFrame(4)
            End If

            Dim breaks As DataTable = HBSAcodeLibrary.MatchResult.BreaksForMatch(HomeTeam_DropDownList.SelectedValue, SessionAwayTeamID.Value)
            SessionBreaksTable.Value = HBSAcodeLibrary.Utilities.SerialiseDataTable(breaks)

            ShowBreaks()

        Else

            MatchDate_Textbox.Text = FixtureDate_DropDownList.SelectedItem.Text

            Delete_Result_Div.Visible = False
            If SessionAdminEmail.Value <> "" AndAlso HBSAcodeLibrary.MatchResult.DeletedExists(HomeTeam_DropDownList.SelectedValue, SessionAwayTeamID.Value) Then
                Recover_Button.Visible = True
            Else
                Recover_Button.Visible = False
            End If

            Dim breaks As DataTable = HBSAcodeLibrary.MatchResult.BreaksForMatch(HomeTeam_DropDownList.SelectedValue, SessionAwayTeamID.Value)
            SessionBreaksTable.Value = HBSAcodeLibrary.Utilities.SerialiseDataTable(breaks)

        End If

        Send_Button.Text = "Check your results card"

    End Sub
    Protected Sub FillPlayerDetails(PlayerDD As DropDownList, PlayerID As Integer,
                                     ScoreTB As TextBox, Score As String,
                                     HCapTB As TextBox, HCap As String)
        With PlayerDD
            Dim ix As Integer
            For ix = 1 To .Items.Count - 1      'start after selector, no show & no opponent
                'if the player ID matches the 1st part of the value we've found the entry
                If CInt(.Items(ix).Value.Split("|")(0)) = PlayerID Then
                    .SelectedIndex = ix
                    ScoreTB.Text = Score
                    ScoreTB.Enabled = (PlayerID > 0)
                    HCapTB.Text = HCap
                    HCapTB.Visible = True
                    Exit Sub
                End If
            Next

            .SelectedIndex = 0        '  not found, default to zero IX
            ScoreTB.Text = 0
            HCapTB.Text = 0
            HCapTB.Visible = True

        End With

    End Sub
    Private Sub BreakAdd_Button_Click(sender As Object, e As EventArgs) Handles BreakAdd_Button.Click

        Breaks_Literal.Text = ""
        breakErrorRow.Visible = False
        Dim break As Integer
        Try
            break = CInt(Break_TextBox.Text)
            If break < 25 Then
                break = "error" 'cause exception
            End If
        Catch ex As Exception
            Breaks_Literal.Text = "A break must be an integer greater than 25"
            breakErrorRow.Visible = True
            Exit Sub
        End Try

        Dim breaks As DataTable = HBSAcodeLibrary.Utilities.DeSerialiseDataTable(SessionBreaksTable.Value)

        If breaks.Columns.Count < 1 Then
            breaks.Columns.Add("Player", Type.GetType("System.String"))
            breaks.Columns.Add("ID", Type.GetType("System.Int32"))
            breaks.Columns.Add("MatchResultID", Type.GetType("System.Int32"))
            breaks.Columns.Add("PlayerID", Type.GetType("System.Int32"))
            breaks.Columns.Add("Break", Type.GetType("System.Int32"))
            breaks.TableName = "breaks"
        End If

        Dim breakRow As DataRow = breaks.NewRow
        breakRow("Player") = BreakPlayers_DropDownList.SelectedItem.Text
        breakRow("ID") = 0
        breakRow("MatchResultID") = 0
        breakRow("PlayerID") = BreakPlayers_DropDownList.SelectedValue
        breakRow("Break") = break
        breaks.Rows.Add(breakRow)
        breaks.AcceptChanges()

        SessionBreaksTable.Value = HBSAcodeLibrary.Utilities.SerialiseDataTable(breaks)

        Breaks_GridView.DataSource = breaks
        Breaks_GridView.DataBind()

        Break_TextBox.Text = ""
        BreakPlayers_DropDownList.SelectedIndex = 0
        ShowBreaks()

    End Sub

    Private Sub Breaks_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Breaks_GridView.RowDeleting

        Dim breaks As DataTable = HBSAcodeLibrary.Utilities.DeSerialiseDataTable(SessionBreaksTable.Value)
        breaks.Rows.RemoveAt(e.RowIndex)
        breaks.AcceptChanges()
        SessionBreaksTable.Value = HBSAcodeLibrary.Utilities.SerialiseDataTable(breaks)

        Breaks_GridView.DataSource = breaks
        Breaks_GridView.DataBind()
        ShowBreaks()

    End Sub

    Protected Sub Send_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) _
           Handles Send_Button.Click

        Result_Literal.Text = ""

        If MatchDate_Textbox.Text = "" Then
            MatchDate_Textbox.Text = FixtureDate_DropDownList.SelectedItem.Text
        End If

        'Calculate result and verify input

        Retry_Button.Visible = False

        If Send_Button.Text = "Check your results card" OrElse Send_Button.Text = "Send the results to HBSA" Then

            Dim errMsg As New StringBuilder

            Dim matchDate As Date
            Dim homeHcap(3) As Integer
            Dim homeScore(3) As Integer
            Dim awayHcap(3) As Integer
            Dim awayScore(3) As Integer

            Try
                matchDate = CDate(MatchDate_Textbox.Text)
            Catch ex As Exception
                errMsg.Append("Invalid match date<br/>")
            End Try

            If SessionAdminEmail.Value = "" Then 'not admin
                If Math.Abs(DateAndTime.DateDiff(DateInterval.Day, matchDate, CDate(FixtureDate_DropDownList.SelectedItem.Text))) > 28 Then
                    errMsg.Append("<span style='color:red;text-size:larger'>" &
                          "<b>The match cannot be played more than 4 weeks before or after the fixture date.<br/><br/>" &
                          "If you believe the match was played within within this restriction, or was sanctioned by the " &
                          "league secretary you should send the full result to the league secretary. " &
                          "The secretary will verify, And if OK, enter the result on your behalf.</span></b><br />OR")
                End If
            Else
                Using Seasons As New HBSAcodeLibrary.FixturesData
                    If DateAndTime.DateDiff(DateInterval.Day, matchDate, Seasons.StartOfSeason) > 28 Then
                        errMsg.Append("<b>The match date cannot be more than 4 weeks before the season start date.<br/>" &
                          "If the match was actually played outside of this limitation you should use " &
                          Format(DateAndTime.DateAdd(DateInterval.Day, -28, Seasons.StartOfSeason), "dd MMM yyyy"))
                    ElseIf DateAndTime.DateDiff(DateInterval.Day, Seasons.EndOfSeason, matchDate) > 28 Then
                        errMsg.Append("<b>The match date cannot be more than 4 weeks after the season end date.<br/>" &
                          "If the match was actually played outside of this limitation you should use " &
                          Format(DateAndTime.DateAdd(DateInterval.Day, 28, Seasons.EndOfSeason), "dd MMM yyyy"))


                    End If

                End Using
            End If

            If HomePlayer1_DropDownList.SelectedValue.Split("|")(0) = "0" Then
                errMsg.Append("Home Player 1 has Not been selected.</br>")
            End If
            If HomePlayer2_DropDownList.SelectedValue.Split("|")(0) = "0" Then
                errMsg.Append("Home Player 2 has Not been selected.</br>")
            End If
            If HomePlayer3_DropDownList.SelectedValue.Split("|")(0) = "0" Then
                errMsg.Append("Home Player 3 has Not been selected.</br>")
            End If
            If Section_DropDownList.SelectedValue < 7 AndAlso HomePlayer4_DropDownList.SelectedValue.Split("|")(0) = "0" Then
                errMsg.Append("Home Player 4 has Not been selected.</br>")
            End If

            If AwayPlayer1_DropDownList.SelectedValue.Split("|")(0) = "0" Then
                errMsg.Append("Away Player 1 has Not been selected.</br>")
            End If
            If AwayPlayer2_DropDownList.SelectedValue.Split("|")(0) = "0" Then
                errMsg.Append("Away Player 2 has Not been selected.</br>")
            End If
            If AwayPlayer3_DropDownList.SelectedValue.Split("|")(0) = "0" Then
                errMsg.Append("Away Player 3 has Not been selected.</br>")
            End If
            If Section_DropDownList.SelectedValue < 7 AndAlso AwayPlayer4_DropDownList.SelectedValue.Split("|")(0) = "0" Then
                errMsg.Append("Away Player 4 has Not been selected.</br>")
            End If

            If errMsg.Length > 0 Then
                GoTo showError
            End If

            If HomePlayer1_DropDownList.SelectedValue.Split("|")(0) > "0" AndAlso HomePlayer1_DropDownList.SelectedValue.Split("|")(0) = HomePlayer2_DropDownList.SelectedValue.Split("|")(0) Then
                errMsg.Append(HomePlayer1_DropDownList.SelectedItem.Text & " (home player) has been selected twice.</br>")
            End If
            If HomePlayer1_DropDownList.SelectedValue.Split("|")(0) > "0" AndAlso HomePlayer1_DropDownList.SelectedValue.Split("|")(0) = HomePlayer3_DropDownList.SelectedValue.Split("|")(0) Then
                errMsg.Append(HomePlayer1_DropDownList.SelectedItem.Text & " (home player) has been selected twice.</br>")
            End If
            If HomePlayer1_DropDownList.SelectedValue.Split("|")(0) > "0" AndAlso HomePlayer1_DropDownList.SelectedValue.Split("|")(0) = HomePlayer4_DropDownList.SelectedValue.Split("|")(0) Then
                errMsg.Append(HomePlayer1_DropDownList.SelectedItem.Text & " (home player) has been selected twice.</br>")
            End If
            If HomePlayer2_DropDownList.SelectedValue.Split("|")(0) > "0" AndAlso HomePlayer2_DropDownList.SelectedValue.Split("|")(0) = HomePlayer3_DropDownList.SelectedValue.Split("|")(0) Then
                errMsg.Append(HomePlayer2_DropDownList.SelectedItem.Text & " (home player) has been selected twice.</br>")
            End If
            If HomePlayer2_DropDownList.SelectedValue.Split("|")(0) > "0" AndAlso HomePlayer2_DropDownList.SelectedValue.Split("|")(0) = HomePlayer4_DropDownList.SelectedValue.Split("|")(0) Then
                errMsg.Append(HomePlayer2_DropDownList.SelectedItem.Text & " (home player) has been selected twice.</br>")
            End If
            If HomePlayer3_DropDownList.SelectedValue.Split("|")(0) > "0" AndAlso HomePlayer3_DropDownList.SelectedValue.Split("|")(0) = HomePlayer4_DropDownList.SelectedValue.Split("|")(0) Then
                errMsg.Append(HomePlayer3_DropDownList.SelectedItem.Text & " (home player) has been selected twice.</br>")
            End If

            If AwayPlayer1_DropDownList.SelectedValue.Split("|")(0) > "0" AndAlso AwayPlayer1_DropDownList.SelectedValue.Split("|")(0) = AwayPlayer2_DropDownList.SelectedValue.Split("|")(0) Then
                errMsg.Append(AwayPlayer1_DropDownList.SelectedItem.Text & " has been selected twice.</br>")
            End If
            If AwayPlayer1_DropDownList.SelectedValue.Split("|")(0) > "0" AndAlso AwayPlayer1_DropDownList.SelectedValue.Split("|")(0) = AwayPlayer3_DropDownList.SelectedValue.Split("|")(0) Then
                errMsg.Append(AwayPlayer1_DropDownList.SelectedItem.Text & " (away player) has been selected twice.</br>")
            End If
            If AwayPlayer1_DropDownList.SelectedValue.Split("|")(0) > "0" AndAlso AwayPlayer1_DropDownList.SelectedValue.Split("|")(0) = AwayPlayer4_DropDownList.SelectedValue.Split("|")(0) Then
                errMsg.Append(AwayPlayer1_DropDownList.SelectedItem.Text & " (away player) has been selected twice.</br>")
            End If
            If AwayPlayer2_DropDownList.SelectedValue.Split("|")(0) > "0" AndAlso AwayPlayer2_DropDownList.SelectedValue.Split("|")(0) = AwayPlayer3_DropDownList.SelectedValue.Split("|")(0) Then
                errMsg.Append(AwayPlayer2_DropDownList.SelectedItem.Text & " (away player) has been selected twice.</br>")
            End If
            If AwayPlayer2_DropDownList.SelectedValue.Split("|")(0) > "0" AndAlso AwayPlayer2_DropDownList.SelectedValue.Split("|")(0) = AwayPlayer4_DropDownList.SelectedValue.Split("|")(0) Then
                errMsg.Append(AwayPlayer2_DropDownList.SelectedItem.Text & " (away player) has been selected twice.</br>")
            End If
            If AwayPlayer3_DropDownList.SelectedValue.Split("|")(0) > "0" AndAlso AwayPlayer3_DropDownList.SelectedValue.Split("|")(0) = AwayPlayer4_DropDownList.SelectedValue.Split("|")(0) Then
                errMsg.Append(AwayPlayer3_DropDownList.SelectedItem.Text & " (away player) has been selected twice.</br>")
            End If

            If errMsg.Length > 0 Then
                'GoTo showError
            End If

            CheckHandicapBoxes()
            CheckScoreBoxes()

            errMsg.Append(Handicap(HomeHcap1_TextBox, homeHcap(0)))
            errMsg.Append(Handicap(HomeHcap2_TextBox, homeHcap(1)))
            errMsg.Append(Handicap(HomeHcap3_TextBox, homeHcap(2)))
            If Section_DropDownList.SelectedValue < 7 Then errMsg.Append(Handicap(HomeHcap4_TextBox, homeHcap(3)))
            errMsg.Append(Handicap(AwayHcap1_TextBox, awayHcap(0)))
            errMsg.Append(Handicap(AwayHcap2_TextBox, awayHcap(1)))
            errMsg.Append(Handicap(AwayHcap3_TextBox, awayHcap(2)))
            If Section_DropDownList.SelectedValue < 7 Then errMsg.Append(Handicap(AwayHcap4_TextBox, awayHcap(3)))

            errMsg.Append(FrameScore(HomeScore1_TextBox, homeScore(0)))
            errMsg.Append(FrameScore(HomeScore2_TextBox, homeScore(1)))
            errMsg.Append(FrameScore(HomeScore3_TextBox, homeScore(2)))
            If Section_DropDownList.SelectedValue < 7 Then errMsg.Append(FrameScore(HomeScore4_TextBox, homeScore(3)))
            errMsg.Append(FrameScore(AwayScore1_TextBox, awayScore(0)))
            errMsg.Append(FrameScore(AwayScore2_TextBox, awayScore(1)))
            errMsg.Append(FrameScore(AwayScore3_TextBox, awayScore(2)))
            If Section_DropDownList.SelectedValue < 7 Then errMsg.Append(FrameScore(AwayScore4_TextBox, awayScore(3)))

            HomeFrames.Value = 0
            AwayFrames.Value = 0

showError:
            If errMsg.Length > 0 Then
                'we have a validation error, show them etc.
                Dim status_message As String = errMsg.ToString
                While status_message.EndsWith("<br/>")
                    status_message = status_message.Substring(0, status_message.Length - 5)
                End While
                status_Literal.Text = "An error occurred:<br/><span style='color:red ;'><br/>" & status_message & "<br/></span><br/>Review your data and try again."
            Else
                Dim matches As Integer = IIf(Section_DropDownList.SelectedValue < 7, 4, 3)
                For ix As Integer = 0 To matches - 1
                    HomeFrames.Value += Math.Abs(CInt((homeScore(ix) > awayScore(ix))))
                    AwayFrames.Value += Math.Abs(CInt((homeScore(ix) < awayScore(ix))))
                Next
                status_Literal.Text = "Results checked.<br/><strong>"
                If AwayFrames.Value < HomeFrames.Value Then
                    status_Literal.Text = HomeTeam_DropDownList.SelectedItem.Text & " wins " & HomeFrames.Value & " frames to " & AwayFrames.Value
                ElseIf AwayFrames.Value > HomeFrames.Value Then
                    status_Literal.Text = AwayTeam_Literal.Text & " wins " & AwayFrames.Value & " frames to " & HomeFrames.Value
                Else
                    status_Literal.Text = HomeTeam_DropDownList.SelectedItem.Text & " draws with " & AwayTeam_Literal.Text
                End If

                Result_Literal.Text = "<br/>" & status_Literal.Text

                If Send_Button.Text <> "Send the results to HBSA" Then

                    status_Literal.Text += "</strong><br/>" &
                                       "If you are happy with these click 'Send the results to HBSA'<br/>" &
                                       "A copy will also be emailed to you.<br/>" &
                                       "Otherwise change them and click 'Check your results card'"

                    Send_Button.Text = "Send the results to HBSA"
                Else
                    status_Literal.Text = ""

                    If HBSAcodeLibrary.HBSA_Configuration.CloseSeason Then

                        status_Literal.Text += "<br/><span style='color:red;'>Cannot update or submit a result as the season is closed.</span>"
                        Retry_Button.Visible = False
                        Cancel_Button.Visible = False
                        If SessionAdminEmail.Value = "" Then
                            Send_Button.Text = "Finished"
                        End If

                    Else

                        Dim MatchID As Integer = Store_result()

                        If MatchID > 0 Then

                            If Not Send_email(MatchID) Then

                                status_Literal.Text += "<br/><span style='color:blue;'>Your result card Emails have been sent."
                                Retry_Button.Visible = False
                                Cancel_Button.Visible = False
                                If SessionAdminEmail.Value = "" Then
                                    Send_Button.Text = "Finished"
                                    status_Literal.Text += "  Click Finished.</span>"
                                Else
                                    status_Literal.Text = "</span>"
                                    Response.Redirect("MatchResult.aspx")
                                End If
                            Else

                                SessionMatchResultID.Value = MatchID
                                Retry_Button.Visible = True
                                Retry_Button.Text = "Re-send Emails"
                                Cancel_Button.Visible = False
                                If SessionAdminEmail.Value = "" Then
                                    Send_Button.Text = "Finished"
                                End If
                            End If

                        End If

                    End If
                End If
            End If

        Else 'If Send_Button.Text = "Finished" Then
            Session("TeamID") = Nothing
            Response.Redirect("../Login.aspx")

        End If

    End Sub

    Private Function Handicap(ByVal textBox As TextBox, ByRef intValue As Integer) As String

        textBox.Text = textBox.Text.Trim
        If textBox.Text.StartsWith("(") Then
            textBox.Text = textBox.Text.Replace("(", "-").Replace(")", "")
        End If

        Try
            intValue = CInt(textBox.Text)
            'If Math.Abs(intValue) > 45 Then
            '    Return textBox.ClientID.Replace("_TextBox", " ") & "handicap value must be between -45 and 45<br/>"
            'End If
        Catch ex As Exception
            Return textBox.ID.Replace("_TextBox", " ") & "handicap must be numbers<br/>"
        End Try

        Return ""

    End Function

    Private Function FrameScore(ByVal textBox As TextBox, ByRef intValue As Integer) As String

        Try
            intValue = CInt(textBox.Text)
            If intValue < -100 OrElse intValue > 299 Then
                Return textBox.ID.Replace("_TextBox", " ") & "score must be between -100 and 300<br/>"
            End If
        Catch ex As Exception
            Return textBox.ID.Replace("_TextBox", " ") & "score must be numbers<br/>"
        End Try

        Return ""

    End Function

    Function Store_result() As Integer

        CheckHandicapBoxes()

        Try
            Dim MatchID As Integer =
                HBSAcodeLibrary.MatchResult.InsertResultCard(CDate(MatchDate_Textbox.Text),
                                                       HomeTeam_DropDownList.SelectedValue,
                                                       SessionAwayTeamID.Value,
                                                       HomePlayer1_DropDownList.SelectedValue.Split("|")(0),
                                                       HomeScore1_TextBox.Text,
                                                       AwayPlayer1_DropDownList.SelectedValue.Split("|")(0),
                                                       AwayScore1_TextBox.Text,
                                                       HomePlayer2_DropDownList.SelectedValue.Split("|")(0),
                                                       HomeScore2_TextBox.Text,
                                                       AwayPlayer2_DropDownList.SelectedValue.Split("|")(0),
                                                       AwayScore2_TextBox.Text,
                                                       HomePlayer3_DropDownList.SelectedValue.Split("|")(0),
                                                       HomeScore3_TextBox.Text,
                                                       AwayPlayer3_DropDownList.SelectedValue.Split("|")(0),
                                                       AwayScore3_TextBox.Text,
                                                       HomePlayer4_DropDownList.SelectedValue.Split("|")(0),
                                                       If(HomeScore4_TextBox.Text.Trim = "", 0, HomeScore4_TextBox.Text),
                                                       AwayPlayer4_DropDownList.SelectedValue.Split("|")(0),
                                                       If(AwayScore4_TextBox.Text.Trim = "", 0, AwayScore4_TextBox.Text),
                                                       HomeHcap1_TextBox.Text,
                                                       HomeHcap2_TextBox.Text,
                                                       HomeHcap3_TextBox.Text,
                                                       If(HomeHcap4_TextBox.Text.Trim = "", 0, HomeHcap4_TextBox.Text),
                                                       AwayHcap1_TextBox.Text,
                                                       AwayHcap2_TextBox.Text,
                                                       AwayHcap3_TextBox.Text,
                                                       If(AwayHcap4_TextBox.Text.Trim = "", 0, AwayHcap4_TextBox.Text),
                                                       SessionUser.Value)
            Store_result = MatchID

            'Look for breaks to add to the database
            InsertMatchBreaks(HBSAcodeLibrary.Utilities.DeSerialiseDataTable(SessionBreaksTable.Value), MatchID)

        Catch ex As Exception

            Store_result = 0

            Dim errorMessage As String = ex.Message
            Dim innerEx As Exception = ex.InnerException
            While Not IsNothing(innerEx)
                errorMessage += "<br/>    " & innerEx.Message
                innerEx = innerEx.InnerException
            End While

            status_Literal.Text += "<br/><br/><span style='color:red;'>There was an error storing the results to the database.<br/><br/>" &
                                                                    "Please use the contact page for assistance and supply the following information:<br/>" &
                                                  errorMessage & "</span>"

            'send email alert
            Using cfg As New HBSAcodeLibrary.HBSA_Configuration
                Dim toAddress As String = cfg.Value("LeagueSecretaryEmail")
                Dim subject As String
                Dim body As String
                subject = "*** Web site database alert *** (" & HomeTeam_DropDownList.SelectedItem.Text.Trim & ")"
                body = status_Literal.Text

                Try
                    HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body)
                Catch eMex As Exception

                End Try

            End Using
        End Try

    End Function

    Private Sub InsertMatchBreaks(BreaksTable As DataTable, MatchID As Integer)

        If Not BreaksTable Is Nothing Then
            For Each BreakRow In BreaksTable.Rows
                If BreakRow.rowstate <> DataRowState.Deleted AndAlso BreakRow.rowstate <> DataRowState.Detached Then

                    Try
                        HBSAcodeLibrary.MatchResult.InsertMatchBreak(MatchID, BreakRow.item("PlayerID"), BreakRow.item("Break"), SessionUser.Value)

                    Catch ex As Exception
                        Throw New ApplicationException("Database error recording a break (PlayerID = " & BreakRow.item("PlayerID") &
                                                                                            "Break = " & BreakRow.item("Break") &
                                                                                           "UserID = " & SessionUserID.Value &
                                                                                             ")", ex)
                    End Try
                End If
            Next
        End If
    End Sub

    Protected Function Send_email(MatchID As Integer) As Boolean

        CheckHandicapBoxes()

        Dim MatchResult As String
        Using emailTemplate As EmailTemplateData = New EmailTemplateData("MatchResult")
            MatchResult = emailTemplate.eMailTemplateHTML
        End Using

        MatchResult = MatchResult.Replace("|Section|", Section_DropDownList.SelectedItem.Text.Trim)
        MatchResult = MatchResult.Replace("|FixtureDate|", FixtureDate_DropDownList.SelectedItem.Text)
        MatchResult = MatchResult.Replace("|MatchDate|", MatchDate_Textbox.Text)
        MatchResult = MatchResult.Replace("|HomeTeam|", HomeTeam_DropDownList.SelectedItem.Text)
        MatchResult = MatchResult.Replace("|AwayTeam|", AwayTeam_Literal.Text)
        MatchResult = MatchResult.Replace("|HomeHcap1|", HomeHcap1_TextBox.Text)
        MatchResult = MatchResult.Replace("|HomeHcap2|", HomeHcap2_TextBox.Text)
        MatchResult = MatchResult.Replace("|HomeHcap3|", HomeHcap3_TextBox.Text)
        MatchResult = MatchResult.Replace("|HomeHcap4|", If(Section_DropDownList.SelectedValue < 7, HomeHcap4_TextBox.Text, ""))
        MatchResult = MatchResult.Replace("|HomeScore1|", HomeScore1_TextBox.Text)
        MatchResult = MatchResult.Replace("|HomeScore2|", HomeScore2_TextBox.Text)
        MatchResult = MatchResult.Replace("|HomeScore3|", HomeScore3_TextBox.Text)
        MatchResult = MatchResult.Replace("|HomeScore4|", If(Section_DropDownList.SelectedValue < 7, HomeScore4_TextBox.Text, ""))
        MatchResult = MatchResult.Replace("|HomePlayer1|", HomePlayer1_DropDownList.SelectedItem.Text)
        MatchResult = MatchResult.Replace("|HomePlayer2|", HomePlayer2_DropDownList.SelectedItem.Text)
        MatchResult = MatchResult.Replace("|HomePlayer3|", HomePlayer3_DropDownList.SelectedItem.Text)
        MatchResult = MatchResult.Replace("|HomePlayer4|", If(Section_DropDownList.SelectedValue < 7, HomePlayer4_DropDownList.SelectedItem.Text, ""))
        MatchResult = MatchResult.Replace("|AwayHcap1|", AwayHcap1_TextBox.Text)
        MatchResult = MatchResult.Replace("|AwayHcap2|", AwayHcap2_TextBox.Text)
        MatchResult = MatchResult.Replace("|AwayHcap3|", AwayHcap3_TextBox.Text)
        MatchResult = MatchResult.Replace("|AwayHcap4|", If(Section_DropDownList.SelectedValue < 7, AwayHcap4_TextBox.Text, ""))
        MatchResult = MatchResult.Replace("|AwayScore1|", AwayScore1_TextBox.Text)
        MatchResult = MatchResult.Replace("|AwayScore2|", AwayScore2_TextBox.Text)
        MatchResult = MatchResult.Replace("|AwayScore3|", AwayScore3_TextBox.Text)
        MatchResult = MatchResult.Replace("|AwayScore4|", If(Section_DropDownList.SelectedValue < 7, AwayScore4_TextBox.Text, ""))
        MatchResult = MatchResult.Replace("|AwayPlayer1|", AwayPlayer1_DropDownList.SelectedItem.Text)
        MatchResult = MatchResult.Replace("|AwayPlayer2|", AwayPlayer2_DropDownList.SelectedItem.Text)
        MatchResult = MatchResult.Replace("|AwayPlayer3|", AwayPlayer3_DropDownList.SelectedItem.Text)
        MatchResult = MatchResult.Replace("|AwayPlayer4|", If(Section_DropDownList.SelectedValue < 7, AwayPlayer4_DropDownList.SelectedItem.Text, ""))

        MatchResult = MatchResult.Replace("|HomeFrames|", HomeFrames.Value)
        MatchResult = MatchResult.Replace("|AwayFrames|", AwayFrames.Value)

        Dim Breaks As String = ""
        For Each PlayerBreakRow As DataRow In HBSAcodeLibrary.Utilities.DeSerialiseDataTable(SessionBreaksTable.Value).Rows
            Breaks += PlayerBreakRow.Item("Player") & " " & PlayerBreakRow.Item("Break") & ", "
        Next
        If Breaks.Length > 2 Then Breaks = Left(Breaks, Breaks.Length - 2)
        MatchResult = MatchResult.Replace("|Breaks|", Breaks)

        Using cfg As New HBSAcodeLibrary.HBSA_Configuration

            Dim toAddress As String = HBSAcodeLibrary.MatchResult.MatchTeamUsers(MatchID) 'cfg.value("LeagueSecretaryEmail")
            Dim ccAddr As String = SessionAdminEmail.Value 'copy to administrator (if logged in)
            Dim replyAddr As String = SessionEmail.Value 'reply to team login (if logged in)
            Dim subject As String
            Dim body As String
            subject = "Match result from " & HomeTeam_DropDownList.SelectedItem.Text.Trim
            body = "Result Card from " & HomeTeam_DropDownList.SelectedItem.Text.Trim & "<br />" &
                            MatchResult & "<br/><br/>"
            Try
                HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body, ccAddr, replyAddr, MatchID, SessionUser.Value)
                Send_email = False 'indicates success

            Catch ex As Exception
                Dim errorMessage As String
                errorMessage = ex.Message
                Dim innerEx As Exception = ex.InnerException
                While Not IsNothing(innerEx)
                    errorMessage += "<br/>    " & innerEx.Message
                    innerEx = innerEx.InnerException
                End While

                status_Literal.Text += "<span style='color:maroon;'>Your results email has NOT been sent.</span><br/>" &
                                                "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUT the match result has been stored in the database. Go to <a href='" & HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() & "/Results.aspx'>League >> Match results</a> if you want to check it is correct.</font><br/><br/>" &
                                                "<span style='color:blue;'>Click the 'Re-send Emails' button under the score card to try sending them again, otherwise Click Finished.</span>" &
                                                "<span style='color:red;'><br/><br/>Please use the contact page and supply the following information:<br/>" &
                                              errorMessage & "</span>"

                Send_email = True 'indicates failure

            End Try

        End Using

    End Function

    Protected Sub Cancel_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        Session("TeamID") = Nothing
        Session("LoginCaller") = "MatchResult.aspx"
        Response.Redirect("../Login.aspx")

    End Sub

    Protected Sub Retry_Button_Click(sender As Object, e As EventArgs) Handles Retry_Button.Click

        status_Literal.Text = ""

        If Not Send_email(SessionMatchResultID.Value) Then

            status_Literal.Text += "<br/><span style='color:blue;'>Your result card Emails have been sent.  Click Finished.</span>"
            Retry_Button.Visible = False
            Cancel_Button.Visible = False
            Send_Button.Text = "Finished"

        Else

            Retry_Button.Visible = True
            Retry_Button.Text = "Re-send Emails"
            Cancel_Button.Visible = False
            Send_Button.Text = "Finished"

        End If

    End Sub

    Protected Sub Remove_Button_Click(sender As Object, e As EventArgs) Handles Remove_Button.Click

        Try

            HBSAcodeLibrary.MatchResult.Delete(HomeTeam_DropDownList.SelectedValue, SessionAwayTeamID.Value, SessionUserID.Value)
            FixtureDate_DropDownList_SelectedIndexChanged(sender, e)

        Catch ex As Exception

            DeleteResult_Literal.Text = "ERROR removing a result card:" & "<br/> Contact support with these details: " & ex.Message

        End Try

    End Sub

    Protected Sub Recover_Button_Click(sender As Object, e As EventArgs) Handles Recover_Button.Click

        'Given the selection Criteria attempt to recover a previously deleted result
        Using MatchResult As New HBSAcodeLibrary.MatchResult(HomeTeam_DropDownList.SelectedValue, SessionAwayTeamID.Value)
            MatchResult.Recover(HomeTeam_DropDownList.SelectedValue, SessionAwayTeamID.Value)
            PopulateMatchResult(MatchResult)
        End Using

    End Sub

    Private Sub Breaks_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Breaks_GridView.RowDataBound

        e.Row.Cells(2).Visible = False  'hide ID
        e.Row.Cells(3).Visible = False  'hide MatchResultID
        e.Row.Cells(4).Visible = False  'hide PlayerID

    End Sub

    Sub CheckHandicapBoxes()

        'if non administrator use the drop down handicap value 
        If SessionAdminEmail.Value = "" Then
            HomeHcap1_TextBox.Text = HomePlayer1_DropDownList.SelectedValue.Split("|")(1)
            HomeHcap2_TextBox.Text = HomePlayer2_DropDownList.SelectedValue.Split("|")(1)
            HomeHcap3_TextBox.Text = HomePlayer3_DropDownList.SelectedValue.Split("|")(1)
            HomeHcap4_TextBox.Text = HomePlayer4_DropDownList.SelectedValue.Split("|")(1)
            AwayHcap1_TextBox.Text = AwayPlayer1_DropDownList.SelectedValue.Split("|")(1)
            AwayHcap2_TextBox.Text = AwayPlayer2_DropDownList.SelectedValue.Split("|")(1)
            AwayHcap3_TextBox.Text = AwayPlayer3_DropDownList.SelectedValue.Split("|")(1)
            AwayHcap4_TextBox.Text = AwayPlayer4_DropDownList.SelectedValue.Split("|")(1)
        End If

    End Sub
    Sub CheckScoreBoxes()

        Dim PlayerDD() As DropDownList = {HomePlayer1_DropDownList, HomePlayer2_DropDownList, HomePlayer3_DropDownList, HomePlayer4_DropDownList,
                                          AwayPlayer1_DropDownList, AwayPlayer2_DropDownList, AwayPlayer3_DropDownList, AwayPlayer4_DropDownList}
        Dim ScoreBox() As TextBox = {HomeScore1_TextBox, HomeScore2_TextBox, HomeScore3_TextBox, HomeScore4_TextBox,
                                     AwayScore1_TextBox, AwayScore2_TextBox, AwayScore3_TextBox, AwayScore4_TextBox}

        For ix As Integer = 0 To 7
            If Not ((ix Mod 4) = 3 AndAlso Section_DropDownList.SelectedValue >= 7) Then
                If PlayerDD(ix).SelectedValue.Split("|")(0) < 0 Then
                    'if no opponent/no show, frame not played set appropiate score
                    ScoreBox(ix).Text = PlayerDD(ix).SelectedValue.Split("|")(0) Mod 2 + 2
                End If
            End If
        Next

    End Sub

End Class