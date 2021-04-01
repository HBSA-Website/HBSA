Imports HBSAcodeLibrary
Public Class CompetitionsResults
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If IsPostBack Then

                If Request.Item("_ButtonClicked").Length > 0 Then
                    HandleButton(Request.Item("_ButtonClicked"))
                End If

                If Request.Item("_BoxChanged").Length > 0 Then
                    HandleBox(Request.Item("_BoxChanged"))
                End If
            Else

                PopulateCompetitionsDropDown()

            End If
        End If

    End Sub

    Sub PopulateCompetitionsDropDown()

        Using drawnComps As DataTable = HBSAcodeLibrary.CompetitionData.GetCompetitions(1)

            With Competitions_DropDownList
                .Items.Clear()
                .Visible = True
                .DataSource = drawnComps
                .DataTextField = "Name"
                .DataValueField = "ID"
                .DataBind()

                .Items.Insert(0, New ListItem("**Select a Competition**", 0))
                Try
                    .SelectedValue = Session("CompetitionID")
                    Competitions_DropDownList_SelectedIndexChanged(New Object, New EventArgs)
                Catch ex As Exception
                    .SelectedIndex = 0
                End Try

            End With

        End Using

    End Sub

    Protected Sub Competitions_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Competitions_DropDownList.SelectedIndexChanged

        If Competitions_DropDownList.SelectedIndex > 0 Then

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

        Status_Literal.Text = "When an entrant has won, click the >> button.<br/>" &
                              "To revert a winning player click the << button.<br/>" &
                              "To change a match note click the !! button."

        Using CompRounds As CompetitionRounds = New CompetitionRounds(Competitions_DropDownList.SelectedValue)

            Comment_Literal.Text = CompRounds.CompetitionComment(Competitions_DropDownList.SelectedValue).Replace(vbCrLf, "<br/>")

            With Competition_Table
                .Rows.Clear()
                .Visible = True

                If NoRounds = 0 Then
                    .Visible = False
                    Comment_Literal.Text += "<br/><br/><span style='color:red;'>Waiting for the draw to be made.</span>"
                Else
                    'build header row
                    Dim headerRow As New TableHeaderRow
                    With headerRow
                        For RoundIx As Integer = 0 To NoRounds
                            Dim headerCell As New TableCell With {
                                .ForeColor = Drawing.Color.DarkBlue,
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
                                        .VerticalAlign = VerticalAlign.Middle,
                                        .HorizontalAlign = HorizontalAlign.Center,
                                        .BorderColor = Drawing.Color.Black,
                                        .BorderStyle = BorderStyle.Solid,
                                        .BorderWidth = 1
                                    }

                                    'get 1st Entrant details for this cell
                                    Dim FirstEntrant As CompetitionRounds.Entrant = CompRounds.EntrantDetail(RoundIx, EntryID)
                                    'get opponent details
                                    Dim SecondEntrantID As Integer = EntryID + (2 ^ RoundIx)
                                    Dim SecondEntrant As CompetitionRounds.Entrant = CompRounds.EntrantDetail(RoundIx, SecondEntrantID)
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

                                    If Not nextRoundExists Then

                                        If Not IsNothing(FirstEntrant.name) Then 'And FirstEntrant.name <> "Bye" Then
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

                                            Cell.Controls.Add(HoverDiv)

                                        End If

                                        If Not IsNothing(FirstEntrant.name) Then 'AndAlso FirstEntrant.name <> "Bye" Then
                                            If Not IsNothing(SecondEntrant.name) Then
                                                'add promote button

                                                Dim PromoteButton As New Button()
                                                With PromoteButton
                                                    .ID = "PromoteButton_" & CStr(EntryID) + "_" + CStr(RoundIx)
                                                    .Text = ">>"
                                                    .Attributes.Add("onClick", "document.forms[0]." & "_ButtonClicked.value='" & .ID & "';document.forms[0].submit();")

                                                End With

                                                Cell.Controls.Add(PromoteButton)

                                            End If

                                            'add remove button
                                            Dim RemoveButton As New Button()
                                            With RemoveButton
                                                .ID = "RemoveButton_" & CStr(EntryID) + "_" + CStr(RoundIx)
                                                .Text = "<<"
                                                .Attributes.Add("onClick", "document.forms[0]." & "_ButtonClicked.value='" & .ID & "';document.forms[0].submit();")

                                            End With

                                            Cell.Controls.Add(RemoveButton)

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
                                        Dim note As String = CompRounds.Notes(RoundIx, EntryID, Competitions_DropDownList.SelectedValue, admin:=True)
                                        If note Is Nothing Then note = ""

                                        .Text = "<span style='color:red;'><i>" &
                                                     note.Replace(vbCrLf, "<br/>") &
                                                    "</span></i>&nbsp;&nbsp;"

                                        Cell.Controls.Add(NotesBox)

                                        Dim NotesButton As New Button()
                                        With NotesButton
                                            .ID = "NotesBox_" & CStr(EntryID) + "_" + CStr(RoundIx)
                                            .Text = "!!"
                                            .Attributes.Add("onClick", "document.forms[0]." & "_BoxChanged.value='" & .ID & "';document.forms[0].submit();")
                                        End With

                                        Cell.Controls.Add(NotesButton)
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

                                    If Not nextRoundExists Then

                                        If Not IsNothing(SecondEntrant.name) Then 'AndAlso SecondEntrant.name <> "Bye" Then
                                            ' Add hover div for contact info.
                                            Dim HoverDiv As New HtmlGenericControl("div class='hoverDiv'")
                                            With HoverDiv
                                                .ID = HoverDivID
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

                                            Cell.Controls.Add(HoverDiv)

                                        End If

                                        If Not IsNothing(SecondEntrant.name) Then 'AndAlso SecondEntrant.name <> "Bye" Then
                                            If Not IsNothing(FirstEntrant.name) Then

                                                'add promote button
                                                Dim PromoteButton As New Button()
                                                With PromoteButton
                                                    .ID = "PromoteButton_" & CStr(SecondEntrantID) + "_" + CStr(RoundIx)
                                                    .Text = ">>"
                                                    .Attributes.Add("onClick", "document.forms[0]." & "_ButtonClicked.value='" & .ID & "';document.forms[0].submit();")

                                                End With

                                                Cell.Controls.Add(PromoteButton)

                                            End If

                                            'add remove button
                                            Dim RemoveButton As New Button()
                                            With RemoveButton
                                                .ID = "RemoveButton_" & CStr(SecondEntrantID) + "_" + CStr(RoundIx)
                                                .Text = "<<"
                                                .Attributes.Add("onClick", "document.forms[0]." & "_ButtonClicked.value='" & .ID & "';document.forms[0].submit();")

                                            End With

                                            Cell.Controls.Add(RemoveButton)

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

    Sub HandleButton(ButtonValue As String)

        Try
            Dim ButtonItems() As String = ButtonValue.Split("_")
            Dim Command = ButtonItems(0).Replace("Button", "")  'Promote or Remove
            Dim EntryID As Integer = CInt(ButtonItems(1))
            Dim RoundNo As Integer = CInt(ButtonItems(2))

            Using Comp As New CompetitionData(Competitions_DropDownList.SelectedValue)

                If Command = "Promote" Then
                    Comp.PromoteCompetitionEntry(EntryID, RoundNo)
                Else
                    Comp.RemoveCompetitionEntry(EntryID, RoundNo)
                End If

                BuildCompetitionTable(Comp.ID, Comp.Name, Comp.NoRounds)

            End Using

        Catch ex As Exception

            Status_Literal.Text = "<span style='color:red;'>There was a database error.  Please contact the web master:<br/><br/>" & ex.ToString & "</span>"

        End Try

    End Sub

    Sub HandleBox(BoxValue As String)

        Dim BoxItems() As String = BoxValue.Split("_")
        Dim EntryID As Integer = CInt(BoxItems(1))
        Dim RoundNo As Integer = CInt(BoxItems(2))

        Using CompRounds As New CompetitionRounds
            Dim oldNote As String = CompRounds.Notes(RoundNo, EntryID, Competitions_DropDownList.SelectedValue)
            Note_TextBox.Text = oldNote
        End Using

        Note_TextBox.Attributes.Add("Style", "text-align:center")
        ID_TextBox.Text = CStr(EntryID) & "_" & CStr(RoundNo)

        Edit_Literal.Text = "Enter any changes required to the note and click Submit.  When satisfied click Close.<br/>" &
                          "Note that if the note is made blank it will revert to the round's play by date, if it exists."

        Edit_Panel.Visible = True

    End Sub

    Protected Sub SubmitPlayer_Button_Click(sender As Object, e As EventArgs) Handles SubmitPlayer_Button.Click

        Dim BoxItems() As String = ID_TextBox.Text.Split("_")
        Dim EntryID As Integer = CInt(BoxItems(0))
        Dim RoundNo As Integer = CInt(BoxItems(1))

        Try
            'create/amend (merge) note for this match
            HBSAcodeLibrary.CompetitionRounds.MergeNote(Competitions_DropDownList.SelectedValue, RoundNo, EntryID, Note_TextBox.Text.Trim)
            Edit_Literal.Text = "Match note changed. Either click Close to exit, or try again."

        Catch ex As Exception

            Edit_Literal.Text = "<span style='color:red;'>There was a database error.  Please contact the web master:<br/><br/>" & ex.ToString & "</span>"

        End Try

    End Sub

    Protected Sub Close_Button_Click(sender As Object, e As EventArgs) Handles Close_Button.Click

        Edit_Panel.Visible = False

        Using Comp As New CompetitionData(Competitions_DropDownList.SelectedValue)

            BuildCompetitionTable(Comp.ID, Comp.Name, Comp.NoRounds)

        End Using
    End Sub

End Class