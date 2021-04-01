Imports HBSAcodeLibrary

Public Class ArrangeEntrantsInCompetition
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If IsPostBack Then

            PerformAction()
            'populateTeams()

        Else

            populateLeagueDropDpwnList()

            Session("ChangesPending") = False

        End If

    End Sub

    Protected Sub PopulateLeagueDropDpwnList()

        Dim competitions As DataTable = HBSAcodeLibrary.CompetitionData.GetCompetitions

        With Competitions_DropDownList

            .Items.Clear()

            .DataSource = competitions
            .DataTextField = "Name"
            .DataValueField = "ID"
            .DataBind()
            .Items.Insert(0, New ListItem("**Select Competition**", "0"))

        End With

    End Sub

    Protected Sub Competitions_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Competitions_DropDownList.SelectedIndexChanged

        If Session("ChangesPending") = True Then
            QuerySavePanel.Visible = True
        Else

            Using Comp As New HBSAcodeLibrary.CompetitionRounds(Competitions_DropDownList.SelectedValue)

                If Comp.CompetitionDetailsData.Tables(1).Rows.Count > 1 Then

                    Dim CompName As String = New CompetitionData(Competitions_DropDownList.SelectedValue).Name
                    Confirm_Literal.Text = "This competition (" & CompName &
                                                         ") has matches already recorded (could be byes).  <br /><br />If you need to rearrange entries Click Confirm.  " &
                                                         "This will remove any results and take the competition back to the first round. <br/><br/> " &
                                                         "After having done this and/or having made any rearrangements go to the competitions results page and promote any byes/winners.<br/><br/>Otherwise Click Cancel"

                    Confirm_Panel.Visible = True

                    Session("Confirm") = "Confirm Baseline"

                Else

                    Session("CompetitionRound1Entries") = HBSAcodeLibrary.CompetitionRounds.GetCompetitionRound1Data(Competitions_DropDownList.SelectedValue)
                    Session("ChangesPending") = False

                    PopulateEntries()

                End If

            End Using

        End If

    End Sub

    Protected Sub CancelConfirm_Button_Click(sender As Object, e As EventArgs) Handles CancelConfirm_Button.Click

        Confirm_Panel.Visible = False
        If Session("Confirm") = "Cannot Save" Then
            PopulateEntries()
        End If

    End Sub

    Protected Sub ConfirmCompetition_Button_Click(sender As Object, e As EventArgs) Handles ConfirmCompetition_Button.Click

        Using Comp As New CompetitionData(Competitions_DropDownList.SelectedValue)

            If Session("Confirm") = "Confirm Baseline" Then
                Comp.Clear(1) 'clears all except riound 1
                Confirm_Panel.Visible = False
                Competitions_DropDownList_SelectedIndexChanged(sender, e)
            ElseIf Session("Confirm") = "Saved" Then
                Session("CompetitionID") = Competitions_DropDownList.SelectedValue
                Response.Redirect("CompetitionsResults.aspx")
            Else

                Confirm_Panel.Visible = False
                PopulateEntries()
            End If

        End Using

    End Sub

    Private Sub PopulateEntries()

        tblPage.Rows.Clear()

        Dim CompetitionEntries As DataTable = Session("CompetitionRound1Entries")

        If CompetitionEntries Is Nothing Then Exit Sub

        Dim HeaderRow As New HtmlTableRow
        tblPage.Rows.Add(HeaderRow)

        Dim th0 As New HtmlTableCell With {
            .InnerText = "Entrant(s)"
        }
        HeaderRow.Cells.Add(th0)
        Dim th1 As New HtmlTableCell With {
            .InnerText = "Opponent(s)"
        }
        HeaderRow.Cells.Add(th1)


        For RowIx As Integer = 0 To CompetitionEntries.Rows.Count - 2 Step 2

            Dim tr As New HtmlTableRow
            tblPage.Rows.Add(tr)

            Dim tRow0 As DataRow = CompetitionEntries.Rows(RowIx)
            Dim td0 As New HtmlTableCell With {
                .ID = "Cell_" & RowIx,
                .ClientIDMode = UI.ClientIDMode.Static
            }

            If Not IsDBNull(tRow0.Item("EntryID")) Then

                td0.InnerHtml = String.Format("<div id=""Component_{0}"" class=""drag {1} climit1_1"" style=""text-align: right"">&nbsp;" & tRow0.Item("Entrant") & "&nbsp;</div>", RowIx, "green")
            End If
            tr.Cells.Add(td0)

            Dim tRow1 As DataRow = CompetitionEntries.Rows(RowIx + 1)
            Dim td1 As New HtmlTableCell With {
                .ID = "Cell_" & RowIx + 1,
                .ClientIDMode = UI.ClientIDMode.Static
            }

            If Not IsDBNull(tRow1.Item("EntryID")) Then
                td1.InnerHtml = String.Format("<div id=""Component_{0}"" class=""drag {1} climit1_1"" style=""text-align: left"">&nbsp;" & tRow1.Item("Entrant") & "&nbsp;</div>", RowIx, "green")
            End If
            tr.Cells.Add(td1)

        Next

    End Sub

    Private Sub Refresh_Button_Click(sender As Object, e As EventArgs) Handles Refresh_Button.Click

        Session("ChangesPending") = False 'refresh implies start again
        Competitions_DropDownList_SelectedIndexChanged(sender, e)

    End Sub

    Sub PerformAction()

        ' Now there is a postback, let's see what happend
        If dragAction.Value = "" Then Exit Sub

        ' Get the right Id's                
        Dim action() As String = dragAction.Value.Split("|")
        Dim Entrant As String = action(0)

        Dim location() As String = action(1).Split("_")
        Dim TargetRowIx As Integer = Integer.Parse(location(1))

        UpdateTables(Entrant, TargetRowIx)
        PopulateEntries()
        dragAction.Value = ""

    End Sub

    Private Sub UpdateTables(Entrant As String, TargetRowIx As Integer)

        'Given the source entrant move it to the given co-ordinates

        Dim CompetitionEntries As DataTable = Session("CompetitionRound1Entries")

        For RowIx As Integer = 0 To CompetitionEntries.Rows.Count - 1

            'locate source cell from the name
            If Not IsDBNull(CompetitionEntries.Rows(RowIx).Item("Entrant")) AndAlso
                    CompetitionEntries.Rows(RowIx).Item("Entrant").trim = Entrant.Trim Then

                If RowIx <> TargetRowIx Then 'ignore if target = source

                    For ItemIX = 0 To CompetitionEntries.Rows(RowIx).ItemArray.GetUpperBound(0)
                        CompetitionEntries.Rows(TargetRowIx).Item(ItemIX) = CompetitionEntries.Rows(RowIx).Item(ItemIX)
                        CompetitionEntries.Rows(RowIx).Item(ItemIX) = DBNull.Value
                    Next

                    CompetitionEntries.AcceptChanges()

                    Session("CompetitionRound1Entries") = CompetitionEntries
                    Session("ChangesPending") = True

                End If

            End If

        Next

    End Sub

    Private Sub QueryCancel_Button_Click(sender As Object, e As EventArgs) Handles QueryCancel_Button.Click

        QuerySavePanel.Visible = False
        Session("ChangesPending") = False
        Competitions_DropDownList_SelectedIndexChanged(sender, e)

    End Sub

    Private Sub Save_Button_Click(sender As Object, e As EventArgs) Handles Save_Button.Click

        Dim CompetitionEntries As DataTable = Session("CompetitionRound1Entries")
        Confirm_Literal.Text = ""

        For ix = 0 To CompetitionEntries.Rows.Count - 5


            If IsDBNull(CompetitionEntries.Rows(ix).Item("EntryID")) Then
                Confirm_Literal.Text = "There are empty slots within the main body of the table.  It cannot be saved.<br/><br/>" &
                                       "Move entries such that there are no empty slots within the main body.<br/><br/> Click Confirm or Cancel"

            End If
            If ix Mod 2 = 0 AndAlso CompetitionEntries.Rows(ix).Item("Entrant").trim Like "Bye*" Then
                Confirm_Literal.Text = "There is a Bye as the 1st of a pair [" & CompetitionEntries.Rows(ix).Item("Entrant").trim & "].  It cannot be saved.<br/><br/>" &
                                       "Move entries such that there are no byes as the 1st of a match pair.<br/><br/> Click Confirm or Cancel"

            End If

            If Confirm_Literal.Text <> "" Then
                Confirm_Panel.Visible = True

                Session("Confirm") = "Cannot Save"

                populateEntries()

                Exit Sub
            End If

        Next

        'update the database with the new table
        For ix = 0 To CompetitionEntries.Rows.Count - 5

            'update Competitions_Entries set EntryID=ix where competitionID=SelectedIndex and DrawID=DrawID
            HBSAcodeLibrary.CompetitionRounds.UpdateCompetitionEntryID(Competitions_DropDownList.SelectedValue, CompetitionEntries.Rows(ix).Item("DrawID"), ix)

        Next

        Session("ChangesPending") = False
        Competitions_DropDownList_SelectedIndexChanged(sender, e)

        Confirm_Literal.Text = "SAVED...<br/><br/> Go to the results page to ensure all entries with byes are promoted.<br/><br/>Click Confirm or Cancel"

        Confirm_Panel.Visible = True

        Session("Confirm") = "Saved"
        populateEntries()

    End Sub

End Class