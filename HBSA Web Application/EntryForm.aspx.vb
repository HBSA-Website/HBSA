Imports HBSAcodeLibrary
Public Class EntryForm
    Inherits System.Web.UI.Page

    Protected Sub Accept_Button_Click(sender As Object, e As EventArgs) _
        Handles Accept_Button.Click, Accept_CheckBox.CheckedChanged

        If Accept_CheckBox.Checked Then
            Club_Panel.Visible = True
            Acceptance_Panel.Visible = False
            PopulateClubs()
        Else
            Club_Panel.Visible = False
            Acceptance_Panel.Visible = True
        End If

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Session("LoginCaller") = Request.Url.AbsolutePath
        If adminHiddenField.Value = "" Then
            If (Session("adminDetails") Is Nothing) OrElse (Session("adminDetails").Rows.count = 0) Then
                adminHiddenField.Value = "False"
            Else
                adminHiddenField.Value = "True"
            End If
        End If

        If adminHiddenField.Value = "True" Then
            Club_Selector_Literal.Text = "<br/><span style=""text-align: center""><span style='color:#FF6600;'><h3>BEWARE!! if the entry forms have been applied changes here will have no effect.</h3></span></span>"
        Else

            If Not HBSA_Configuration.CloseSeason Then
                Club_Selector_Literal.Text = "<br/><br/><br/><span style=""text-align: center""><span style='color:red;'><h3>You cannot complete an entry form whilst the current season is active.</h3></span></span><br/><br/>"
                Club_UpdatePanel.Visible = False
                Teams_UpdatePanel.Visible = False
                Head_Literal.Visible = False
                Exit Sub
            Else
                If Not HBSA_Configuration.AllowLeaguesEntryForms Then
                    Club_Selector_Literal.Text = "<br/><br/><br/><span style=""text-align: center""><span style='color:red;'><h3>You cannot complete an entry form until entry forms are made available.</h3></span></span><br/><br/>"
                    Club_UpdatePanel.Visible = False
                    Teams_UpdatePanel.Visible = False
                    Head_Literal.Visible = False
                    Exit Sub
                End If
            End If
        End If

        If Not IsPostBack Then

            Using AcceptanceCopy As New ContentData("Entry Form Acceptance")
                Using cfg As New HBSA_Configuration
                    AcceptanceCopy_Literal.Text = AcceptanceCopy.ContentHTML.Replace("|Default Handicap|", cfg.Value("EntryFormNewRegStartHCap"))
                End Using
            End Using

            userHiddenField.Value = Session("user")
            ClubLoginIDHiddenField.Value = Session("ClubLoginID")

            Season_Literal.Text = CStr(Year(Today)) & " - " & CStr(Year(Today) + 1)
            Club_Fee_Literal.Text = ""

            populateClubs()

            With Team_League_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("**Select a league**", 0))
                For Each League As DataRow In LeagueData.AllLeagues.Rows
                    .Items.Add(New ListItem(League.Item("League name"), League.Item("ID")))
                Next
            End With

            Using HeaderText As New ContentData("EntryFormHeader_Leagues")
                Head_Literal.Text = HeaderText.ContentHTML
            End Using

            If (Session("adminDetails") Is Nothing) OrElse (Session("adminDetails").Rows.count = 0) Then
                Player_Handicap_Text.Attributes.Add("readonly", "true")
                Player_Handicap_Text.Attributes.Add("onclick", """loadDiv('divHCapMsg');""")
                Player_Handicap_Text.Attributes.Add("onmouseover", """this.style.cursor='pointer';""")
            End If

        End If

    End Sub

    Protected Sub PopulateClubs()

        Using clubs As DataTable = EntryFormData.GetClubs()

            With Club_DropDownList
                .Items.Clear()
                .Visible = True

                .Items.Add(New ListItem("**Select a Club**", "-1"))
                .Items.Add(New ListItem("**New Club to the HBSA**", "0"))

                For Each row As DataRow In clubs.Rows
                    .Items.Add(New ListItem(row.Item("Club Name"), row.Item("ClubID")))
                Next

                .Enabled = True

                .SelectedIndex = 0
                ShowHideTeamsPanel(False)

                If adminHiddenField.Value = "True" Then
                    Club_Selector_Literal.Text += "<span style='color:red;'> You are logged in as an administrator. Select the required club and proceed.</span>"
                    Club_Panel.Visible = True
                    Club_UpdatePanel.Visible = True
                    Acceptance_Panel.Visible = False
                Else
                    If ClubLoginIDHiddenField.Value <> "" Then
                        If Not Accept_CheckBox.Checked Then
                            'first time in - show acceptance panel
                            Club_Panel.Visible = False
                            Acceptance_Panel.Visible = True
                        Else

                            'we have a logged in user, select & fix the club
                            Using User As New ClubUserData(ClubLoginIDHiddenField.Value)
                                .SelectedValue = User.ClubID
                                .Enabled = False
                                Club_DropDownList_SelectedIndexChanged(New Object, New EventArgs)
                            End Using
                            Club_Selector_Literal.Text = "You are registered to this club, please proceed."

                            Club_Panel.Visible = True
                            Club_UpdatePanel.Visible = True
                            Acceptance_Panel.Visible = False

                        End If

                    Else
                        'neither admin nor user logged in
                        Club_Selector_Literal.Text = "&nbsp;&nbsp;&nbsp;&nbsp;<span style='color:red;'>You are not logged in.<br/><br/>" &
                                                     "&nbsp;&nbsp;&nbsp;&nbsp;<a href=""ClubLogin.aspx"" >Log in</a> with the credentials that are registered to your club,<br/><br/>" &
                                                     "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;or if you wish to register a new club to the league, download an entry form <a href=""EntryFormsDownload.aspx"" >(League >> Entry Forms Download)</a>,<br/>" &
                                                     "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;complete it and post it (the address is on the form).</span>"
                        Session("LoginCaller") = "EntryForm.aspx"
                        Club_UpdatePanel.Visible = False
                    End If
                End If

            End With

        End Using

    End Sub

    Private Sub Club_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Club_DropDownList.SelectedIndexChanged

        Dim _ClubID As Integer = Club_DropDownList.SelectedValue

        Teams_Literal.Text = ""
        Club_Status_Literal.Text = ""

        If Club_DropDownList.SelectedIndex < 2 Then

            'Club_ID.Text = _ClubID
            Club_Name_TextBox.Text = ""
            Club_Addr1_TextBox.Text = ""
            Club_Addr2_TextBox.Text = ""
            Club_PostCode_TextBox.Text = ""
            Club_NoTables_TextBox.Text = ""
            Club_Contact_TextBox.Text = ""
            Club_Email_Label.Text = ""
            Club_Telephone_TextBox.Text = ""
            Club_Mobile_TextBox.Text = ""

            Club_Save_Button.Visible = True
            Club_WIP_Literal.Text = ""
            Club_Save_Button.Text = "Save Club Details"

            Show_Button.Visible = False

        Else

            Show_Button.Visible = True

            Using EntryForm As EntryFormData = New EntryFormData(_ClubID)

                With EntryForm
                    Club_Fee_Literal.Text = Format(.ClubFee, "0.00")
                    'Club_ID.Text = .ClubID
                    Club_Name_TextBox.Text = .ClubName
                    Club_Addr1_TextBox.Text = .Address1
                    Club_Addr2_TextBox.Text = .Address2
                    Club_PostCode_TextBox.Text = .PostCode
                    Club_NoTables_TextBox.Text = .MatchTables
                    Club_Contact_TextBox.Text = .ContactName
                    Club_Email_Label.Text = .ContactEMail
                    Club_Telephone_TextBox.Text = .ContactTelNo
                    Club_Mobile_TextBox.Text = .ContactMobNo
                    privacyCheckBox.Checked = .PrivacyAccepted

                    Select Case .State

                        Case EntryFormData.WIP.NotEntered
                            Club_Save_Button.Visible = True
                            .UpdateWIP(EntryFormData.WIP.InProgress, userHiddenField.Value)
                            Club_WIP_Literal.Text = ""
                            Club_Save_Button.Text = "Save/Accept Club Details"

                        Case EntryFormData.WIP.InProgress, EntryFormData.WIP.Submitted
                            Club_Save_Button.Visible = True
                            Club_WIP_Literal.Text = ""
                            Club_Save_Button.Text = "Save/Accept Club Details"

                        Case EntryFormData.WIP.Fixed
                            Club_WIP_Literal.Text = "<span style='color:red;'>This entry form has been accepted and processed. No changes allowed.<br/>Contact the HBSA if changes are needed.</span>"
                            Club_Save_Button.Visible = False

                    End Select

                    If adminHiddenField.Value = "False" Then
                        ' not admin so simulate save/accept club 
                        Club_Save_Button.Visible = False
                    Else
                        'admin - allows club details to change
                        Club_Save_Button.Visible = True
                    End If
                    SaveClub_Button_Click(sender, e)

                End With

            End Using

        End If

    End Sub

    Protected Sub SaveClub_Button_Click(sender As Object, e As EventArgs) Handles Club_Save_Button.Click

        submitErrorMsg.Text = ""

        If Club_Save_Button.Text = "Edit Club details" Then
            ShowHideTeamsPanel(False)
        ElseIf Club_Save_Button.Text = "Change" Then
            Club_Save_Button.Visible = True
            Using EntryForm As New EntryFormData(Club_DropDownList.SelectedValue)
                EntryForm.UpdateWIP(EntryFormData.WIP.InProgress, userHiddenField.Value)
            End Using
            Club_WIP_Literal.Text = ""
            Club_Save_Button.Text = "Save/Accept Club Details"
            Club_Status_Literal.Text = ""
        Else

            'validate the data
            Dim errMsg As String = ""
            Dim NoTables As Integer

            Try
                NoTables = CInt(Club_NoTables_TextBox.Text)
                If NoTables < 1 Then
                    errMsg += "<br/>There must be at least one available snooker table."
                End If

            Catch ex As Exception
                errMsg += "<br/>No of tables must be numbers."
            End Try

            If Club_Name_TextBox.Text.Trim = "" Then errMsg += "<br/>There must be a Club Name."
            If Club_Addr1_TextBox.Text.Trim = "" Then errMsg += "<br/>There must be at least one address line."
            If Club_PostCode_TextBox.Text.Trim = "" Then errMsg += "<br/>There must be a post code."
            If Club_Contact_TextBox.Text.Trim = "" Then errMsg += "<br/>There must be contact name."
            If Club_Telephone_TextBox.Text.Trim = "" AndAlso
               Club_Mobile_TextBox.Text.Trim = "" Then
                errMsg += "<br/>There must be at least one of Telephone or Mobile."
            End If
            Dim formattedNo As String
            If Club_Telephone_TextBox.Text.Trim <> "" Then
                formattedNo = SharedRoutines.CheckValidPhoneNoForHuddersfield(Club_Telephone_TextBox.Text.Trim)
                If formattedNo.StartsWith("ERR") Then
                    errMsg += "<br/>The telephone number is invalid (" + formattedNo.Substring(7)
                Else
                    Club_Telephone_TextBox.Text = formattedNo
                End If
            End If
            If Club_Mobile_TextBox.Text.Trim <> "" Then
                formattedNo = SharedRoutines.CheckValidPhoneNoForHuddersfield(Club_Mobile_TextBox.Text.Trim)
                If formattedNo.StartsWith("ERR") Then
                    errMsg += "<br/>The mobile number is invalid (" + formattedNo.Substring(7)
                ElseIf formattedNo.Substring(1, 1) <> "7" Then
                    errMsg += "<br/>The mobile number is invalid (must be an 07 number)"
                Else
                    Club_Mobile_TextBox.Text = formattedNo
                End If
            End If

            If errMsg = "" Then

                Dim _ClubID As Integer = Club_DropDownList.SelectedValue

                Using EntryForm As EntryFormData = New EntryFormData(_ClubID)

                    With EntryForm

                        .ClubName = Club_Name_TextBox.Text.Trim
                        .Address1 = Club_Addr1_TextBox.Text.Trim
                        .Address2 = Club_Addr2_TextBox.Text.Trim
                        .PostCode = Club_PostCode_TextBox.Text.Trim
                        .MatchTables = Club_NoTables_TextBox.Text.Trim
                        .ContactName = Club_Contact_TextBox.Text.Trim
                        .ContactTelNo = Club_Telephone_TextBox.Text.Trim
                        .ContactMobNo = Club_Mobile_TextBox.Text.Trim
                        .PrivacyAccepted = privacyCheckBox.Checked

                        Try

                            _ClubID = .MergeClubData()

                            If ClubLoginIDHiddenField.Value = "" Then
                                PopulateClubs()
                            End If

                            Club_DropDownList.SelectedValue = _ClubID

                            If adminHiddenField.Value = "True" Then
                                Club_Status_Literal.Text = "<br/><span style='color:blue;'>Club details saved, Select or create a team.</span>"
                            Else
                                Club_Status_Literal.Text = "<br/><span style='color:blue;'>To change any club details please <a href='Contact.aspx'>Contact the HBSA.</a></span>"
                            End If

                            ShowHideTeamsPanel(True)

                            PopulateTeams(EntryForm)

                            privacyCheckBox.Checked = .PrivacyAccepted

                        Catch ex As Exception
                            If ex.Message Like "*uplicate*" Then
                                Club_Status_Literal.Text = "<span style='color:red;'>Cannot save as this club name is already registered.</span>"
                            Else
                                Club_Status_Literal.Text = "<span style='color:red;'>Database error:" & ex.Message & "</span>"
                            End If

                        End Try

                    End With

                End Using

            Else
                Club_Status_Literal.Text = "<span style='color:red;'>" & errMsg & "</span>"
            End If

        End If

    End Sub

    Sub ShowHideTeamsPanel(Show As Boolean)

        Teams_Panel.Visible = Show

        Club_Name_TextBox.Enabled = Not Show
        Club_Addr1_TextBox.Enabled = Not Show
        Club_Addr2_TextBox.Enabled = Not Show
        Club_PostCode_TextBox.Enabled = Not Show
        Club_NoTables_TextBox.Enabled = Not Show
        Club_Contact_TextBox.Enabled = Not Show
        Club_Email_Label.Enabled = Not Show
        Club_Telephone_TextBox.Enabled = Not Show
        Club_Mobile_TextBox.Enabled = Not Show

        If Show Then
            Club_Save_Button.Text = "Edit Club details"
        Else
            Club_Save_Button.Text = "Save/Accept Club Details"
            Player_Edit_Panel.Visible = False
            Player_Transfer_Panel.Visible = False
            Club_Status_Literal.Text = ""
        End If

    End Sub

    Protected Sub PopulateTeams(ByRef EntryForm As EntryFormData)

        With Teams_GridView

            .DataSource = EntryForm.Teams
            .DataBind()

            If .Rows.Count > 0 Then
                .SelectedIndex = 0
                Player_Add_Button.Visible = True
            Else
                Player_Add_Button.Visible = False
            End If

            Teams_GridView_SelectedIndexChanged(New Object, New System.EventArgs)

        End With

        Teams_Literal.Text = ""

    End Sub

    Private Sub Teams_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Teams_GridView.RowDataBound

        If e.Row.Cells.Count > 2 Then
            For ix = 1 To 2
                e.Row.Cells(ix).Text = e.Row.Cells(ix).Text.Replace("&nbsp;", " ")
            Next

            For ix = 3 To e.Row.Cells.Count - 1
            e.Row.Cells(ix).Visible = False
        Next
        End If

    End Sub

    Private Sub Teams_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Teams_GridView.RowDeleting

        submitErrorMsg.Text = ""

        'Delete clicked:  ensure this row is selected
        Teams_GridView.SelectedIndex = e.RowIndex
        Teams_GridView_SelectedIndexChanged(sender, e)

        DeleteTeam_Literal.Text = Club_DropDownList.SelectedItem.Text & " " & Teams_GridView.Rows(e.RowIndex).Cells(1).Text & " " & Teams_GridView.Rows(e.RowIndex).Cells(2).Text
        divConfirmDeleteTeam.Style("display") = "block"

        e.Cancel = True

    End Sub
    Private Sub TeamDelete(sender As Object, e As EventArgs) Handles DeleteTeam_Button.Click

        Dim Team As String = Teams_GridView.SelectedRow.Cells(2).Text.Replace("&nbsp;", " ")

        Dim _ClubID As Integer = Club_DropDownList.SelectedValue

        Using EntryForm As EntryFormData = New EntryFormData(_ClubID)

            Try
                EntryForm.DeleteTeam(Team_League_DropDownList.SelectedValue, Team)

                'store status message (populateteams will destroy the literal text
                Dim statusMsg As String = "<span style='color:red;'>The " & (Team_League_DropDownList.SelectedItem.Text & " " & Team_Letter_DropDownList.SelectedValue).Trim & " team has been deleted.</br>" &
                                          "If this was a mistake click 'Add another Team' and re-enter the team details (the players will be reinstated and required players will need to be ReRegistered)." & "</span>"

                PopulateTeams(EntryForm)

                Teams_Literal.Text = statusMsg
                If Teams_GridView.Rows.Count > 0 Then
                    Teams_GridView.SelectedIndex = 0
                End If

            Catch ex As Exception
                Teams_Literal.Text = "<span style='color:red;'>Error deleting a team: " & ex.Message & "</span>"
            End Try

        End Using

        divConfirmDeleteTeam.Style("display") = "none"

    End Sub
    Private Sub KeepTeam(sender As Object, e As EventArgs) Handles KeepTeam_Button.Click
        divConfirmDeleteTeam.Style("display") = "none"
    End Sub
    Protected Sub Teams_GridView_SelectedIndexChanged(sender As Object, e As EventArgs) _
        Handles Teams_GridView.SelectedIndexChanged,
                Team_Add_Button.Click

        submitErrorMsg.Text = ""

        Dim _ClubID As Integer = Club_DropDownList.SelectedValue

        Dim teamLetter As String = ""
        Dim LeagueID As Integer = 0

        Teams_Literal.Text = ""
        Team_Literal.Text = ""

        Using EntryForm As EntryFormData = New EntryFormData(_ClubID)

            If TryCast(sender, Button) IsNot Nothing Or
               Teams_GridView.SelectedIndex < 0 Or
               Teams_GridView.Rows.Count = 0 Then

                'Add a team
                Team_Letter_DropDownList.SelectedValue = 0
                Team_Letter_DropDownList.Enabled = True
                Team_League_DropDownList.SelectedValue = 0
                Team_League_DropDownList.Enabled = True

                Teams_GridView.SelectedIndex = -1
                teamLiteral.Text = ""
                Teams_Literal.Text = "<span style='color:red; font-size:larger;color:navy;'>Enter the team details to the right, then click Save Team.</span>"
                Team_ContactCaptain_Label.Text = "Don't forget to choose a captain from the players when added."
                Team_ContactCaptain_PlayerID_HiddenField.Value = 0

            Else

                teamLetter = Teams_GridView.SelectedRow.Cells(2).Text.Replace("&nbsp;", " ")
                teamLiteral.Text = (Teams_GridView.SelectedRow.Cells(1).Text + " " & teamLetter).Trim
                LeagueID = Teams_GridView.SelectedRow.Cells(3).Text
                leagueIDHiddenField.Value = LeagueID

                Dim team As DataRow = EntryForm.Teams.Select("LeagueID=" & LeagueID & " And Team='" & teamLetter & "'")(0)
                Team_Fee_Literal.Text = "<b>" & Format(team!Fee, "£0.00") & "</b>"
                Team_ContactCaptain_Label.Text = "Don't forget to choose a captain from the players before submitting the entry form."
                Team_ContactCaptain_PlayerID_HiddenField.Value = team!Captain
                Team_Letter_DropDownList.SelectedValue = teamLetter
                Team_Letter_DropDownList.Enabled = False
                Team_League_DropDownList.SelectedValue = LeagueID
                Team_League_DropDownList.Enabled = False
            End If

            With Players_GridView

                Dim TeamPlayers As DataTable = EntryForm.Players.Clone()
                Dim Players() As DataRow = EntryForm.Players.Select("LeagueID=" & LeagueID & " and Team='" & teamLetter & "'")

                For Each PlayerRow In Players
                    TeamPlayers.ImportRow(PlayerRow)
                    If PlayerRow!Captain = 1 AndAlso
                        PlayerRow!PlayerID = Team_ContactCaptain_PlayerID_HiddenField.Value Then
                        Team_ContactCaptain_Label.Text = PlayerRow!FullName
                    End If
                Next

                .DataSource = TeamPlayers
                .DataBind()

            End With

        End Using

    End Sub
    Protected Sub SaveTeam_Button_Click(sender As Object, e As EventArgs) Handles Team_Save_Button.Click

        Dim _ClubID As Integer = Club_DropDownList.SelectedValue
        Teams_Literal.Text = ""
        submitErrorMsg.Text = ""

        'validate team data
        Dim errMsg As String = ""
        If Team_League_DropDownList.SelectedIndex < 1 Then errMsg += "Select a League<br/>"
        If Team_Letter_DropDownList.SelectedIndex < 1 Then errMsg += "Select a Team Letter<br/>"

        If errMsg = "" Then

            Dim LeagueID As Integer = Team_League_DropDownList.SelectedValue
            Dim TeamLetter As String = Team_Letter_DropDownList.SelectedValue

            EntryFormData.MergeTeam(_ClubID, LeagueID, TeamLetter, Team_ContactCaptain_PlayerID_HiddenField.Value)

            Using ef As New EntryFormData(_ClubID)

                PopulateTeams(ef)

                For Each row As GridViewRow In Teams_GridView.Rows
                    If row.Cells(3).Text = LeagueID And
                       row.Cells(2).Text.Replace("&nbsp;", " ") = TeamLetter Then
                        Teams_GridView.SelectedIndex = row.RowIndex
                        Exit For
                    End If
                Next
                Teams_GridView_SelectedIndexChanged(New GridView, New System.EventArgs)

            End Using
            Team_Literal.Text = "<span style='color:blue;'>Team saved<br/>Check and/or add players."
            If Team_ContactCaptain_PlayerID_HiddenField.Value = 0 Then
                Team_Literal.Text &= "<br/>Don't forget to choose a captain from the players before submitting the entry form."
            End If
            Team_Literal.Text &= "</span>"
        Else

            Team_Literal.Text = "<span style='color:red;'>" & errMsg & "</span>"

        End If


    End Sub

    Private Sub Players_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Players_GridView.RowDataBound

        If e.Row.Cells.Count > 2 Then
            If e.Row.RowType = DataControlRowType.Header Then
                e.Row.Cells(e.Row.Cells.Count - 5).Text = If(leagueIDHiddenField.Value = 2, "Over80", "Over70")
            End If

            If e.Row.RowType = DataControlRowType.DataRow Then
                'set up checkbox templates 
                CType(e.Row.Cells(1).Controls(1), CheckBox).Checked = CType(e.Row.Cells(e.Row.Cells.Count - 1).Controls(0), CheckBox).Checked
                CType(e.Row.Cells(2).Controls(1), CheckBox).Checked = e.Row.Cells(e.Row.Cells.Count - 2).Text = 1

                For ix As Integer = 2 To e.Row.Cells.Count - 1
                    If TryCast(e.Row.Cells(e.Row.Cells.Count - 1).Controls(0), CheckBox).Checked Then
                        e.Row.Cells(ix).BackColor = Drawing.Color.White
                        e.Row.Cells(ix).ForeColor = Drawing.Color.DarkGreen
                    Else
                        e.Row.Cells(ix).BackColor = Drawing.Color.FromArgb(244, 244, 244)
                        e.Row.Cells(ix).ForeColor = Drawing.Color.DarkGray
                    End If
                Next
            End If

            'hide the columns that the user does not need to see
            e.Row.Cells(3).Visible = False 'PlayerID
            e.Row.Cells(4).Visible = False 'LeagueID
            e.Row.Cells(9).Visible = False 'Team Letter
            e.Row.Cells(e.Row.Cells.Count - 4).Visible = False 'Tagged
            e.Row.Cells(e.Row.Cells.Count - 3).Visible = False 'FullName
            e.Row.Cells(e.Row.Cells.Count - 2).Visible = False 'Captain   
            e.Row.Cells(e.Row.Cells.Count - 1).Visible = False 'ReRegister

        End If

    End Sub

    Private Sub Players_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles Players_GridView.RowEditing

        submitErrorMsg.Text = ""

        Dim gvRow As GridViewRow = Players_GridView.Rows(e.NewEditIndex)

        Player_Forename_TextBox.Text = gvRow.Cells(5).Text.Replace("&nbsp;", " ").Replace("&#39;", "'")
        Player_Inits_TextBox.Text = gvRow.Cells(6).Text.Replace("&nbsp;", " ").Replace("&#39;", "'")
        Player_Surname_TextBox.Text = gvRow.Cells(7).Text.Replace("&nbsp;", " ").Replace("&#39;", "'")

        Player_Tag_Text.Value = gvRow.Cells(12).Text.Replace("&nbsp;", " ").Trim
        Player_Tag_Value.Value = gvRow.Cells(14).Text
        If Player_Tag_Value.Value = 0 Then
            Player_Tag_Text.Value = "Seasoned"
        End If

        Player_Over70_CheckBox.Checked = gvRow.Cells(1).Text IsNot ""
        Player_email_TextBox.Text = gvRow.Cells(10).Text.Replace("&nbsp;", " ").Replace("&#39;", "'")
        Player_TelNo_TextBox.Text = gvRow.Cells(11).Text.Replace("&nbsp;", " ").Replace("&#39;", "'")
        Player_Handicap_Text.Value = gvRow.Cells(8).Text.Replace("&nbsp;", " ").Replace("&#39;", "'")

        Player_Submit_Button.Text = "Save this Player"

        ShowHidePlayerPanel(True, "Edit a player")

        Players_GridView.SelectedIndex = e.NewEditIndex

        e.Cancel = True

    End Sub

    Private Sub Players_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Players_GridView.RowDeleting

        Dim _ClubID As Integer = Club_DropDownList.SelectedValue
        Dim _LeagueID As Integer = Team_League_DropDownList.SelectedValue
        Dim _TeamLetter As String = Team_Letter_DropDownList.SelectedValue
        Dim _PlayerID As Integer = Players_GridView.Rows(e.RowIndex).Cells(3).Text

        Player_Error_Literal.Text = ""
        submitErrorMsg.Text = ""

        Try
            'setting club id to zero effectively deletes the player
            EntryFormData.MergePlayer(_PlayerID,
                                      0,
                                      _LeagueID,
                                      _TeamLetter,
                                      "",
                                      "",
                                      "",
                                      0,
                                      "",
                                      "",
                                      0,
                                      0,
                                      0)

            Teams_GridView_SelectedIndexChanged(Teams_GridView, e)

        Catch ex As Exception

            Player_Error_Literal.Text = "ERROR: " & ex.Message & "<br/>Please inform HBSA with all these details via the contact page."

        End Try


        e.Cancel = True

    End Sub

    Protected Sub AddPlayer_Button_Click(sender As Object, e As EventArgs) Handles Player_Add_Button.Click

        If Player_Transfer_TextBox.Text.Trim.Length > 0 Then
            'try to use the player data already entered
            'strip out any multiple spaces
            Player_Transfer_TextBox.Text = Player_Transfer_TextBox.Text.Trim
            While Player_Transfer_TextBox.Text.Contains("  ")
                Player_Transfer_TextBox.Text = Player_Transfer_TextBox.Text.Replace("  ", " ")
            End While
            'get name elements
            Dim NameElements() As String = Player_Transfer_TextBox.Text.Split(" ")
            Select Case NameElements.Length
                Case 1
                    Player_Forename_TextBox.Text = ""
                    Player_Inits_TextBox.Text = ""
                    Player_Surname_TextBox.Text = NameElements(0)
                Case 2
                    Player_Forename_TextBox.Text = NameElements(0)
                    Player_Inits_TextBox.Text = ""
                    Player_Surname_TextBox.Text = NameElements(1)
                Case Else
                    Player_Forename_TextBox.Text = NameElements(0)
                    Player_Inits_TextBox.Text = NameElements(1)
                    Player_Surname_TextBox.Text = NameElements(2)

            End Select

        Else
            Player_Forename_TextBox.Text = ""
            Player_Inits_TextBox.Text = ""
            Player_Surname_TextBox.Text = ""
        End If

        'Player_Tag_Text.Value = "Unseasoned"  'Adding so set unseasoned
        Player_Tag_Value.Value = 3
        'Player_Tagged_DropDownList.SelectedValue = 3 'Adding so set unseasoned
        Player_Over70_CheckBox.Checked = False
        Player_email_TextBox.Text = ""
        Player_TelNo_TextBox.Text = ""
        Using cfg As New HBSA_Configuration
            Player_Handicap_Text.Value = cfg.Value("EntryFormNewRegStartHCap")
        End Using

        Player_Submit_Button.Text = "Add this Player"

        ShowHidePlayerPanel(True, "Add a new player")

    End Sub

    Protected Sub ShowHidePlayerPanel(Show As Boolean, Optional PlayerPanelTitle As String = "")

        AddEdit_Literal.Text = PlayerPanelTitle
        Player_Edit_Panel.Visible = Show
        Team_ContactCaptain_Label.Enabled = Not Show
        Team_Add_Button.Visible = Not Show
        Team_Save_Button.Visible = Not Show
        Player_Add_Button.Visible = Not Show
        Player_Find_Button.Visible = Not Show
        If Show Then
            Player_Transfer_Panel.Visible = False
        Else
            Player_Similar_Panel.Visible = False
        End If

        submitEntryForm_Button.Visible = Not Show

    End Sub
    Protected Sub Player_Cancel_Button_Click(sender As Object, e As EventArgs) Handles Player_Cancel_Button.Click

        ShowHidePlayerPanel(False)

    End Sub
    Protected Sub Player_Submit_Button_Click(sender As Object, e As EventArgs) _
            Handles Player_Submit_Button.Click, Player_Similar_Add_Button.Click

        Dim _ClubID As Integer = Club_DropDownList.SelectedValue
        Dim _LeagueID As Integer = Team_League_DropDownList.SelectedValue
        Dim _TeamLetter As String = Team_Letter_DropDownList.SelectedValue

        'given a player edit validate

        Dim errMsg As String = ""
        Player_Status_Literal.Text = ""

        If Player_Forename_TextBox.Text.Trim = "" Then errMsg += "There must be a player's first name<br/>"
        If Player_Surname_TextBox.Text.Trim = "" Then errMsg += "There must be a player's surname<br/>"

        Dim senderID As String = DirectCast(sender, Button).ID.ToLower
        Dim senderText As String = DirectCast(sender, Button).Text.ToLower

        If senderText Like "*add*" AndAlso
           Not senderID Like "*similar*" Then
            'check for similar name
            Dim otherPlayer As DataTable = EntryFormData.SimilarPlayers(_LeagueID, 0,
                                                                        Player_Forename_TextBox.Text.Trim,
                                                                        Player_Inits_TextBox.Text.Trim,
                                                                        Player_Surname_TextBox.Text.Trim)
            If otherPlayer IsNot Nothing AndAlso
                otherPlayer.Rows.Count > 0 Then
                'There are other players with a similar name
                'Show the options (use entered one, or substitute a transfer of another)
                Player_Similar_Panel.Visible = True
                Player_Similar_GridView.DataSource = otherPlayer
                Player_Similar_GridView.DataBind()
                Exit Sub
            End If
        Else
            Player_Similar_Panel.Visible = False
        End If


        Try

            Dim hcap As Integer = CInt(Player_Handicap_Text.Value.Trim)
            Using lgd As LeagueData = New LeagueData(_LeagueID)

                If hcap > lgd.MaxHandicap OrElse hcap < lgd.MinHandicap Then
                    errMsg += "<br/>A " & lgd.LeagueName & " handicap must be between " & lgd.MinHandicap & " and " & lgd.MaxHandicap & "."
                End If
                If _LeagueID = 3 Then
                    If hcap Mod 5 <> 0 Then
                        Using cfg As New HBSAcodeLibrary.HBSA_Configuration
                            If hcap <> cfg.Value("EntryFormNewRegStartHCap") Then
                                errMsg += "<br/>A billiards handicap must be a multiple Of 5."
                            End If
                        End Using
                    End If
                End If

            End Using

        Catch ex As Exception

            errMsg += "The handicap must be a positive Or negative number"

        End Try

        If Not Player_email_TextBox.Text.Trim = "" Then
            If Not Emailer.IsValidEmailAddress(Player_email_TextBox.Text.Trim) Then
                errMsg += "<br/>The email address Is incorrectly formatted."
            End If
        End If
        If Player_TelNo_TextBox.Text.Trim <> "" Then
            Dim formattedNo As String = SharedRoutines.CheckValidPhoneNoForHuddersfield(Player_TelNo_TextBox.Text.Trim)
            If formattedNo.StartsWith("ERR") Then
                errMsg += "<br/>Invalid telephone no. (" + formattedNo.Substring(7)
            Else
                Player_TelNo_TextBox.Text = formattedNo
            End If
        End If

        If errMsg = "" Then

            'validated OK merge the player and refresh the players gridview

            Dim _PlayerID As Integer = If(Player_Submit_Button.Text.ToLower Like "*add*", 0, Players_GridView.SelectedRow.Cells(3).Text)

            Try
                EntryFormData.MergePlayer(_PlayerID,
                                          _ClubID,
                                          _LeagueID,
                                          _TeamLetter,
                                          Player_Forename_TextBox.Text.Trim,
                                          Player_Inits_TextBox.Text.Trim,
                                          Player_Surname_TextBox.Text.Trim,
                                          Player_Handicap_Text.Value,
                                          Player_email_TextBox.Text.Trim,
                                          Player_TelNo_TextBox.Text.Trim,
                                          Player_Tag_Value.Value,
                                          Player_Over70_CheckBox.Checked,
                                          1) 'assume that modified or added or transferred player is to be registered

                Teams_GridView_SelectedIndexChanged(Teams_GridView, e)

                ShowHidePlayerPanel(False)

            Catch ex As Exception
                Player_Status_Literal.Text = "Error: " & ex.Message
            End Try

        Else
            Player_Status_Literal.Text = errMsg
        End If

    End Sub

    Protected Sub Player_Similar_GridView_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Player_Similar_GridView.SelectedIndexChanged

        Try

            'use the selected player for this team
            Dim _PlayerID As Integer = Player_Similar_GridView.SelectedRow.Cells(3).Text
            Dim _ClubID As Integer = Club_DropDownList.SelectedValue
            Dim _LeagueID As Integer = Team_League_DropDownList.SelectedValue
            Dim _TeamLetter As String = Team_Letter_DropDownList.SelectedValue

            EntryFormData.TransferPlayer(_PlayerID,
                                         _ClubID,
                                         _LeagueID,
                                         _TeamLetter)

            Teams_GridView_SelectedIndexChanged(Teams_GridView, e)

            ShowHidePlayerPanel(False)

        Catch ex As Exception
            Player_Status_Literal.Text = "ERROR: " & ex.Message
        End Try

    End Sub

    <System.Web.Script.Services.ScriptMethod>
    <System.Web.Services.WebMethod>
    Public Shared Function Player_Transfer_SuggestPlayers(ByVal prefixText As String, ByVal count As Integer, ByVal contextKey As String) As List(Of String)

        Dim LeagueID As Integer = CInt(contextKey)

        Return EntryFormData.GetSuggestedPlayers(prefixText, count, LeagueID)

    End Function

    Protected Sub ShowHideTransferPanel(Show As Boolean)

        Player_Edit_Panel.Visible = False
        Player_Transfer_TextBox.Text = ""
        Team_Add_Button.Visible = Not Show
        Team_Save_Button.Visible = Not Show
        Player_Find_Button.Visible = Not Show
        Player_Transfer_Panel.Visible = Show
        Player_Similar_Panel.Visible = False
        Team_ContactCaptain_Label.Enabled = Not Show

        submitEntryForm_Button.Visible = Not Show

    End Sub

    Private Sub Player_Find_Button_Click(sender As Object, e As EventArgs) Handles Player_Find_Button.Click

        ShowHideTransferPanel(True)
        submitErrorMsg.Text = ""

    End Sub

    Protected Sub Player_Transfer_Cancel_Button_Click(sender As Object, e As EventArgs) Handles Player_Transfer_Cancel_Button.Click

        ShowHideTransferPanel(False)

    End Sub

    Protected Sub Player_Transfer_GetByName_Button_Click(sender As Object, e As EventArgs) Handles Player_Transfer_GetByName_Button.Click

        If Not (Player_Transfer_TextBox.Text.Contains("[") AndAlso Player_Transfer_TextBox.Text.Contains("]")) Then
            'Looks like a player that doesn't exist, use the Enter Details process
            AddPlayer_Button_Click(sender, e)
            Exit Sub
        End If

        If Player_Transfer_TextBox.Text.Trim.Length < 1 OrElse Player_Transfer_TextBox.Text.IndexOf("]") < 2 Then
            Player_Transfer_Literal.Text = "ERROR: Must select a player."
            Exit Sub
        End If

        Dim _PlayerID As Integer = Player_Transfer_TextBox.Text.Substring(Player_Transfer_TextBox.Text.IndexOf("[") + 1, Player_Transfer_TextBox.Text.IndexOf("]") - Player_Transfer_TextBox.Text.IndexOf("[") - 1)
        Dim _ClubID As Integer = Club_DropDownList.SelectedValue
        Dim _LeagueID As Integer = Team_League_DropDownList.SelectedValue
        Dim _TeamLetter As String = Team_Letter_DropDownList.SelectedValue

        Try
            EntryFormData.TransferPlayer(_PlayerID,
                                         _ClubID,
                                         _LeagueID,
                                         _TeamLetter)

            Teams_GridView_SelectedIndexChanged(Teams_GridView, e)

            ShowHideTransferPanel(False)

        Catch ex As Exception
            Player_Transfer_Literal.Text = "ERROR: " & ex.Message
        End Try
    End Sub

    Protected Sub EntryForm_Submit_Button_Click(sender As Object, e As EventArgs) Handles submitEntryForm_Button.Click

        Dim errMsg As String = ""
        submitErrorMsg.Text = ""

        If Not privacyCheckBox.Checked Then
            submitErrorMsg.Text = "&nbsp;&nbsp;You must tick the consent box above to indicate your consent to our <a href='InfoPage.aspx?Subject=Privacy Statement&Title=Privacy Policy' target='_blank'>privacy policy</a> in order to submit an entry form."
            Exit Sub
        End If
        submitErrorMsg.Text = ""

        Dim _ClubID As Integer = Club_DropDownList.SelectedValue

        Dim TeamLetter As String = ""
        Dim LeagueID As Integer = 0

        Team_Literal.Text = ""

        Using EntryForm As EntryFormData = New EntryFormData(_ClubID)

            With EntryForm

                For Each team As DataRow In .Teams.Rows
                    Dim MinPlayers As Integer = If(team!LeagueID = 1, 5, 4) 'Min 5 players for snooker, 4 for vets and billiards
                    If EntryForm.Players.Select("LeagueID=" & team!LeagueID & " And Team='" & team!Team & "' And ReRegister = 1").Length < MinPlayers Then
                        errMsg &= "<br/>The " & team!League & " " & team!Team & " team has fewer than " & MinPlayers & " players to register."
                    End If

                    Dim TeamPlayers As DataTable = EntryForm.Players.Clone()
                    Dim Players() As DataRow = EntryForm.Players.Select("LeagueID=" & team!LeagueID & " and Team='" & team!Team & "'")
                    Dim CaptainFound As Boolean = False

                    For Each PlayerRow In Players
                        If PlayerRow!Captain = 1 Then
                            CaptainFound = True
                            If (PlayerRow!eMail = "" OrElse PlayerRow!TelNo = "") Then
                                errMsg &= "<br/> The designated captain (" & PlayerRow!FullName & ") must have both an email address and telephone number."
                            End If
                        End If
                    Next
                    If Not CaptainFound Then
                        errMsg &= "<br/>Team " & (team!League & " " & team!Team).ToString.Trim & " does not have a player designated as captain."
                    End If

                Next

                If errMsg <> "" Then

                    submitErrorMsg.Text = "This form cannot be submitted because: " & errMsg

                Else

                    .PrivacyAccepted = privacyCheckBox.Checked
                    .MergeClubData()
                    .UpdateWIP(EntryFormData.WIP.Submitted, userHiddenField.Value)

                    'Club_ID.Text = .ClubID
                    Club_Name_TextBox.Text = .ClubName
                    Club_Addr1_TextBox.Text = .Address1
                    Club_Addr2_TextBox.Text = .Address2
                    Club_PostCode_TextBox.Text = .PostCode
                    Club_NoTables_TextBox.Text = .MatchTables
                    Club_Contact_TextBox.Text = .ContactName
                    Club_Email_Label.Text = .ContactEMail
                    Club_Telephone_TextBox.Text = .ContactTelNo
                    Club_Mobile_TextBox.Text = .ContactMobNo

                    Club_WIP_Literal.Text = "<span style='color:darkblue;'><br/>This entry form has been submitted and will be passed to the HBSA.<br/><br/>" &
                                            "The full fee for this entry is <span style='color:red;'> &pound;" & Format(.TeamFees + .ClubFee, "0.00") & "</span>"

                    PayNotice2.Visible = True
                    Using InfoPage As New ContentData("Payments")
                        PayNotice2.InnerHtml = InfoPage.ContentHTML
                    End Using

                    If .AmountPaid > 0 Then
                        Club_WIP_Literal.Text &= " of which &pound;<span style='color:red;'> &pound;" & Format(.AmountPaid, "0.00") & "</span> has already been paid."
                    End If
                    If .TeamFees + .ClubFee - .AmountPaid > 0 Then
                        Club_WIP_Literal.Text &= "<br/><br/> Please send a payment of <span style='color:red;'> &pound;" & Format(.TeamFees + .ClubFee - .AmountPaid, "0.00") & "</span>" &
                                            " to the League Treasurer or the League Secretary. <a href=""InfoPage.aspx?Subject=Officials&Title=Officials"">(see H.B.& S. Association >> Officials for address etc.)</a></span><br/>"
                    ElseIf .TeamFees + .ClubFee - .AmountPaid < 0 Then
                        Club_WIP_Literal.Text &= "<br/><br/> This account is overpaid by <span style='color:red;'> &pound;" & Format(.TeamFees + .ClubFee - .AmountPaid, "0.00") & "</span>" &
                                            " contact League Treasurer or the League Secretary. <a href=""InfoPage.aspx?Subject=Officials&Title=Officials"">(see H.B.& S. Association >> Officials for address etc.)</a> to get a refund.</font><br/>"
                        PayNotice2.Visible = False
                    Else
                        Club_WIP_Literal.Text &= "<br/><br/> This account is fully paid."
                        PayNotice2.Visible = False
                    End If

                    Club_Save_Button.Visible = False

                    ShowHideTeamsPanel(False)
                    Club_Status_Literal.Text = ""

                    'Session("payment_amt") = .TeamFees + .ClubFee - .AmountPaid
                    'Session("ClubID") = Club_DropDownList.SelectedValue
                    'Session("Description") = "League Entry Fee for " & Club_DropDownList.SelectedItem.Text

                    'send email alert
                    Using cfg As New HBSA_Configuration
                        Dim toAddress As String = "" 'cfg.value("LeagueSecretaryEmail") & ";" & cfg.value("TreasurerEmail")
                        Dim ccAddress As String = userHiddenField.Value
                        Dim subject As String
                        Dim body As String
                        subject = "Web site entry form alert (" & .ClubName & ")"
                        body = "An entry form has been submitted by " & .ClubName & ". Payment due is: " & Format(.TeamFees + .ClubFee - .AmountPaid, "£0.00") &
                               "<br/><br/>Details can be found by logging on and going to the entry form again where all details can be viewed.  " &
                               "Click 'Show all entry form details' to see all details with a print option so that it can be shown to your club.<br/>"
                        For Each player As DataRow In EntryForm.Players.Rows
                            If player.Item("H'cap") = cfg.Value("EntryFormNewRegStartHCap") Then
                                Dim teamName As String = ""
                                Dim defaultHCap As String = ""
                                For Each team As DataRow In EntryForm.Teams.Rows
                                    If team!LeagueID = player!LeagueID AndAlso team!Team = player!Team Then
                                        teamName = team!League + " " + team!Team
                                        Exit For
                                    End If
                                Next
                                body += "<br/><span style='font-weight:bold;'>NOTE TO League Secretary: " + player!Forename + " " + (player!inits.trim + " ").trim + player!surname + "</span> was added to the " + teamName.Trim +
                                                              " team as a new player with a handicap of " + cfg.Value("EntryFormNewRegStartHCap")
                            End If
                        Next

                        Using InfoPage As New ContentData("Payments")
                            body += "<br/><br/>" & InfoPage.ContentHTML
                        End Using

                        Try
                            Emailer.Send_eMail(toAddress, subject, body, ccAddress)
                        Catch eMex As Exception

                        End Try

                    End Using

                End If

            End With

        End Using

    End Sub

    Protected Sub Show_Button_Click(sender As Object, e As EventArgs) Handles Show_Button.Click

        Response.Redirect("EntryFormShowDetail.aspx?ClubID=" & Club_DropDownList.SelectedValue & "&Form=League")

    End Sub
    Protected Sub Captain_Checkbox_Changed(sender As Object, e As EventArgs)

        submitErrorMsg.Text = ""

        Player_Error_Literal.Text = ""

        Dim Captain_Checkbox As CheckBox = CType(sender, CheckBox)
        Dim PlayerRow As GridViewRow = Captain_Checkbox.Parent.Parent
        Dim PlayerID As Integer = CInt(PlayerRow.Cells(3).Text)

        If CType(PlayerRow.Cells(2).Controls(1), CheckBox).Checked Then
            If Not CType(PlayerRow.Cells(1).Controls(1), CheckBox).Checked Then
                Player_Error_Literal.Text = "Cannot make non registered player a captain"
            ElseIf PlayerRow.Cells(10).Text.Replace("&nbsp;", "") = "" OrElse PlayerRow.Cells(11).Text.Replace("&nbsp;", "") = "" Then
                Player_Error_Literal.Text = "Cannot make player a captain without email address and telephone Number"
            Else
                'update the record on the database
                EntryFormData.EntryForm_SetTeamCaptain(PlayerID, CType(PlayerRow.Cells(2).Controls(1), CheckBox).Checked)
                End If
            Else
            Player_Error_Literal.Text = "Cannot de-select a player as captain, select another player as captain."
        End If

        'refresh the players grid view
        Teams_GridView_SelectedIndexChanged(Teams_GridView, e)

    End Sub
    Protected Sub ReRegister_Checkbox_Changed(sender As Object, e As EventArgs)

        submitErrorMsg.Text = ""

        Dim ReRegister_CheckBox As CheckBox = CType(sender, CheckBox)
        Dim PlayerRow As GridViewRow = ReRegister_CheckBox.Parent.Parent
        Dim PlayerID As Integer = CInt(PlayerRow.Cells(3).Text)

        'update the record on the database
        EntryFormData.UpdateReRegister(PlayerID, CType(PlayerRow.Cells(1).Controls(1), CheckBox).Checked)

        'refresh the players grid view
        Teams_GridView_SelectedIndexChanged(Teams_GridView, e)

    End Sub

    'Protected Sub PayPal_Button_Click(sender As Object, e As ImageClickEventArgs) Handles PayPal_Button1.Click

    '    'Request to pay via PayPal
    '    Session("PaymentID") = dbClasses.PayPalCredentials.nextPaymentID(Club_DropDownList.SelectedValue)    'get next paymentID
    '    Session("PaymentReason") = "League Entry Fee"
    '    Session("FineID") = 0
    '    Response.Redirect("PayPalCheckOut.aspx")

    'End Sub

End Class