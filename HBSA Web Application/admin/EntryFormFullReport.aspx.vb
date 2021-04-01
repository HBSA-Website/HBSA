Imports HBSAcodeLibrary.EntryFormData
Public Class EntryFormFullReport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
            OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else

            If Not IsPostBack Then
                populateClubs()
            End If

        End If

    End Sub

    Protected Sub PopulateClubs()


        Using clubsList As DataTable = GetClubs()

            With Club_DropDownList

                .Items.Clear()
                .Visible = True
                .DataSource = clubsList
                .DataTextField = "Club Name"
                .DataValueField = "ClubID"
                .DataBind()

                .Items.Insert(0, New ListItem("** Choose a report **", 0))
                .Items.Insert(1, New ListItem("** All Clubs **", "WIP0"))
                .Items.Insert(2, New ListItem("** Clubs who have at least started entering data **", "WIP1"))
                .Items.Insert(3, New ListItem("** Clubs that have submitted their entry form **", "WIP2"))
                .Items.Insert(4, New ListItem("** Clubs that have started, but not submitted, their entry form **", "WIP-2"))
                .Items.Insert(5, New ListItem("** Entry forms that are fixed **", "WIP3"))
                .Items.Insert(6, New ListItem("** Clubs that have not completed Entry forms **", "WIP-1"))

                .Enabled = True
                .SelectedIndex = 0

            End With

        End Using

    End Sub
    Protected Sub Club_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Club_DropDownList.SelectedIndexChanged

        With EntryFormsReport_GridView

            If Club_DropDownList.SelectedIndex > 0 Then
                Dim EntryFormsTeamsSummaryTable As DataTable

                If Club_DropDownList.SelectedValue.StartsWith("WIP") Then
                    EntryFormsTeamsSummaryTable = FullReport("byWIP", CInt(Club_DropDownList.SelectedValue.Substring(3)))
                Else
                    EntryFormsTeamsSummaryTable = FullReport("byClub", Club_DropDownList.SelectedValue)
                End If

                .DataSource = EntryFormsTeamsSummaryTable
                .DataBind()
                Export_Button.Visible = EntryFormsTeamsSummaryTable.Rows.Count > 0
                .Visible = True
                EntryFormsTeamsSummaryTable.Dispose()
            Else
                .Visible = False
            End If

        End With

    End Sub

    Private Sub EntryFormsReport_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles EntryFormsReport_GridView.RowDataBound

        With e.Row

            If e.Row.RowType = DataControlRowType.DataRow Then
                For Each cell In e.Row.Cells
                    cell.Text = Server.HtmlDecode(cell.Text)
                Next
            End If

            .Cells(0).Font.Bold = True

            Dim col1 As String = .Cells(0).Text
            Select Case col1
                Case "League"
                    .Font.Bold = True
                Case "Club Name", "Address 1", "Address 2", "Post Code"
                    .Cells(2).Font.Bold = True
                Case Else
            End Select


        End With
    End Sub
End Class