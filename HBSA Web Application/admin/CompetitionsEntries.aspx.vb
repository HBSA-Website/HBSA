Imports HBSAcodeLibrary
Public Class CompetitionsEntries
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                populateCompetitionsDropDown()
            End If
        End If

    End Sub

    Sub PopulateCompetitionsDropDown()

        Using comps As DataTable = HBSAcodeLibrary.CompetitionData.GetCompetitions()

            With Competitions_DropDownList
                .Items.Clear()
                .Visible = True
                .DataSource = comps
                .DataTextField = "Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Choose a Competition**", 0))

            End With

        End Using

    End Sub

    Sub PopulateEntrantsIDs(competition As CompetitionData)

        Using entrants As DataTable = competition.CompetitionEntrants()

            With Entrants_DropDownList
                .Items.Clear()
                .Visible = True
                .DataSource = entrants
                .DataTextField = "Entrant"
                .DataValueField = "EntrantID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select an Entrant**", 0))
            End With

            With Entrant2_DropDownList
                If competition.competitionType = HBSAcodeLibrary.CompetitionType.Pairs Then
                    .Items.Clear()
                    .Visible = True
                    .DataSource = entrants
                    .DataTextField = "Entrant"
                    .DataValueField = "EntrantID"
                    .DataBind()
                    .Items.Insert(0, New ListItem("**Select an Entrant**", 0))

                    .Visible = False
                End If
            End With

        End Using

        Status_Literal.Text = ""

    End Sub

    Private Sub Competitions_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Competitions_DropDownList.SelectedIndexChanged

        'Empty the grid view
        With Entrants_GridView
            .EmptyDataText = "Please click Select Competition"
            .EmptyDataRowStyle.ForeColor = Drawing.Color.DarkBlue
            .EmptyDataRowStyle.Font.Bold = False
            .DataSource = Nothing
            .DataBind()
        End With

        Juniors_SetUp.Visible = False

    End Sub

    Private Sub CompetitionSelected(sender As Object, e As EventArgs) Handles SelectCompetition_Button.Click

        Using comp As New CompetitionData(Competitions_DropDownList.SelectedValue)

            'Using CompRounds As New HBSA_data.CompetitionRounds(Competitions_DropDownList.SelectedValue)

            If Competitions_DropDownList.SelectedIndex > 0 Then

                Juniors_SetUp_Literal.Text = ""
                If comp.Name.ToLower Like "*junior*" Then
                    Juniors_SetUp.Visible = True
                    MakeDraw_Button.Visible = False
                Else
                    Juniors_SetUp.Visible = False
                    MakeDraw_Button.Visible = True
                End If

            End If

            If comp.Drawn Then

                Confirm_Literal.Text = "This competition (" & comp.Name &
                                                         ") has been drawn and may have matches already recorded.  <br /><br />" &
                                                         "If you need to add, change or remove entries Click Confirm. &nbsp; Otherwise Click Cancel.<br /><br />"

                Confirm_Panel.Visible = True
                EnableDisableControls(False)

                Session("Confirm") = "Confirm Baseline"

            Else

                PopulateEntrantsIDs(comp)
                PopulateGridView(comp)

            End If

            'End Using

        End Using

    End Sub

    Protected Sub CancelConfirm_Button_Click(sender As Object, e As EventArgs) Handles CancelConfirm_Button.Click

        Confirm_Panel.Visible = False
        EnableDisableControls(True)

    End Sub

    Protected Sub ConfirmCompetition_Button_Click(sender As Object, e As EventArgs) Handles ConfirmCompetition_Button.Click

        Using comp As New CompetitionData(Competitions_DropDownList.SelectedValue)

            If Session("Confirm") = "Confirm Baseline" Then

                PopulateEntrantsIDs(comp)
                PopulateGridView(comp)

            ElseIf Session("Confirm") = "Confirm Draw" Then

                comp.MakeDraw()
                Session("CompetitionID") = comp.ID
                Response.Redirect("CompetitionsResults.aspx")

            ElseIf Session("Confirm") = "ApplyEntryForms" Then

                Dim privacyNotAcceptedClubsTable As DataTable = comp.ApplyCompetitionEntryEntryForms()
                If Not IsNothing(privacyNotAcceptedClubsTable) AndAlso privacyNotAcceptedClubsTable.Rows.Count > 0 Then
                    ClubsWithoutPrivacyAccepted_GridView.DataSource = privacyNotAcceptedClubsTable
                    ClubsWithoutPrivacyAccepted_GridView.DataBind()
                    ClubsWithoutPrivacyAccepted_Panel.Visible = True
                Else
                    ClubsWithoutPrivacyAccepted_Panel.Visible = False
                End If

            ElseIf Session("Confirm").ToString.StartsWith("Delete") Then

                comp.DeleteEntry(CInt(Session("Confirm").ToString.Substring(6)))
                PopulateEntrantsIDs(comp)
                PopulateGridView(comp)

            End If

        End Using

        Confirm_Panel.Visible = False
        EnableDisableControls(True)

    End Sub

    Sub PopulateGridView(competition As CompetitionData)


        Using entries As DataTable = competition.CompetitionEntries()

            With Entrants_GridView
                If Competitions_DropDownList.SelectedIndex > 0 Then
                    .EmptyDataText = "No entrants found for this competition"
                    .EmptyDataRowStyle.ForeColor = Drawing.Color.DarkBlue
                    .EmptyDataRowStyle.Font.Bold = False
                    .EmptyDataRowStyle.Font.Size = FontUnit.Larger
                Else
                    .EmptyDataText = "Please choose a competition"
                    .EmptyDataRowStyle.ForeColor = Drawing.Color.Red
                    .EmptyDataRowStyle.Font.Bold = True
                    .EmptyDataRowStyle.Font.Size = FontUnit.Larger
                End If

                .DataSource = entries
                .DataBind()

                MakeDraw_Button.Visible = .Rows.Count > 1 AndAlso Not Competitions_DropDownList.SelectedItem.Text.ToLower Like "*junior*"
                Using comp As New CompetitionData(Competitions_DropDownList.SelectedValue)
                    PopulateEntrantsIDs(comp)
                End Using

            End With

        End Using

    End Sub


    Private Sub Entrants_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Entrants_GridView.RowDataBound

        If e.Row.Cells.Count > 1 Then
            'hide the identity column
            e.Row.Cells(1).Visible = False
        End If

    End Sub

    Private Sub Entrants_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Entrants_DropDownList.SelectedIndexChanged

        Using Comp As New CompetitionData(Competitions_DropDownList.SelectedValue)

            ShowHideEntrant2(Comp.competitionType = HBSAcodeLibrary.CompetitionType.Pairs)

        End Using

    End Sub
    Private Sub ShowHideEntrant2(visibility As Boolean)

        Entrant2_DropDownList.Visible = visibility
        Entrant2_Literal.Visible = visibility
        Entrant2_TextBox.Visible = visibility

    End Sub

    Private Sub Submit_Button_Click(sender As Object, e As EventArgs) Handles Submit_Button.Click

        Status_Literal.Text = ""

        'add entry to competition
        Using comp As New CompetitionData(Competitions_DropDownList.SelectedValue)

            'if came from a textbox look for a match in the dd list(s)
            Status_Literal.Text = ""

            If sender.ClientID Like "*Button*" Then

                Dim ix As Integer

                With Entrants_DropDownList

                    For ix = 0 To .Items.Count - 1
                        If .Items(ix).Text.Trim.ToLower = Entrant_TextBox.Text.Trim.ToLower Then
                            .SelectedIndex = ix
                            Exit For
                        End If
                    Next
                    If ix >= .Items.Count Then
                        ReplaceStatus_Literal.Text = "<span style='color:red;'>The entrant in the search box does not match any of the selectable entrants.<br/>" &
                                              "The entrant is possibly already entered, or was not selected in the name box.</span>"
                    End If

                End With

                If comp.competitionType = HBSAcodeLibrary.CompetitionType.Pairs Then
                    With Entrant2_DropDownList

                        For ix = 0 To .Items.Count - 1
                            If .Items(ix).Text.Trim.ToLower = Entrant2_TextBox.Text.Trim.ToLower Then
                                .SelectedIndex = ix
                                Exit For
                            End If
                        Next
                        If ix >= .Items.Count Then
                            ReplaceStatus_Literal.Text = "<span style='color:red;'>The entrant in the second search box does not match any of the selectable entrants." &
                                                  "The entrant is possibly already entered, or was not selected in the name box.</span>"
                        End If

                    End With

                End If

            End If

            If Status_Literal.Text = "" Then

                comp.MergeCompetitionEntry(If(Session("EntryID"), -1),
                                           Entrants_DropDownList.SelectedValue,
                                           If(comp.competitionType = HBSAcodeLibrary.CompetitionType.Pairs, Entrant2_DropDownList.SelectedValue, Nothing)
                                           )
                Session("EntryID") = Nothing
                Replace_Panel.Visible = False
                EnableDisableControls(True)
                Entrants_GridView.SelectedIndex = -1

                ShowHideEntrant2(False)

                PopulateGridView(comp)

            End If

        End Using

    End Sub

    Private Sub MakeDraw_Button_Click(sender As Object, e As EventArgs) Handles MakeDraw_Button.Click

        Confirm_Literal.Text = "This competition (" & Competitions_DropDownList.SelectedItem.Text & ") will be drawn setting entrants into a random order.<br />" &
                                         "If a draw has been made already this will change it.&nbsp;&nbsp;&nbsp;  Byes will be allocated where needed." &
                                         "<br /><br />To do this Click Confirm.  " &
                                         "<br/><br/>Otherwise Click Cancel"

        Confirm_Panel.Visible = True
        EnableDisableControls(False)

        Session("Confirm") = "Confirm Draw"

    End Sub

    Private Sub Entrants_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Entrants_GridView.RowDeleting

        Using Comp As New CompetitionData(Competitions_DropDownList.SelectedValue)

            Confirm_Literal.Text = "Click Confirm to remove " & Entrants_GridView.Rows(e.RowIndex).Cells(2).Text & " from the competition.<br /><br />"
            If Comp.Drawn Then
                Confirm_Literal.Text &= "This will change this entry to a <b>Bye</b> in the latest round.<br /><br />" &
                                        "<span style='color:red;'><b>NOTE: After doing this you will have to examine the results page and promote the opposing entry to the next round.</b></span><br /><br />"
            End If
            Confirm_Literal.Text &= "Otherwise Click Cancel"
            Confirm_Panel.Visible = True
            EnableDisableControls(False)

            Session("Confirm") = "Delete" & Entrants_GridView.Rows(e.RowIndex).Cells(1).Text

        End Using

        e.Cancel = True

    End Sub

    Private Sub Entrants_GridView_SelectedIndexChanging(sender As Object, e As GridViewSelectEventArgs) Handles Entrants_GridView.SelectedIndexChanging

        'to replace the shown entrant indicate that the next selected entrant will go in here

        Session("EntryID") = Entrants_GridView.Rows(e.NewSelectedIndex).Cells(1).Text

        Using comp As New CompetitionData(Competitions_DropDownList.SelectedValue)

            ShowHideEntrant2(comp.competitionType = HBSAcodeLibrary.CompetitionType.Pairs)
            Entrant2_TextBox.Text = ""
            Entrant_TextBox.Text = ""
            Add_Table.Visible = False
            Replace_Table.Visible = True
            Replace_Panel.Visible = True
            EnableDisableControls(False)

        End Using

    End Sub


    <System.Web.Script.Services.ScriptMethod>
    <System.Web.Services.WebMethod>
    Public Shared Function SuggestEntrants(ByVal prefixText As String, ByVal count As Integer, ByVal contextKey As String) As List(Of String)

        Dim CompetitionID As Integer = CInt(contextKey)
        Return HBSAcodeLibrary.PlayerData.GetSuggestedEntrants(prefixText, count, CompetitionID)

    End Function

    Private Sub ApplyEntryForms_Button_Click(sender As Object, e As EventArgs) Handles ApplyEntryForms_Button.Click

        Confirm_Literal.Text = "<span style='color:'red';'>WARNING:  This button will clear down all competitions, then apply the entry forms.<br/><br/>" &
                               "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;It will also disallow competition entry forms for general users.</span>"
        Confirm_Panel.Visible = True
        EnableDisableControls(False)
        Session("Confirm") = "ApplyEntryForms"

    End Sub

    Protected Sub CancelReplace_Button_Click(sender As Object, e As EventArgs) Handles CancelReplace_Button.Click

        Session("EntryID") = Nothing
        Replace_Panel.Visible = False
        EnableDisableControls(True)
        Entrants_GridView.SelectedIndex = -1

    End Sub

    Protected Sub Juniors_SetUp_Button_Click(sender As Object, e As EventArgs) Handles Juniors_SetUp_Button.Click

        If Not HBSAcodeLibrary.JuniorsCompetitions.ResultsExist OrElse
            Juniors_SetUp_Literal.Text = "<span style='color:red;'>Results have already been recorded for the Juniors.<br/>Click 'Set up juniors into mini leagues' again to remove all juniors results and set up the mini leagues afresh.</span>" Then

            If JuniorsMiniLeagues_DropDownList.SelectedValue > 0 Then
                HBSAcodeLibrary.JuniorsCompetitions.SetupJuniors(JuniorsMiniLeagues_DropDownList.SelectedValue)
                Juniors_SetUp_Literal.Text = "<span style='color:navy;'>The juniors mini leagues have been set up ready.</span>"
            Else
                Juniors_SetUp_Literal.Text = "<span style='color:red;'>Please select the number of mini leagues required.</span>"
            End If

        Else
            Juniors_SetUp_Literal.Text = "<span style='color:red;'>Results have already been recorded for the Juniors.<br/>Click 'Set up juniors into mini leagues' again to remove all juniors results and set up the mini leagues afresh.</span>"
        End If

    End Sub

    Protected Sub AddEntry_Button_Click(sender As Object, e As EventArgs) Handles AddEntry_Button.Click

        If Competitions_DropDownList.SelectedIndex < 1 Then
            Status_Literal.Text = "<span style='color:red;'>Please select a competition to add an entry to.</span>"
        Else
            Status_Literal.Text = ""
            Session("EntryID") = Nothing
            Using Comp As New CompetitionData(Competitions_DropDownList.SelectedValue)

                If Comp.Drawn Then
                    Replace_Table.Visible = False
                    Add_Table.Visible = True
                Else
                    Replace_Table.Visible = True
                    Add_Table.Visible = False
                End If

                ReplaceStatus_Literal.Text = ""
                ShowHideEntrant2(Comp.competitionType = HBSAcodeLibrary.CompetitionType.Pairs)
                Replace_Panel.Visible = True
                EnableDisableControls(False)

            End Using

        End If

    End Sub

    Protected Sub CancelAddEntry_Button_Click(sender As Object, e As EventArgs) Handles CancelAddEntry_Button.Click

        Replace_Panel.Visible = False
        EnableDisableControls(True)
        Status_Literal.Text = ""

    End Sub

    Protected Sub ClearDraw_Button_Click(sender As Object, e As EventArgs) Handles ClearDraw_Button.Click

        'user has requested clear draw comp (make round 1)
        Using comp As CompetitionData = New CompetitionData(Competitions_DropDownList.SelectedValue)
            comp.Make1stRound()
        End Using

        'set up to select entries
        Replace_Table.Visible = True
        Add_Table.Visible = False

    End Sub

    Protected Sub Entrant_TextBox_TextChanged(sender As Object, e As EventArgs) Handles Entrant_TextBox.TextChanged

        Dim ix As Integer
        ReplaceStatus_Literal.Text = ""

        With Entrants_DropDownList

            For ix = 0 To .Items.Count - 1
                If .Items(ix).Text.Trim.ToLower = Entrant_TextBox.Text.Trim.ToLower Then
                    .SelectedIndex = ix
                    Exit For
                End If
            Next
            If ix >= .Items.Count Then
                ReplaceStatus_Literal.Text = "<span style='color:red;'>The entrant in the search box does not match any of the selectable entrants.<br/>" &
                                             "The entrant is probably already entered in the competition.</span>"
            End If

        End With

    End Sub

    Protected Sub Entrant2_TextBox_TextChanged(sender As Object, e As EventArgs) Handles Entrant2_TextBox.TextChanged

        Dim ix As Integer
        ReplaceStatus_Literal.Text = ""

        With Entrant2_DropDownList

            For ix = 0 To .Items.Count - 1
                If .Items(ix).Text.Trim.ToLower = Entrant2_TextBox.Text.Trim.ToLower Then
                    .SelectedIndex = ix
                    Exit For
                End If
            Next
            If ix >= .Items.Count Then
                ReplaceStatus_Literal.Text = "<span style='color:red;'>The entrant in the second search box does not match any of the selectable entrants." &
                                             "The entrant is probably already enteredin the competition.</span>"
            End If

        End With
    End Sub

    Sub EnableDisableControls(EnableDisable As Boolean)

        For Each ctl As Control In MainPage.Controls
            Select Case ctl.GetType()
                Case GetType(TextBox)
                    Dim Ctrl As TextBox = CType(ctl, TextBox)
                    Ctrl.Enabled = EnableDisable
                Case GetType(DropDownList)
                    Dim Ctrl As DropDownList = CType(ctl, DropDownList)
                    Ctrl.Enabled = EnableDisable
                Case GetType(Button)
                    Dim Ctrl As Button = CType(ctl, Button)
                    Ctrl.Enabled = EnableDisable
            End Select
        Next
    End Sub

    Protected Sub Entrants_GridView_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Entrants_GridView.SelectedIndexChanged
        ClubsWithoutPrivacyAccepted_Panel.Visible = False
    End Sub

    Protected Sub ClubsWithoutPrivacyAccepted_Button_Click(sender As Object, e As EventArgs) Handles ClubsWithoutPrivacyAccepted_Button.Click
        ClubsWithoutPrivacyAccepted_Panel.Visible = False
    End Sub
End Class