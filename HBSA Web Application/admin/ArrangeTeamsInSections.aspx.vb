Imports HBSAcodeLibrary
Public Class ArrangeTeamsInSections
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        If Session("adminDetails") Is Nothing _
               OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        End If

        If IsPostBack Then

            PerformAction()
            populateTeams()

        Else

            populateLeagueDropDpwnList()

            Session("ChangesPending") = False

        End If



    End Sub

    Protected Sub PopulateLeagueDropDpwnList()

        Dim leagues As DataTable = LeagueData.GetLeagues
        With League_DropDownList

            .Items.Clear()

            .DataSource = leagues
            .DataTextField = "League Name"
            .DataValueField = "ID"
            .DataBind()
            .Items.Insert(0, New ListItem("**Select**", "0"))

        End With

    End Sub

    Protected Sub League_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles League_DropDownList.SelectedIndexChanged

        If Session("ChangesPending") = True Then
            QuerySavePanel.Visible = True
        Else

            Dim TeamsTables As DataSet = HBSAcodeLibrary.TeamData.GetTeamTables(League_DropDownList.SelectedValue)
            Session("TeamsTables") = TeamsTables
            Session("ChangesPending") = False

            PopulateTeams()

        End If

    End Sub

    Sub PerformAction()

        ' Now there is a postback, let's see what happend
        If dragAction.Value = "" Then Exit Sub

        Try

            ' Get the right Id's                
            Dim action() As String = dragAction.Value.Split("|")
            Dim TeamName As String = action(0)

            Dim location() As String = action(1).Split("_")
            Dim TargetRowIx As Integer = Integer.Parse(location(1))
            Dim TargetColIx As Integer = Integer.Parse(location(2))

            UpdateTables(TeamName, TargetRowIx, TargetColIx)
            PopulateTeams()
            dragAction.Value = ""

        Catch ex As Exception ' Ignore error

        End Try

    End Sub

    Private Sub UpdateTables(TeamName As String, TargetRowIx As Integer, TargetColIx As Integer)

        'Given the source team name, move it to the given co-ordinates

        Dim TeamsTables As DataSet = Session("TeamsTables")
        Dim Teams As DataTable = TeamsTables.Tables(0)
        Dim TeamIDs As DataTable = TeamsTables.Tables(1)

        For RowIx As Integer = 0 To Teams.Rows.Count - 1
            For ColIx As Integer = 1 To Teams.Rows(RowIx).ItemArray.GetUpperBound(0)
                'locate source cell from the name
                If Teams.Rows(RowIx).Item(ColIx).trim = TeamName.Trim Then
                    If RowIx <> TargetRowIx OrElse ColIx <> TargetColIx Then 'ignore if target = source
                        Teams.Rows(TargetRowIx).Item(TargetColIx) = Teams.Rows(RowIx).Item(ColIx)
                        Teams.Rows(RowIx).Item(ColIx) = ""
                        TeamIDs.Rows(TargetRowIx).Item(TargetColIx) = TeamIDs.Rows(RowIx).Item(ColIx)
                        TeamIDs.Rows(RowIx).Item(ColIx) = 0
                        Session("TeamsTables") = TeamsTables
                        Session("ChangesPending") = True
                        Exit Sub
                    End If
                End If
            Next
        Next

    End Sub

    Private Sub PopulateTeams()

        tblPage.Rows.Clear()

        Dim TeamTables As DataSet = Session("TeamsTables")

        If TeamTables Is Nothing OrElse TeamTables.Tables.Count < 2 Then Exit Sub

        Dim Teams As DataTable = TeamTables.Tables(0)
        Dim TeamIDs As DataTable = TeamTables.Tables(1)

        Dim HeaderRow As New HtmlTableRow
        tblPage.Rows.Add(HeaderRow)

        For ColIx As Integer = 0 To TeamIDs.Columns.Count - 1

            Dim td As New HtmlTableCell With {
                .InnerText = Teams.Columns(ColIx).ColumnName
            }

            HeaderRow.Cells.Add(td)

        Next

        For RowIx As Integer = 0 To Teams.Rows.Count - 1

            Dim tRow As DataRow = Teams.Rows(RowIx)

            Dim tr As New HtmlTableRow
            tblPage.Rows.Add(tr)

            For ColIx As Integer = 0 To tRow.ItemArray.GetUpperBound(0)

                Dim Team As DataRow = Teams.Rows(RowIx)

                Dim td As New HtmlTableCell
                If ColIx = 0 Then
                    If Team.Item(ColIx) > 0 Then
                        td.InnerText = Team.Item(ColIx)
                    End If
                Else
                    td.ID = "Cell_" & RowIx & "_" & ColIx
                    td.ClientIDMode = UI.ClientIDMode.Static
                    'td.Attributes.Add("runat", "server")
                    'If i = 0 And y = 3 Then td.Attributes.Add("class", "upper_right")
                    'If i = 3 And y = 0 Then td.Attributes.Add("class", "lower_left")

                    If Team.Item(ColIx) <> "" Then
                        td.InnerHtml = String.Format("<div id=""Component_{0}"" class=""drag {1} climit1_1"">" & Team.Item(ColIx) & "</div>", RowIx, "green")
                    End If
                End If

                tr.Cells.Add(td)

            Next

        Next

    End Sub

    Protected Sub QuerySave_Button_Click(sender As Object, e As EventArgs) Handles QuerySave_Button.Click

        'save the tabels to the database
        SaveTables()
        QueryCancel_Button_Click(sender, e)

    End Sub

    Protected Sub QueryCancel_Button_Click(sender As Object, e As EventArgs) Handles QueryCancel_Button.Click

        QuerySavePanel.Visible = False
        Session("ChangesPending") = False
        League_DropDownList_SelectedIndexChanged(sender, e)

    End Sub

    Protected Sub SaveTables()

        If Not HBSAcodeLibrary.HBSA_Configuration.CloseSeason Then

            msgBox_Literal.Text = "<span style='color:red;'>Cannot update the database<br />The current season is active</span>"
            msgBox_Panel.Visible = True

        Else

            SaveTeamTables()
            'if saved clear ChangesPending and redo the grid

            Session("ChangesPending") = False
            QuerySavePanel.Visible = False

            'Check for too many home fixtures
            If ThereAreTooManyHomeFixtures() Then
                msgBox_Literal.Text = "<span style='color:red;'>There are clubs with too many home fixtures.</span>"
                msgBox_Panel.Visible = True
            End If

        End If

    End Sub

    Private Sub SaveTeamTables()

        Dim TeamTables As DataSet = Session("TeamsTables")
        If TeamTables Is Nothing OrElse TeamTables.Tables.Count < 2 Then Exit Sub
        Dim Teams As DataTable = TeamTables.Tables(0)
        Dim TeamIDs As DataTable = TeamTables.Tables(1)

        'validate
        'Dim errMsg As String = ""
        Dim EmptyTeamDetected As Boolean = False

        'For iCol = 1 To Teams.Columns.Count - 1

        '    For iRow = 0 To Teams.Rows.Count - 1

        '        Dim F_No As Integer = Teams.Rows(iRow).Item(0)

        'If F_No < 0 Then

        '    If Not ignoreWarning AndAlso Teams.Rows(iRow).Item(iCol) <> "" AndAlso Teams.Rows(iRow).Item(iCol).tolower.trim <> "bye" Then

        '        QuerySave_Literal.Text = "<span style='color:red;'>WARNING: Any team left in the work area will be deleted." & vbCrLf &
        '                Teams.Rows(iRow).Item(iCol) & If(F_No > 0, "   f_no = " & F_No, "") & ", Section = " & Teams.Columns(iCol).ColumnName & vbCrLf & vbCrLf &
        '                "Click Yes to proceed with the deletion, otherwise Click No"
        '        QuerySavePanel.Visible = True

        '        Exit Sub

        '    End If

        'Else

        'If Teams.Rows(iRow).Item(iCol) = "" Then

        '    If iCol = Teams.Columns.Count - 1 Then
        '        EmptyTeamDetected = True
        '    Else
        '        errMsg = "Cannot have an empty team in the fixture slots." & vbCrLf & "   f_no = " & F_No & ", Section = " & Teams.Columns(iCol).ColumnName
        '        Exit For
        '    End If

        'Else

        '    If EmptyTeamDetected Then 'the last column has shown an empty team previously - not allowed
        '        errMsg = "Cannot have an empty team in the fixture slots." & vbCrLf & "   f_no = " & F_No & ", Section = " & Teams.Columns(iCol).ColumnName
        '        Exit For
        '    End If

        'End If

        ''End If
        '    Next

        'If errMsg <> "" Then
        '    Exit For
        'End If

        'Next

        'If errMsg <> "" Then

        '    msgBox_Literal.Text = "<span style='color:red;'>Cannot save: " & errMsg & "</span>"
        '    msgBox_Panel.Visible = True
        '    Exit Sub

        'End If

        'save changes
        For row As Integer = 0 To Teams.Rows.Count - 1

            For col As Integer = 1 To Teams.Rows(row).ItemArray.Length - 1

                Dim teamID As Integer = TeamIDs.Rows(row).Item(col)

                If Teams.Rows(row).Item(col) <> "" Then

                    Dim SectionID As Integer = TeamIDs.Columns(col).ColumnName
                    Dim FixtureNo As Integer = TeamIDs.Rows(row).Item(0)

                    Using team As New TeamData(teamID)

                        With team

                            'If Teams.Rows(row).Item(0) > 0 Then 'update
                            .SectionID = SectionID
                            .FixtureNo = FixtureNo
                            'Else                         ' In the work area, Delete it
                            '.SectionID = -1
                            'End If

                            .Merge()

                        End With

                    End Using

                End If
            Next

        Next

        'Having possibly changed the sizes of sections reassign their fixture grids.
        HBSAcodeLibrary.LeagueData.AssignFixtureGrids(League_DropDownList.SelectedValue)

        msgBox_Literal.Text = "Saved, please proceed."
        msgBox_Panel.Visible = True

    End Sub

    Protected Sub Save_Button_Click(sender As Object, e As EventArgs) Handles Save_Button.Click

        SaveTables()
        League_DropDownList_SelectedIndexChanged(sender, e)

    End Sub

    Protected Sub Refresh_Button_Click(sender As Object, e As EventArgs) Handles Refresh_Button.Click

        League_DropDownList_SelectedIndexChanged(sender, e)

    End Sub

    Private Sub ArrangeTeamsInSections_Unload(sender As Object, e As EventArgs) Handles Me.Unload

        If Session("ChangesPending") = True Then
            QuerySave_Literal.Text = "Do you want to save your changes?"
            QuerySavePanel.Visible = True
        End If

    End Sub

    Protected Sub Close_Button_Click(sender As Object, e As EventArgs) Handles Close_Button.Click

        msgBox_Panel.Visible = False

    End Sub

    Protected Function ThereAreTooManyHomeFixtures() As Boolean

        Dim ReturnValue As Boolean = False

        If League_DropDownList.SelectedIndex > 0 Then

            Using HomeFixturesTable As DataTable = HBSAcodeLibrary.TeamData.LookForTooManyHomeFixtures(League_DropDownList.SelectedValue)

                ReturnValue = (HomeFixturesTable Is Nothing OrElse HomeFixturesTable.Rows.Count > 0)

            End Using

        End If

        Return ReturnValue

    End Function

End Class