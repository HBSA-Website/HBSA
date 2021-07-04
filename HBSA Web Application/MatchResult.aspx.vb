Imports HBSAcodeLibrary
Public Class MatchResult
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'GoDaddy will terminate the application on a 5 minute timeout
        'despite and web.config settings. It has become apparent that some users are
        'experiencing this so:
        'preserve session user values in the client page
        If Not IsPostBack Then

            SessionEmail.Value = Session("Email")
            SessionPassword.Value = Session("Password")
            SessionUserID.Value = Session("UserID")
            SessionUserName.Value = Session("UserName")
            If Not IsNothing(Session("adminDetails")) AndAlso Session("adminDetails").Rows.count > 0 Then
                SessionadminDetails.Value = Session("adminDetails").rows(0).item("email")
            Else
                SessionadminDetails.Value = ""
            End If
            SessionTeamID.Value = Session("TeamID")
            SessionUser.Value = If(Session("user") Is Nothing, Session("AdminUser"), Session("user"))
            Delete_Result_Div.Visible = False

        End If

        Dim adminLoggedIn As Boolean = (Not SessionadminDetails.Value = "")
        Dim userLoggedIn As Boolean = False

        If Not adminLoggedIn Then
            Dim TodaysDate As Date = Utilities.UKDateTimeNow
            Using Season As New HBSAcodeLibrary.FixturesData
                Dim DaySinceSeasonEnd As Integer = DateDiff(DateInterval.Day, Season.EndOfSeason, TodaysDate)
                If DaySinceSeasonEnd > 7 Then 'cannot enter match result more than a weeks after the season end
                    status_Literal.Text = "<br/><span style='color:red;text-size:larger'>" &
                          "<b>The match cannot be entered or changed more than a week after the season finishes.<br/><br/>" &
                          "If you believe the match was played within within this restriction, or was sanctioned by the " &
                          "league secretary you should send the full result to the league secretary. " &
                          "The secretary will verify, And if OK, enter the result on your behalf.</span></b><br /><br />"

                    CardDiv.Visible = False
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
                Session("LoginCaller") = "MatchResult.aspx"
                Response.Redirect("Login.aspx")
            End If

        Else
            Using User As New HBSAcodeLibrary.UserData(SessionEmail.Value, SessionPassword.Value)
                If Not User.Confirmed Then
                    If Not adminLoggedIn Then
                        Session("LoginCaller") = "MatchResult.aspx"
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
                        'League_Literal.Text = .LeagueName
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

            status_Literal.Text = "To find your match result card select a fixture date."
            Send_Button.Text = "Check your results card"

        End If

        matchDate_Textbox.Attributes.Add("readonly", "readonly")

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

    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        InitBoxes()

        If Section_DropDownList.SelectedValue.StartsWith("**") Then
            HomeTeam_DropDownList.Items.Clear()
            AwayTeam_Literal.Text = ""
            League_Literal.Text = ""

        Else

            Using SectionInfo As New HBSAcodeLibrary.SectionData(Section_DropDownList.SelectedValue)
                Using LeagueInfo As New HBSAcodeLibrary.LeagueData(SectionInfo.LeagueID)
                    League_Literal.Text = LeagueInfo.LeagueName
                End Using
            End Using

            If Section_DropDownList.SelectedValue >= 7 Then
                HomeHcap4_TextBox.Visible = False
                HomeScore4_TextBox.Visible = False
                HomePlayer4_DropDownList.Visible = False
                AwayHcap4_TextBox.Visible = False
                AwayScore4_TextBox.Visible = False
                AwayPlayer4_DropDownList.Visible = False
                HomeHcap4_TextBox.Text = ""
                HomeScore4_TextBox.Text = ""
                AwayHcap4_TextBox.Text = ""
                AwayScore4_TextBox.Text = ""
            End If

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

            HCapTextBoxes(ix).Visible = True
            ScoresBoxes(ix).Visible = True
            PlayerLists(ix).Visible = True

            If SessionadminDetails.Value <> "" Then
                HCapTextBoxes(ix).Enabled = True
                HCapImgs(ix).Visible = False
            Else
                HCapTextBoxes(ix).Enabled = False
                HCapImgs(ix).Visible = True
            End If

            If (ix = 3 OrElse ix = 7) AndAlso Section_DropDownList.SelectedValue > 6 Then 'hide 4th player for vets & billiards
                HCapTextBoxes(ix).Visible = False
                ScoresBoxes(ix).Visible = False
                PlayerLists(ix).Visible = False
                HomeHCapImg4.Visible = False
                AwayHCapImg4.Visible = False
            End If

        Next

        HomeBreakPlayers_DropDownList.Items.Clear()
        HomeBreakPlayers_DropDownList.Items.Add("** Select a Player **")
        AwayBreakPlayers_DropDownList.Items.Clear()
        AwayBreakPlayers_DropDownList.Items.Add("** Select a Player **")

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
        matchDate_Textbox.Text = ""
        'matchDate_CalendarExtender.SelectedDate = DateTime.MinValue

        HomeFrames_Literal.Text = ""
        AwayFrames_Literal.Text = ""

        For ix As Integer = 0 To 7
            ScoresBoxes(ix).Text = ""
            HCapTextBoxes(ix).Text = ""
            PlayerLists(ix).Items.Clear()
            HCapTextBoxes(ix).Visible = False
            ScoresBoxes(ix).Visible = False
            PlayerLists(ix).Visible = False
        Next

        status_Literal.Text = "<br />To submit your match results enter the details, then click 'Check your results card'<br />"

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
                    .Items.Add(New ListItem(TeamPlayer!Player & If(TeamPlayer!OtherTeam = 1, " (Not played yet)", If(TeamPlayer!OtherTeam = 2, " (deRegistered)", "")),
                                            TeamPlayer!PlayerID & "|" & TeamPlayer!HandiCap))
                Next

                .SelectedIndex = True
                .Visible = True

            End With

        End Using

    End Sub

    Sub PopulateFixtureDates(ByVal TeamID As Integer)

        With FixtureDate_DropDownList

            .Items.Clear()
            .Items.Add(New ListItem("** Select a fixture date **", 0))

            Using FixtureDates As DataTable = HBSAcodeLibrary.FixturesData.GetFixtureDatesForTeam(TeamID)
                For Each FixtureDate As DataRow In FixtureDates.Rows
                    .Items.Add(New ListItem(FixtureDate!Date, If(FixtureDate!Halfway, 100 + FixtureDate!WeekNo, FixtureDate!WeekNo)))
                Next
            End Using

            FixtureDate_DropDownList.Visible = (.Items.Count > 1)

        End With

    End Sub

    Function CreateAspBreaksTable(PlayerIDsAndBreaks() As String) As DataTable

        Dim asp_BreaksTable As New DataTable
        asp_BreaksTable.Columns.Add("PlayerID", GetType(Integer))
        asp_BreaksTable.Columns.Add("Player", GetType(String))
        asp_BreaksTable.Columns.Add("Break", GetType(Integer))

        For Each PlayerIDandBreak As String In PlayerIDsAndBreaks
            If PlayerIDandBreak <> "" Then
                Dim PlayerID As Integer = CInt(PlayerIDandBreak.Split(",")(0))
                Dim Break As Integer = CInt(PlayerIDandBreak.Split(",")(1))
                Using Player As New HBSAcodeLibrary.PlayerData(PlayerID)
                    Dim newRow As DataRow = asp_BreaksTable.NewRow
                    newRow.Item("PlayerID") = PlayerID
                    newRow.Item("Player") = Player.FullName
                    newRow.Item("Break") = Break
                    asp_BreaksTable.Rows.Add(newRow)
                End Using
            End If
        Next

        Return asp_BreaksTable

    End Function

    Protected Sub Send_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) _
           Handles Send_Button.Click

        'if the session expires need to request login
        If SessionAwayTeamID.Value = "" Then
            Response.Redirect("Login.aspx")
            Exit Sub
        End If

        Reform_and_store_the_breaks_tables()

        If matchDate_Textbox.Text = "" Then
            matchDate_CalendarExtender.SelectedDate = FixtureDate_DropDownList.SelectedItem.Text
            matchDate_Textbox.Text = Format(matchDate_CalendarExtender.SelectedDate, "dd mmm yyyy")
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
                matchDate = CDate(matchDate_Textbox.Text)
                matchDate_CalendarExtender.SelectedDate = matchDate
                matchDate_Textbox.Text = Format(matchDate, "dd MMM yyyy")
            Catch ex As Exception
                errMsg.Append("Invalid match date<br/>")
            End Try

            If SessionadminDetails.Value = "" Then 'not admin
                If Math.Abs(DateAndTime.DateDiff(DateInterval.Day, matchDate, CDate(FixtureDate_DropDownList.SelectedItem.Text))) > 28 Then
                    errMsg.Append("<br/><span style='color:red;text-size:larger'>" &
                          "<b>The match cannot be played more than 4 weeks before or after the fixture date.<br/><br/>" &
                          "If you believe the match was played within within this restriction, or was sanctioned by the " &
                          "league secretary you should send the full result to the league secretary. " &
                          "The secretary will verify, And if OK, enter the result on your behalf.</span></b><br /><br />")
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

            HomeFrames_Literal.Text = 0
            AwayFrames_Literal.Text = 0

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
                    HomeFrames_Literal.Text += Math.Abs(CInt((homeScore(ix) > awayScore(ix))))
                    AwayFrames_Literal.Text += Math.Abs(CInt((homeScore(ix) < awayScore(ix))))
                Next
                status_Literal.Text = "Results checked.<br/><strong>"
                If AwayFrames_Literal.Text < HomeFrames_Literal.Text Then
                    status_Literal.Text = HomeTeam_DropDownList.SelectedItem.Text & " wins " & HomeFrames_Literal.Text & " frames to " & AwayFrames_Literal.Text
                ElseIf AwayFrames_Literal.Text > HomeFrames_Literal.Text Then
                    status_Literal.Text = AwayTeam_Literal.Text & " wins " & AwayFrames_Literal.Text & " frames to " & HomeFrames_Literal.Text
                Else
                    status_Literal.Text = HomeTeam_DropDownList.SelectedItem.Text & " draws with " & AwayTeam_Literal.Text
                End If

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
                        If SessionadminDetails.Value = "" Then
                            Send_Button.Text = "Finished"
                        End If

                    Else

                        Dim MatchID As Integer = Store_result()

                        If MatchID > 0 Then

                            If Not Send_email(MatchID) Then

                                status_Literal.Text += "<br/><span style='color:blue;'>Your result card Emails have been sent.  Click Finished.</span>"
                                Retry_Button.Visible = False
                                Cancel_Button.Visible = False
                                If SessionadminDetails.Value = "" Then
                                    Send_Button.Text = "Finished"
                                End If
                            Else

                                SessionMatchResultID.Value = MatchID
                                Retry_Button.Visible = True
                                Retry_Button.Text = "Re-send Emails"
                                Cancel_Button.Visible = False
                                If SessionadminDetails.Value = "" Then
                                    Send_Button.Text = "Finished"
                                End If
                            End If

                        End If

                    End If
                End If
            End If

        Else 'If Send_Button.Text = "Finished" Then
            Session("TeamID") = Nothing
            Response.Redirect("Login.aspx")

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

    Sub PopulateMatchResult(ByVal MatchResult As HBSAcodeLibrary.MatchResult)

        Setup_TextBoxes()

        If MatchResult.MatchResultID > 0 Then  'a match is already recorded for this date

            Dim Match As DataRow = MatchResult.Match.Rows(0)
            Dim HomeBreaksTable As DataTable = MatchResult.HomeBreaksTable
            Dim AwayBreaksTable As DataTable = MatchResult.AwayBreaksTable


            status_Literal.Text = "Enter any changes required, then click 'Check your results card'&nbsp;&nbsp;&nbsp;&nbsp;"

            Try
                matchDate_CalendarExtender.SelectedDate = CDate(Match.Item("Match Date"))
                matchDate_Textbox.Text = Format(matchDate_CalendarExtender.SelectedDate, "dd MMM yyyy")
            Catch ex As Exception
                'matchDate_CalendarExtender.SelectedDate = DateTime.MinValue
                matchDate_Textbox.Text = ""
            End Try
            HomeFrames_Literal.Text = Match.Item("H_Pts")
            AwayFrames_Literal.Text = Match.Item("A_Pts")

            PopulateBreaksTable(webPage_HomeBreaks_Table, HomeBreaksTable)
            Session("HomeAspBreaksTable") = HomeBreaksTable
            PopulateBreaksTable(webPage_AwayBreaks_Table, AwayBreaksTable)
            Session("AwayAspBreaksTable") = AwayBreaksTable

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

            PopulateBreaksPlayers(False) 'Home
                PopulateBreaksPlayers(True)  'Away

                status_Literal.Text = "<br/>This match has already been recorded.<br />Make any required changes and click 'Check your results card', or click 'Cancel'."

                Recover_Button.Visible = False
                If SessionadminDetails.Value <> "" Then
                    Delete_Result_Div.Visible = True
                Else
                    Delete_Result_Div.Visible = False
                End If

            status_Literal.Text = "<br />To submit your match results enter the details, then click 'Check your results card'"

            matchDate_CalendarExtender.SelectedDate = FixtureDate_DropDownList.SelectedItem.Text
            matchDate_Textbox.Text = Format(matchDate_CalendarExtender.SelectedDate, "dd MMM yyyy")

            Delete_Result_Div.Visible = False
            If SessionadminDetails.Value <> "" AndAlso HBSAcodeLibrary.MatchResult.DeletedExists(HomeTeam_DropDownList.SelectedValue, SessionAwayTeamID.Value) Then
                Recover_Button.Visible = True
            Else
                Recover_Button.Visible = False
            End If

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
                    HCapTB.Visible = true'Section_DropDownList.SelectedValue < 7
                    Exit Sub
                End If
            Next

            .SelectedIndex = 0        '  not found, default to zero IX
            ScoreTB.Text = 0
            HCapTB.Text = 0
            HCapTB.Visible = True

        End With

    End Sub

    Protected Sub PopulateBreaksTable(WebPage_Breaks_Table As Table, asp_BreaksTable As DataTable)

        'populate the list of breaks in a native html table to match the format used by the javascript

        With WebPage_Breaks_Table
            .Rows.Clear()

            ' reflect empty table in the hidden element
            Dim Player_IDs As HtmlInputHidden
            If WebPage_Breaks_Table.ID.ToLower Like "*home*" Then
                Player_IDs = Home_Player_IDs
            Else
                Player_IDs = Away_Player_IDs
            End If
            Player_IDs.Value = ""

            For Each Break As DataRow In asp_BreaksTable.Rows
                Dim rowNo As Integer = .Rows.Count

                Dim newRow As New TableRow With {
                    .ID = WebPage_Breaks_Table.ID & "|r" & rowNo
                }
                newRow.Attributes.Add("runat", "server")

                Dim newCell0 As New TableCell With {
                    .ID = WebPage_Breaks_Table.ID & "|r" & rowNo & "c0",
                    .Text = Break.Item("Player")
                }
                newRow.Cells.Add(newCell0)

                Dim newCell1 As New TableCell With {
                    .ID = WebPage_Breaks_Table.ID & "|r" & rowNo & "c1",
                    .Text = Break.Item("Break")
                }
                newRow.Cells.Add(newCell1)

                Dim newCell2 As New TableCell With {
                    .ID = WebPage_Breaks_Table.ID & "|r" & rowNo & "c2",
                    .Text = "<span onmouseover=""this.style.cursor='pointer';"" onclick=""deleteBreakRow(this);""><i><span style='color:red;'>remove</span></i></span>"
                }
                newRow.Cells.Add(newCell2)

                .Rows.Add(newRow)

                Player_IDs.Value = Player_IDs.Value & Break.Item("PlayerID") & "," & Break.Item("Break") & "|"

            Next

        End With

    End Sub

    Protected Sub FixtureDate_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles FixtureDate_DropDownList.SelectedIndexChanged

        Session("HalfWay") = Int(FixtureDate_DropDownList.SelectedValue / 100)

        InitBoxes()

        Using dr As New HBSAcodeLibrary.TeamData(Section_DropDownList.SelectedValue, FixtureDate_DropDownList.SelectedValue Mod 100, HomeTeam_DropDownList.SelectedValue)
            AwayTeam_Literal.Text = (dr.ClubName & " " & dr.Team).Trim
            SessionAwayTeamID.Value = dr.ID
        End Using

        Using MatchResult As New HBSAcodeLibrary.MatchResult(HomeTeam_DropDownList.SelectedValue, SessionAwayTeamID.Value)
            'If not an administrator ensure it is not outside the 4 week limit
            If SessionadminDetails.Value = "" Then
                Dim TodaysDate As Date = Utilities.UKDateTimeNow
                Dim FixtureDate As Date = CDate(FixtureDate_DropDownList.SelectedItem.Text)
                Dim diff As Integer = DateDiff(DateInterval.Day, FixtureDate, TodaysDate)
                If diff > 32 Then 'cannot enter match result more than 4 weeks & 4 days (grace) after the fixture
                    'date, allowing 2 days grace to enter it. 
                    status_Literal.Text = "<br/><span style='color:red;text-size:larger'>" &
                      "<b>The match cannot be entered or changed more than 4 weeks before or after the fixture date.<br/><br/>" &
                      "If you believe the match was played within within this restriction, or was sanctioned by the " &
                      "league secretary you should send the full result to the league secretary. " &
                      "The secretary will verify, And if OK, enter the result on your behalf.</span></b><br /><br />"

                    Exit Sub
                End If
            End If

            Setup_TextBoxes()
            PopulateMatchResult(MatchResult)

        End Using


    End Sub

    Sub PopulateBreaksPlayers(Away As Boolean)

        Dim PlayerLists() As DropDownList = {HomePlayer1_DropDownList, HomePlayer2_DropDownList, HomePlayer3_DropDownList, HomePlayer4_DropDownList,
                                             AwayPlayer1_DropDownList, AwayPlayer2_DropDownList, AwayPlayer3_DropDownList, AwayPlayer4_DropDownList}

        Dim BreakPlayerDD As DropDownList = IIf(Away, AwayBreakPlayers_DropDownList, HomeBreakPlayers_DropDownList)

        With BreakPlayerDD
            .Items.Clear()
            .Items.Add("**Select a player**")
            For ix = If(Away, 4, 0) To If(Away, 7, 3)
                If PlayerLists(ix).SelectedValue.Split("|")(0) <> " " AndAlso PlayerLists(ix).SelectedValue.Split("|")(0) > 0 Then
                    .Items.Add(New ListItem(PlayerLists(ix).SelectedItem.Text, PlayerLists(ix).SelectedValue.Split("|")(0)))
                End If
            Next

        End With

    End Sub

    Function Store_result() As Integer

        CheckHandicapBoxes()

        Try
            Dim MatchID As Integer =
                HBSAcodeLibrary.MatchResult.InsertResultCard(matchDate_Textbox.Text,
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
            InsertMatchBreaks(Session("HomeAspBreaksTable"), MatchID)
            InsertMatchBreaks(Session("AwayAspBreaksTable"), MatchID)

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
                        Throw New ApplicationException("Database error recording a break (MatchResultID = " & MatchID &
                                                                                             "PlayerID = " & BreakRow.item("PlayerID") &
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

        MatchResult = MatchResult.Replace("|League|", League_Literal.Text)
        MatchResult = MatchResult.Replace("|Section|", Section_DropDownList.SelectedItem.Text)
        MatchResult = MatchResult.Replace("|FixtureDate|", FixtureDate_DropDownList.SelectedItem.Text)
        MatchResult = MatchResult.Replace("|MatchDate|", matchDate_Textbox.Text)
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

        Dim Breaks As String = ""
        For Each PlayerBreakRow As DataRow In Session("HomeAspBreaksTable").Rows
            Breaks += PlayerBreakRow.Item("Player") & " " & PlayerBreakRow.Item("Break") & ", "
        Next
        For Each PlayerBreakRow As DataRow In Session("AwayAspBreaksTable").Rows
            Breaks += PlayerBreakRow.Item("Player") & " " & PlayerBreakRow.Item("Break") & ", "
        Next
        If Breaks.Length > 2 Then Breaks = Left(Breaks, Breaks.Length - 2)
        MatchResult = MatchResult.Replace("|Breaks|", Breaks)

        MatchResult = MatchResult.Replace("|HomeFrames|", HomeFrames_Literal.Text)
        MatchResult = MatchResult.Replace("|AwayFrames|", AwayFrames_Literal.Text)

        Using cfg As New HBSAcodeLibrary.HBSA_Configuration

            Dim toAddress As String = HBSAcodeLibrary.MatchResult.MatchTeamUsers(MatchID) 'cfg.value("LeagueSecretaryEmail")
            Dim ccAddr As String = SessionadminDetails.Value 'copy to administrator if logged in as admin
            Dim subject As String
            Dim body As String
            subject = "Match result from " & HomeTeam_DropDownList.SelectedItem.Text.Trim
            body = "Result Card from " & HomeTeam_DropDownList.SelectedItem.Text.Trim & "<br />" &
                            MatchResult & "<br/><br/>"
            Try
                HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body, ccAddr, , MatchID, SessionUser.Value)
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

        Dim caller As String = Session("LoginCaller")
        Session("TeamID") = Nothing
        Session("LoginCaller") = "MatchResult.aspx"
        Response.Redirect("Login.aspx")

    End Sub

    Protected Sub Retry_Button_Click(sender As Object, e As EventArgs) Handles Retry_Button.Click

        'If Retry_Button.Text = "Re-send Emails" Then

        status_Literal.Text = ""

        If Not Send_email(SessionMatchResultID.Value) Then

            status_Literal.Text += "<br/><span style='color:blue;'>Your result card Emails have been sent.  Click Finished.</span>"
            Retry_Button.Visible = False
            'Retry_Button.Text = "Change the details"
            Cancel_Button.Visible = False
            Send_Button.Text = "Finished"

        Else

            Retry_Button.Visible = True
            Retry_Button.Text = "Re-send Emails"
            Cancel_Button.Visible = False
            Send_Button.Text = "Finished"

        End If

    End Sub

    Sub Reform_and_store_the_breaks_tables()

        Dim Home_PlayerIDsAndBreaks() As String = Home_Player_IDs.Value.Split("|")
        Dim HomeAspBreaksTable As DataTable = CreateAspBreaksTable(Home_PlayerIDsAndBreaks)
        PopulateBreaksTable(webPage_HomeBreaks_Table, HomeAspBreaksTable)
        Session("HomeAspBreaksTable") = HomeAspBreaksTable

        Dim Away_PlayerIDsAndBreaks() As String = Away_Player_IDs.Value.Split("|")
        Dim AwayAspBreaksTable As DataTable = CreateAspBreaksTable(Away_PlayerIDsAndBreaks)
        PopulateBreaksTable(webPage_AwayBreaks_Table, AwayAspBreaksTable)
        Session("AwayAspBreaksTable") = AwayAspBreaksTable

        Retry_Button.Visible = False

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

    Sub CheckHandicapBoxes()

        'if non administrator use the drop down handicap value 
        If SessionadminDetails.Value = "" Then
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