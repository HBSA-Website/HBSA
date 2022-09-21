Public Class PlayingRecords1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            PopulateSections()

        End If

    End Sub
    Protected Sub PopulateSections()

        PlayingRecords_Div.InnerHtml = ""

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

        PlayingRecords_Div.InnerHtml = ""

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

        PlayingRecords_Div.InnerHtml = ""

        Using dt As DataTable = HBSAcodeLibrary.TeamData.TeamLetters(Section_DropDownList.SelectedValue,
                                                                     Clubs_DropDownList.SelectedValue)

            With Team_DropDownList
                .Items.Clear()

                If dt.Rows.Count > 0 Then
                    .Items.Add(New ListItem("**All Teams**", ""))
                    .Enabled = True
                    .DataSource = dt
                    .DataTextField = "Team"
                    .DataValueField = "Team"
                    .DataBind()
                    .SelectedIndex = 0
                End If

                .Visible = dt.Rows.Count > 1
                Team_Literal.Visible = .Visible

            End With

        End Using

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        PopulateClubs()

    End Sub

    Protected Sub Clubs_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Clubs_DropDownList.SelectedIndexChanged

        PopulateTeams()

    End Sub
    Protected Sub Get_Button_Click(sender As Object, e As EventArgs) Handles Get_Button.Click

        Using PlayingRecordsTable As DataTable = HBSAcodeLibrary.PlayerData.GetPlayingRecords _
                                                      (Section_DropDownList.SelectedValue,
                                                       Clubs_DropDownList.SelectedValue,
                                                       Team_DropDownList.SelectedValue.Replace("  ", " "),
                                                       Player_TextBox.Text.Trim,
                                                       Tagged_CheckBox.Checked,
                                                       Over70_CheckBox.Checked, True)
            PlayingRecords_Div.InnerHtml = HBSAcodeLibrary.Utilities.BuildMobileActiveTable(PlayingRecordsTable, 2,, "ActiveDetailDiv", "PlayingRecord")

        End Using

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