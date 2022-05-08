Public Class TrophiesAndPrizes
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        With Awards_GridView
            Using _Awards As New HBSAcodeLibrary.AwardsObj

                Dim AwardsReport As DataTable = _Awards.Report(0)

                .DataSource = AwardsReport
                .DataBind()

            End Using

        End With

    End Sub

    Private Sub Awards_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Awards_GridView.RowDataBound

        For ix = 4 To e.Row.Cells.Count - 1
            e.Row.Cells(ix).Visible = False
        Next

    End Sub
End Class