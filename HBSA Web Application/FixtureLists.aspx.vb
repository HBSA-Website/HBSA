Partial Class FixtureLists
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            populateSections()

        End If

    End Sub

    Protected Sub PopulateSections()

        Section_GridView.Visible = False
        Matrix_GridView.Visible = False
        Fixtures_GridView.Visible = False

        Dim leaguesSections As DataTable = HBSAcodeLibrary.SectionData.GetSections()

        With Section_DropDownList
            .Items.Clear()
            .Visible = True

            If leaguesSections.Rows.Count > 1 Then
                .Items.Add("**Select a league and section**")
            End If

            For Each row As DataRow In leaguesSections.Rows
                .Items.Add(New ListItem(row!League & " " & row.Item("Section Name"), row.Item("ID")))
            Next

            If leaguesSections.Rows.Count < 2 Then
                .Enabled = False
            Else
                .Enabled = True
            End If

            leaguesSections = HBSAcodeLibrary.LeagueData.GetLeagues()

            For Each row As DataRow In leaguesSections.Rows
                .Items.Add(New ListItem(row.Item("League Name") & " - All sections", row.Item("ID") + 100))
            Next

            .SelectedIndex = 0

        End With

        leaguesSections.Dispose()

        Section_DropDownList_SelectedIndexChanged(New Object, New EventArgs)

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        Section_GridView.Visible = False
        Matrix_GridView.Visible = False
        Fixtures_GridView.Visible = False

        If Section_DropDownList.SelectedValue.StartsWith("**") Then

            FixtureDate_DropDownList.Items.Clear()
            Team_DropDownList.Items.Clear()
            print_Button.Visible = False
            Download_Button.Visible = print_Button.Visible

            With FixtureDate_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("All Fixture dates", "All"))
            End With
            With Team_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("All teams", "All"))
            End With

        Else

            If Section_DropDownList.SelectedValue > 99 Then
                FixtureType_CheckBox.Checked = True
                FixtureType_CheckBox.Visible = False
            Else
                FixtureType_CheckBox.Visible = True
            End If

            If FixtureType_CheckBox.Checked Then
                'populate the dates and teams selectors

                Dim FixtureList As DataSet = HBSAcodeLibrary.FixturesData.FixtureList(Section_DropDownList.SelectedValue, "All", "All")

                With FixtureDate_DropDownList
                    .Items.Clear()
                    .Items.Add(New ListItem("All Fixture dates", "All"))
                    For Each row As DataRow In FixtureList.Tables(1).Rows
                        .Items.Add(row.Item("Fixture Date"))
                    Next
                End With
                With Team_DropDownList
                    .Items.Clear()
                    .Items.Add(New ListItem("All teams", "All"))
                    For Each row As DataRow In FixtureList.Tables(2).Rows
                        .Items.Add(row!Team)
                    Next
                End With

                'Fixtures_GridView.DataSource = FixtureList.Tables(0)
                'Fixtures_GridView.DataBind()
                'Fixtures_GridView.Visible = True
                'Section_GridView.Visible = False
                'Matrix_GridView.Visible = False
                print_Button.Visible = False
                Download_Button.Visible = print_Button.Visible
                Session("Fixtures") = Nothing

            Else

                Dim Fixtures As DataSet = HBSAcodeLibrary.FixturesData.GetFixtures(Section_DropDownList.SelectedValue)

                Matrix_GridView.DataSource = Fixtures.Tables(0)
                Matrix_GridView.DataBind()

                Section_GridView.DataSource = Fixtures.Tables(1)
                Section_GridView.DataBind()

                Fixtures_GridView.Visible = False
                Section_GridView.Visible = True
                Matrix_GridView.Visible = True
                print_Button.Visible = Section_GridView.Rows.Count > 1
                Download_Button.Visible = print_Button.Visible

                Dim FixturesSBS As DataTable = HBSAcodeLibrary.FixturesData.GetFixturesSideBySide(Section_DropDownList.SelectedValue)
                Session("Fixtures") = FixturesSBS

            End If

        End If

    End Sub

    Protected Sub Section_GridView_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles Section_GridView.RowDataBound

        e.Row.Cells(1).HorizontalAlign = HorizontalAlign.Left

    End Sub

    Protected Sub FixtureType_CheckBox_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles FixtureType_CheckBox.CheckedChanged

        FixtureDate_DropDownList.Visible = FixtureType_CheckBox.Checked
        Team_DropDownList.Visible = FixtureType_CheckBox.Checked
        Get_Button.Visible = FixtureType_CheckBox.Checked

        If FixtureType_CheckBox.Checked Then
            Selection_Literal.Text = "Select a league and a section, then optionally a Fixture date and/or team, then Click Show Fixtures."
        Else
            Selection_Literal.Text = "Select a league and a section, then Click Show Fixtures."
        End If

        Section_DropDownList_SelectedIndexChanged(sender, e)

    End Sub

    Protected Sub Fixtures_GridView_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles Fixtures_GridView.RowDataBound
        e.Row.Cells(1).HorizontalAlign = HorizontalAlign.Right
        e.Row.Cells(2).HorizontalAlign = HorizontalAlign.Left
    End Sub

    Protected Sub Get_Button_Click(sender As Object, e As EventArgs) Handles Get_Button.Click

        If Section_DropDownList.SelectedIndex < 1 Then
            Selection_Literal.Text = "<span style='color:red;'>Please select a league and/or section first.</span>"
        Else
            Dim Fixtures As DataSet = HBSAcodeLibrary.FixturesData.FixtureList(Section_DropDownList.SelectedValue, FixtureDate_DropDownList.SelectedValue, Team_DropDownList.SelectedValue)
            Fixtures_GridView.DataSource = Fixtures.Tables(0)
            Fixtures_GridView.DataBind()
            Fixtures_GridView.Visible = True
            Section_GridView.Visible = False
            Matrix_GridView.Visible = False
            print_Button.Visible = Fixtures_GridView.Rows.Count > 1
            Download_Button.Visible = print_Button.Visible
            Session("Fixtures") = Fixtures.Tables(0)

        End If

    End Sub

End Class
