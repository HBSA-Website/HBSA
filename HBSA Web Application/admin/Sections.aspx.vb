Imports HBSAcodeLibrary
Public Class Sections
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                populateLeagues()
                populateSections()
            End If
        End If

    End Sub

    Sub PopulateLeagues()

        Using leaguesList As DataTable = LeagueData.AllLeagues

            With League_DropDownList
                .Items.Clear()
                .DataSource = leaguesList
                .DataTextField = "League Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("** Select a League **", 0))

            End With

        End Using

    End Sub
    Sub PopulateSections()

        Using sectionsList As DataTable = SectionData.GetSections()

            Session("SectionsData") = sectionsList

            With Sections_GridView
                .DataSource = sectionsList
                .DataBind()
            End With

        End Using

    End Sub

    Private Sub Sections_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Sections_GridView.RowDataBound

        e.Row.Cells(1).Visible = False

    End Sub

    Private Sub Sections_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Sections_GridView.RowDeleting

        SubmitPlayer_Button.Text = "Delete"
        Edit_Literal.Text = "Do you really want to remove this Section? <br/><br/>click Delete to remove it from the system, or click Cancel."
        Err_Literal.Text = ""

        Using Section As New HBSAcodeLibrary.SectionData(Sections_GridView.Rows(e.RowIndex).Cells(1).Text)

            If Section.Players.Rows.Count > 0 Then
                Err_Literal.Text += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cannot remove " & Section.SectionName & " because it has " & Section.Players.Rows.Count & " players registered."
            End If

            If Err_Literal.Text = "" Then
                FillEditTextBoxes(Section)
                EnableDisableTextBoxes(False)
            Else
                Err_Literal.Text += "<br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To remove this Section, remove it's registered players and teams first.<br/><br/>"
            End If

        End Using

        e.Cancel = True

    End Sub

    Private Sub Sections_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles Sections_GridView.RowEditing, Sections_GridView.RowEditing

        SubmitPlayer_Button.Text = "Save"
        Edit_Literal.Text = "Amend required Section details here then click Save to record them in the system, or click Cancel."

        FillEditTextBoxes(New HBSAcodeLibrary.SectionData(Sections_GridView.Rows(e.NewEditIndex).Cells(1).Text))
        EnableDisableTextBoxes(True)

        e.Cancel = True

    End Sub

    Sub FillEditTextBoxes(Section As HBSAcodeLibrary.SectionData)

        With Section

            ID_TextBox.Text = .ID
            SectionName_TextBox.Text = .SectionName
            League_DropDownList.SelectedValue = .LeagueID
            ReversedMatrix_CheckBox.Checked = .ReversedMatrix
        End With

        Edit_Panel.Visible = True

    End Sub

    Private Sub Sections_GridView_Sorting(sender As Object, e As GridViewSortEventArgs) Handles Sections_GridView.Sorting

        If Not IsNothing(Session("SectionsData")) Then
            Dim OrdersData As DataTable = Session("SectionsData")
            OrdersData.DefaultView.Sort = e.SortExpression & " " & GetSortDirection(e.SortExpression)
            With Sections_GridView
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

    Protected Sub Add_Button_Click(sender As Object, e As EventArgs) Handles Add_Button.Click

        ID_TextBox.Text = "-1"
        SectionName_TextBox.Text = ""
        League_DropDownList.SelectedValue = 0
        ReversedMatrix_CheckBox.Checked = False

        SubmitPlayer_Button.Text = "Add"
        Edit_Literal.Text = "Enter the new Section's details here then click Add to record them in the system, or click Cancel."

        EnableDisableTextBoxes(True)
        Edit_Panel.Visible = True

    End Sub

    Sub EnableDisableTextBoxes(enable As Boolean)

        SectionName_TextBox.Enabled = enable
        League_DropDownList.Enabled = enable
        ReversedMatrix_CheckBox.Enabled = enable

    End Sub

    Protected Sub CancelPlayer_Button_Click(sender As Object, e As EventArgs) Handles CancelPlayer_Button.Click

        Edit_Panel.Visible = False

    End Sub

    Protected Sub SubmitPlayer_Button_Click(sender As Object, e As EventArgs) Handles SubmitPlayer_Button.Click

        Err_Literal.Text = ""

        If SubmitPlayer_Button.Text = "Delete" Then
            SectionName_TextBox.Text = "remove"
        Else
            If League_DropDownList.SelectedIndex < 1 Then
                Err_Literal.Text = "Please select the league to which this section belongs."
                Exit Sub
            End If
        End If

        Using Section As New HBSAcodeLibrary.SectionData() 'CInt(ID_TextBox.Text))
            With Section
                .ID = CInt(ID_TextBox.Text)
                .SectionName = SectionName_TextBox.Text.Trim
                .LeagueID = League_DropDownList.SelectedValue
                .ReversedMatrix = Math.Abs(CInt(ReversedMatrix_CheckBox.Checked))

                Dim action As String = .Merge() ' This will insert/update/delete as required
                If action Is Nothing Then
                    Err_Literal.Text = "Error: Cannot delete/insert this Section with ID=" & CInt(ID_TextBox.Text) & "<br/><br/>Please contact support."
                End If

                If AssignMatrix_CheckBox.Checked Then
                    HBSAcodeLibrary.SectionData.AssignFixtureGrid(.ID)
                End If

                populateSections()
                Edit_Panel.Visible = False

            End With
        End Using

    End Sub


End Class