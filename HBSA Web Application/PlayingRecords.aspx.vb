Public Class PlayingRecords
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            populateSections()

        End If

    End Sub

    Protected Sub PopulateSections()

        Records_GridView.Visible = False

        Using sectionsList As DataTable = HBSAcodeLibrary.LeagueData.GetSections(0)

            With Section_DropDownList
                .Items.Clear()
                .Visible = True

                If sectionsList.Rows.Count > 0 Then
                    .DataSource = sectionsList
                    .DataTextField = "Section Name"
                    .DataValueField = "ID"
                    .DataBind()
                    .Items.Insert(0, New ListItem("**All Leagues and Sections**", 0))
                    .Enabled = True
                    .SelectedIndex = 0
                Else
                    .Enabled = False
                End If

            End With

        End Using

        PopulateClubs()

    End Sub

    Protected Sub PopulateClubs()

        Records_GridView.Visible = False

        Using clubsList As DataTable = HBSAcodeLibrary.ClubData.GetClubs(Section_DropDownList.SelectedValue)

            With Clubs_DropDownList
                .Items.Clear()
                .Visible = True

                If clubsList.Rows.Count > 0 Then
                    .DataSource = clubsList
                    .DataTextField = "Club Name"
                    .DataValueField = "ID"
                    .DataBind()
                    .Items.Insert(0, New ListItem("**All Clubs**", 0))
                    .Enabled = True
                    .SelectedIndex = 0
                Else
                    .Enabled = False
                End If

            End With

        End Using

        PopulateTeams()

    End Sub

    Protected Sub PopulateTeams()

        Records_GridView.Visible = False

        Using dt As DataTable = HBSAcodeLibrary.TeamData.TeamLetters(Section_DropDownList.SelectedValue,
                                                                     Clubs_DropDownList.SelectedValue)

            With Team_DropDownList
                .Items.Clear()
                .Visible = True

                If dt.Rows.Count > 0 Then
                    .Items.Add(New ListItem("**All Teams**", ""))
                    .Enabled = True
                    .DataSource = dt
                    .DataTextField = "Team"
                    .DataValueField = "Team"
                    .DataBind()
                    .SelectedIndex = 0
                    .Enabled = True
                Else
                    .Enabled = False
                End If

            End With

        End Using

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        populateClubs()


    End Sub

    Protected Sub Clubs_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Clubs_DropDownList.SelectedIndexChanged

        populateTeams()

    End Sub

    Protected Sub Tagged_CheckBox_CheckedChanged(sender As Object, e As EventArgs) Handles Tagged_CheckBox.CheckedChanged, Over70_CheckBox.CheckedChanged, Details_CheckBox.CheckedChanged

        Records_GridView.Visible = False
        Export_Button.Visible = False

    End Sub


    Protected Sub Get_Button_Click(sender As Object, e As EventArgs) Handles Get_Button.Click

        Dim PlayingRecordsTable As DataTable
        If Details_CheckBox.Checked Then
            PlayingRecordsTable = HBSAcodeLibrary.PlayerData.GetPlayingRecordsDetail _
                                                      (Section_DropDownList.SelectedValue,
                                                       Clubs_DropDownList.SelectedValue,
                                                       Team_DropDownList.SelectedValue.Replace("  ", " "),
                                                       Player_TextBox.Text.Trim,
                                                       Tagged_CheckBox.Checked,
                                                       Over70_CheckBox.Checked, Nothing)
        Else
            PlayingRecordsTable = HBSAcodeLibrary.PlayerData.GetPlayingRecords _
                                                      (Section_DropDownList.SelectedValue,
                                                       Clubs_DropDownList.SelectedValue,
                                                       Team_DropDownList.SelectedValue.Replace("  ", " "),
                                                       Player_TextBox.Text.Trim,
                                                       Tagged_CheckBox.Checked,
                                                       Over70_CheckBox.Checked, False)
        End If

        With Records_GridView

                If PlayingRecordsTable.Rows.Count > 0 Then
                    .DataSource = PlayingRecordsTable
                    .DataBind()
                    .Visible = True
                    Status_Literal.Text = ""
                    Export_Button.Visible = True
                    Session("PlayingRecordsTable") = PlayingRecordsTable

                Else

                    Status_Literal.Text = "No data found for the selected criteria"
                    .Visible = False
                    Export_Button.Visible = False

                End If

            End With

        PlayingRecordsTable.Dispose()

    End Sub

    Private Sub Records_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Records_GridView.RowDataBound

        e.Row.Cells(e.Row.Cells.Count - 1).Visible = False

        If e.Row.RowType = DataControlRowType.DataRow Then

            For ix As Integer = 0 To e.Row.Cells.Count - 1
                Select Case ix
                    Case 0
                        e.Row.Cells(ix).HorizontalAlign = HorizontalAlign.Right
                    Case 1 To 3, 6, 7
                        e.Row.Cells(ix).HorizontalAlign = HorizontalAlign.Left
                    Case Else
                        e.Row.Cells(ix).HorizontalAlign = HorizontalAlign.Center

                End Select
            Next

        End If


    End Sub

    <System.Web.Script.Services.ScriptMethod>
    <System.Web.Services.WebMethod>
    Public Shared Function SuggestPlayers(ByVal prefixText As String, ByVal count As Integer, ByVal contextKey As String) As List(Of String)

        Dim params() As String = contextKey.Split("|")
        Dim Section As Integer = CInt(params(0))
        Dim LeagueID As Integer
        Dim SectionID As Integer

        If Section > 99 Then
            LeagueID = Section Mod 100
            SectionID = 0
        Else
            LeagueID = 0
            SectionID = Section
        End If

        Dim ClubID As Integer = CInt(params(1))

        Return HBSAcodeLibrary.PlayerData.GetSuggestedPlayers(prefixText, count, LeagueID, SectionID, ClubID)

    End Function

End Class