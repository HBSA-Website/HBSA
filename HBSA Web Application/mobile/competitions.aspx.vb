
Imports HBSAcodeLibrary

Public Class competitions1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            populateCompetitionsDropDown()

        End If

    End Sub

    Sub PopulateCompetitionsDropDown()


        Using CompetitionsTable As DataTable = HBSAcodeLibrary.CompetitionData.GetCompetitions()

            With Competitions_DropDownList
                .Items.Clear()
                .Visible = True
                .Enabled = True

                If CompetitionsTable.Rows.Count > 0 Then

                    .Items.Add(New ListItem("**Select a Competition**", 0))

                    For Each row As DataRow In CompetitionsTable.Rows
                        .Items.Add(New ListItem(row.Item("Name"), row.Item("ID")))
                    Next

                    Try
                        .SelectedValue = CInt(Request.Params("CompetitionID"))
                        Competitions_DropDownList_SelectedIndexChanged(New Object, New EventArgs)
                    Catch ex As Exception
                        .SelectedIndex = 0
                    End Try

                Else

                    .Items.Add(New ListItem("** No Competitions have been drawn yet. **", 0))
                    .Enabled = False

                End If

            End With

        End Using

    End Sub

    Protected Sub Competitions_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) _
        Handles Competitions_DropDownList.SelectedIndexChanged

        If Competitions_DropDownList.SelectedValue > 0 Then

            Using Comp As New CompetitionData(Competitions_DropDownList.SelectedValue)

                BuildCompetitionTable(Comp.ID, Comp.Name, Comp.NoRounds)

            End Using

        Else

            With Competition_Table
                .Rows.Clear()
                .Visible = False
            End With

        End If

    End Sub

    Sub BuildCompetitionTable(ByVal ID As Integer, ByVal Name As String, ByVal NoRounds As Integer)

        Using CompRounds As CompetitionRounds = New CompetitionRounds(Competitions_DropDownList.SelectedValue)

            Comment_Literal.Text = CompRounds.CompetitionComment(Competitions_DropDownList.SelectedValue).Replace(vbCrLf, "<br/>")

            With Competition_Table

                If NoRounds = 0 Then

                    If Competitions_DropDownList.SelectedItem.Text.ToLower Like "*junior*" Then
                        Response.Redirect("../JuniorsComp2.aspx")

                        'ElseIf Competitions_DropDownList.SelectedValue = 13 Then
                        '    Response.Redirect("VetsPlayoff.aspx")

                    Else
                        .Visible = False
                        Comment_Literal.Text += "<br/><br/><span style='color:red;'>Waiting for the draw to be made.</span>"

                    End If

                Else

                    .Rows.Clear()
                    .Visible = True

                    For RoundIX As Integer = NoRounds To 0 Step -1 'start at the last round (winner)

                        Dim RoundTable As DataTable = CompRounds.CompetitionDetailsData.Tables(RoundIX)
                        If RoundTable.Rows.Count > 0 Then
                            'build round header into a row
                            Dim headerRow As New TableHeaderRow
                            With headerRow
                                Dim headerCell As TableCell = EntrantRowCell()
                                headerCell.ColumnSpan = 3
                                headerCell.ForeColor = Drawing.Color.White
                                headerCell.BackColor = Drawing.Color.DarkGreen

                                headerCell.Text = "<strong>"
                                Select Case RoundIX
                                    Case NoRounds
                                        headerCell.Text += "Winner"
                                    Case NoRounds - 1
                                        headerCell.Text += "Final"
                                    Case NoRounds - 2
                                        headerCell.Text += "Semi-Final"
                                    Case Else
                                        headerCell.Text += "Round " & (RoundIX + 1)
                                End Select
                                headerCell.Text += "</strong>"

                                Dim RoundHeaderData As CompetitionRounds.RoundHeader = CompRounds.GetRoundHeader(RoundIX)
                                If Not RoundHeaderData.PlayByDate.Trim = "" Then
                                    headerCell.Text += "<i><small> To be played " & If(RoundIX = NoRounds - 1, "on ", "by ") & RoundHeaderData.PlayByDate & "</small></i>"
                                End If

                                If Not RoundHeaderData.Comment.Trim = "" Then
                                    headerCell.Text += "<small> " & RoundHeaderData.Comment & "</small>"
                                End If

                                .Cells.Add(headerCell)
                            End With

                            .Rows.Add(headerRow)

                            Dim entrantIX As Integer = 0
                            While entrantIX < (RoundTable.Rows.Count)
                                Dim EntrantRow As New TableRow
                                Dim nextRoundExists As Boolean

                                Dim Entrant1Cell As TableCell = EntrantRowCell()
                                If RoundIX = NoRounds Then
                                    Entrant1Cell.ColumnSpan = 3
                                End If
                                'first entrant detail

                                Dim EntryID As Integer = RoundTable.Rows(entrantIX).Item("EntryID")
                                Dim roundNo As Integer = RoundTable.Rows(entrantIX).Item("RoundNo")
                                Dim FirstEntrant As HBSAcodeLibrary.CompetitionRounds.Entrant = Nothing

                                If (EntryID / (2 ^ roundNo)) Mod 2 = 0 Then 'Check that this entrant is home player
                                    FirstEntrant = CompRounds.EntrantDetail(RoundIX, RoundTable.Rows(entrantIX).Item("EntryID"))

                                    'get next round details (if they exist)
                                    Dim NextID As Integer = Int((EntryID / (2 ^ RoundIX) / 2)) * (2 ^ (RoundIX + 1)) 'floor((@i / power(2,@r))/2)*power(2,@r+1)
                                    nextRoundExists = Not IsNothing(CompRounds.EntrantDetail(RoundIX + 1, NextID).name)
                                    'setup 1st entrant cell
                                    Dim EntrantDiv As New HtmlGenericControl("span")
                                    Dim HoverDivID As String = "HoverDiv" & Format(EntryID, "000") & Format(RoundIX, "000")
                                    If Not IsNothing(FirstEntrant.name) AndAlso Not nextRoundExists Then
                                        EntrantDiv.Attributes.Add("onmouseout", "hideHoverDiv(""" & HoverDivID & """);")
                                        EntrantDiv.Attributes.Add("onmouseover", "this.style.cursor=""pointer"";loadHoverDiv(""" & HoverDivID & """);")
                                    End If
                                    EntrantDiv.InnerHtml = If(IsNothing(FirstEntrant.name), "", FirstEntrant.name)

                                    Entrant1Cell.Controls.Add(EntrantDiv)
                                    entrantIX += 1 'having found an entrant step to the next one

                                    ' add hover div if needed
                                    If Not nextRoundExists And FirstEntrant.name <> "Bye" Then

                                        If Not IsNothing(FirstEntrant.name) Then
                                            ' Add hover div for contact info.
                                            Dim HoverDiv As New HtmlGenericControl("div class='hoverDiv'")
                                            With HoverDiv
                                                .ID = HoverDivID
                                                If FirstEntrant.TelNo <> "" Then
                                                    .InnerHtml = "TelNo: " & FirstEntrant.TelNo
                                                End If
                                                If FirstEntrant.eMail <> "" Then
                                                    If FirstEntrant.TelNo <> "" Then
                                                        .InnerHtml += "<br />"
                                                    End If
                                                    .InnerHtml += "email: " & FirstEntrant.eMail
                                                End If

                                            End With

                                            Entrant1Cell.Controls.Add(HoverDiv)

                                        End If

                                    End If

                                End If

                                EntrantRow.Cells.Add(Entrant1Cell)

                                'Comments Cell
                                Dim CommentCell As TableCell = EntrantRowCell()
                                CommentCell.CssClass = "noteBox"
                                Dim NotesBox As New Literal
                                With NotesBox
                                    '.ID = "NotesBox_" & CStr(EntryID) + "_" + CStr(RoundIx)
                                    Dim note As String = CompRounds.Notes(RoundIX, EntryID, Competitions_DropDownList.SelectedValue)
                                    If note Is Nothing Then note = ""

                                    .Text = "<span class=noteBox>" &
                                                     note.Replace(vbCrLf, "<br/>") &
                                            "</span>"

                                    CommentCell.Controls.Add(NotesBox)

                                End With

                                EntrantRow.Cells.Add(CommentCell)

                                '2nd entrant cell
                                Dim Entrant2Cell As TableCell = EntrantRowCell()

                                If entrantIX < (RoundTable.Rows.Count) Then

                                    If RoundTable.Rows(entrantIX).Item("EntryID") = EntryID + (2 ^ roundNo) _
                                        OrElse IsNothing(FirstEntrant.name) Then 'Check there is an opponent for this slot

                                        EntryID = RoundTable.Rows(entrantIX).Item("EntryID")
                                        Dim SecondEntrantID As Integer = RoundTable.Rows(entrantIX).Item("EntryID")
                                        Dim SecondEntrant As HBSAcodeLibrary.CompetitionRounds.Entrant = CompRounds.EntrantDetail(RoundIX, RoundTable.Rows(entrantIX).Item("EntryID"))

                                        Dim HoverDiv2ID As String = "HoverDiv" & Format(EntryID, "000") & Format(RoundIX, "000") & "opponent"
                                        Dim OpponentDiv As New HtmlGenericControl("span")
                                        If Not IsNothing(SecondEntrant.name) AndAlso SecondEntrant.name <> "Bye" AndAlso Not nextRoundExists Then
                                            OpponentDiv.Attributes.Add("onmouseout", "hideHoverDiv(""" & HoverDiv2ID & """);")
                                            OpponentDiv.Attributes.Add("onmouseover", "this.style.cursor=""pointer"";loadHoverDiv(""" & HoverDiv2ID & """);")
                                        End If

                                        OpponentDiv.InnerHtml = "<br />" & If(IsNothing(SecondEntrant.name), "", SecondEntrant.name)

                                        Entrant2Cell.Controls.Add(OpponentDiv)

                                        If Not IsNothing(SecondEntrant.name) AndAlso SecondEntrant.name <> "Bye" Then
                                            ' Add hover div for contact info.
                                            Dim HoverDiv As New HtmlGenericControl("div Class='hoverDiv'")
                                            With HoverDiv
                                                .ID = HoverDiv2ID
                                                If SecondEntrant.TelNo <> "" Then
                                                    .InnerHtml = "TelNo: " & SecondEntrant.TelNo
                                                End If
                                                If SecondEntrant.eMail <> "" Then
                                                    If SecondEntrant.TelNo <> "" Then
                                                        .InnerHtml += "<br />"
                                                    End If
                                                    .InnerHtml += "email: " & SecondEntrant.eMail
                                                End If

                                            End With

                                            Entrant2Cell.Controls.Add(HoverDiv)

                                        End If

                                        entrantIX += 1 'having found an entrant step to the next one

                                    End If

                                End If

                                EntrantRow.Cells.Add(Entrant2Cell)

                                .Rows.Add(EntrantRow)

                            End While

                        End If

                    Next

                End If

            End With

        End Using

    End Sub

    Function EntrantRowCell() As TableCell
        Dim Cell As New TableCell With {
            .ForeColor = Drawing.Color.DarkGreen,
            .VerticalAlign = VerticalAlign.Middle,
            .HorizontalAlign = HorizontalAlign.Center,
            .BorderColor = Drawing.Color.Black,
            .BorderStyle = BorderStyle.Solid,
            .BorderWidth = 1,
            .CssClass = "entrantBox"
        }
        Cell.Font.Size = 28

        Return Cell

    End Function

End Class