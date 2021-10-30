Public Class Awards
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            populateReports(sender, e)
        Else
            'WinnerCell_TextBox.Text = ""
        End If

    End Sub

    Sub PopulateReports(ByVal sender As Object, ByVal e As System.EventArgs)

        With Report_DropDownList

            Dim AwardTypes As DataTable = HBSAcodeLibrary.AwardsTemplate.AwardTypes

            .Items.Clear()

            .DataSource = AwardTypes
            .DataTextField = "Description"
            .DataValueField = "AwardType"
            .DataBind()

            .Items.Insert(0, New ListItem("**All types**", "0"))

            .SelectedIndex = 0
            Report_DropDownList_SelectedIndexChanged(sender, e)

        End With

    End Sub

    Private Sub Report_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) _
            Handles Report_DropDownList.SelectedIndexChanged

        Status_Literal.Text = ""

        With Awards_GridView
            Using _Awards As New HBSAcodeLibrary.AwardsObj

                Dim AwardsReport As DataTable = _Awards.Report(Report_DropDownList.SelectedValue)

                .DataSource = AwardsReport
                .DataBind()

                ExportCells.Visible = AwardsReport.Rows.Count > 0

                Session("AwardsReport") = AwardsReport

            End Using

        End With

    End Sub

    Private Sub Awards_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Awards_GridView.RowDataBound

        For ix = 6 To e.Row.Cells.Count - 1
            e.Row.Cells(ix).Visible = False
        Next

    End Sub

    Protected Sub Generate_Button_Click(sender As Object, e As EventArgs) Handles Generate_Button.Click

        Using _Awards As New HBSAcodeLibrary.AwardsObj
            _Awards.Generate(Report_DropDownList.SelectedValue)
        End Using

        Report_DropDownList_SelectedIndexChanged(sender, e)
        Status_Literal.Text = "A new table of award winners generated."

    End Sub

    Private Sub FillEditPanel(gRow As GridViewRow)

        With gRow
            LeagueCell.InnerText = .Cells(1).Text
            CompetitionCell.InnerText = .Cells(2).Text
            TrophyCell.InnerText = .Cells(3).Text.Replace("&nbsp;", "").Replace("&amp;", "&")
            AwardCell.InnerText = .Cells(5).Text
            AwardType_HiddenField.Value = .Cells(6).Text
            AwardID_HiddenField.Value = If(.Cells(7).Text = "&nbsp;", "", .Cells(7).Text)
            SubID_HiddenField.Value = If(.Cells(8).Text = "&nbsp;", "", .Cells(8).Text)
            LeagueID_HiddenField.Value = .Cells(9).Text
        End With

    End Sub

    Private Sub Awards_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Awards_GridView.RowDeleting

        FillEditPanel(Awards_GridView.Rows(e.RowIndex))
        WinnerCell_TextBox.Text = Awards_GridView.Rows(e.RowIndex).Cells(4).Text.Replace("&nbsp;", "").Replace("&amp;", "&")
        WinnerCell_TextBox.Enabled = False
        EntrantID_HiddenField.Value = Awards_GridView.Rows(e.RowIndex).Cells(10).Text
        Entrant2ID_HiddenField.Value = Awards_GridView.Rows(e.RowIndex).Cells(11).Text.Replace("&nbsp;", "")
        EditPanel_Literal.Text = "Delete&nbsp;a&nbsp;winner"
        EditPanel_Literal2.Text = "Click 'Delete' to confirm you wish to remove this winner from the table."
        AvailableAwards_DropDownList.Visible = False

        Submit_Button.Text = "Delete"
        Submit_Button.Visible = True

        Edit_Panel.Visible = True

        e.Cancel = True

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        Edit_Panel.Visible = False

    End Sub

    Private Sub Awards_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles Awards_GridView.RowEditing

        FillEditPanel(Awards_GridView.Rows(e.NewEditIndex))

        EditPanel_Literal.Text = "Edit&nbsp;a&nbsp;winner"
        EditPanel_Literal2.Text = "Make any changes then click 'Submit' to make the changes, otherwise click 'Cancel'."
        WinnerCell_TextBox.Text = ""
        WinnerCell_TextBox.Enabled = True
        Submit_Button.Text = "Submit"
        Submit_Button.Visible = True
        AvailableAwards_DropDownList.Visible = False

        Edit_Panel.Visible = True

        e.Cancel = True

    End Sub

    <System.Web.Script.Services.ScriptMethod>
    <System.Web.Services.WebMethod>
    Public Shared Function SuggestWinners(ByVal prefixText As String, ByVal count As Integer, ByVal contextKey As String) As List(Of String)

        Dim params() As String = contextKey.Split("|")
        Dim AwardType As Integer = CInt(params(0))
        Dim AwardID As Integer = If(params(1) = "", Nothing, CInt(params(1)))
        Dim SubID As Integer = If(params(2) = "", Nothing, CInt(params(2)))
        Dim LeagueID As Integer = CInt(params(3))

        Return HBSAcodeLibrary.AwardsObj.GetSuggestedWinners(prefixText,
                                                       count,
                                                       AwardType,
                                                       AwardID,
                                                       LeagueID)

    End Function

    Protected Sub Submit_Button_Click(sender As Object, e As EventArgs) _
            Handles Submit_Button.Click

        If Submit_Button.Text = "Submit" Then
            Using _awards As New HBSAcodeLibrary.AwardsObj()
                _awards.Update(AwardType_HiddenField.Value,
                              AwardID_HiddenField.Value,
                              SubID_HiddenField.Value,
                              LeagueID_HiddenField.Value,
                              EntrantID_HiddenField.Value,
                              Entrant2ID_HiddenField.Value
                             )
                Status_Literal.Text = WinnerCell_TextBox.Text & " awarded " & CompetitionCell.InnerText
            End Using
        ElseIf Submit_Button.Text = "Delete" Then
            Using _awards As New HBSAcodeLibrary.AwardsObj()
                _awards.Delete(AwardType_HiddenField.Value,
                              AwardID_HiddenField.Value,
                              SubID_HiddenField.Value,
                              LeagueID_HiddenField.Value,
                              EntrantID_HiddenField.Value
                         )
            End Using
            Status_Literal.Text = WinnerCell_TextBox.Text & " deleted as " & CompetitionCell.InnerText

        ElseIf Submit_Button.Text = "Award Winner" Then
            Using _awards As New HBSAcodeLibrary.AwardsObj()

                Try
                    _awards.Insert(AwardType_HiddenField.Value,
                                  AwardID_HiddenField.Value,
                                  SubID_HiddenField.Value,
                                  LeagueID_HiddenField.Value,
                                  EntrantID_HiddenField.Value,
                                  Entrant2ID_HiddenField.Value
                                 )
                    Status_Literal.Text = WinnerCell_TextBox.Text & " awarded " & CompetitionCell.InnerText

                Catch ex As Exception

                    If ex.Message Like "*Warning*" Then
                        Status_Literal.Text += "<br/><span style='color:red;'>WARNING there is now more than one recipient for this award</span>"
                    Else
                        Status_Literal.Text += "<br/><span style='color:red'>ERROR: " & ex.Message & "</span>"
                    End If

                End Try

            End Using

        End If

        Edit_Panel.Visible = False
        Dim saved As String = Status_Literal.Text
        Report_DropDownList_SelectedIndexChanged(sender, e)
        Status_Literal.Text = saved

    End Sub

    Protected Sub AddWinner_Button_Click(sender As Object, e As EventArgs) Handles AddWinner_Button.Click

        LeagueCell.InnerText = ""
        CompetitionCell.InnerText = ""
        TrophyCell.InnerText = ""
        AwardCell.InnerText = ""
        AwardType_HiddenField.Value = ""
        AwardID_HiddenField.Value = ""
        SubID_HiddenField.Value = ""
        LeagueID_HiddenField.Value = ""

        EditPanel_Literal.Text = "Add&nbsp;a&nbsp;winner"
        EditPanel_Literal2.Text = "Select an available Award, otherwise click 'Cancel'."
        WinnerCell_TextBox.Enabled = False
        WinnerCell_TextBox.Text = ""

        Submit_Button.Text = ""
        Submit_Button.Visible = False

        'populate available awards
        With AvailableAwards_DropDownList

            .Items.Clear()
            .Items.Add("**Select an available award**")
            Dim AvailableAwards As DataTable = HBSAcodeLibrary.AwardsTemplate.AvailableAwards()
            For Each dRow As DataRow In AvailableAwards.Rows
                .Items.Add(New ListItem(dRow.Item("Competition"),
                                        dRow.Item("League Name") & "|" & dRow.Item("awardType") & "|" &
                                            dRow.Item("AwardID") & "|" & dRow.Item("SubID") & "|" & dRow.Item("LeagueID") & "|" &
                                            dRow.Item("Trophy") & "|" & dRow.Item("Award")))
            Next

            .Visible = True

        End With

        Edit_Panel.Visible = True

    End Sub

    Protected Sub AvailableAwards_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles AvailableAwards_DropDownList.SelectedIndexChanged

        Dim AvailableField() As String = AvailableAwards_DropDownList.SelectedItem.Value.Split("|")

        LeagueCell.InnerText = availableField(0)
        CompetitionCell.InnerText = AvailableAwards_DropDownList.SelectedItem.Text
        TrophyCell.InnerText = AvailableField(5)
        AwardCell.InnerText = AvailableField(6)
        AwardType_HiddenField.Value = AvailableField(1)
        AwardID_HiddenField.Value = AvailableField(2)
        SubID_HiddenField.Value = AvailableField(3)
        LeagueID_HiddenField.Value = AvailableField(4)

        EditPanel_Literal.Text = "Add&nbsp;a&nbsp;winner"
        EditPanel_Literal2.Text = "Start entering the winner, select the desired one then click Award Winner, otherwise click 'Cancel'."
        WinnerCell_TextBox.Enabled = True

        Submit_Button.Text = "Award Winner"
        Submit_Button.Visible = True

    End Sub

End Class