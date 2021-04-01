Imports HBSAcodeLibrary
Public Class ClubsPlayers1
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            'PopulateSections()
            PopulateClubs()

        End If

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
                Players_Div.InnerHtml = Utilities.BuildMobileActiveTable(ClubDetails.Tables(2), 1, 5, "ActiveDetailDiv", "Player")
            End Using

            Team_Literal.Text = "<span style = 'color: maroon;' > Touch / click a team for more detail</span>"
            Player_Literal.Text = "<span style = 'color: maroon;' > Touch / click a player for more detail</span>"

        End If

    End Sub

End Class