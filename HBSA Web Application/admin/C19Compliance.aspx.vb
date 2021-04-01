Public Class C19Compliance
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                PopulateClubs()
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
        Handles Club_DropDownList.SelectedIndexChanged

        Err_Literal.Text = ""

        If Err_Literal.Text = "" Then

            With C19ComplianceReport_GridView

                .DataSource = HBSAcodeLibrary.Covid19Compliance.Covid19Compliance_Report(Club_DropDownList.SelectedValue)
                .DataBind()

            End With

        Else

            Err_Literal.Text = "ERROR: " & Err_Literal.Text.Substring(0, Err_Literal.Text.Length - 5)

        End If

    End Sub
    Private Sub C19ComplianceReport_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles C19ComplianceReport_GridView.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            e.Row.Cells(1).HorizontalAlign = HorizontalAlign.Center
            e.Row.Cells(1).Text = If(e.Row.Cells(1).Text = "True", "Confirmed", "NOT confirmed")
            e.Row.Cells(2).HorizontalAlign = HorizontalAlign.Center
            e.Row.Cells(2).Text = If(e.Row.Cells(2).Text = "True", "Confirmed", "NOT confirmed")
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Center
            e.Row.Cells(3).Text = If(e.Row.Cells(3).Text = "True", "Confirmed", "NOT confirmed")
            e.Row.Cells(5).HorizontalAlign = HorizontalAlign.Center
            e.Row.Cells(5).Text = If(e.Row.Cells(5).Text = "True", "Not Concerned", "CONCERNED")
            e.Row.Cells(4).Text = e.Row.Cells(4).Text.Replace(vbCrLf, "<br/>")
            e.Row.Cells(6).Text = e.Row.Cells(6).Text.Replace(vbCrLf, "<br/>")
            e.Row.Cells(7).Text = e.Row.Cells(7).Text.Replace(vbCrLf, "<br/>")
            e.Row.Cells(8).Text = Format(Convert.ToDateTime(e.Row.Cells(8).Text), "dd MMM yyyy hh:mm tt")

        End If

    End Sub

    'Private Sub C19ComplianceReport_GridView_DataBound(sender As Object, e As EventArgs) Handles C19ComplianceReport_GridView.DataBound

    '    If C19ComplianceReport_GridView.Columns.Count > 7 Then
    '        C19ComplianceReport_GridView.Columns(6).ItemStyle.Width = Unit.Pixel(600)
    '        C19ComplianceReport_GridView.Columns(7).ItemStyle.Width = Unit.Pixel(600)
    '        C19ComplianceReport_GridView.Columns(8).ItemStyle.Width = 600
    '    End If

    'End Sub
End Class