Imports HBSAcodeLibrary
Public Class Players
    Inherits System.Web.UI.Page
    Friend Enum SearchType
        ByClub
        ByName
    End Enum
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                populateSections()
                SessionUser.Value = Session("user")
            End If
        End If

    End Sub
    Protected Sub PopulateSections()

        Section_DropDownList.Items.Clear()

        Using sectionsList As DataTable = LeagueData.GetSections(0)

            With Section_DropDownList
                .Items.Clear()
                .Visible = True
                .DataSource = sectionsList
                .DataTextField = "Section Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**All leagues**", 0))

                Using leaguesList As DataTable = LeagueData.GetLeagues
                    For Each lge As DataRow In leaguesList.Rows
                        .Items.Add(New ListItem(lge.Item("League Name") & " - All sections", lge.Item("ID") + 100))
                    Next
                End Using

                .SelectedIndex = 0

                If .Items.Count < 2 Then
                    .Enabled = False
                Else
                    .Enabled = True
                End If

            End With

        End Using

        populateClubs(Section_DropDownList.SelectedValue)

    End Sub
    Protected Sub PopulateClubs(SectionID As Integer)

        Using clubsList As DataTable = ClubData.GetClubs(SectionID)

            With Club_DropDownList

                .Items.Clear()
                .Visible = True
                .DataSource = clubsList
                .DataTextField = "Club Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**All Clubs**", 0))

                .Enabled = (clubsList.Rows.Count > 1)

            End With

        End Using

    End Sub
    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) _
            Handles Section_DropDownList.SelectedIndexChanged

        populateClubs(Section_DropDownList.SelectedValue)

    End Sub
    Sub FillGrid(sType As Integer)

        Dim players As DataTable
        If sType = SearchType.ByClub Then
            players = PlayerData.GetPlayerDetails(Section_DropDownList.SelectedValue,
                                                  Club_DropDownList.SelectedValue)
        Else
            players = PlayerData.GetPlayerDetailsByPlayer(Section_DropDownList.SelectedValue,
                                                          Club_DropDownList.SelectedValue,
                                                          Player_TextBox.Text.Trim)
        End If

        With Players_GridView

            .DataSource = players
            .DataBind()

            help_Literal.Visible = players.Rows.Count > 1

        End With

        Session("PlayersData") = players
        Session("sType") = sType

        players.Dispose()

    End Sub
    Private Sub Players_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Players_GridView.RowDataBound

        For ix As Integer = 14 To e.Row.Cells.Count - 1
            e.Row.Cells(ix).Visible = False
        Next

    End Sub
    Private Sub Players_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Players_GridView.RowDeleting

        Dim PlayerRow As GridViewRow = Players_GridView.Rows(e.RowIndex)
        e.Cancel = True

        If PlayerRow.RowType = DataControlRowType.DataRow Then

            With PlayerRow
                Forename_TextBox.Text = .Cells(1).Text
                Inits_TextBox.Text = .Cells(2).Text.Replace("&nbsp;", "")
                Surname_TextBox.Text = .Cells(3).Text
                Handicap_TextBox.Text = .Cells(4).Text
                populateEditLeagues()
                editLeague_DropDownList.SelectedValue = .Cells(14).Text
                populateEditSections()
                editSection_DropDownList.SelectedValue = .Cells(15).Text
                populateEditClubs(True)
                Try
                    editClubs_DropDownList.SelectedValue = .Cells(16).Text
                Catch ex As Exception  'club probably been deleted so force selection
                    editClubs_DropDownList.SelectedIndex = 0
                End Try
                Team_DropDownList.SelectedValue = .Cells(6).Text
                Played_CheckBox.Checked = DirectCast(.Cells(7).Controls(0), CheckBox).Checked
                Tagged_DropDownList.SelectedValue = .Cells(8).Text
                Over70_CheckBox.Checked = DirectCast(.Cells(9).Controls(0), CheckBox).Checked
                email_TextBox.Text = .Cells(10).Text.Replace("&nbsp;", "")
                TelNo_TextBox.Text = .Cells(11).Text.Replace("&nbsp;", "")
                EditPanel_Literal.Text = "Edit Player Details"
                PlayerID_Label.Text = .Cells(17).Text

                If Played_CheckBox.Checked Then
                    Status_Literal.Text = "<span style='color:red;font-size:large'>This player is classed having already played a match.<br/>" &
                                          "He/She CANNOT BE DELETED.</span>"
                    SubmitPlayer_Button.Visible = False
                Else
                    Status_Literal.Text = "<span style='color:red;font-size:large'>Confirm that you wish to delete this player by clicking the Delete Player button.</span>"
                    SubmitPlayer_Button.Visible = True
                    SubmitPlayer_Button.Text = "Delete Player"
                End If
            End With

            Edit_Panel.Visible = True

        End If

    End Sub
    Private Sub Players_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles Players_GridView.RowEditing

        Dim PlayerRow As GridViewRow = Players_GridView.Rows(e.NewEditIndex)
        e.Cancel = True

        ErrorTeam_Literal.Text = ""
        ErrorTeamRow.Visible = False

        If PlayerRow.RowType = DataControlRowType.DataRow Then

            Status_Literal.Text = ""

            With PlayerRow
                Forename_TextBox.Text = .Cells(1).Text.Replace("&nbsp;", "").Replace("&#39;", "'")
                Inits_TextBox.Text = .Cells(2).Text.Replace("&nbsp;", "").Replace("&#39;", "'")
                Surname_TextBox.Text = .Cells(3).Text.Replace("&nbsp;", "").Replace("&#39;", "'")
                Handicap_TextBox.Text = .Cells(4).Text
                populateEditLeagues()
                editLeague_DropDownList.SelectedValue = .Cells(14).Text
                populateEditSections()
                If .Cells(15).Text <> 0 Then 'Not a Deleted player! i.e. sectionID is not zero
                    editSection_DropDownList.SelectedValue = .Cells(15).Text
                End If

                populateEditClubs(True)
                editClubs_DropDownList.SelectedValue = .Cells(16).Text
                Team_DropDownList.SelectedValue = .Cells(6).Text
                Played_CheckBox.Checked = DirectCast(.Cells(7).Controls(0), CheckBox).Checked
                Tagged_DropDownList.SelectedValue = .Cells(8).Text
                Over70_CheckBox.Checked = DirectCast(.Cells(9).Controls(0), CheckBox).Checked
                email_TextBox.Text = .Cells(10).Text.Replace("&nbsp;", "").Replace("&#39;", "'")
                TelNo_TextBox.Text = .Cells(11).Text.Replace("&nbsp;", "")
                EditPanel_Literal.Text = "Edit Player Details"
                PlayerID_Label.Text = .Cells(17).Text

                If Played_CheckBox.Checked Then
                    Status_Literal.Text = "<span style='color:red;'>This player is classed having already played a match.<br>" &
                                        "Take care if changing his/her club and or team, which is NOT recommended.</span>"
                End If
            End With

            SubmitPlayer_Button.Visible = True
            Edit_Panel.Visible = True
            SubmitPlayer_Button.Text = "Change Player Details"

        End If

    End Sub
    Sub PopulateEditLeagues()

        Using leagueList As DataTable = LeagueData.GetLeagues

            With editLeague_DropDownList

                .Items.Clear()
                .DataSource = leagueList
                .DataTextField = "League Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select a League**", 0))

                If Section_DropDownList.SelectedItem.Text.ToLower Like "*billiards*" Then
                    .SelectedValue = 3
                ElseIf Section_DropDownList.SelectedItem.Text.ToLower Like "*veterans*" Then
                    .SelectedValue = 2
                ElseIf Section_DropDownList.SelectedItem.Text.ToLower Like "*open*" Then
                    .SelectedValue = 1
                Else
                    .SelectedValue = 0
                End If

            End With

        End Using

    End Sub
    Sub PopulateEditSections()

        Using sectionList As DataTable = LeagueData.GetSections(editLeague_DropDownList.SelectedValue)

            With editSection_DropDownList
                .Items.Clear()
                .Visible = True
                .DataSource = sectionList
                .DataTextField = "Section Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select a division/section**", 0))

                If editLeague_DropDownList.SelectedItem.Text.ToLower Like "*billiards*" OrElse
                   Section_DropDownList.SelectedItem.Text.ToLower Like "*billiards*" Then 'its billiards with no sections
                    .SelectedIndex = 1
                    .SelectedItem.Text = "Billiards"
                    .Enabled = False
                Else
                    If Section_DropDownList.SelectedValue < 100 Then
                        .SelectedValue = Section_DropDownList.SelectedValue
                    Else
                        .SelectedValue = 0
                    End If

                    .Enabled = True

                End If

            End With

        End Using

    End Sub
    Sub PopulateEditClubs(Optional AllClubs As Boolean = False)

        Using dt As DataTable = ClubData.GetClubs(If(AllClubs, 0, editSection_DropDownList.SelectedValue))

            With editClubs_DropDownList

                .Items.Clear()
                .Visible = True
                .DataSource = dt
                .DataTextField = "Club Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select a club**", 0))

                If Not AllClubs Then
                    .Items.Add(New ListItem("**Show all clubs**", -9))
                End If

                Try
                    .SelectedValue = Club_DropDownList.SelectedValue
                Catch ex As Exception
                    .SelectedIndex = 0
                End Try

            End With

        End Using

    End Sub
    Protected Sub EditLeague_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles editLeague_DropDownList.SelectedIndexChanged

        PopulateEditSections()
        EditSection_DropDownList_SelectedIndexChanged(sender, e)

    End Sub
    Protected Sub EditSection_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles editSection_DropDownList.SelectedIndexChanged

        Dim oldValue As Integer = editClubs_DropDownList.SelectedValue
        PopulateEditClubs()
        Try
            editClubs_DropDownList.SelectedValue = oldValue
        Catch ex As Exception
            editClubs_DropDownList.SelectedIndex = 0
        End Try
        If editClubs_DropDownList.SelectedIndex = 0 Then
            Try
                editClubs_DropDownList.SelectedValue = Club_DropDownList.SelectedValue
            Catch ex As Exception
                editClubs_DropDownList.SelectedIndex = 0
            End Try
        End If

        CheckTeam()

    End Sub
    Private Sub EditClubs_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles editClubs_DropDownList.SelectedIndexChanged

        If editClubs_DropDownList.SelectedValue = -9 Then
            PopulateEditClubs(True)
        ElseIf editClubs_DropDownList.SelectedValue > 0 Then
            CheckTeam()
        End If

    End Sub
    Private Sub Team_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Team_DropDownList.SelectedIndexChanged

        CheckTeam()

    End Sub
    Protected Sub CheckTeam(Optional KeepStatus As Boolean = False)

        ErrorTeam_Literal.Text = ""
        ErrorTeamRow.Visible = False
        If Not KeepStatus Then
            Status_Literal.Text = ""
        End If

        If editClubs_DropDownList.SelectedValue > 0 AndAlso
           editSection_DropDownList.SelectedValue > 0 Then

            'check is valid for section/club

            Using TeamLetters = HBSAcodeLibrary.TeamData.TeamLetters(editSection_DropDownList.SelectedValue, editClubs_DropDownList.SelectedValue)
                Dim teams As String = ""
                For Each TeamLetter As DataRow In TeamLetters.Rows
                    teams += "'" + TeamLetter!Team + "', "
                    If Team_DropDownList.SelectedValue = TeamLetter!Team Then
                        Exit Sub
                    End If
                Next

                ErrorTeam_Literal.Text = "This team does not exist in this League/Division/Section for this Club.<br/>"
                If TeamLetters.Rows.Count = 1 Then
                    ErrorTeam_Literal.Text += "Can only be the " & Left(teams, teams.Length - 2) & " team."
                ElseIf TeamLetters.Rows.Count > 1 Then
                    ErrorTeam_Literal.Text += "Can only be one of " & Left(teams, teams.Length - 2) & " team."
                End If
                ErrorTeam_Literal.Text += "<br/>You may need to select a different club and/or League/Division/Section as well as the team."

                ErrorTeamRow.Visible = True

            End Using

        End If

    End Sub
    Protected Sub CancelPlayer_Button_Click(sender As Object, e As EventArgs) Handles CancelPlayer_Button.Click

        Edit_Panel.Visible = False

    End Sub
    Protected Sub SubmitPlayer_Button_Click(sender As Object, e As EventArgs) Handles SubmitPlayer_Button.Click

        Status_Literal.Text = ""

        If SubmitPlayer_Button.Text = "Delete Player" Then

            Try

                Using player As PlayerData = New PlayerData(CInt(PlayerID_Label.Text))
                    player.Delete(SessionUser.Value)
                End Using

                Edit_Panel.Visible = False
                'Refill the gridview
                FillGrid(Session("sType"))

            Catch ex As Exception

                Dim msg As String = ex.Message
                Dim exc As Exception = ex.InnerException
                While Not exc Is Nothing
                    msg += "<br/>" + exc.Message
                    exc = exc.InnerException
                End While
                If msg.ToLower Like "* delete *" Then
                    Status_Literal.Text = "<Strong><span style='color:red;'>" & msg & "</Strong></span>"
                Else
                    Status_Literal.Text = "<Strong><span style='color:red;font-size:large'>Exception updating the database." &
                                              "Please inform support with the following:<br/><br/>" & msg &
                                              "</Strong></span>"
                End If
            End Try

        Else

            If editLeague_DropDownList.SelectedIndex = 0 Then
                Status_Literal.Text += "Please select a League.<br/>"
            End If
            If editSection_DropDownList.SelectedIndex = 0 Then
                Status_Literal.Text += "Please Select a division/section.<br/>"
            End If
            If editClubs_DropDownList.SelectedIndex = 0 Then
                Status_Literal.Text += "Please select a Club.<br/>"
            End If
            If email_TextBox.Text.Trim <> "" Then
                If Not Emailer.IsValidEmailAddress(email_TextBox.Text) Then
                    Status_Literal.Text += "The eMail address is invalid.<br/>"
                End If
            End If
            If TelNo_TextBox.Text.Trim <> "" Then
                Dim FormattedNo As String = SharedRoutines.CheckValidPhoneNoForHuddersfield(TelNo_TextBox.Text)
                If FormattedNo.StartsWith("ERR") Then
                    Status_Literal.Text += "The Telephone number is invalid.<br/>"
                Else
                    TelNo_TextBox.Text = FormattedNo
                End If
            End If
            If Forename_TextBox.Text.Trim = "" Then
                Status_Literal.Text += "There must be a First Name.<br/>"
            End If
            If Surname_TextBox.Text.Trim = "" Then
                Status_Literal.Text += "There must be a Surame.<br/>"
            End If

            CheckTeam(True)
            Status_Literal.Text += ErrorTeam_Literal.Text
            ErrorTeam_Literal.Text = ""
            ErrorTeamRow.Visible = False

            If Status_Literal.Text = "" AndAlso SubmitPlayer_Button.Text = "Add Player" Then

                    Using OtherPlayer As New PlayerData(1, Surname_TextBox.Text.Trim, 1, Forename_TextBox.Text.Trim, editLeague_DropDownList.SelectedValue)

                        With OtherPlayer

                            If .PlayersTable.Rows.Count <> 0 Then

                                SubmitPlayer_Button.Text = "Confirm"

                                If .SectionID = 0 Or .ClubID = 0 Then
                                    Status_Literal.Text = "WARNING:<br/>" &
                                                               "This player is deleted, but appears to have been registered before with a handicap of " & .Handicap & ".<br/>" &
                                                               "Click Confirm to re-register him/her to your team, otherwise click Cancel."
                                    Handicap_TextBox.Text = .Handicap
                                    PlayerID_Label.Text = .PlayersTable.Rows(0)!ID
                                Else
                                    If .PlayersTable.Rows.Count = 1 Then
                                    Status_Literal.Text = "WARNING:<br/>" &
                                                               "There is a player already registered to " & .ClubName & " " & .Team &
                                                               ", with the same name and with a handicap of " & .Handicap & ".<br/>" &
                                                               "Click Confirm to register him/her as a NEW player with the same name, otherwise click Cancel.<br/>" &
                                                               "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To transfer this player, locate him/her and edit his/her details."
                                Else
                                        Status_Literal.Text = "WARNING:<br/>" &
                                                               "There are " & .PlayersTable.Rows.Count & " players already registered with the same name.<br/>" &
                                                               "Click Confirm to register him/her as a new player with the same name, otherwise click Cancel.<br/>" &
                                                               "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To transfer this player, locate him/her and edit his/her details."
                                    End If

                                    'Handicap_TextBox.Text = .Handicap  
                                End If

                            End If

                        End With

                    End Using

                End If

                If Status_Literal.Text <> "" Then
                    Status_Literal.Text = "<span style='color:red;background: white;'>" + Status_Literal.Text + "</span>"
                Else

                    Using Player As New PlayerData(CInt(PlayerID_Label.Text))

                        Dim handicap As Integer
                        Try
                            handicap = CInt(Handicap_TextBox.Text)
                        Catch ex As Exception
                            Status_Literal.Text = " <strong><span style='color:red;font-size:large'>ERROR: Please enter a number (include - (minus) for less than scratch) for the handicap." &
                                                            "</strong></span>"
                            Exit Sub

                        End Try

                        Player.Forename = Forename_TextBox.Text
                        Player.Initials = Inits_TextBox.Text
                        Player.Surname = Surname_TextBox.Text
                        Dim PrevHandicap As Integer = Player.Handicap
                        Player.Handicap = handicap
                        Player.LeagueID = editLeague_DropDownList.SelectedValue
                        Player.SectionID = editSection_DropDownList.SelectedValue
                        Player.ClubID = editClubs_DropDownList.SelectedValue
                        Player.Team = Team_DropDownList.SelectedValue
                        Player.Tagged = Tagged_DropDownList.SelectedValue
                        Player.Over70 = Over70_CheckBox.Checked
                        Player.Played = Played_CheckBox.Checked
                        Player.eMail = email_TextBox.Text
                        Player.TelNo = TelNo_TextBox.Text

                        Try

                            Player.Merge(SessionUser.Value)

                            FillGrid(Session("sType"))

                            If SubmitPlayer_Button.Text = "Change Player Details" AndAlso
                                       handicap <> PrevHandicap Then

                                Status_Literal.Text = HBSAcodeLibrary.Emailer.SendHandicapChangeEmail(
                                                                                             Player.ClubEmail,
                                                                                             Player.TeamEMail,
                                                                                             Player.eMail,
                                                                                             Player.FullName,
                                                                                             (Player.ClubName & " " & Player.Team).Trim,
                                                                                             PrevHandicap,
                                                                                             handicap,
                                                                                             (Player.LeagueName & " " & Player.SectionName).Trim
                                                                                                                  )
                            End If

                            If Status_Literal.Text = "" Then
                                Edit_Panel.Visible = False
                            End If

                        Catch ex As Exception

                            Dim msg As String = ex.Message
                            Dim exc As Exception = ex.InnerException
                            While Not exc Is Nothing
                                msg += "<br/>" + exc.Message
                                exc = exc.InnerException
                            End While
                            Status_Literal.Text = "<strong><span style='color:red;font-size:large'>Exception updating the database." &
                                                      "Please inform support with the following:<br/><br/>" & msg &
                                                      "</strong></span>"

                        End Try

                    End Using

                    SubmitPlayer_Button.Text = "Submit"

                End If

            End If

    End Sub
    Protected Sub Add_Button_Click(sender As Object, e As EventArgs) Handles Add_Button.Click

        populateEditLeagues()
        populateEditSections()
        populateEditClubs(True)

        Status_Literal.Text = ""
        ErrorTeam_Literal.Text = ""
        ErrorTeamRow.Visible = False

        Forename_TextBox.Text = ""
        Inits_TextBox.Text = ""
        Surname_TextBox.Text = ""
        Handicap_TextBox.Text = ""
        ' editClubs_DropDownList.SelectedIndex = 0
        Team_DropDownList.SelectedIndex = 0
        'editSection_DropDownList.SelectedIndex = 0
        'editLeague_DropDownList.SelectedIndex = 0
        Played_CheckBox.Checked = False
        Tagged_DropDownList.SelectedValue = 3
        Over70_CheckBox.Checked = False
        email_TextBox.Text = ""
        TelNo_TextBox.Text = ""
        EditPanel_Literal.Text = "Add New Player Details"
        PlayerID_Label.Text = 0

        Edit_Panel.Visible = True
        SubmitPlayer_Button.Visible = True
        SubmitPlayer_Button.Text = "Add Player"

    End Sub
    Private Sub Players_GridView_Sorting(sender As Object, e As GridViewSortEventArgs) Handles Players_GridView.Sorting

        If Not IsNothing(Session("PlayersData")) Then
            Dim OrdersData As DataTable = Session("PlayersData")
            OrdersData.DefaultView.Sort = e.SortExpression & " " & GetSortDirection(e.SortExpression)
            With Players_GridView
                .PageIndex = 0
                .DataSource = OrdersData
                .DataBind()
            End With
        End If

    End Sub
    Private Function GetSortDirection(ByVal column As String) As String

        ' By default, set the sort direction to ascending.
        Dim sortDirection = "ASC"

        ' Retrieve the last column that was sorted.
        Dim sortExpression = TryCast(ViewState("SortExpression"), String)

        If sortExpression IsNot Nothing Then
            ' Check if the same column is being sorted.
            ' Otherwise, the default value can be returned.
            If sortExpression = column Then
                Dim lastDirection = TryCast(ViewState("SortDirection"), String)
                If lastDirection IsNot Nothing _
                  AndAlso lastDirection = "ASC" Then

                    sortDirection = "DESC"

                End If
            End If
        End If

        ' Save new values in ViewState.
        ViewState("SortDirection") = sortDirection
        ViewState("SortExpression") = column

        Return sortDirection

    End Function
    Protected Sub GetByClub_Button_Click(sender As Object, e As EventArgs) Handles GetByClub_Button.Click

        FillGrid(SearchType.ByClub)

    End Sub
    Protected Sub GetByName_Button_Click(sender As Object, e As EventArgs) Handles GetByName_Button.Click

        FillGrid(SearchType.ByName)

    End Sub

    <System.Web.Script.Services.ScriptMethod>
    <System.Web.Services.WebMethod>
    Public Shared Function SuggestPlayers(ByVal prefixText As String, ByVal count As Integer, ByVal contextKey As String) As List(Of String)

        Dim params() As String = contextKey.Split("|")
        Dim Section As Integer = CInt(params(0))
        Dim LeagueID As Integer
        Dim SectionID As Integer

        If Section > 99 Then
            LeagueID = Section Mod 100
            SectionID = 0
        Else
            LeagueID = 0
            SectionID = Section
        End If

        Dim ClubID As Integer = CInt(params(1))

        Return HBSAcodeLibrary.PlayerData.GetSuggestedPlayers(prefixText, count, LeagueID, SectionID, ClubID)

    End Function

End Class