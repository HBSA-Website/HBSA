Public Class JuniorsResults
    Inherits System.Web.UI.Page
    Private Sub JuniorsResults_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Not IsPostBack Then

            bindGrid

        End If
    End Sub
    Sub bindGrid()

        With GridView1
            .DataSource = HBSAcodeLibrary.JuniorsCompetitions.JuniorsResultsForAdmin
            .DataBind()
        End With

    End Sub
    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click

        Try

            HBSAcodeLibrary.JuniorsCompetitions.PromoteToKO()
            Promote_Literal.Text = "<br/><span style='color:darkgreen;'>Done.  Go to the Competitions page to view it.</span>"

        Catch ex As Exception

            Promote_Literal.Text = "<br/><span style='color:red;'>Failed: " & ex.Message & "</span>"

        End Try

    End Sub

    Private Sub GridView1_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles GridView1.RowEditing

        GridView1.EditIndex = e.NewEditIndex
        Me.bindGrid()

    End Sub
    Private Sub GridView1_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles GridView1.RowUpdating

        Dim ID As Integer
        Dim NewValues(5) As Integer

        With GridView1.Rows(e.RowIndex)
            ID = CInt(.Cells(1).Text)
            For ix = 5 To 10
                For Each ctl As Control In .Cells(ix).Controls
                    If ctl.GetType() Is GetType(TextBox) Then
                        NewValues(ix - 5) = CInt(CType(ctl, TextBox).Text)
                    End If
                Next
            Next
        End With

        HBSAcodeLibrary.JuniorsCompetitions.UpdateJuniorResult(ID, NewValues)

        GridView1.EditIndex = -1
        Me.bindGrid()

    End Sub
    Private Sub GridView1_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles GridView1.RowCancelingEdit

        GridView1.EditIndex = -1
        Me.bindGrid()

    End Sub

    Private Sub GridView1_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView1.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow OrElse e.Row.RowType = DataControlRowType.Header Then
            e.Row.Cells(1).Visible = False
        End If
    End Sub
End Class