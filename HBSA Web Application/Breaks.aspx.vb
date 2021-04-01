Public Class Breaks
    Inherits System.Web.UI.Page
    Protected Sub Open_Button_Click(sender As Button, e As EventArgs) _
        Handles Open_Button.Click, Vets_Button.Click, Billiards_Button.Click

        Using breaksReport As DataTable = HBSAcodeLibrary.SharedRoutines.BreaksReport(If(sender.ClientID Like "*Open*", 1, If(sender.ClientID Like "*Vets*", 2, 3)))

            With Breaks_GridView
                .DataSource = breaksReport
                .DataBind()
            End With

        End Using

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