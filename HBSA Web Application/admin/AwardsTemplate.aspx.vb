Public Class AwardsTemplate
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            PopulateLeagueDropDownList()
            PopulateAwardTypeDropDownList()
            ReportTemplates()
        End If

    End Sub

    Protected Sub PopulateAwardTypeDropDownList()

        Dim AwardTypes As DataTable = HBSAcodeLibrary.AwardsTemplate.AwardTypes

        With AwardType_DropDownList

            .Items.Clear()

            .DataSource = AwardTypes
            .DataTextField = "Description"
            .DataValueField = "AwardType"
            .DataBind()

            .Items.Insert(0, New ListItem("**Select**", "0"))

        End With

    End Sub

    Protected Sub PopulateLeagueDropDownList()

        Dim Leagues As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues

        With League_DropDownList

            .Items.Clear()

            .DataSource = Leagues
            .DataTextField = "League Name"
            .DataValueField = "ID"
            .DataBind()
            .Items.Insert(0, New ListItem("**Select**", "0"))

        End With


    End Sub

    Private Sub ReportTemplates()

        With AwardsTemplates_GridView

            Dim AwardsReport As DataTable = HBSAcodeLibrary.AwardsTemplate.AvailableAwards(True)

            .DataSource = AwardsReport
            .DataBind()

        End With

    End Sub

    Private Sub AwardsTemplates_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles AwardsTemplates_GridView.RowDataBound

        If e.Row.Cells.Count > 6 Then

            For ix As Integer = 3 To 6
                e.Row.Cells(ix).Visible = False
            Next

            If e.Row.Cells.Count > 9 Then
                e.Row.Cells(9).HorizontalAlign = HorizontalAlign.Center
            End If

        End If

    End Sub

    Private Sub AwardsTemplates_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles AwardsTemplates_GridView.RowDeleting

        EditPanel_Literal2.Text = "Click Confirm if you want to delete this Trophy/Prize, or click Cancel."

        FillEditPanel(AwardsTemplates_GridView.Rows(e.RowIndex), False)

        Submit_Button.Text = "Confirm"

        e.Cancel = True

    End Sub

    Private Sub AwardsTemplates_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles AwardsTemplates_GridView.RowEditing

        EditPanel_Literal2.Text = "Enter the changes to Trophy and/or Award, and indicate whether multiple winmners are allowed, then click Change, or click Cancel."

        FillEditPanel(AwardsTemplates_GridView.Rows(e.NewEditIndex), True)

        Submit_Button.Text = "Change"

        e.Cancel = True

    End Sub
    Sub FillEditPanel(templateRow As GridViewRow, editing As Boolean)

        EditStatus_Literal.Text = ""

        With templateRow

            League_DropDownList.SelectedValue = .Cells(6).Text
            Competition_Literal.Text = .Cells(2).Text
            Trophy_TextBox.Text = .Cells(7).Text
            Award_DropDownList.SelectedValue = .Cells(8).Text
            MultipleWinners_CheckBox.Checked = DirectCast(.Cells(9).Controls(0), CheckBox).Checked
            Recipient_DropDownList.SelectedValue = .Cells(10).Text

            AwardType_HiddenField.Value = .Cells(3).Text
            AwardID_HiddenField.Value = .Cells(4).Text
            SubID_HiddenField.Value = .Cells(5).Text

        End With

        Trophy_TextBox.Enabled = editing
        Award_DropDownList.Enabled = editing
        MultipleWinners_CheckBox.Enabled = editing
        Recipient_DropDownList.Enabled = editing

        League_DropDownList.Enabled = False

        AddPanel.Visible = False
        EditPanel.Visible = True
        Submit_Button.Visible = True
        Edit_Panel.Visible = True



    End Sub
    Protected Sub CreateTemplate_Button_Click(sender As Object, e As EventArgs) Handles CreateTemplate_Button.Click

        EditPanel_Literal2.Text = "Enter the details you require, and click Create, or click Cancel."
        EditStatus_Literal.Text = ""

        'clear dependent controls
        SubID_DropDownList.Items.Clear()
        SubID_DropDownList.Enabled = False
        AwardID_DropDownList.Items.Clear()
        AwardID_DropDownList.Enabled = False

        League_DropDownList.SelectedIndex = 0
        Competition_Literal.Text = ""
        Trophy_TextBox.Text = ""

        League_DropDownList.Enabled = True
        Competition_Literal.Text = ""
        Trophy_TextBox.Text = ""
        Award_DropDownList.SelectedIndex = 0
        MultipleWinners_CheckBox.Checked = False
        Recipient_DropDownList.SelectedIndex = 0

        Trophy_TextBox.Enabled = True
        Award_DropDownList.Enabled = True
        MultipleWinners_CheckBox.Enabled = True
        Recipient_DropDownList.Enabled = True

        AwardType_HiddenField.Value = 0
        AwardID_HiddenField.Value = 0
        SubID_HiddenField.Value = 0

        MultipleWinners_CheckBox.Checked = False

        AddPanel.Visible = True
        EditPanel.Visible = True

        Submit_Button.Text = "Create"
        Submit_Button.Visible = True

        Edit_Panel.Visible = True

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        Edit_Panel.Visible = False

    End Sub

    Protected Sub AwardType_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles AwardType_DropDownList.SelectedIndexChanged

        'clear dependent controls
        SubID_DropDownList.Items.Clear()
        SubID_DropDownList.Enabled = False

        'Given the award type populate the award ID
        With AwardID_DropDownList

            .Items.Clear()
            Select Case AwardType_DropDownList.SelectedValue
                Case 1
                    .Items.Add(New ListItem("**select a division", 0))
                    Dim Sections As DataTable = HBSAcodeLibrary.SectionData.GetSections
                    For Each Section As DataRow In Sections.Rows
                        .Items.Add(New ListItem(Section.Item("League") + " " + Section.Item("Section Name"), Section.Item("ID")))
                    Next
                    .Items(0).Selected = True
                    .Enabled = True

                Case 2
                    .Items.Add(New ListItem("**select a competition", 0))
                    Dim Competitions As DataTable = HBSAcodeLibrary.CompetitionData.GetCompetitions
                    For Each Competition As DataRow In Competitions.Rows
                        .Items.Add(New ListItem(Competition.Item("League") + " " + Competition.Item("Name"), Competition.Item("ID")))
                    Next
                    .Items(0).Selected = True
                    .Enabled = True

                Case 3
                    .Items.Add(New ListItem("**select a break category", 0))
                    Dim BreakCategories As DataTable = HBSAcodeLibrary.AwardsTemplate.GetBreaksCategories
                    For Each Competition As DataRow In BreakCategories.Rows
                        .Items.Add(New ListItem(Competition.Item("League Name") & " " & Competition.Item("LowHandicap") & " to " & Competition.Item("HighHandicap"), Competition.Item("ID")))
                    Next
                    .Items(0).Selected = True
                    .Enabled = True

                    MultipleWinners_CheckBox.Checked = True

                Case 4, 5, 6
                    MultipleWinners_CheckBox.Checked = (AwardType_DropDownList.SelectedValue = 4)

                    .Enabled = False

                    League_DropDownList.Enabled = True
                    League_DropDownList.SelectedIndex = 0

                    With SubID_DropDownList
                        .Enabled = False
                        .Items.Clear()
                    End With

                Case Else
                    Status_Literal.Text = "Please select an Award Type"

            End Select

        End With

        FillCompetitionLiteral()

    End Sub

    Protected Sub AwardID_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles AwardID_DropDownList.SelectedIndexChanged

        'Given the award type populate the award ID
        With SubID_DropDownList

            .Items.Clear()

            Select Case AwardType_DropDownList.SelectedValue

                Case 1
                    'Given the section set up winners & Runners up
                    .Items.Add(New ListItem("** select the recipient **"))
                    .Items.Add(New ListItem("Winner", 1))
                    .Items.Add(New ListItem("Runner up", 2))
                    .SelectedIndex = 0
                    .Enabled = True

                    Using Section As New HBSAcodeLibrary.SectionData(AwardID_DropDownList.SelectedValue)
                        League_DropDownList.SelectedValue = Section.LeagueID
                    End Using
                    League_DropDownList.Enabled = False

                Case 2
                    'Given the section set up winners & Runners up
                    .Items.Add(New ListItem("** select the recipient **", 0))
                    .Items.Add(New ListItem("Winner", 1))
                    .Items.Add(New ListItem("Runner up", 2))
                    .Items.Add(New ListItem("1st semi-finalist", 3))
                    .Items.Add(New ListItem("2nd semi-finalist", 4))
                    .SelectedIndex = 0
                    .Enabled = True

                    Using Competition As New HBSAcodeLibrary.CompetitionData(AwardID_DropDownList.SelectedValue)
                        League_DropDownList.SelectedValue = Competition.LeagueID
                    End Using
                    League_DropDownList.Enabled = False

                Case 3
                    Dim BreakCategory As DataRow = HBSAcodeLibrary.AwardsTemplate.GetBreaksCategory(AwardID_DropDownList.SelectedValue)
                    League_DropDownList.SelectedValue = BreakCategory.Item("LeagueID")
                    League_DropDownList.Enabled = False

                Case 4, 5, 6
                    .Enabled = False
                    League_DropDownList.Enabled = True
                    League_DropDownList.SelectedIndex = 0

            End Select

        End With

        FillCompetitionLiteral

    End Sub

    Private Sub Submit_Button_Click(sender As Object, e As EventArgs) Handles Submit_Button.Click

        Dim StatusMsg As String = ""

        'Note: with create the hidden values are empty so will instatiate an object with empty public properties
        Using AwardTemplate As New HBSAcodeLibrary.AwardsTemplate(AwardType_HiddenField.Value,
                                                            AwardID_HiddenField.Value,
                                                            SubID_HiddenField.Value,
                                                            League_DropDownList.SelectedValue)
            With AwardTemplate

                Select Case Submit_Button.Text

                    Case "Confirm"    'Delete
                        StatusMsg = .Delete
                        If Not StatusMsg Like "*deleted*" Then
                            EditStatus_Literal.Text = "<span style='color:red;'>WARNING: " & StatusMsg & "</span>.  Click Delete to remove this award anyway."
                            Submit_Button.Text = "Delete"
                            Exit Sub
                        End If

                    Case "Delete"    'Delete override
                        Dim Override As Boolean = True
                        StatusMsg = .Delete(Override)

                    Case "Change"     'Amend
                        .Trophy = Trophy_TextBox.Text
                        .Award = Award_DropDownList.SelectedItem.Text
                        .MultipleWinners = MultipleWinners_CheckBox.Checked
                        .RecipientType = Recipient_DropDownList.SelectedValue
                        .Update()
                        StatusMsg = League_DropDownList.SelectedItem.Text & ", " & Competition_Literal.Text & " Changed.  See table below for details"

                    Case "Create"     'Insert
                        .AwardType = AwardType_DropDownList.SelectedValue
                        .AwardID = AwardID_DropDownList.SelectedValue
                        .SubID = SubID_DropDownList.SelectedValue
                        .LeagueID = League_DropDownList.SelectedValue
                        .Trophy = Trophy_TextBox.Text
                        .Award = Award_DropDownList.SelectedValue
                        .MultipleWinners = MultipleWinners_CheckBox.Checked
                        .RecipientType = Recipient_DropDownList.SelectedValue
                        .create()
                        StatusMsg = League_DropDownList.SelectedItem.Text & ", " & Competition_Literal.Text & " Created.  See table below for details"

                End Select

            End With

        End Using

        Edit_Panel.Visible = False
        ReportTemplates()
        Status_Literal.Text = statusMsg

    End Sub

    Protected Sub SubID_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles SubID_DropDownList.SelectedIndexChanged
        FillCompetitionLiteral
    End Sub

    Sub FillCompetitionLiteral()

        Competition_Literal.Text = HBSAcodeLibrary.AwardsTemplate.CompetitionName(
                                        AwardType_DropDownList.SelectedValue,
                                        AwardID_DropDownList.SelectedValue,
                                        SubID_DropDownList.SelectedValue,
                                        League_DropDownList.SelectedValue)
    End Sub
End Class