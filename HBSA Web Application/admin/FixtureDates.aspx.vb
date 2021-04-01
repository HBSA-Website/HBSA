Imports HBSAcodeLibrary
Public Class FixtureDates
    Inherits System.Web.UI.Page

    Private Sub FixtureDates_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                populateSections()
            End If
        End If

    End Sub

    Sub PopulateSections()


        With Section_DropDownList
            .Items.Clear()

            Using Leagues As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues()

                If Leagues.Rows.Count > 1 Then
                    .Items.Add(New ListItem("**Select a League or a Section**", 0))
                End If

                For Each row As DataRow In Leagues.Rows
                    .Items.Add(New ListItem("All sections in " & row.Item("League Name"), row.Item("ID") + 100))
                Next

            End Using

            Using Sections As DataTable = HBSAcodeLibrary.LeagueData.GetSections(0)

                For Each row As DataRow In Sections.Rows
                    .Items.Add(New ListItem(row.Item("Section Name"), row.Item("ID")))
                Next

            End Using

        End With

    End Sub

    Sub Populate_Dates()

        Dim SectionID As Integer = Section_DropDownList.SelectedValue
        If SectionID > 100 Then 'selection is for the full league - use the 1st section in the league
            SectionID = HBSAcodeLibrary.LeagueData.GetSections(SectionID - 100).Rows(0).Item("ID")
        End If

        Dim Fixtures As New FixturesData(SectionID)

        If Fixtures.CurfewDates.Rows.Count > 0 Then
            With Fixtures.CurfewDates.Rows(0)
                StartDate_TextBox.Text = !Startdate
                StartDate_CalendarExtender.SelectedDate = CDate(!StartDate)
                CurfewStart_TextBox.Text = !CurfewStart
                CurfewStart_CalendarExtender.SelectedDate = CDate(!CurfewStart)
                CurfewEnd_TextBox.Text = !CurfewEnd
                CurfewEnd_CalendarExtender.SelectedDate = CDate(!CurfewEnd)
            End With
        Else
            StartDate_TextBox.Text = ""
            CurfewStart_TextBox.Text = ""
            CurfewEnd_TextBox.Text = ""
        End If

        With FixtureDates_GridView
            .DataSource = Fixtures.Dates
            .DataBind()
        End With

        If Fixtures.Dates.Rows.Count > 0 Then
            NumberOfFixtures_TextBox.Text = Fixtures.Dates.Rows.Count
        Else
            NumberOfFixtures_TextBox.Text = FixturesData.DefaultNoOfFixtures(Section_DropDownList.SelectedValue)
        End If


    End Sub

    Protected Sub League_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        If Section_DropDownList.SelectedIndex < 1 Then
            Main_Panel.Visible = False
            NumberOfFixtures_TextBox.Text = ""
        Else
            Main_Panel.Visible = True
            populate_Dates()
        End If
    End Sub

    Protected Sub Recalc_Button_Click(sender As Object, e As EventArgs) Handles Recalc_Button.Click

        Err_Literal.Text = ""

        Dim Fixtures As New FixturesData()

        With Fixtures.CurfewDates
            Dim CurfewDatesRow As DataRow = .NewRow

            Try
                CurfewDatesRow("StartDate") = (StartDate_TextBox.Text)
                CurfewDatesRow("CurfewStart") = (CurfewStart_TextBox.Text)
                CurfewDatesRow("CurfewEnd") = (CurfewEnd_TextBox.Text)

                Fixtures.NoOfFixtures = CInt(NumberOfFixtures_TextBox.Text)

            Catch ex As Exception
                Err_Literal.Text = "Enter a valid date in the form dd mmm yyyy, or dd/mm/yy"
                Exit Sub
            End Try

            .Rows.Add(CurfewDatesRow)

            Try
                Dim SectionID As Integer = Section_DropDownList.SelectedValue
                If SectionID > 100 Then 'selection is for the full league - update all sections
                    Dim sections As DataTable = HBSAcodeLibrary.LeagueData.GetSections(SectionID - 100)
                    For Each section As DataRow In sections.Rows
                        Fixtures.NoOfFixtures = CInt(NumberOfFixtures_TextBox.Text)
                        Fixtures.Merge(section.Item("ID"))
                    Next
                Else
                    Fixtures.NoOfFixtures = CInt(NumberOfFixtures_TextBox.Text)
                    Fixtures.Merge(SectionID)
                End If


            Catch ex As Exception
                Err_Literal.Text = ex.Message
                Exit Sub
            End Try

        End With

        populate_Dates()

    End Sub

End Class