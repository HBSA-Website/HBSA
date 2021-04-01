Public Class LastSixMatches
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            populateLeagues()
        End If

    End Sub

    Sub PopulateLeagues()

        Dim Leagues As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues

        With League_DropDownList

            .Items.Clear()
            .DataSource = Leagues
            .DataTextField = "League Name"
            .DataValueField = "ID"
            .DataBind()
            .Items.Insert(0, New ListItem("**Select a League**", "0"))

        End With
    End Sub

    Protected Sub League_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles League_DropDownList.SelectedIndexChanged

        Report_Button_Cell.Visible = League_DropDownList.SelectedIndex > 0

        PopulateSections()
        Download_Cell.Visible = False
        With Last6Matches_GridView
            .Visible = False
            .DataSource = Nothing
            .DataBind()
        End With

    End Sub
    Sub PopulateSections()


        With Section_DropDownList

            .Items.Clear()

            If League_DropDownList.SelectedIndex < 1 Then

                .Visible = False

            Else

                Dim Sections As DataTable = HBSAcodeLibrary.LeagueData.GetSections(League_DropDownList.SelectedValue)

                If Sections.Rows.Count < 2 Then
                    .Visible = False
                Else
                    .DataSource = Sections
                    .DataTextField = "Section Name"
                    .DataValueField = "ID"
                    .DataBind()
                    .Visible = True
                End If
            End If

            .Items.Insert(0, New ListItem("**Full League**", "0"))
            .SelectedIndex = 0

        End With
    End Sub

    Private Sub Report_Button_Click(sender As Object, e As EventArgs) Handles Report_Button.Click

        With Last6Matches_GridView

            Dim Last6Matches As DataTable = HBSAcodeLibrary.LeagueData.GetLast6Matches(League_DropDownList.SelectedValue, Section_DropDownList.SelectedValue)
            .DataSource = Last6Matches
            .DataBind()

            Download_Cell.Visible = Last6Matches.Rows.Count > 0
            .Visible = Download_Cell.Visible

            Session("Last6Matches") = Last6Matches

        End With

    End Sub

    Private Sub Last6Matches_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Last6Matches_GridView.RowDataBound

        For ix = 1 To e.Row.Cells.Count - 1
            e.Row.Cells(ix).HorizontalAlign = HorizontalAlign.Center
        Next

    End Sub
End Class