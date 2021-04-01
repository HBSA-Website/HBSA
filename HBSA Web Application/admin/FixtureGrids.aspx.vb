Public Class FixtureGrids
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Session("SaveButton") = Save_Button.Text

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then

                PopulateSections()
                Session("ChangesPending") = False

            Else

                If Request.Item("_DropDownChanged").Length > 0 Then
                    HandleButton(Request.Item("_DropDownChanged"))
                End If

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

    Protected Sub Section_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Section_DropDownList.SelectedIndexChanged 'Handles Section_DropDownList.SelectedIndexChanged

        Refresh_Button_Click(sender, e)

    End Sub

    Protected Sub Refresh_Button_Click(sender As Object, e As EventArgs) Handles Refresh_Button.Click

        Dim SectionID As Integer = Section_DropDownList.SelectedValue
        If SectionID > 100 Then 'selection is for the full league - use the 1st section in the league
            SectionID = HBSAcodeLibrary.LeagueData.GetSections(SectionID - 100).Rows(0).Item("ID")
        End If

        Using Grid As New HBSAcodeLibrary.FixtureGrid(SectionID)

            Session("FixtureMatrix") = Grid.FixtureMatrix
            Session("NoMatches") = Grid.NoMatches
            Session("NoWeeks") = Grid.NoWeeks
            Session("NoOfTeams") = Grid.NoOfTeams
            Session("ChangesPending") = False

            BuildFixtureGridTable(Grid.FixtureMatrix, Grid.NoMatches, Grid.NoWeeks, Grid.NoOfTeams)

        End Using

    End Sub

    Protected Sub Restart_Button_Click(sender As Object, e As EventArgs) Handles Restart_Button.Click

        Using Grid As New HBSAcodeLibrary.FixtureGrid()

            Dim SectionID As Integer = Section_DropDownList.SelectedValue
            If SectionID > 100 Then 'selection is for the full league - use the 1st section in the league
                SectionID = HBSAcodeLibrary.LeagueData.GetSections(SectionID - 100).Rows(0).Item("ID")
            End If

            Grid.GetFixtureMatrix(SectionID)

            Session("FixtureMatrix") = Grid.FixtureMatrix
            Session("NoMatches") = Grid.NoMatches
            Session("NoWeeks") = Grid.NoWeeks
            Session("NoOfTeams") = Grid.NoOfTeams
            Session("ChangesPending") = False

            BuildFixtureGridTable(Grid.FixtureMatrix, Grid.NoMatches, Grid.NoWeeks, Grid.NoOfTeams)

            Save_Button_Click(sender, e)

        End Using
    End Sub

    Protected Sub BuildFixtureGridTable(Fixtures As DataTable, NoMatches As Integer, NoWeeks As Integer, NoOfTeams As Integer)

        With FixtureGrid_Table
            .Rows.Clear()

            Dim Header As New TableHeaderRow
            With Header
                Dim WeekHeaderCell As New TableHeaderCell With {
                    .VerticalAlign = VerticalAlign.Middle,
                    .CssClass = "CellAll",
                    .Text = "Week No"
                }
                .Cells.Add(WeekHeaderCell)

                For iy = 0 To NoMatches - 1 'one column per match (home v away)
                    Dim HomeHead As New TableCell With {
                        .VerticalAlign = VerticalAlign.Middle,
                        .CssClass = "CellLeft",
                        .Text = "home"
                    }
                    .Cells.Add(HomeHead)

                    Dim vHead As New TableCell With {
                        .VerticalAlign = VerticalAlign.Middle,
                        .CssClass = "CellMiddle",
                        .Text = "v"
                    }
                    .Cells.Add(vHead)

                    Dim AwayHead As New TableCell With {
                        .VerticalAlign = VerticalAlign.Middle,
                        .CssClass = "CellRight",
                        .Text = "away"
                    }
                    .Cells.Add(AwayHead)
                Next


            End With
            .Rows.Add(Header)

            'there will be a row per week.  
            For ix = 0 To NoWeeks - 1
                Dim Row As New TableRow
                With Row
                    Dim WeekCell As New TableCell With {
                        .VerticalAlign = VerticalAlign.Middle,
                        .CssClass = "CellAll",
                        .Text = ix + 1
                    }
                    .Cells.Add(WeekCell)

                    For iy = 0 To NoMatches - 1 'one column per match (home v away)
                        Dim HomeFixtureNo As New TableCell With {
                            .VerticalAlign = VerticalAlign.Middle,
                            .CssClass = "CellLeft"
                        }

                        Dim HomeFixture As New DropDownList

                        With HomeFixture
                            .ID = "HomeFixtureNumber_" & CStr(ix) + "_" + CStr(iy)
                            .Attributes.Add("onChange", "document.forms[0]." & "_DropDownChanged.value='" & .ID & "_' + this.options[this.selectedIndex].value;document.forms[0].submit();")

                            For TeamNo = 1 To NoOfTeams
                                .Items.Add(TeamNo)
                            Next

                            .Enabled = (ix < (NoOfTeams - 1)) Or Unlock_CheckBox.Checked
                            .SelectedValue = Fixtures.Rows(ix).Item(3 + (iy * 2))
                            '.AutoPostBack = True
                            ' AddHandler .SelectedIndexChanged, AddressOf handleButton

                        End With

                        HomeFixtureNo.Controls.Add(HomeFixture)
                        .Cells.Add(HomeFixtureNo)

                        Dim versus As New TableCell With {
                            .CssClass = "CellMiddle",
                            .Text = " v "
                        }
                        .Cells.Add(versus)

                        Dim AwayFixtureNo As New TableCell With {
                            .VerticalAlign = VerticalAlign.Middle,
                            .CssClass = "CellRight"
                        }

                        Dim AwayFixture As New DropDownList
                        With AwayFixture
                            .ID = "AwayFixtureNumber_" & CStr(ix) + "_" + CStr(iy)
                            .Attributes.Add("onChange", "document.forms[0]." & "_DropDownChanged.value='" & .ID & "_' + this.options[this.selectedIndex].value;document.forms[0].submit();")

                            For TeamNo = 1 To NoOfTeams
                                .Items.Add(TeamNo)
                            Next

                            .Enabled = (ix < (NoOfTeams - 1)) Or Unlock_CheckBox.Checked
                            .SelectedValue = Fixtures.Rows(ix).Item(4 + (iy * 2))

                        End With

                        AwayFixtureNo.Controls.Add(AwayFixture)
                        .Cells.Add(AwayFixtureNo)

                    Next

                End With

                .Rows.Add(Row)

            Next
        End With

        Check_Message.Text = ""
        Grid_Panel.Visible = (NoMatches > 0)
        Move_Button.Enabled = Not Session("ChangesPending")
        Swap_Button.Enabled = Not Session("ChangesPending")

    End Sub

    Protected Sub CheckGrid_Button_Click(sender As Object, e As EventArgs) Handles CheckGrid_Button.Click

        BuildFixtureGridTable(Session("FixtureMatrix"), Session("NoMatches"), Session("NoWeeks"), Session("NoOfTeams"))
        Check_Message.Text = CheckGrid(Session("FixtureMatrix"))

    End Sub

    Function CheckGrid(FixtureGrid As DataTable) As String

        Dim SectionSize As Integer = Session("NoOfTeams")
        Dim Homes(16, SectionSize) As Integer
        Dim Aways(16, SectionSize) As Integer

        For rowNo = 0 To FixtureGrid.Rows.Count - 1
            Dim dr As DataRow = FixtureGrid.Rows(rowNo)

            Homes(dr!h1, dr!a1) += 1
            Aways(dr!a1, dr!h1) += 1
            If SectionSize > 2 Then
                Homes(dr!h2, dr!a2) += 1
                Aways(dr!a2, dr!h2) += 1
                If SectionSize > 4 Then
                    Homes(dr!h3, dr!a3) += 1
                    Aways(dr!a3, dr!h3) += 1
                    If SectionSize > 6 Then
                        Homes(dr!h4, dr!a4) += 1
                        Aways(dr!a4, dr!h4) += 1
                        If SectionSize > 8 Then
                            Homes(dr!h5, dr!a5) += 1
                            Aways(dr!a5, dr!h5) += 1
                            If SectionSize > 10 Then
                                Homes(dr!h6, dr!a6) += 1
                                Aways(dr!a6, dr!h6) += 1
                                If SectionSize > 12 Then
                                    Homes(dr!h7, dr!a7) += 1
                                    Aways(dr!a7, dr!h7) += 1
                                    If SectionSize > 14 Then
                                        Homes(dr!h8, dr!a8) += 1
                                        Aways(dr!a8, dr!h8) += 1
                                    End If
                                End If
                            End If
                        End If
                    End If
                End If
            End If

        Next

        Dim errmsg As String = ""
        For x As Integer = 1 To SectionSize
            For y As Integer = 1 To SectionSize
                If y <> x Then
                    If Homes(x, y) = 0 Then
                        errmsg += "Home Team " & x & " is missing a match against " & y & "<br />"
                    ElseIf Homes(x, y) > 1 Then
                        errmsg += "Home Team " & x & " has " & Homes(x, y) & " matches against " & y & "<br />"
                    End If
                    If Aways(x, y) = 0 Then
                        errmsg += "Away Team " & x & " is missing a match against " & y & "<br />"
                    ElseIf Aways(x, y) > 1 Then
                        errmsg += "Away Team " & x & " has " & Aways(x, y) & " matches against " & y & "<br />"
                    End If

                End If

            Next
        Next

        CheckGrid = IIf(errmsg = "", "The Fixture Grid for this section verifies OK.", errmsg)

    End Function

    Sub HandleButton(DropDownChanged As String)

        Dim DropDownItems() As String = DropDownChanged.Split("_")
        Dim Command = DropDownItems(0).Replace("FixtureNumber", "")
        Dim RowNo As Integer = CInt(DropDownItems(1))
        Dim ItemNo As Integer = If(Command.ToLower = "home", 3, 4) + (CInt(DropDownItems(2)) * 2)
        Dim NewValue As String = CInt(DropDownItems(3))

        Dim fixtures As DataTable = Session("FixtureMatrix")
        fixtures.Rows(RowNo).Item(ItemNo) = NewValue

        Session("ChangesPending") = True

        If Not Unlock_CheckBox.Checked Then
            'Make change to opposite half
            RowNo += (Session("NoOfTeams")) - 1
            If fixtures.Rows.Count > RowNo Then
                ItemNo += If(Command.ToLower = "home", 1, -1)
                fixtures.Rows(RowNo).Item(ItemNo) = NewValue
                'look for more than single second half
                RowNo += (Session("NoOfTeams")) - 1
                If fixtures.Rows.Count > RowNo Then
                    ItemNo -= If(Command.ToLower = "home", 1, -1)
                    fixtures.Rows(RowNo).Item(ItemNo) = NewValue
                End If
            End If
        End If

        Session("FixtureMatrix") = fixtures

        BuildFixtureGridTable(Session("FixtureMatrix"), Session("NoMatches"), Session("NoWeeks"), Session("NoOfTeams"))

    End Sub

    Private Sub Unlock_CheckBox_CheckedChanged(sender As Object, e As EventArgs) Handles Unlock_CheckBox.CheckedChanged

        BuildFixtureGridTable(Session("FixtureMatrix"), Session("NoMatches"), Session("NoWeeks"), Session("NoOfTeams"))

    End Sub

    Protected Sub CloseHelp_Button_Click(sender As Object, e As EventArgs) Handles CloseHelp_Button.Click

        Help_Panel.Visible = False
        BuildFixtureGridTable(Session("FixtureMatrix"), Session("NoMatches"), Session("NoWeeks"), Session("NoOfTeams"))

    End Sub

    Protected Sub Help_Button_Click(sender As Object, e As ImageClickEventArgs) Handles Help_Button.Click

        Help_Panel.Visible = True

    End Sub

    Protected Sub Reverse_Button_Click(sender As Object, e As EventArgs) Handles Reverse_Button.Click

        Dim grid As DataTable = Session("FixtureMatrix")
        Dim NoWeeks As Integer = Session("NoWeeks")
        Dim temp As Integer
        For rowNo = 0 To NoWeeks - 1
            For itemNo = 3 To Session("NoOfTeams") + 2 Step 2
                temp = grid.Rows(rowNo).Item(itemNo)
                grid.Rows(rowNo).Item(itemNo) = grid.Rows(rowNo).Item(itemNo + 1)
                grid.Rows(rowNo).Item(itemNo + 1) = temp
            Next
        Next

        Session("FixtureMatrix") = grid
        BuildFixtureGridTable(Session("FixtureMatrix"), Session("NoMatches"), Session("NoWeeks"), Session("NoOfTeams"))

    End Sub

    Protected Sub Save_Button_Click(sender As Object, e As EventArgs) Handles Save_Button.Click

        If Session("SaveButton") = "Confirm" OrElse CheckGrid(Session("FixtureMatrix")) = "The Fixture Grid for this section verifies OK." Then

            Save_Button.Text = "Save"

            Using grid As New HBSAcodeLibrary.FixtureGrid()
                grid.FixtureMatrix = Session("FixtureMatrix")
                Try
                    Dim SectionID As Integer = Section_DropDownList.SelectedValue
                    If SectionID > 100 Then 'selection is for the full league - update all sections
                        Dim sections As DataTable = HBSAcodeLibrary.LeagueData.GetSections(SectionID - 100)
                        For Each section As DataRow In sections.Rows
                            'go through grid.FixtureMatrix and update the sectionID
                            For Each FixtureMatrixRow As DataRow In grid.FixtureMatrix.Rows
                                FixtureMatrixRow.Item("SectionID") = section.Item("ID")
                            Next
                            grid.Merge(section.Item("ID"))
                        Next
                    Else
                        grid.Merge(SectionID)
                    End If

                    Session("ChangesPending") = False
                    Refresh_Button_Click(sender, e)
                    Check_Message.Text = "<span style='color:darkorange;'>Saved.  Please select a league or section, or use a menu option at the top.</span>"
                Catch ex As Exception
                    Check_Message.Text = "<span style='color:red;'>DATABASE ERROR: please contact support with the following:</span><br/>" + ex.Message
                End Try
            End Using
        Else
            BuildFixtureGridTable(Session("FixtureMatrix"), Session("NoMatches"), Session("NoWeeks"), Session("NoOfTeams"))
            Check_Message.Text = "<span style='color:darkorange;'>WARNING, the grid does not check OK:<br/>Click Confirm to save anyway or continue.</span><br/>"

            Save_Button.Text = "Confirm"

        End If

    End Sub

    Private Sub Swap_Button_Click(sender As Object, e As EventArgs) Handles Swap_Button.Click

        Weeks_Literal.Text = "<p style='font-size:12pt;font-weight:bolder;'>Swap one week with another</p>"
        Week1_Literal1.Text = "Enter week to swap:"
        Week2_Literal2.Text = "Enter week to swap with:"
        Week1_TextBox.Text = ""
        Week2_TextBox.Text = ""
        Update_Button.Text = "Swap week x with week y"
        Weeks_Panel.Visible = True
        BuildFixtureGridTable(Session("FixtureMatrix"), Session("NoMatches"), Session("NoWeeks"), Session("NoOfTeams"))

    End Sub

    Private Sub Move_Button_Click(sender As Object, e As EventArgs) Handles Move_Button.Click

        Weeks_Literal.Text = "<p style='font-size:12pt;font-weight:bolder;'>Move one week after another</p>"
        Week1_Literal1.Text = "Enter week to move:"
        Week2_Literal2.Text = "Enter week after which to move to"
        Week1_TextBox.Text = ""
        Week2_TextBox.Text = ""
        Update_Button.Text = "Move week x after week y"
        Weeks_Panel.Visible = True
        BuildFixtureGridTable(Session("FixtureMatrix"), Session("NoMatches"), Session("NoWeeks"), Session("NoOfTeams"))

    End Sub

    Protected Sub Week_TextBox_TextChanged(sender As Object, e As EventArgs) Handles Week1_TextBox.TextChanged, Week2_TextBox.TextChanged

        Update_Button.Text = If(Update_Button.Text.ToLower.Contains("move"),
                                 "Move week " & Week1_TextBox.Text.Trim & " after week " & Week2_TextBox.Text.Trim,
                                 "Swap week " & Week1_TextBox.Text.Trim & " with " & Week2_TextBox.Text.Trim)

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        Weeks_Panel.Visible = False
        Refresh_Button_Click(sender, e)

    End Sub

    Private Sub Update_Button_Click(sender As Object, e As EventArgs) Handles Update_Button.Click

        Dim errmsg As String = ""

        Try
            Dim week1 As Integer = Week1_TextBox.Text
            Dim week2 As Integer = Week2_TextBox.Text

            If week1 < 1 Then
                errmsg += "The first week must not be less than 1<br/>"
            End If
            If week2 < 1 Then
                errmsg += "The second week must not be less than 1<br/>"
            End If

            If Unlock_CheckBox.Checked Then
                If week1 > Session("NoWeeks") Then
                    errmsg += "The first week must not be larger than the total number of weeks available<br/>"
                End If
                If week2 > Session("NoWeeks") Then
                    errmsg += "The second week must not be larger than the total number of weeks available<br/>"
                End If
            Else
                If week1 > (Session("NoWeeks") / 2) Then
                    errmsg += "The first week must not be larger than the number of weeks in the first half of the season<br/>"
                End If
                If week2 > (Session("NoWeeks") / 2) Then
                    errmsg += "The second week must not be larger than the number of weeks in the first half of the season<br/>"
                End If
            End If

        Catch ex As Exception
            errmsg += "Both week numbers must be numeric.<br/>"
        End Try

        If errmsg <> "" Then
            errmsg = errmsg.Substring(0, errmsg.Length - 5)
            Weeks_Literal.Text = "<span style='color:red;'>" + errmsg + "</span>"
        Else
            'update
            Dim SectionID As Integer = Section_DropDownList.SelectedValue
            If SectionID > 100 Then 'selection is for the full league - update all sections
                Dim sections As DataTable = HBSAcodeLibrary.LeagueData.GetSections(SectionID - 100)
                For Each section As DataRow In sections.Rows
                    HBSAcodeLibrary.FixtureGrid.UpdateRows(If(Update_Button.Text.ToLower.Contains("move"), "move", "swap"),
                                             section.Item("ID"),
                                             Week1_TextBox.Text,
                                             Week2_TextBox.Text,
                                             Unlock_CheckBox.Checked)
                Next
            Else
                HBSAcodeLibrary.FixtureGrid.UpdateRows(If(Update_Button.Text.ToLower.Contains("move"), "move", "swap"),
                                             SectionID,
                                             Week1_TextBox.Text,
                                             Week2_TextBox.Text,
                                             Unlock_CheckBox.Checked)
            End If

            Weeks_Panel.Visible = False

        End If

        Session("ChangesPending") = False
        Refresh_Button_Click(sender, e)
        Check_Message.Text = "<span style='color:darkorange;'>Saved.  Please select a league or section, or use a menu option at the top.</span>"

    End Sub

End Class