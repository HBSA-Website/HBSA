Public Class Breaks1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            Using LeaguesTable As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues

                With League_DropDownList
                    .Items.Clear()
                    .Items.Add(New ListItem("** Select a League **", 0))
                    For Each row As DataRow In LeaguesTable.Rows
                        .Items.Add(New ListItem(row.Item("League Name"), row.Item("ID")))
                    Next

                End With

            End Using

        End If

    End Sub
    Protected Sub League_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles League_DropDownList.SelectedIndexChanged

        If League_DropDownList.SelectedIndex > 0 Then

            Using breaksReport As DataTable = HBSAcodeLibrary.SharedRoutines.BreaksReport(League_DropDownList.SelectedValue)

                With Breaks_GridView
                    .DataSource = breaksReport
                    .DataBind()
                End With

            End Using

        End If

    End Sub

    Private Sub Breaks_GridView_DataBound(sender As Object, e As EventArgs) Handles Breaks_GridView.DataBound

        If Breaks_GridView.Rows.Count > 0 Then
            Breaks_GridView.Rows(0).BackColor = Drawing.Color.FromArgb(255, 210, 0)
            Breaks_GridView.Rows(0).ForeColor = Drawing.Color.White
            Breaks_GridView.Rows(0).Font.Bold = True
            Breaks_GridView.Rows(0).Height = 50 'Breaks_GridView.Rows(0).Height.Value * 2
            Breaks_GridView.Rows(0).VerticalAlign = VerticalAlign.Middle
        End If

    End Sub

    Private Sub Breaks_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Breaks_GridView.RowDataBound

        With e.Row
            For Each cell As TableCell In .Cells
                If e.Row.RowType = DataControlRowType.Header Then
                    If cell.Text.StartsWith("Breaks") Then
                        cell.Text = "Breaks"
                    End If
                End If
                'cell.Text = cell.Text.Replace(" ", "&nbsp;")
            Next
        End With

    End Sub

End Class