Imports HBSAcodeLibrary
Public Class Teams
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                populateSections()
            End If
        End If

    End Sub

    Protected Sub PopulateSections()

        Using sectionsList As DataTable = LeagueData.GetSections(0)

            With Section_DropDownList
                .Items.Clear()
                .DataSource = sectionsList
                .DataTextField = "Section Name"
                .DataValueField = "ID"
                .DataBind()
                .Visible = True
                .Items.Insert(0, New ListItem("**All leagues**", 0))
                .Items.Add(New ListItem("**Competitions only**", -1))

                Using leaguesList As DataTable = LeagueData.GetLeagues()
                    For Each row As DataRow In leaguesList.Rows
                        .Items.Add(New ListItem(row.Item("League Name") & " - All sections", row.Item("ID") + 100))
                    Next
                End Using

                .SelectedIndex = 0

                If .Items.Count < 3 Then
                    .Enabled = False
                Else
                    .Enabled = True
                End If

                PopulateGridView()

            End With

        End Using

    End Sub
    Sub PopulateClubs(LeagueID As Integer)

        Using clubsAndByes As DataTable = ClubData.GetClubs(100 + LeagueID, False)

            With Club_DropDownList
                .Items.Clear()
                .DataSource = clubsAndByes
                .DataTextField = "Club Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select a Club**", 0))
            End With

        End Using

    End Sub

    Sub PopulateGridView()

        Using teamsInSection As DataTable = TeamData.GetAllTeams(Section_DropDownList.SelectedValue)

            With Teams_GridView
                .DataSource = teamsInSection
                .DataBind()
            End With

        End Using

    End Sub

    Private Sub Section_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        SequenceTeams_Button.Visible = (Section_DropDownList.SelectedValue > 0 AndAlso Section_DropDownList.SelectedValue < 100)

        PopulateGridView()

    End Sub

    Private Sub Teams_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Teams_GridView.RowDataBound

        If e.Row Is Nothing Then

        Else
            If e.Row.Cells.Count > 3 Then
                e.Row.Cells(1).Visible = False
                e.Row.Cells(3).Visible = False
                e.Row.Cells(e.Row.Cells.Count - 1).Visible = False

                If e.Row.Cells(2).Text = "Bye" Then
                    For Each ctrl In e.Row.Cells(0).Controls
                        If ctrl.text = "Edit" Then
                            ctrl.visible = False
                        End If
                    Next
                    'e.Row.Cells(0).Controls(0).Visible = False
                    'e.Row.Cells(0).Controls(1).Visible = False
                    'e.Row.Cells(0).Controls(2).Visible = False
                End If
            End If
        End If

    End Sub

    Private Sub Teams_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Teams_GridView.RowDeleting

        SubmitTeam_Button.Text = "Delete"

        If Teams_GridView.Rows(e.RowIndex).Cells(2).Text.ToLower = "bye" Then
            Edit_Literal.Text = "Do you really want to remove this Bye from the section? <br/><br/>clicking Delete will remove it and may leave gaps in the fixtures or click Cancel."
        Else
            Edit_Literal.Text = "Do you really want to remove this Team from the league? <br/><br/>click Delete to remove it from the system, along with all the team's results, breaks etc.<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; or click Cancel."
        End If
        Err_Literal.Text = ""

        Using Team As New HBSAcodeLibrary.TeamData(Teams_GridView.Rows(e.RowIndex).Cells(1).Text)

            If Team.Players.Rows.Count > 0 Then
                Edit_Literal.Text += "<br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style='color:red;'>WARNING: " & Team.ClubName & " " & Team.Team &
                                    " has " & Team.Players.Rows.Count & " players registered." &
                                    "<br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If you remove this team, then it's players can only be removed or reassigned by using the search by name option in the Players maintenance page.</span><br/><br/>"
            End If

            FillEditTextBoxes(Team)
            EnableDisableTextBoxes(False)

        End Using

        e.Cancel = True
    End Sub

    Sub EnableDisableTextBoxes(enable As Boolean)

        For Each ctrl In Edit_Panel.Controls

            If TypeOf ctrl Is TextBox Then
                DirectCast(ctrl, TextBox).Enabled = enable
            End If

            If TypeOf ctrl Is DropDownList Then
                DirectCast(ctrl, DropDownList).Enabled = enable
            End If
        Next

    End Sub

    Sub FillEditTextBoxes(Team As TeamData)

        With Team

            ID_TextBox.Text = .ID

            With Captain_DropDownList
                .Items.Clear()
                For Each Player As DataRow In Team.Players.Rows
                    .Items.Add(New ListItem(Player!Forename & (" " & Player!Initials & " ").ToString.Replace("  ", " ") & Player!Surname,
                                            Player!ID))
                Next
                If .Items.Count < 1 Then
                    .Items.Add(New ListItem("Assign a captain after players have been added to the team", 0))
                Else
                    If Team.Captain = 0 Then
                        .Items.Insert(0, New ListItem("Select a team player as captain.", 0))
                        .SelectedValue = 0
                    Else
                        Try
                            .SelectedValue = Team.Captain
                        Catch ex As Exception
                            'Captain is not in list of players, ask for on eto be assigned.
                            .Items.Insert(0, New ListItem("Select a team player as captain.", 0))
                            .SelectedValue = 0
                        End Try
                    End If
                End If
            End With

            PopulateClubs(Team.LeagueID)

            Club_DropDownList.SelectedValue = .ClubID

            Using sectionsList As DataTable = LeagueData.GetSections(Team.LeagueID)
                With editSection_DropDownList
                    .Items.Clear()
                    .DataSource = sectionsList
                    .DataTextField = "Section Name"
                    .DataValueField = "ID"
                    .DataBind()
                    .Items.Insert(0, New ListItem("**All leagues**", 0))
                    .Items.Add(New ListItem("**Competitions only**", -1))
                End With
            End Using

            editSection_DropDownList.SelectedValue = .SectionID

            Team_DropDownList.SelectedValue = .Team
            If .SectionID = -1 Then 'competitions only
                FixtureNo_TextBox.Text = ""
                FixtureNo_TextBox.Visible = False
            Else
                FixtureNo_TextBox.Text = .FixtureNo
                FixtureNo_TextBox.Visible = True
            End If
            Edit_Panel.Visible = True

        End With

    End Sub

    Protected Sub CancelTeam_Button_Click(sender As Object, e As EventArgs) Handles CancelTeam_Button.Click

        Edit_Panel.Visible = False

    End Sub

    Protected Sub Add_Button_Click(sender As Object, e As EventArgs) Handles Add_Button.Click

        ID_TextBox.Text = "-1"
        Captain_DropDownList.Items.Clear()
        Captain_DropDownList.Items.Add(New ListItem("Assign a captain after players have been added to the team", 0))
        Club_DropDownList.SelectedValue = 0
        editSection_DropDownList.SelectedValue = 0
        Team_DropDownList.SelectedValue = " "
        FixtureNo_TextBox.Text = ""

        SubmitTeam_Button.Text = "Add"
        Edit_Literal.Text = "Enter the new Team's details here then click Add to record them in the system, or click Cancel."

        EnableDisableTextBoxes(True)
        Edit_Panel.Visible = True

    End Sub

    Private Sub Teams_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles Teams_GridView.RowEditing

        SubmitTeam_Button.Text = "Save"
        Edit_Literal.Text = "Amend required Section details here then click Save to record them in the system, or click Cancel."

        FillEditTextBoxes(New TeamData(Teams_GridView.Rows(e.NewEditIndex).Cells(1).Text))

        EnableDisableTextBoxes(True)

        e.Cancel = True

    End Sub

    Protected Sub SubmitTeam_Button_Click(sender As Object, e As EventArgs) Handles SubmitTeam_Button.Click

        Err_Literal.Text = ""
        Edit_Literal.Text = ""

        Using Team As New TeamData(CInt(ID_TextBox.Text))
            With Team
                If SubmitTeam_Button.Text = "Delete" Then

                    .SectionID = -100

                Else

                    If Edit_Literal.Text <> "" Then
                        Edit_Literal.Text = "<span style='color:red'>" & Edit_Literal.Text & "</span>"
                        Exit Sub
                    End If

                    If SubmitTeam_Button.Text = "Confirm" Then
                        'Move the team and it's players to the new section/club/team
                        .MoveTeam(Club_DropDownList.SelectedValue, editSection_DropDownList.SelectedValue, Team_DropDownList.SelectedValue)
                        'then allow further changes such as contact details
                        .ClubID = Club_DropDownList.SelectedValue
                        .SectionID = editSection_DropDownList.SelectedValue
                        .Team = Team_DropDownList.SelectedValue
                    End If

                    .ID = CInt(ID_TextBox.Text)
                    .Captain = Captain_DropDownList.SelectedValue

                    If .Players.Rows.Count > 0 AndAlso
                           .ID <> -100 AndAlso
                           (.ClubID <> Club_DropDownList.SelectedValue OrElse
                            .SectionID <> editSection_DropDownList.SelectedValue OrElse
                            .Team <> Team_DropDownList.SelectedValue) Then
                        'trying to change team's club and/or letter and/or section when players are linked
                        'need to warn and get confirmation as we will need to update players as well
                        SubmitTeam_Button.Text = "Confirm"
                        Edit_Literal.Text = "<span style='color:red;'>This team has players assigned.<br/>" &
                                                "Click Confirm to change the players as well.<br/>" &
                                                "Otherwise Click Cancel.</span>"
                        Exit Sub

                    Else
                        .ClubID = Club_DropDownList.SelectedValue
                        .SectionID = editSection_DropDownList.SelectedValue
                        .Team = Team_DropDownList.SelectedValue
                    End If


                End If

                If Club_DropDownList.SelectedIndex < 1 Then
                    Edit_Literal.Text += "<br/><span style='color:red;'>You must select a Club.</span>"
                End If
                If editSection_DropDownList.SelectedIndex < 1 Then
                    Edit_Literal.Text += "<br/><span style='color:red;'>You must select a League/Section.</span>"
                End If

                Try
                    .FixtureNo = If(FixtureNo_TextBox.Text.Trim = "", -1, CInt(FixtureNo_TextBox.Text)) '-1 indicates set to next available
                Catch ex As Exception
                    Edit_Literal.Text += "<br/><span style='color:red;'>The Fixture Number must be numeric or blank.</span>"
                End Try

                If Edit_Literal.Text = "" Then

                    Dim action As String
                    If .SectionID = -100 And Club_DropDownList.SelectedItem.Text.ToLower <> "bye" Then
                        action = .Remove(Session("AdminUser"))
                    Else

                        Using newTeam As TeamData = New TeamData(CInt(editSection_DropDownList.SelectedValue), CInt(Club_DropDownList.SelectedValue), Team_DropDownList.SelectedValue)
                            If newTeam.ID > 0 AndAlso newTeam.ID <> CInt(ID_TextBox.Text) Then  'shows no team in this league with the new credentials, so is OK to use.
                                Edit_Literal.Text = "<span style='color:red;'>Error:  Cannot submit.  The team " & (newTeam.ClubName & " " & newTeam.Team).Trim &
                                    " already exists in " & newTeam.SectionName & "<br/>" &
                                    "Choose an alternative or Cancel.</span>"

                                Exit Sub

                            End If
                        End Using

                        action = .Merge(Session("AdminUser")) ' This will insert/update as required
                    End If

                    If action Is Nothing Then

                        Edit_Literal.Text = "<span style='color:red;'>Error: Cannot delete/insert/update this Team with ID = " & CInt(ID_TextBox.Text) & "<br/><br/>Please contact support.</span>"

                    Else

                        PopulateGridView()
                        Edit_Panel.Visible = False

                    End If

                End If

            End With

        End Using

    End Sub

    Private Sub Club_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) _
        Handles Club_DropDownList.SelectedIndexChanged,
                Team_DropDownList.SelectedIndexChanged

        Edit_Literal.Text = ""
        'If the club and/or team letter changes, need to ensure the new team doesn't exist
        Using newTeam As TeamData = New TeamData(CInt(editSection_DropDownList.SelectedValue), CInt(Club_DropDownList.SelectedValue), Team_DropDownList.SelectedValue)

            If newTeam.ID = 0 Then  'shows no team in this league with the new credentials, so is OK to use.
                With Captain_DropDownList
                    If Club_DropDownList.SelectedItem.Text = "Bye" Then
                        .Items.Clear()
                        .Items.Add(New ListItem("", 0))
                        .SelectedIndex = 0
                        .Enabled = False
                    Else
                        .Enabled = True
                    End If
                End With
            Else
                'FillEditTextBoxes(New TeamData(ID_TextBox.Text))
                Edit_Literal.Text = "<span style='color:red;'>The team " & (newTeam.ClubName & " " & newTeam.Team).Trim &
                                " already exists in " & newTeam.SectionName & "<br/>" &
                                "Choose an alternative or Cancel. </span>"

            End If

        End Using

    End Sub

    Protected Sub SequenceTeams_Button_Click(sender As Object, e As EventArgs) Handles SequenceTeams_Button.Click

        HBSAcodeLibrary.TeamData.SequenceTeamsInSection(Section_DropDownList.SelectedValue)
        'HBSAcodeLibrary.SectionData.AssignFixtureGrid(Section_DropDownList.SelectedValue)

        populateGridView()

    End Sub

    Protected Sub editSection_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles editSection_DropDownList.SelectedIndexChanged

        If editSection_DropDownList.SelectedValue = -1 Then 'competitions only
            FixtureNo_TextBox.Text = ""
            FixtureNo_TextBox.Visible = False
        Else
            FixtureNo_TextBox.Visible = True
        End If

    End Sub
End Class