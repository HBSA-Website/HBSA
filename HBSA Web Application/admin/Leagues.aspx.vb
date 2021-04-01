Public Class Leagues
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                populateLeagues()
            End If
        End If

    End Sub

    Sub PopulateLeagues()

        Using dt As DataTable = HBSAcodeLibrary.LeagueData.GetLeaguesWithHandicapLimits

            With Leagues_GridView
                .DataSource = dt
                .DataBind()
            End With

        End Using

    End Sub

    Private Sub Leagues_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Leagues_GridView.RowDataBound

        e.Row.Cells(1).Visible = False

    End Sub

    Private Sub Leagues_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Leagues_GridView.RowDeleting

        Submit_Button.Text = "Delete"
        Edit_Literal.Text = "Do you really want to remove this League? <br/><br/>click Delete to remove it from the system, or click Cancel."
        Err_Literal.Text = ""

        Using League As New HBSAcodeLibrary.LeagueData(Leagues_GridView.Rows(e.RowIndex).Cells(1).Text)

            If League.Sections.Rows.Count > 0 Then
                Err_Literal.Text = "Cannot remove " & League.LeagueName & " because it has " & League.Sections.Rows.Count & " Sections registered."
            End If

            If League.Teams.Rows.Count > 0 Then
                Err_Literal.Text += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cannot remove " & League.LeagueName & " because it has " & League.Teams.Rows.Count & " teams registered."
            End If
            If League.Players.Rows.Count > 0 Then
                Err_Literal.Text += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cannot remove " & League.LeagueName & " because it has " & League.Players.Rows.Count & " players registered."
            End If

            If Err_Literal.Text = "" Then
                FillEditTextBoxes(League)
                EnableDisableTextBoxes(False)
            Else
                Err_Literal.Text += "<br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To remove this League, remove it's registered sections, players and teams first.<br/><br/>"
            End If

        End Using

        e.Cancel = True

    End Sub

    Private Sub Leagues_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles Leagues_GridView.RowEditing, Leagues_GridView.RowEditing

        Submit_Button.Text = "Save"
        Edit_Literal.Text = "Amend required League details here then click Save to record them in the system, or click Cancel."

        FillEditTextBoxes(New HBSAcodeLibrary.LeagueData(Leagues_GridView.Rows(e.NewEditIndex).Cells(1).Text))
        EnableDisableTextBoxes(True)

        e.Cancel = True

    End Sub

    Sub FillEditTextBoxes(League As HBSAcodeLibrary.LeagueData)

        With League

            ID_TextBox.Text = .ID
            LeagueName_TextBox.Text = .LeagueName
            MaxHandicapTextBox.Text = If(.MaxHandicap = HBSAcodeLibrary.Utilities.maxInteger, "No Limit", .MaxHandicap)
            MinHandicapTextBox.Text = If(.MinHandicap = HBSAcodeLibrary.Utilities.minInteger, "No Limit", .MinHandicap)

        End With

        Edit_Panel.Visible = True

    End Sub

    Protected Sub Add_Button_Click(sender As Object, e As EventArgs) Handles Add_Button.Click

        ID_TextBox.Text = "-1"
        LeagueName_TextBox.Text = ""

        Submit_Button.Text = "Add"
        Edit_Literal.Text = "Enter the new League's details here then click Add to record them in the system, or click Cancel."

        EnableDisableTextBoxes(True)
        Edit_Panel.Visible = True

    End Sub

    Sub EnableDisableTextBoxes(enable As Boolean)

        LeagueName_TextBox.Enabled = enable
        MaxHandicapTextBox.Enabled = enable
        MinHandicapTextBox.Enabled = enable

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        Edit_Panel.Visible = False
        Err_Literal.Text = ""

    End Sub

    Protected Sub Submit_Button_Click(sender As Object, e As EventArgs) Handles Submit_Button.Click

        Err_Literal.Text = ""

        If Submit_Button.Text <> "Delete" Then
            If LeagueName_TextBox.Text.Trim = "" Then
                Err_Literal.Text = "Cannot have a League without a name."
                Exit Sub
            End If
        Else
            LeagueName_TextBox.Text = ""
        End If

        Using League As New HBSAcodeLibrary.LeagueData(CInt(ID_TextBox.Text))
            With League
                .ID = CInt(ID_TextBox.Text)
                .LeagueName = LeagueName_TextBox.Text.Trim
                Try
                    .MaxHandicap = If(MaxHandicapTextBox.Text.ToLower.Contains("no"), HBSAcodeLibrary.Utilities.maxInteger, CInt(MaxHandicapTextBox.Text))
                Catch ex As Exception
                    Err_Literal.Text = "Max Handicap must be an integer or contain the word 'no'."
                    Exit Sub
                End Try
                Try
                    .MinHandicap = If(MinHandicapTextBox.Text.ToLower.Contains("no"), HBSAcodeLibrary.Utilities.minInteger, CInt(MinHandicapTextBox.Text))
                Catch ex As Exception
                    Err_Literal.Text = "Min Handicap must be an integer or contain the word 'no'."
                    Exit Sub
                End Try

                Dim action As String = .Merge() ' This will insert/update/delete as required
                If action Is Nothing Then
                    Err_Literal.Text = "Error: Cannot delete/insert this League with ID=" & CInt(ID_TextBox.Text) & "<br/><br/>Please contact support."
                End If

                populateLeagues()
                Edit_Panel.Visible = False

            End With
        End Using

    End Sub
End Class