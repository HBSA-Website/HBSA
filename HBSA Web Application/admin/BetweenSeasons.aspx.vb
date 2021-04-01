Public Class BetweenSeasons
    Inherits System.Web.UI.Page

    Private Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
           OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminHome.aspx")

        End If

        Handicaps_Button.Enabled = HBSAcodeLibrary.HBSA_Configuration.CloseSeason
        ConfirmApply_Button.Enabled = Handicaps_Button.Enabled
        Start_Season_Button.Enabled = Handicaps_Button.Enabled
        EntryForms_Button.Enabled = Handicaps_Button.Enabled
        Player_Tags_Button.Enabled = Handicaps_Button.Enabled
        SetupEntryForms_Button.Enabled = Handicaps_Button.Enabled

    End Sub

    Sub EnablePanel(Panel As Panel)

        Introduction_Panel.Enabled = Panel.ID.ToLower Like "*introduction*"

        Season_Panel.Visible = False
        Handicaps_Panel.Visible = False
        Confirm_Panel.Visible = False

        Panel.Visible = True

    End Sub

    Protected Sub CloseSeason_Button_Click(sender As Object, e As EventArgs) Handles CloseSeason_Button.Click


        Season_Literal.Text = "You have opted to close the season.<br />" &
                                 "Click Confirm to close the season, otherwise Click Cancel."

        EnablePanel(Season_Panel)

    End Sub

    Protected Sub Confirm_Button_Click(sender As Object, e As EventArgs) Handles Confirm_Button.Click

        Try
            If Season_Literal.Text.ToLower Like "*close*" Then
                HBSAcodeLibrary.FixturesData.EndTheSeason()
            Else
                HBSAcodeLibrary.FixturesData.StartTheSeason()
            End If

            Handicaps_Panel.Visible = False
            Introduction_Panel.Enabled = True
            Season_Panel.Visible = False
            Handicaps_Button.Enabled = HBSAcodeLibrary.HBSA_Configuration.CloseSeason
            ConfirmApply_Button.Enabled = Handicaps_Button.Enabled
            Start_Season_Button.Enabled = ConfirmApply_Button.Enabled
            EntryForms_Button.Enabled = ConfirmApply_Button.Enabled

            Err_Literal.Text = If(Season_Literal.Text.ToLower Like "*close*", "End", "Start") & " the season succeeded.  Please continue"

        Catch ex As Exception
            Err_Literal.Text = "ERROR with " & If(Season_Literal.Text.ToLower Like "*close*", "End", "Start") & " the season.  Please contact support and supply the following:<br/><br/>" & ex.Message
        End Try

        EnablePanel(Introduction_Panel)

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        EnablePanel(Introduction_Panel)

    End Sub

    Protected Sub Start_Season_Button_Click(sender As Object, e As EventArgs) Handles Start_Season_Button.Click

        Season_Literal.Text = "You have opted to start a new season.<br />" &
                       "Click Confirm to start the season, otherwise Click Cancel."

        EnablePanel(Season_Panel)

    End Sub


    Protected Sub Handicaps_Button_Click(sender As Object, e As EventArgs) Handles Handicaps_Button.Click

        EnablePanel(Handicaps_Panel)

        populateSections()


    End Sub

    Protected Sub PopulateSections()

        Dim dt As DataTable = HBSAcodeLibrary.LeagueData.GetSections(0)

        With Section_DropDownList
            .Items.Clear()
            .Visible = True

            If dt.Rows.Count > 1 Then
                .Items.Add(New ListItem("**All leagues**", 0))
            End If

            For Each row As DataRow In dt.Rows
                .Items.Add(New ListItem(row.Item("Section Name"), row.Item("ID")))
            Next

            dt = HBSAcodeLibrary.LeagueData.GetLeagues()

            For Each row As DataRow In dt.Rows
                .Items.Add(New ListItem(row.Item("League Name") & " - All sections", row.Item("ID") + 100))
            Next

            .SelectedIndex = 0

            If dt.Rows.Count < 2 Then
                .Enabled = False
            Else
                .Enabled = True
            End If

            PopulateGridView()

        End With

        dt.Dispose()


    End Sub

    Sub PopulateGridView()


        Using dt As DataTable = HBSAcodeLibrary.PlayerData.HandicapsReport(Section_DropDownList.SelectedValue)

            With Teams_GridView
                .DataSource = dt
                .DataBind()
            End With

        End Using

    End Sub

    Protected Sub Teams_GridView_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Teams_GridView.SelectedIndexChanged

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        populateGridView()

    End Sub

    Protected Sub Close_Button_Click(sender As Object, e As EventArgs) Handles Close_Button.Click

        EnablePanel(Introduction_Panel)

    End Sub

    Protected Sub Update_Button_Click(sender As Object, e As EventArgs) Handles Update_Button.Click

        Try
            HBSAcodeLibrary.PlayerData.UpdateHandicaps(Section_DropDownList.SelectedValue)
            Err_Literal.Text = "Update handicaps succeeded.  Please continue"

            EnablePanel(Introduction_Panel)

        Catch ex As Exception
            Err_Literal.Text = "ERROR: with Update handicaps.  Please contact support and supply the following:<br/><br/>" & ex.Message
        End Try

    End Sub

    Protected Sub Player_Tags_Button_Click(sender As Object, e As EventArgs) Handles Player_Tags_Button.Click

        Confirm_Literal.Text = "You have opted to calculate and apply new player tags.<br />" &
                       "Click Confirm to do this, otherwise Click Cancel.<br/><br/>" &
                       "Note that this may take quite a while.  When it has finished this dialogue will disappear."

        EnablePanel(Confirm_Panel)
        ConfirmApply_Button.Visible = True

    End Sub

    Protected Sub ApplyTags_Cancel_Button_Click(sender As Object, e As EventArgs) Handles ApplyTags_Cancel_Button.Click

        EnablePanel(Introduction_Panel)

    End Sub

    Protected Sub ConfirmApply_Button_Click(sender As Object, e As EventArgs) Handles ConfirmApply_Button.Click

        If Session("user") Is Nothing Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminHome.aspx")

        Else

            If Confirm_Literal.Text.ToLower Like "*entry form*" Then

                Dim privacyNotAcceptedClubsTable As DataTable = HBSAcodeLibrary.EntryFormData.ApplyEntryForms(Session("user"))
                If Not IsNothing(privacyNotAcceptedClubsTable) AndAlso privacyNotAcceptedClubsTable.Rows.Count > 0 Then
                    ClubsWithoutPrivacyAccepted_GridView.DataSource = privacyNotAcceptedClubsTable
                    ClubsWithoutPrivacyAccepted_GridView.DataBind()
                    ClubsWithoutPrivacyAccepted_Panel.Visible = True
                Else
                    ClubsWithoutPrivacyAccepted_Panel.Visible = False
                End If

                Confirm_Panel.Visible = False

            Else

                Dim errMsg As String = HBSAcodeLibrary.PlayerData.ApplyNewPlayerTags()

                If errMsg = "" Then
                    EnablePanel(Introduction_Panel)
                    Err_Literal.Text = "New tags applied.  Please continue"
                Else
                    Confirm_Literal.Text = "<span style='color:red;'>" & errMsg & "</span>"
                    ConfirmApply_Button.Visible = False
                End If

            End If

        End If

    End Sub

    Protected Sub EntryForms_Button_Click(sender As Object, e As EventArgs) Handles EntryForms_Button.Click

        Confirm_Literal.Text = "You have opted to apply the entry forms.<br /><br/>" &
               "This will update the database to reflect these forms by updating clubs, teams and players.<br/><br/>" &
               "Click Confirm to do this, otherwise Click Cancel."

        EnablePanel(Confirm_Panel)

    End Sub

    Protected Sub SetupEntryForms_Button_Click(sender As Object, e As EventArgs) Handles SetupEntryForms_Button.Click

        If Session("user") Is Nothing Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminHome.aspx")

        Else

            HBSAcodeLibrary.EntryFormData.SetupEntryForms()
            Err_Literal.Text = "Entry forms ready.  Please continue"

        End If

    End Sub

    Protected Sub ClubsWithoutPrivacyAccepted_Button_Click(sender As Object, e As EventArgs) Handles ClubsWithoutPrivacyAccepted_Button.Click
        ClubsWithoutPrivacyAccepted_Panel.Visible = False
    End Sub
End Class