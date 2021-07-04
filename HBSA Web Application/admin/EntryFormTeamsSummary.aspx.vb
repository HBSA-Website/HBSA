Imports HBSAcodeLibrary.EntryFormData

Public Class EntryFormTeamsSummary
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
            OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else

            If Not IsPostBack Then
                State_DropDownList_SelectedIndexChanged(sender, e)
            End If

        End If

    End Sub


    Protected Sub State_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles State_DropDownList.SelectedIndexChanged

        With EntryFormsTeams_GridView
            Dim EntryFormsFullReportTable As DataTable = TeamsSummaryReport(State_DropDownList.SelectedValue)
            Session("EntryFormsTeamsSummary") = EntryFormsFullReportTable
            .DataSource = EntryFormsFullReportTable
            .DataBind()
            Export_Button.Visible = EntryFormsFullReportTable.Rows.Count > 0
        End With

    End Sub

    Private Sub EntryFormsClubs_GridView_SelectedIndexChanging(sender As Object, e As GridViewSelectEventArgs) Handles EntryFormsTeams_GridView.SelectedIndexChanging

        'UpdateFeePaid(EntryFormsTeams_GridView.Rows(e.NewSelectedIndex).Cells(1).Text, Session("AdminUser"))

        With EntryFormsTeams_GridView

            Dim EntryFormsTeamsSummaryTable As DataTable = TeamsSummaryReport(State_DropDownList.SelectedValue)
            Session("EntryFormsTeamsSummary") = EntryFormsTeamsSummaryTable
            .DataSource = EntryFormsTeamsSummaryTable
            .DataBind()
            Export_Button.Visible = EntryFormsTeamsSummaryTable.Rows.Count > 0
        End With

    End Sub

End Class