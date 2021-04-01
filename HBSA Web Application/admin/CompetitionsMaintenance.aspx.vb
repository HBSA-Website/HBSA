Imports HBSAcodeLibrary
Public Class CompetitionsMaintenance
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                populateLeagueDropDown()
                populateGridView()
            Else
                If Request.Item("_ButtonClicked").Length > 0 Then
                    HandleButtonClicked(Request.Item("_ButtonClicked"))
                End If
            End If
        End If

    End Sub

    Sub PopulateLeagueDropDown()

        Using leaguesList As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues()

            With League_DropDownList

                .Items.Clear()
                .DataSource = leaguesList
                .DataTextField = "League Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select**", "0"))

            End With

        End Using

    End Sub

    Sub PopulateGridView()

        Using comps As DataTable = HBSAcodeLibrary.CompetitionData.GetCompetitions()

            Competitions_GridView.DataSource = comps
            Competitions_GridView.DataBind()

        End Using

    End Sub

    Private Sub Competitions_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Competitions_GridView.RowDataBound

        With e.Row

            If .RowType = DataControlRowType.DataRow Then
                Dim EditButton As New Button()
                With EditButton
                    .ID = "EditButton_" & e.Row.RowIndex & "_" & e.Row.Cells(1).Text
                    .Text = "Edit"
                    .Attributes.Add("onClick", "document.forms[0]." & "_ButtonClicked.value='" & .ID & "';document.forms[0].submit();")

                End With

                .Cells(0).Controls.Add(EditButton)

                Dim DeleteButton As New Button()
                With DeleteButton
                    .ID = "DeleteButton_" & e.Row.RowIndex & "_" & e.Row.Cells(1).Text
                    .Text = "Delete"
                    .Attributes.Add("onClick", "document.forms[0]." & "_ButtonClicked.value='" & .ID & "';document.forms[0].submit();")

                End With

                .Cells(0).Controls.Add(DeleteButton)

                Dim ClearButton As New Button()
                With ClearButton
                    .ID = "ClearButton_" & e.Row.RowIndex & "_" & e.Row.Cells(1).Text
                    .Text = "Clear"
                    .Attributes.Add("onClick", "document.forms[0]." & "_ButtonClicked.value='" & .ID & "';document.forms[0].submit();")

                End With

                .Cells(0).Controls.Add(ClearButton)

                .Cells(.Cells.Count - 1).Text = .Cells(.Cells.Count - 1).Text.Replace(vbCrLf, "<br/>")

            End If

        End With

    End Sub

    Sub HandleButtonClicked(RequestItem As String)

        Dim RequestItemValues() As String = RequestItem.Split("_")

        Dim RowIndex As Integer = RequestItemValues(1)
        Dim CompetitionsID As Integer = RequestItemValues(2)

        Using Comp As New CompetitionData(CompetitionsID)

            With Comp
                If RequestItemValues(0).ToLower Like "*edit*" Then

                    ID_TextBox.Text = .ID
                    ID_TextBox.Enabled = False
                    Name_TextBox.Text = .Name
                    Name_TextBox.Enabled = True
                    League_DropDownList.SelectedValue = .LeagueID
                    League_DropDownList.Enabled = True
                    Type_DropDownList.SelectedValue = .competitionType
                    Type_DropDownList.Enabled = True
                    Comment_TextBox.Text = .Comment
                    Comment_TextBox.Enabled = True
                    EntryForm_CheckBox.Checked = .EntryForm
                    EntryFee_TextBox.Text = .EntryFee
                    Edit_Literal.Text = "Edit the competition details then click Save (or Cancel to do nothing)."
                    SubmitCompetition_Button.Text = "Save"
                    Edit_Panel.Visible = True

                ElseIf RequestItemValues(0).ToLower Like "*delete*" Then

                    Delete_Literal.Text = "To remove the competition named " & .Name & "(" & .ID & ") click Remove, otherwise click Cancel.<br/><br/> NOTE: this will remove all entrants and results as well."
                    Delete_Panel.Visible = True
                    Delete_Button.Text = "Remove"
                    DeletePanel_Literal.Text = DeletePanel_Literal.Text.Replace("Clear", "Remove")

                Else

                    Delete_Literal.Text = "To clear the competition named " & .Name & "(" & .ID & ") click Clear, otherwise click Cancel.<br/><br/> NOTE: this will remove all entrants and results but the leave the competition intact."
                    Delete_Panel.Visible = True
                    Delete_Button.Text = "Clear"
                    DeletePanel_Literal.Text = DeletePanel_Literal.Text.Replace("Remove", "Clear")

                End If

            End With

        End Using


    End Sub



    Protected Sub CancelCompetition_Button_Click(sender As Object, e As EventArgs) Handles CancelCompetition_Button.Click

        Edit_Panel.Visible = False
        populateGridView()

    End Sub

    Protected Sub SubmitCompetition_Button_Click(sender As Object, e As EventArgs) Handles SubmitCompetition_Button.Click

        If Name_TextBox.Text.Trim = "" Then
            Edit_Literal.Text += "<br/><span style='color:red;'>Please enter a name for the competition.</span>"
            Exit Sub
        End If

        Dim EntryFee As Decimal
        Try
            EntryFee = CDec(EntryFee_TextBox.Text)
        Catch ex As Exception
            Edit_Literal.Text += "<br/><span style='color:red;'>The entry fee must be a valid monetary amount without the currency symbol.</span>"
            Exit Sub
        End Try

        If SubmitCompetition_Button.Text = "Save" Then

            Using Comp As New CompetitionData(CInt(ID_TextBox.Text))

                With Comp
                    .Name = Name_TextBox.Text.Trim
                    .LeagueID = League_DropDownList.SelectedValue
                    .competitionType = Type_DropDownList.SelectedValue
                    .Comment = Comment_TextBox.Text.Trim
                    .EntryForm = EntryForm_CheckBox.Checked
                    .EntryFee = EntryFee

                    .Update()

                End With

            End Using
        Else

            If League_DropDownList.SelectedIndex = 0 Then
                Edit_Literal.Text += "<br/><span style='color:red;'>Please select a league for the competition.</span>"
                Exit Sub
            End If
            If Type_DropDownList.SelectedIndex = 0 Then
                Edit_Literal.Text += "<br/><span style='color:red;'>Please select a competition type.</span>"
                Exit Sub
            End If


            Using Comp As New CompetitionData()

                With Comp
                    .Name = Name_TextBox.Text.Trim
                    .LeagueID = League_DropDownList.SelectedValue
                    .competitionType = Type_DropDownList.SelectedValue
                    .Comment = Comment_TextBox.Text.Trim
                    .EntryForm = EntryForm_CheckBox.Checked
                    .EntryFee = EntryFee

                    .Insert()
                End With

            End Using

        End If

        populateGridView()

        Edit_Panel.Visible = False

    End Sub

    Protected Sub Add_Button_Click(sender As Object, e As EventArgs) Handles Add_Button.Click

        Using Comp As New CompetitionData()

            With Comp
                ID_TextBox.Text = ""
                ID_TextBox.Enabled = False
                Name_TextBox.Text = ""
                Name_TextBox.Enabled = True
                League_DropDownList.SelectedIndex = 0
                League_DropDownList.Enabled = True
                Type_DropDownList.SelectedIndex = 0
                Type_DropDownList.Enabled = True
                Comment_TextBox.Text = ""
                Comment_TextBox.Enabled = True
                EntryForm_CheckBox.Checked = False
                EntryForm_CheckBox.Enabled = True
                EntryFee_TextBox.Text = 0.00

                Edit_Literal.Text = "Enter the competition details, then click Add (or Cancel to do nothing)."
                SubmitCompetition_Button.Text = "Add"

            End With

            Edit_Panel.Visible = True

        End Using

    End Sub


    Protected Sub CancelDelete_Button_Click(sender As Object, e As EventArgs) Handles CancelDelete_Button.Click

        Delete_Panel.Visible = False
        populateGridView()


    End Sub

    Protected Sub Delete_Button_Click(sender As Object, e As EventArgs) Handles Delete_Button.Click

        If Delete_Button.Text = "Clear ALL" Then

            CompetitionData.ClearAllCompetitions()

        ElseIf Delete_Button.Text = "Allow Competitions Entry Forms" Then

            HBSAcodeLibrary.HBSA_Configuration.AllowCompetitionsEntryForms(True)

        Else
            Dim ix1 As Integer = Delete_Literal.Text.LastIndexOf("(")
            Dim ix2 As Integer = Delete_Literal.Text.LastIndexOf(")")
            Dim CompetitionID As Integer = CInt(Delete_Literal.Text.Substring(ix1 + 1, ix2 - ix1 - 1))

            Using comp As New CompetitionData(CompetitionID)

                If Delete_Button.Text.ToLower Like "*clear*" Then
                    comp.Clear()
                Else
                    comp.Delete()
                End If

            End Using


        End If

        Delete_Button.Text = "Remove"
        Delete_Panel.Visible = False
        populateGridView()

    End Sub

    Protected Sub ClearAll_Button_Click(sender As Object, e As EventArgs) Handles ClearAll_Button.Click

        Delete_Literal.Text = "To clear ALL the competitions click Clear ALL, otherwise click Cancel.<br/><br/>" &
                              "NOTE: this will remove all entrants and results in each competition.  This will require all competitions to be re-drawn<br/>" &
                              "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to clear entry forms use</br>" &
                              "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href='ClearCompetitionsEntryForms.aspx'>Competitions >> Competitions Entry Forms Maintenance >> Clear All Entry Forms.</a>"
        Delete_Button.Text = "Clear ALL"
        Delete_Panel.Visible = True

    End Sub

    Protected Sub AllowEntryForms_Button_Click(sender As Object, e As EventArgs) Handles AllowEntryForms_Button.Click

        Delete_Literal.Text = "To enable competitions entry forms click 'Allow Competitions Entry Forms'.<br/><br/>" &
                              "NOTE: this will open up competitions entry forms for general users, and set the entry forms to 'submitted', but will not do anything else.<br/>" &
                              "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This will allow any entry form to be amended if required."
        Delete_Button.Text = "Allow Competitions Entry Forms"
        Delete_Panel.Visible = True

    End Sub

End Class