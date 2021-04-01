Public Class TeamRecords
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            populateSections()

        End If

    End Sub

    Protected Sub PopulateSections()

        Results_GridView.Visible = False
        Download_Button.Visible = False
        Points_Table.Visible = False

        Using sectionsList As DataTable = HBSAcodeLibrary.LeagueData.GetSections(0)

            With Section_DropDownList
                .Items.Clear()
                .Visible = True
                .DataSource = sectionsList
                .DataTextField = "Section Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select a division/section**", 0))
                .SelectedIndex = 0

                If sectionsList.Rows.Count < 2 Then
                    .Enabled = False
                    .SelectedIndex = 1
                    Section_DropDownList_SelectedIndexChanged(New Object, New Object)
                Else
                    .Enabled = True
                End If


            End With

        End Using

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        Results_GridView.Visible = False
        Download_Button.Visible = False
        Points_Table.Visible = False

        If Section_DropDownList.SelectedValue.StartsWith("**") Then
            Team_DropDownList.Items.Clear()

        Else

            Using resultsList As DataSet = HBSAcodeLibrary.MatchResult.ListResults(Section_DropDownList.SelectedValue)

                With Team_DropDownList
                    .Items.Clear()
                    .Items.Add(New ListItem("** Select a team **", 0))
                    For Each row As DataRow In resultsList.Tables(2).Rows
                        .Items.Add(New ListItem(row!Team, row!TeamID))
                    Next
                End With

            End Using

        End If

    End Sub

    Protected Sub Team_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Team_DropDownList.SelectedIndexChanged

        If Team_DropDownList.SelectedValue = 0 Then

            Results_GridView.Visible = False
            Points_Table.Visible = False
            Download_Button.Visible = False
            Session("TeamResultsData") = Nothing

        Else

            Using teamRecord As DataSet = HBSAcodeLibrary.MatchResult.TeamResultsSheet(Team_DropDownList.SelectedValue)

                With teamRecord.Tables(0).Rows(0)
                    Played_Literal.Text = !Played
                    Won_Literal.Text = !Won
                    Drawn_Literal.Text = !Drawn
                    Lost_Literal.Text = !Lost
                    Points_Literal.Text = !Points
                End With

                Results_GridView.DataSource = teamRecord.Tables(1)
                Results_GridView.DataBind()
                Results_GridView.Visible = True

                Points_Table.Visible = True
                Download_Button.Visible = (teamRecord.Tables(0).Rows.Count > 0)
                Session("TeamResultsData") = teamRecord.Tables(2)

            End Using

        End If

    End Sub

    Private Sub Results_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Results_GridView.RowDataBound

        With e.Row
            If .RowType = DataControlRowType.DataRow Then
                .Cells(3).Text = .Cells(3).Text.Replace(" ", "&nbsp;")
                .Cells(0).HorizontalAlign = HorizontalAlign.Left
                .Cells(1).HorizontalAlign = HorizontalAlign.Left
                .Cells(3).HorizontalAlign = HorizontalAlign.Left

                For ix As Integer = 4 To .Cells.Count - 1
                    .Cells(ix).HorizontalAlign = HorizontalAlign.Center
                Next
            End If
        End With

    End Sub

End Class