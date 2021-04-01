Imports HBSAcodeLibrary
Public Class TaggedPlayers
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                PopulateSections()
            End If
        End If

    End Sub

    Protected Sub PopulateSections()

        Section_DropDownList.Items.Clear()

        Using sectionsList As DataTable = LeagueData.GetSections(0)

            With Section_DropDownList
                .Items.Clear()
                .Visible = True
                .DataSource = sectionsList
                .DataTextField = "Section Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**All leagues**", 0))

                Using leaguesList As DataTable = LeagueData.AllLeagues
                    For Each row As DataRow In leaguesList.Rows
                        .Items.Add(New ListItem(row.Item("League Name") & " - All sections", row.Item("ID") + 100))
                    Next
                End Using

                .SelectedIndex = 0

                If .Items.Count < 3 Then
                    .Enabled = False
                    Section_DropDownList_SelectedIndexChanged(New Object, New System.EventArgs)
                Else
                    .Enabled = True
                End If

            End With

        End Using

        PopulateClubs(Club_DropDownList, Section_DropDownList.SelectedValue)

    End Sub

    Protected Sub PopulateClubs(DropDown As DropDownList, SectionID As Integer)

        DropDown.Items.Clear()

        Using clubsInSection As DataTable = ClubData.GetClubs(SectionID)

            With DropDown
                .Items.Clear()
                .Visible = True
                .DataSource = clubsInSection
                .DataTextField = "Club Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**All Clubs**", 0))

                .Enabled = (clubsInSection.Rows.Count > 1)

                .SelectedIndex = 0

            End With

        End Using

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) _
            Handles Section_DropDownList.SelectedIndexChanged

        populateClubs(Club_DropDownList, Section_DropDownList.SelectedValue)

    End Sub

    Protected Sub GetReport_Button_Click(sender As Object, e As EventArgs) Handles GetReport_Button.Click

        Using TaggedPlayersTable As DataTable = PlayerData.TaggedPlayersReport(If(Section_DropDownList.SelectedValue > 99, Section_DropDownList.SelectedValue Mod 100, 0),
                                                                               If(Section_DropDownList.SelectedValue > 99, 0, Section_DropDownList.SelectedValue Mod 100),
                                                                               Club_DropDownList.SelectedValue,
                                                                               ActionNeeded_CheckBox.Checked)
            With TaggedPlayers_GridView

                .DataSource = TaggedPlayersTable
                .DataBind()

                Session("TaggedPlayers") = TaggedPlayersTable
                Export_Button.Visible = (TaggedPlayersTable.Rows.Count > 0)
                ApplyChanges_Panel.Visible = (TaggedPlayersTable.Rows.Count > 0)
                Apply_Literal.Text = ""

            End With

            Session("TaggedPlayersData") = TaggedPlayersTable

        End Using

    End Sub

    Private Sub TaggedPlayers_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles TaggedPlayers_GridView.RowDataBound

        If e.Row.Cells.Count > 6 Then
            e.Row.Cells(1).Visible = False

            If e.Row.RowType = DataControlRowType.DataRow Then

                e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Center
                e.Row.Cells(4).HorizontalAlign = HorizontalAlign.Center
                e.Row.Cells(5).HorizontalAlign = HorizontalAlign.Center
                e.Row.Cells(6).HorizontalAlign = HorizontalAlign.Center
                e.Row.Cells(8).HorizontalAlign = HorizontalAlign.Center

            End If

        End If

    End Sub

    Protected Sub Apply_Button_Click(sender As Object, e As EventArgs) Handles Apply_Button.Click

        Apply_Literal.Text = ""
        Dim SendErrors As String = PlayerData.ApplyTaggedPlayersHandicaps(
                                                 Section_DropDownList.SelectedValue,
                                                 Club_DropDownList.SelectedValue)

        Dim temp As String = Apply_Literal.Text
        GetReport_Button_Click(sender, e)
        Apply_Literal.Text = temp

        Export_Button.Visible = IsNumeric(SendErrors) AndAlso Convert.ToInt32(SendErrors) > 0
        ApplyChanges_Panel.Visible = True

        If IsNumeric(SendErrors) Then
            Apply_Literal.Text += "<br/><span style='color:green;'><strong> and emails sent.</strong></span><br/>"
        Else
            Apply_Literal.Text += SendErrors
        End If

    End Sub

End Class