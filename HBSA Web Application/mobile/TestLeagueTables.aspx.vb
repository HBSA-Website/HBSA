Public Class TestLeagueTables
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            PopulateSections()

        End If

    End Sub

    Protected Sub PopulateSections()

        LeagueTable_GridView.Visible = False

        With Section_DropDownList

            Using dt As DataTable = HBSAcodeLibrary.LeagueData.GetSections(0)

                .Items.Clear()
                .Visible = True

                If dt.Rows.Count > 1 Then
                    .Items.Add("**Select a division/section**")
                End If

                For Each row As DataRow In dt.Rows
                    .Items.Add(New ListItem(row.Item("Section Name"), row.Item("ID")))
                Next

                If dt.Rows.Count < 2 Then
                    .Enabled = False
                    Section_DropDownList_SelectedIndexChanged(New Object, New Object)
                Else
                    .Enabled = True
                End If

                .SelectedIndex = 0
            End Using

            Using dt As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues()
                For Each row As DataRow In dt.Rows
                    .Items.Add(New ListItem(row.Item("League Name") & " - All sections", row.Item("ID") + 100))
                Next

            End Using

        End With

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        LeagueTable_GridView.Visible = False

        If Section_DropDownList.SelectedValue.StartsWith("**") Then

        Else

            Using FixtureList As DataTable = HBSAcodeLibrary.LeagueData.LeagueTable(Section_DropDownList.SelectedValue)

                LeagueTable_GridView.DataSource = FixtureList
                LeagueTable_GridView.DataBind()
                LeagueTable_GridView.Visible = True

                Session("LeagueTable") = HBSAcodeLibrary.Utilities.SerialiseDataTable(FixtureList)

            End Using

        End If

    End Sub

    Protected Sub Fixtures_GridView_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles LeagueTable_GridView.RowDataBound

        e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
        e.Row.Cells(0).Wrap = False
        e.Row.Cells(e.Row.Cells.Count - 1).Wrap = True
        e.Row.Cells(e.Row.Cells.Count - 1).Visible = False 'hide points comments

        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.Cells(e.Row.Cells.Count - 1).Text.Trim <> "&nbsp;" AndAlso
               e.Row.Cells(e.Row.Cells.Count - 1).Text.Trim <> "" Then
                e.Row.Cells(e.Row.Cells.Count - 1).HorizontalAlign = HorizontalAlign.Left
                e.Row.Cells(e.Row.Cells.Count - 1).Text = e.Row.Cells(e.Row.Cells.Count - 1).Text.Replace("&lt;", "<").Replace("&gt;", ">")

                e.Row.ForeColor = Drawing.Color.Red

                e.Row.Attributes.Add("onmouseover", "this.style.cursor='pointer'")
                e.Row.Attributes.Add("onclick", "PointsDetailDiv('" & e.Row.Cells(0).Text & "<br/>" &
                                                e.Row.Cells(e.Row.Cells.Count - 1).Text.Replace(".0", "") & "')")
            End If

            If e.Row.Cells(1).Text = "&nbsp;" Then  'section header
                e.Row.Cells(0).Font.Bold = True
            End If

            e.Row.Cells(5).Text = e.Row.Cells(5).Text.Replace(".0", "")

            For CellIx = 1 To e.Row.Cells.Count - 2
                e.Row.Cells(CellIx).HorizontalAlign = HorizontalAlign.Center
            Next
        End If

    End Sub

End Class