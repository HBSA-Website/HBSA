Imports HBSAcodeLibrary
Public Class ClubsPlayers1
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            'PopulateSections()
            PopulateClubs()

        Else

            Session("ViewContactDetails") = ViewContactDetailsHidden.Value

        End If

        AccessCode_Panel.Visible = Not Utilities.ViewContactDetailsAccessible()

    End Sub
    Protected Sub PopulateClubs()

        Teams_Div.InnerHtml = ""
        Players_Div.InnerHtml = ""

        Using clubs As DataTable = HBSAcodeLibrary.ClubData.GetClubs(0)

            With Club_DropDownList
                .Items.Clear()
                .Visible = True

                If clubs.Rows.Count > 1 Then
                    .Items.Add("**Select a Club**")
                End If

                For Each row As DataRow In clubs.Rows
                    .Items.Add(New ListItem(row.Item("Club Name"), row.Item("ID")))
                Next

                .Enabled = True

                .SelectedIndex = 0

            End With

        End Using

    End Sub
    Protected Sub Club_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Club_DropDownList.SelectedIndexChanged

        ClubsAndPlayers_Div.InnerHtml = ""
        Teams_Div.InnerHtml = ""
        Players_Div.InnerHtml = ""
        Team_Literal.Text = ""
        Player_Literal.Text = ""

        If Not Club_DropDownList.SelectedValue.StartsWith("**") Then

            Using ClubDetails As DataSet = HBSAcodeLibrary.ClubData.ClubDetails(Club_DropDownList.SelectedValue, True)
                ClubsAndPlayers_Div.InnerHtml = Utilities.BuildMobileActiveTable(ClubDetails.Tables(0))
                Teams_Div.InnerHtml = Utilities.BuildMobileActiveTable(ClubDetails.Tables(1), 1, 4, "ActiveDetailDiv", "Team")
                Players_Div.InnerHtml = Utilities.BuildMobileActiveTable(ClubDetails.Tables(2), 1, 5, "ActiveDetailDiv",
                                         If(Utilities.ViewContactDetailsAccessible, "Player|Accessible", "Player|NotAccessible"))
            End Using

            Team_Literal.Text = "<span style = 'color: maroon;' > Touch / click a team for more detail</span>"
            Player_Literal.Text = "<span style = 'color: maroon;' > Touch / click a player for more detail</span>"

        End If

    End Sub
    <System.Web.Script.Services.ScriptMethod>
    <System.Web.Services.WebMethod>
    Public Shared Function SuggestPlayers(ByVal prefixText As String, ByVal count As Integer) As List(Of String)

        Return HBSAcodeLibrary.PlayerData.GetSuggestedPlayers(prefixText, count, 0, 0, 0)

    End Function

    Protected Sub GetByName_Button_Click(sender As Object, e As EventArgs) Handles GetByName_Button.Click

        ClubsAndPlayers_Div.InnerHtml = ""
        Teams_Div.InnerHtml = ""
        Players_Div.InnerHtml = ""
        Team_Literal.Text = ""
        Player_Literal.Text = ""

        Using players As DataTable = HBSAcodeLibrary.PlayerData.GetPlayerDetailsByPlayer(,, Player_TextBox.Text, , True)
            Players_Div.InnerHtml = Utilities.BuildMobileActiveTable(players, 1, , "ActiveDetailDiv",
                                         If(Utilities.ViewContactDetailsAccessible, "Player|Accessible", "Player|NotAccessible"))
        End Using

    End Sub

    'Protected Sub AccessCode_Button_Click(sender As Object, e As EventArgs) Handles AccessCode_Button.Click

    '    Using cfg As New HBSA_Configuration

    '        If AccessCode_TextBox.Text.Trim.ToLower = cfg.Value("ViewPlayerDetailsAccessCode").ToLower Then
    '            Session("ViewContactDetails") = "Accessible"
    '            AccessCode_Panel.Visible = False
    '            Using players As DataTable = HBSAcodeLibrary.PlayerData.GetPlayerDetailsByPlayer(,, Player_TextBox.Text, , True)
    '                Players_Div.InnerHtml = Utilities.BuildMobileActiveTable(players, 1, , "ActiveDetailDiv",
    '                                             If(Utilities.ViewContactDetailsAccessible, "Player|Accessible", "Player|NotAccessible"))
    '            End Using
    '        Else
    '            AccessCode_Literal.Text = "<span style='color:red'>Incorrect access code.</span>"
    '        End If

    '    End Using

    'End Sub

    Protected Sub CancelAccessCode_Button_Click(sender As Object, e As EventArgs) Handles CancelAccessCode_Button.Click

        AccessCode_Panel.Visible = False

    End Sub
End Class