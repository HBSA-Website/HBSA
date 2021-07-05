Imports HBSAcodeLibrary


Public Class Competitions
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            PopulateCompetitionsDropDown()

            AccessCode_Panel.Visible = Not Utilities.ViewContactDetailsAccessible()

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

    Protected Sub Competitions_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Competitions_DropDownList.SelectedIndexChanged

        If Competitions_DropDownList.SelectedValue > 0 Then

            Using Comp As New CompetitionData(Competitions_DropDownList.SelectedValue)

                BuildCompetitionTable(Comp.ID, Comp.Name, Comp.NoRounds)

            End Using

        Else

            With Competition_Table
                .Rows.Clear()
                .Visible = False
            End With

            Comment_Literal.Text = ""

        End If

    End Sub

    Sub BuildCompetitionTable(ByVal ID As Integer, ByVal Name As String, ByVal NoRounds As Integer)

        Using CompRounds As CompetitionRounds = New CompetitionRounds(Competitions_DropDownList.SelectedValue)

            Comment_Literal.Text = CompRounds.CompetitionComment(Competitions_DropDownList.SelectedValue).Replace(vbCrLf, "<br/>")

            With Competition_Table

                If NoRounds = 0 Then

                    If Competitions_DropDownList.SelectedItem.Text.ToLower Like "*junior*" Then
                        Response.Redirect("JuniorsComp2.aspx")

                        'ElseIf Competitions_DropDownList.SelectedValue = 13 Then
                        '    Response.Redirect("VetsPlayoff.aspx")

                    Else
                        .Visible = False
                        Comment_Literal.Text += "<br/><br/><span style='color:red;'>Waiting for the draw to be made.</span>"

                    End If

                Else

                    .Rows.Clear()
                    .Visible = True

                    'build header row
                    Dim headerRow As New TableHeaderRow
                    With headerRow
                        For RoundIx As Integer = 0 To NoRounds
                            Dim headerCell As New TableCell With {
                                .ForeColor = Drawing.Color.DarkGreen,
                                .VerticalAlign = VerticalAlign.Middle,
                                .HorizontalAlign = HorizontalAlign.Center,
                                .BorderColor = Drawing.Color.Black,
                                .BorderStyle = BorderStyle.Solid,
                                .BorderWidth = 1,
                                .Text = "<strong>"
                            }
                            Select Case RoundIx
                                Case NoRounds
                                    headerCell.Text += "Winner"
                                Case NoRounds - 1
                                    headerCell.Text += "Final"
                                Case NoRounds - 2
                                    headerCell.Text += "Semi-Final"
                                Case Else
                                    headerCell.Text += "Round " & (RoundIx + 1)
                            End Select
                            headerCell.Text += "</strong>"

                            Dim RoundHeaderData As CompetitionRounds.RoundHeader = CompRounds.GetRoundHeader(RoundIx)
                            If Not RoundHeaderData.PlayByDate.Trim = "" Then
                                headerCell.Text += "</br><i><small>To be played " & If(RoundIx = NoRounds - 1, "on ", "by ") & RoundHeaderData.PlayByDate & "</small></i>"
                            End If

                            If Not RoundHeaderData.Comment.Trim = "" Then
                                headerCell.Text += "</br><small>" & RoundHeaderData.Comment & "</small>"
                            End If

                            .Cells.Add(headerCell)
                        Next
                    End With

                    .Rows.Add(headerRow)

                    'build rounds and entries
                    For EntryID As Integer = 0 To 2 ^ NoRounds - 1

                        Dim Row As New TableRow
                        With Row
                            For RoundIx As Integer = 0 To NoRounds
                                If (EntryID Mod 2 ^ RoundIx) = 0 AndAlso (EntryID / 2 ^ RoundIx) Mod 2 = 0 Then

                                    Dim Cell As New TableCell With {
                                        .RowSpan = 2 ^ RoundIx,
                                        .ForeColor = Drawing.Color.DarkGreen,
                                        .VerticalAlign = VerticalAlign.Middle,
                                        .HorizontalAlign = HorizontalAlign.Center,
                                        .BorderColor = Drawing.Color.Black,
                                        .BorderStyle = BorderStyle.Solid,
                                        .BorderWidth = 1
                                    }

                                    'get 1st Entrant details for this cell
                                    Dim FirstEntrant As HBSAcodeLibrary.CompetitionRounds.Entrant = CompRounds.EntrantDetail(RoundIx, EntryID)
                                    'get opponent details
                                    Dim SecondEntrantID As Integer = EntryID + (2 ^ RoundIx)
                                    Dim SecondEntrant As HBSAcodeLibrary.CompetitionRounds.Entrant = CompRounds.EntrantDetail(RoundIx, SecondEntrantID)
                                    'get next round details (if they exist)
                                    Dim NextID As Integer = Int((EntryID / (2 ^ RoundIx) / 2)) * (2 ^ (RoundIx + 1)) 'floor((@i / power(2,@r))/2)*power(2,@r+1)
                                    Dim nextRoundExists As Boolean = Not IsNothing(CompRounds.EntrantDetail(RoundIx + 1, NextID).name)

                                    Dim HoverDivID As String = "HoverDiv" & Format(EntryID, "000") & Format(RoundIx, "000")
                                    Dim EntrantDiv As New HtmlGenericControl("span")
                                    If Not IsNothing(FirstEntrant.name) AndAlso Not nextRoundExists Then
                                        EntrantDiv.Attributes.Add("onmouseout", "hideHoverDiv(""ContentPlaceHolder1_" & HoverDivID & """);")
                                        EntrantDiv.Attributes.Add("onmouseover", "this.style.cursor=""pointer"";loadHoverDiv(""ContentPlaceHolder1_" & HoverDivID & """);")
                                    End If
                                    EntrantDiv.InnerHtml = If(IsNothing(FirstEntrant.name), "", FirstEntrant.name)

                                    Cell.Controls.Add(EntrantDiv)

                                    If Not nextRoundExists And FirstEntrant.name <> "Bye" Then

                                        If Not IsNothing(FirstEntrant.name) Then
                                            ' Add hover div for contact info.
                                            Dim HoverDiv As New HtmlGenericControl("div class='hoverDiv'")
                                            With HoverDiv
                                                .ID = HoverDivID
                                                If Utilities.ViewContactDetailsAccessible Then
                                                    If FirstEntrant.TelNo <> "" Then
                                                        .InnerHtml = "TelNo: " & FirstEntrant.TelNo
                                                    End If
                                                    If FirstEntrant.eMail <> "" Then
                                                        If FirstEntrant.TelNo <> "" Then
                                                            .InnerHtml += "<br />"
                                                        End If
                                                        .InnerHtml += "email: " & FirstEntrant.eMail
                                                    End If
                                                Else
                                                    'Need access code to view
                                                    .InnerHtml = "<p style='color:red;font-weight:bold '>Access code Required for Players' eMail addresses and telephone numbers</p>" &
                                                                  "<br/>Use the dialogue at the top of the page to enter this code, then try again.<br/>" &
                                                                 "<i>Note: If the panel is not visible refresh this page.</i><br><br/>"
                                                End If

                                            End With

                                            Cell.Controls.Add(HoverDiv)

                                        End If

                                    End If

                                    'add any notes
                                    Dim NotesLiteral As New Literal With {
                                        .Text = "<br />"
                                    }
                                    Cell.Controls.Add(NotesLiteral)
                                    Dim NotesBox As New Literal
                                    With NotesBox
                                        '.ID = "NotesBox_" & CStr(EntryID) + "_" + CStr(RoundIx)
                                        Dim note As String = CompRounds.Notes(RoundIx, EntryID, Competitions_DropDownList.SelectedValue)
                                        If note Is Nothing Then note = ""

                                        .Text = "<span style='color:red;'><i>" &
                                                     note.Replace(vbCrLf, "<br/>") &
                                                    "</span></i>&nbsp;&nbsp;"

                                        Cell.Controls.Add(NotesBox)

                                    End With

                                    'add opponent details
                                    HoverDivID += "opponent"
                                    Dim OpponentDiv As New HtmlGenericControl("span")
                                    If Not IsNothing(SecondEntrant.name) AndAlso SecondEntrant.name <> "Bye" AndAlso Not nextRoundExists Then
                                        OpponentDiv.Attributes.Add("onmouseout", "hideHoverDiv(""ContentPlaceHolder1_" & HoverDivID & """);")
                                        OpponentDiv.Attributes.Add("onmouseover", "this.style.cursor=""pointer"";loadHoverDiv(""ContentPlaceHolder1_" & HoverDivID & """);")
                                    End If

                                    OpponentDiv.InnerHtml = "<br />" & If(IsNothing(SecondEntrant.name), "", SecondEntrant.name)

                                    Cell.Controls.Add(OpponentDiv)

                                    If Not nextRoundExists And FirstEntrant.name <> "Bye" Then

                                        If Not IsNothing(SecondEntrant.name) AndAlso SecondEntrant.name <> "Bye" Then
                                            ' Add hover div for contact info.
                                            Dim HoverDiv As New HtmlGenericControl("div class='hoverDiv'")
                                            With HoverDiv
                                                .ID = HoverDivID
                                                If Utilities.ViewContactDetailsAccessible Then
                                                    If SecondEntrant.TelNo <> "" Then
                                                        .InnerHtml = "TelNo: " & SecondEntrant.TelNo
                                                    End If
                                                    If SecondEntrant.eMail <> "" Then
                                                        If SecondEntrant.TelNo <> "" Then
                                                            .InnerHtml += "<br />"
                                                        End If
                                                        .InnerHtml += "email: " & SecondEntrant.eMail
                                                    End If
                                                Else
                                                    'Need access code to view
                                                    .InnerHtml = "<p style='color:red;font-weight:bold '>Access code Required for Players' eMail addresses and telephone numbers</p>" &
                                                                 "<br/>Use the dialogue at the top of the page to enter this code, then try again.<br/>" &
                                                                 "<i>Note: If the panel is not visible refresh this page.</i><br><br/>"
                                                End If

                                            End With

                                            Cell.Controls.Add(HoverDiv)

                                        End If

                                    End If

                                    .Cells.Add(Cell)

                                End If

                            Next

                        End With

                        If Row.Controls.Count > 0 Then
                            .Rows.Add(Row)
                        End If

                    Next

                End If

            End With

        End Using

    End Sub
    Protected Sub AccessCode_Button_Click(sender As Object, e As EventArgs) Handles AccessCode_Button.Click

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
    'Function entrant(RoundIx As Integer, EntrantID As Integer, ByRef CompetitionDetails As DataSet) As String

    '    If RoundIx < CompetitionDetails.Tables.Count Then
    '        Dim EntryDetails() As DataRow = CompetitionDetails.Tables(RoundIx).Select("ID = " & CStr(EntrantID))
    '        If EntryDetails.Count > 0 Then
    '            entrant = EntryDetails(0).Item("Entrant")
    '            If Not IsDBNull(EntryDetails(0).Item("Entrant2")) Then
    '                If EntryDetails(0).Item("Entrant2").length > 0 Then
    '                    entrant += "/" + EntryDetails(0).Item("Entrant2")
    '                End If
    '            End If
    '        Else
    '            entrant = Nothing
    '        End If
    '    Else
    '        entrant = Nothing
    '    End If

    'End Function

End Class