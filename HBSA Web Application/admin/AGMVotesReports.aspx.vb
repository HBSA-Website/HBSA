Public Class AGMVotesReports
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                populateClubs()
                ShowReport(sender, e)
            End If
        End If

    End Sub

    Protected Sub PopulateClubs()

        Club_DropDownList.Items.Clear()

        Dim clubs As DataTable = HBSAcodeLibrary.ClubData.GetClubs(0)

        With Club_DropDownList
            .Items.Clear()
            .Visible = True

            If clubs.Rows.Count > 1 Then
                .Items.Add(New ListItem("**All Clubs**", 0))
            End If

            For Each row As DataRow In clubs.Rows
                .Items.Add(New ListItem(row.Item("Club Name"), row.Item("ID")))
            Next

            .Enabled = (clubs.Rows.Count > 1)

            .SelectedIndex = 0

        End With

    End Sub

    Protected Sub ShowReport(sender As Object, e As EventArgs) _
        Handles Club_DropDownList.SelectedIndexChanged, Report_DropDownList.SelectedIndexChanged

        Err_Literal.Text = ""

        If Err_Literal.Text = "" Then

            With AGMvoteReport_GridView

                Dim AGMvoteReport As DataTable

                If Report_DropDownList.SelectedValue = 0 Then
                    AGMvoteReport = HBSAcodeLibrary.SharedRoutines.ReportAGM_Vote(Club_DropDownList.SelectedValue)
                    .ShowHeader = True
                Else
                    AGMvoteReport = HBSAcodeLibrary.SharedRoutines.FullReportAGM_Vote(Club_DropDownList.SelectedValue)
                    .ShowHeader = False
                End If

                .DataSource = AGMvoteReport
                .DataBind()

            End With

        Else

            Err_Literal.Text = "ERROR: " & Err_Literal.Text.Substring(0, Err_Literal.Text.Length - 5)

        End If

    End Sub

    Private Sub AGMvoteReport_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles AGMvoteReport_GridView.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            e.Row.Cells(2).HorizontalAlign = HorizontalAlign.Center
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Center
            If Report_DropDownList.SelectedIndex = 0 Then
                e.Row.Cells(1).HorizontalAlign = HorizontalAlign.Center
                e.Row.Cells(0).Text = "<div style=width:600px;'>" & e.Row.Cells(0).Text & "</div>"
            Else
                e.Row.Cells(4).HorizontalAlign = HorizontalAlign.Center
                e.Row.Cells(0).Text = "<b>" & e.Row.Cells(0).Text.Replace(" ", "&nbsp;") & "</b>"
                e.Row.Cells(1).Text = "<div style=width:600px;'>" & e.Row.Cells(1).Text & "</div>"
            End If

            For i = 0 To e.Row.Cells.Count - 1
                Dim decodedText As String = HttpUtility.HtmlDecode(e.Row.Cells(i).Text)
                e.Row.Cells(i).Text = decodedText
            Next
        End If

    End Sub
End Class