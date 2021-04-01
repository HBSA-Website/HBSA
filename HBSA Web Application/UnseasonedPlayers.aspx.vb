Imports HBSAcodeLibrary

Public Class UnseasonedPlayers
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            populateSections()
        End If


    End Sub

    Protected Sub PopulateSections()

        With Section_DropDownList
            .Items.Clear()
            .Items.Add(New ListItem("**Select a division/section or League**", -9))
            .Items.Add(New ListItem("** All **", 0))

            For Each Section As DataRow In SectionData.GetSections.Rows
                .Items.Add(New ListItem(Section.Item("League") & " " & Section.Item("Section name"), Section.Item("ID")))
            Next

            For Each League As DataRow In HBSAcodeLibrary.LeagueData.AllLeagues.Rows
                .Items.Add(New ListItem(League.Item("League name"), League.Item("ID") + 100))
            Next

            .SelectedIndex = 0

        End With

    End Sub

    Protected Sub PopulateClubs()

        With Club_DropDownList
            .Items.Clear()
            .Items.Add(New ListItem("** All **", 0))

            For Each Section As DataRow In HBSAcodeLibrary.ClubData.GetClubs(Section_DropDownList.SelectedValue).Rows
                .Items.Add(New ListItem(Section.Item("Club name"), Section.Item("ID")))
            Next

            .SelectedIndex = 0

        End With

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Section_DropDownList.SelectedIndexChanged
        populateClubs()
    End Sub

    Protected Sub GetReport_Button_Click(sender As Object, e As EventArgs) Handles GetReport_Button.Click, GetByName_Button.Click

        If Section_DropDownList.SelectedIndex < 1 Then
            Section_DropDownList.SelectedValue = 0
            Section_DropDownList_SelectedIndexChanged(sender, e)
            Section_DropDownList.SelectedValue = 0
        End If

        Dim UnseasonedPlayersTable As DataTable =
            HBSAcodeLibrary.PlayerData.TaggedPlayersReport _
                (If(Section_DropDownList.SelectedValue > 99, Section_DropDownList.SelectedValue Mod 100, 0),
                 If(Section_DropDownList.SelectedValue > 99, 0, Section_DropDownList.SelectedValue Mod 100),
                 Club_DropDownList.SelectedValue,
                 ActionNeeded_CheckBox.Checked,
                 Player_TextBox.Text)

        With UnseasonedPlayers_GridView

            .DataSource = UnseasonedPlayersTable
            .DataBind()

        End With

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
            SectionID = If(Section < 0, 0, Section)
        End If

        Dim ClubID As Integer
        Try
            ClubID = If(CInt(params(1)) < 0, 0, CInt(params(1)))
        Catch ex As Exception
            ClubID = 0
        End Try


        Return HBSAcodeLibrary.PlayerData.GetSuggestedPlayers(prefixText, count, LeagueID, SectionID, ClubID)

    End Function


End Class