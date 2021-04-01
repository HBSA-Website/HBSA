Public Class LookForTooManyHomeFixtures
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                populateSections()
            End If
        End If

    End Sub

    Protected Sub PopulateSections()

        League_DropDownList.Items.Clear()

        Using leaguesList As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues

            With League_DropDownList
                .Items.Clear()
                .Visible = True

                .DataSource = leaguesList
                .DataTextField = "League Name"
                .DataValueField = "ID"
                .DataBind()

                .Items.Insert(0, New ListItem("**Select a league**", 0))

                .Enabled = True

            End With

        End Using

    End Sub

    Protected Sub League_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles League_DropDownList.SelectedIndexChanged

        If League_DropDownList.SelectedIndex > 0 Then

            Using HomeFixturesTable As DataTable = HBSAcodeLibrary.TeamData.LookForTooManyHomeFixtures(League_DropDownList.SelectedValue)

                With HomeFixtures_GridView

                    .DataSource = HomeFixturesTable
                    .DataBind()
                    .Visible = True

                End With

            End Using

        Else

            HomeFixtures_GridView.Visible = False

        End If


    End Sub


    Private Sub HomeFixtures_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles HomeFixtures_GridView.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            e.Row.Cells(1).HorizontalAlign = HorizontalAlign.Center
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Center
            e.Row.Cells(4).HorizontalAlign = HorizontalAlign.Center
            e.Row.Cells(6).HorizontalAlign = HorizontalAlign.Center

        End If
    End Sub
End Class