Imports HBSAcodeLibrary
Public Class ClubsPlayers
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            PopulateSections()
            PopulateClubs()

            AccessCode_Panel.Visible = Not Utilities.ViewContactDetailsAccessible()

        End If

    End Sub
    Protected Sub PopulateSections()

        ClubsAndPlayers_GridView.Visible = False
        Dim dt As DataTable = HBSAcodeLibrary.LeagueData.GetSections(0)

        With Section_DropDownList
            .Items.Clear()
            .Visible = True

            If dt.Rows.Count > 1 Then
                .Items.Add("**Select a division/section**")
            End If

            For Each row As DataRow In dt.Rows
                .Items.Add(New ListItem(row.Item("Section Name"), row.Item("ID")))
            Next

            dt = HBSAcodeLibrary.LeagueData.GetLeagues()
            dt.Rows.Clear()
            For Each row As DataRow In dt.Rows
                .Items.Add(New ListItem(row.Item("League Name") & " - All sections", row.Item("ID") + 100))
            Next

            .SelectedIndex = 0

        End With

        dt.Dispose()

    End Sub
    Protected Sub PopulateClubs()

        Teams_GridView.Visible = False
        Players_GridView.Visible = False

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
    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        ClubsAndPlayers_GridView.Visible = False
        Teams_GridView.Visible = False
        Players_GridView.Visible = False

        Club_DropDownList.SelectedIndex = 0

        If Not Section_DropDownList.SelectedValue.StartsWith("**") Then

            Dim TeamsAndPlayers As DataTable = SectionData.SectionList(Section_DropDownList.SelectedValue)

            With ClubsAndPlayers_GridView
                .DataSource = TeamsAndPlayers
                .DataBind()
                .Visible = True
            End With

        End If

    End Sub
    Protected Sub Club_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Club_DropDownList.SelectedIndexChanged

        ClubsAndPlayers_GridView.Visible = False
        Teams_GridView.Visible = False
        Players_GridView.Visible = False
        Section_DropDownList.SelectedIndex = 0

        If Not Club_DropDownList.SelectedValue.StartsWith("**") Then

            Dim ClubDetails As DataSet = HBSAcodeLibrary.ClubData.ClubDetails(Club_DropDownList.SelectedValue)

            With ClubsAndPlayers_GridView
                .DataSource = ClubDetails.Tables(0)
                .DataBind()
                .Visible = True
            End With

            With Teams_GridView
                .DataSource = ClubDetails.Tables(1)
                .DataBind()
                .Visible = True
            End With

            With Players_GridView
                .DataSource = ClubDetails.Tables(2)
                .DataBind()
                .Visible = True
            End With

        End If

    End Sub
    Private Sub ClubsAndPlayers_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles ClubsAndPlayers_GridView.RowDataBound

        If Section_DropDownList.SelectedIndex > 0 Then
            e.Row.Cells(0).Visible = False
        End If

    End Sub
    Private Sub Players_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Players_GridView.RowDataBound

        If Not Utilities.ViewContactDetailsAccessible Then
            e.Row.Cells(e.Row.Cells.Count - 1).Visible = False
            e.Row.Cells(e.Row.Cells.Count - 2).Visible = False
        End If

    End Sub
    <System.Web.Script.Services.ScriptMethod>
    <System.Web.Services.WebMethod>
    Public Shared Function SuggestPlayers(ByVal prefixText As String, ByVal count As Integer) As List(Of String)

        Return HBSAcodeLibrary.PlayerData.GetSuggestedPlayers(prefixText, count, 0, 0, 0)

    End Function

    Protected Sub GetByName_Button_Click(sender As Object, e As EventArgs) Handles GetByName_Button.Click

        ClubsAndPlayers_GridView.Visible = False
        Teams_GridView.Visible = False

        Using players As DataTable = HBSAcodeLibrary.PlayerData.GetPlayerDetailsByPlayer(,, Player_TextBox.Text, True)

            With Players_GridView
                .DataSource = players
                .DataBind()
                .Visible = True

                For RowIx = 0 To .Rows.Count - 1
                    Dim PlayerRow As GridViewRow = .Rows(RowIx)
                    For ColIx = 0 To players.Columns.Count - 1
                        If players.Columns(ColIx).ColumnName.Length > PlayerRow.Cells(ColIx).Text.Length Then
                            PlayerRow.Cells(ColIx).HorizontalAlign = HorizontalAlign.Center
                        End If
                    Next
                Next

            End With

        End Using

    End Sub
    Protected Sub AccessCode_Button_Click(sender As Object, e As EventArgs) Handles AccessCode_Button.Click

        AccessCode_Literal.Text = ""
        Using cfg As New HBSA_Configuration

            If AccessCode_TextBox.Text.Trim.ToLower = cfg.Value("ViewPlayerDetailsAccessCode").ToLower Then
                Session("ViewContactDetails") = "Accessible"
                AccessCode_Panel.Visible = False
            Else
                AccessCode_Literal.Text = "<span style='color:red'>Incorrect access code.</span>"
            End If

        End Using

    End Sub

    Protected Sub CancelAccessCode_Button_Click(sender As Object, e As EventArgs) Handles CancelAccessCode_Button.Click
        AccessCode_Panel.Visible = False
    End Sub
End Class