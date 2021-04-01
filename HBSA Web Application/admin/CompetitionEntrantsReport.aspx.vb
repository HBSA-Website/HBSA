Public Class CompetitionEntrantsReport
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

        Using dt As DataTable = HBSAcodeLibrary.CompetitionData.GetCompetitions()

            With Competitions_DropDownList
                .Items.Clear()
                .Visible = True

                .Items.Add(New ListItem("**Select a Competition**", 0))

                For Each row As DataRow In dt.Rows
                    .Items.Add(New ListItem(row.Item("Name"), row.Item("ID")))
                Next

            End With

        End Using

    End Sub

    Protected Sub Competitions_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Competitions_DropDownList.SelectedIndexChanged

        Using entrantsReport As DataTable = HBSAcodeLibrary.CompetitionData.EntrantsReport(Competitions_DropDownList.SelectedValue)

            Export_Button.Visible = (entrantsReport.Rows.Count > 0)
            Session("CompEntrantsReport") = entrantsReport

            With Entrants_GridView
                .DataSource = entrantsReport
                .DataBind()
            End With

        End Using

    End Sub

    Private Sub Entrants_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Entrants_GridView.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Cells(0).Visible = False
        End If

    End Sub
End Class