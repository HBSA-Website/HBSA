

Public Class Fixtures
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            populateSections()

        End If

    End Sub

    Protected Sub PopulateSections()

        Fixtures_GridView.Visible = False
        With Section_DropDownList

            Using SectionsTable As DataTable = HBSAcodeLibrary.LeagueData.GetSections(0)

                .Items.Clear()
                .Visible = True

                If SectionsTable.Rows.Count > 1 Then
                    .Items.Add("**Select a league and section**")
                End If

                For Each row As DataRow In SectionsTable.Rows
                    .Items.Add(New ListItem(row.Item("Section Name"), row.Item("ID")))
                Next

                If SectionsTable.Rows.Count < 2 Then
                    .Enabled = False
                Else
                    .Enabled = True
                End If

            End Using

            Using LeaguesTable As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues

                For Each row As DataRow In LeaguesTable.Rows
                    .Items.Add(New ListItem(row.Item("League Name") & " - All sections", row.Item("ID") + 100))
                Next

            End Using

            .SelectedIndex = 0

        End With

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        Fixtures_GridView.Visible = False

        If Section_DropDownList.SelectedValue.StartsWith("**") Then

            Fixture_Date_DropDownList.Items.Clear()
            Team_DropDownList.Items.Clear()

            With Fixture_Date_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("All match dates", "All"))
            End With
            With Team_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("All teams", "All"))
            End With

        Else

            'populate the dates and teams selectors

            Dim FixtureList As DataSet = HBSAcodeLibrary.FixturesData.FixtureList(Section_DropDownList.SelectedValue, "All", "All")

            With Fixture_Date_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("All match dates", "All"))
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

        End If

    End Sub

    Protected Sub Get_Button_Click(sender As Object, e As EventArgs) Handles Get_Button.Click

        If Section_DropDownList.SelectedIndex < 1 Then

            Selection_Literal.Text = "<span style='color:red;'>Please select a league and/or section first.</span>"

        Else

            Dim Fixtures As DataSet = HBSAcodeLibrary.FixturesData.FixtureList(Section_DropDownList.SelectedValue, Fixture_Date_DropDownList.SelectedValue, Team_DropDownList.SelectedValue)
            Fixtures_GridView.DataSource = Fixtures.Tables(0)
            Fixtures_GridView.DataBind()
            Fixtures_GridView.Visible = True

        End If

    End Sub

End Class