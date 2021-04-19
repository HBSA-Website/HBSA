Public Class Handicaps1
    Inherits System.Web.UI.Page
    Friend Enum SearchType
        ByClub
        ByName
    End Enum

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            ' Player_TextBox.Attributes.Add("onkeyup", "SetContextKey()")
            PopulateSections()
        End If
    End Sub

    Protected Sub PopulateSections()

        Section_DropDownList.Items.Clear()

        Dim leaguesSections As DataTable = HBSAcodeLibrary.SectionData.GetSections()

        With Section_DropDownList
            .Items.Clear()
            .Visible = True

            If leaguesSections.Rows.Count > 1 Then
                .Items.Add(New ListItem("**All leagues**", 0))
            End If

            For Each row As DataRow In leaguesSections.Rows
                .Items.Add(New ListItem(row.Item("League") & " " & row.Item("Section Name"), row.Item("ID")))
            Next

            leaguesSections = HBSAcodeLibrary.LeagueData.GetLeagues()

            For Each row As DataRow In leaguesSections.Rows
                .Items.Add(New ListItem(row.Item("League Name") & " - All sections", row.Item("ID") + 100))
            Next

            .SelectedIndex = 0

            If leaguesSections.Rows.Count < 2 Then
                .Enabled = False
                Section_DropDownList_SelectedIndexChanged(New Object, New System.EventArgs)
            Else
                .Enabled = True
            End If

        End With

        leaguesSections.Dispose()

        PopulateClubs(Section_DropDownList.SelectedValue)

    End Sub

    Protected Sub PopulateClubs(SectionID As Integer)

        Using clubsList As DataTable = HBSAcodeLibrary.ClubData.GetAllClubs()

            With Club_DropDownList

                Dim firstItemText As String = "**All Clubs**"

                Dim SelectedItemText As String = firstItemText
                If .Items.Count > 0 Then
                    SelectedItemText = .SelectedItem.Text
                End If

                .Items.Clear()
                .Visible = True

                If clubsList.Rows.Count > 1 Then
                    .Items.Add(New ListItem(firstItemText, 0))
                End If

                For Each row As DataRow In clubsList.Rows
                    .Items.Add(New ListItem(row.Item("Club Name"), row.Item("ID")))
                Next

                .Enabled = (clubsList.Rows.Count > 1)

                For ix As Integer = 0 To .Items.Count - 1
                    If .Items(ix).Text = SelectedItemText Then
                        .SelectedIndex = ix
                        Exit For
                    End If
                Next

            End With

        End Using

    End Sub
    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) _
            Handles Section_DropDownList.SelectedIndexChanged

        PopulateClubs(Section_DropDownList.SelectedValue)

    End Sub

    Sub FillGrid(sType As Integer)

        Using handiCaps As DataTable = HBSAcodeLibrary.PlayerData.HandicapsReportForMobile(
                                                    Section_DropDownList.SelectedValue,
                                                    Club_DropDownList.SelectedValue,
                                                    sType = SearchType.ByName, Player_TextBox.Text.Trim,
                                                    ChangesOnly_CheckBox.Checked)
            Handicaps_Div.InnerHtml = HBSAcodeLibrary.Utilities.BuildMobileActiveTable(handiCaps, 1,, "ActiveDetailDiv", "Handicap")
        End Using

    End Sub
    Protected Sub GetByClub_Button_Click(sender As Object, e As EventArgs) Handles GetByClub_Button.Click

        FillGrid(SearchType.ByClub)

    End Sub

    Protected Sub GetByName_Button_Click(sender As Object, e As EventArgs) Handles GetByName_Button.Click

        FillGrid(SearchType.ByName)

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