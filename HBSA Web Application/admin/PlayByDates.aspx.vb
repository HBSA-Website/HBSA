Public Class PlayByDates
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

        Using comps As DataTable = HBSAcodeLibrary.CompetitionData.GetCompetitions

            With Competitions_DropDownList
                .Items.Clear()
                .Visible = True
                .DataSource = comps
                .DataTextField = "Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select a Competition**", 0))

            End With

        End Using

    End Sub


    Protected Sub Competitions_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Competitions_DropDownList.SelectedIndexChanged

        Dim PlayByDatesTable As DataTable = HBSAcodeLibrary.CompetitionRounds.GetPlayByDates(Competitions_DropDownList.SelectedValue)
        Dates_GridView.DataSource = PlayByDatesTable
        Dates_GridView.DataBind()

        If PlayByDatesTable.Rows.Count > 0 Then
            'populate update panel
            With Round_DropDownList
                .Items.Clear()
                .Items.Add("** Select a round **")

                For ix = 1 To PlayByDatesTable.Columns.Count - 1
                    Select Case ix
                        Case PlayByDatesTable.Columns.Count - 1
                            .Items.Add(New ListItem("Final", ix - 1))
                        Case PlayByDatesTable.Columns.Count - 2
                            .Items.Add(New ListItem("Semi-Final", ix - 1))
                        Case Else
                            .Items.Add(New ListItem("Round " & ix, ix - 1))
                    End Select
                Next

                .SelectedIndex = 0

            End With

            Update_Panel.Visible = True

        Else
            Update_Panel.Visible = False
        End If

    End Sub

    Protected Sub Round_DropDownList_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Round_DropDownList.SelectedIndexChanged

        With Round_DropDownList
            If .SelectedIndex < 1 Then
                PlayByDate_TextBox.Text = ""
            Else
                PlayByDate_TextBox.Text = Dates_GridView.Rows(0).Cells(Round_DropDownList.SelectedValue + 1).Text.Replace("&nbsp;", "")
                Comment_TextBox.Text = Dates_GridView.Rows(1).Cells(Round_DropDownList.SelectedValue + 1).Text.Replace("&nbsp;", " ").Trim
            End If
        End With

    End Sub

    Protected Sub PlayByDate_Button_Click(sender As Object, e As EventArgs) Handles PlayByDate_Button.Click

        If Round_DropDownList.SelectedIndex < 1 Then
            Status_Literal.Text = "<span style='color:red;'>Please select a round and try again.</span>"
        Else

            'Given a date apply it to that round
            Dim PlayBydate As Date
            Status_Literal.Text = ""
            If PlayByDate_TextBox.Text.Trim = "" Then
                PlayBydate = #1/1/2001#
            Else
                Try
                    PlayBydate = CDate(PlayByDate_TextBox.Text)
                Catch ex As Exception
                    Status_Literal.Text = "<span style='color:red;'>Invalid date, please try again.</span>"
                    Exit Sub
                End Try
            End If

            Dim Comment As String = Comment_TextBox.Text.Trim
            HBSAcodeLibrary.CompetitionRounds.MergeNote(Competitions_DropDownList.SelectedValue, Round_DropDownList.SelectedValue, PlayBydate, Comment)

            Competitions_DropDownList_SelectedIndexChanged(sender, e)

            'Calendar.Visible = False
        End If

    End Sub

    'Protected Sub ImageButton_Click(sender As Object, e As ImageClickEventArgs) Handles Calendar_ImageButton.Click

    '    If Calendar.Visible = True Then
    '        Calendar.Visible = False
    '    Else
    '        Dim dat As New DateTime

    '        If DateTime.TryParse(PlayByDate_TextBox.Text, dat) Then
    '            Calendar.SelectedDate = dat
    '            Calendar.VisibleDate = dat
    '        End If

    '        Calendar.Attributes.Add("style", "position:absolute")

    '        Calendar.Visible = True
    '    End If

    'End Sub

    'Protected Sub Calendar_SelectionChanged(sender As Object, e As EventArgs) Handles Calendar.SelectionChanged

    '    PlayByDate_TextBox.Text = Calendar.SelectedDate.ToString("dd MMM yyyy")

    '    Calendar.Visible = False

    'End Sub

    Private Sub Dates_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Dates_GridView.RowDataBound

        If e.Row.RowType <> DataControlRowType.EmptyDataRow Then
            e.Row.Cells(0).Visible = False
        End If

    End Sub

End Class