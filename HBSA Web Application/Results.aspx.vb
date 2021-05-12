Partial Class Results
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Close_Button1.Attributes.Add("onclick", "hideDiv('divResultCard');")
        Close_Button2.Attributes.Add("onclick", "hideDiv('divResultCard');")

        If Not IsPostBack Then

            populateSections()

        End If

    End Sub
    Protected Sub PopulateSections()

        Results_GridView.Visible = False

        Using dt As DataTable = HBSAcodeLibrary.LeagueData.GetSections(0)

            With Section_DropDownList
                .Items.Clear()
                .Visible = True
                .DataSource = dt
                .DataTextField = "Section Name"
                .DataValueField = "ID"
                .DataBind()

                If dt.Rows.Count > 0 Then
                    .Items.Insert(0, "**Select a division/section**")
                    .Enabled = True
                    .SelectedIndex = 0
                    Section_DropDownList_SelectedIndexChanged(New Object, New EventArgs)
                Else
                    .Enabled = False
                End If

            End With

        End Using

    End Sub
    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        Selection_Literal.Text = "Select a league and section, then optionally a date and/or a team then click Show Results."
        Results_GridView.Visible = False

        If Section_DropDownList.SelectedValue.StartsWith("**") Then
            MatchDate_DropDownList.Items.Clear()
            Team_DropDownList.Items.Clear()
            With MatchDate_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("All match dates", Nothing))
            End With
            With Team_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("All teams", 0))
            End With

        Else

            Using resultsList As DataSet = HBSAcodeLibrary.MatchResult.ListResults(Section_DropDownList.SelectedValue)

                With MatchDate_DropDownList
                    .Items.Clear()
                    .Items.Add(New ListItem("All match dates", Nothing))
                    For Each row As DataRow In resultsList.Tables(1).Rows
                        .Items.Add(row.Item("Match Date"))
                    Next
                End With
                With Team_DropDownList
                    .Items.Clear()
                    .Items.Add(New ListItem("All teams", 0))
                    For Each row As DataRow In resultsList.Tables(2).Rows
                        .Items.Add(New ListItem(row!Team, row!TeamID))
                    Next
                End With

                Results_GridView.Visible = False
                Session("Results") = Nothing

            End Using

        End If

    End Sub

    Protected Sub Results_GridView_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Results_GridView.SelectedIndexChanged

        Dim results As DataTable = Session("Results")
        Dim resultsID As Integer = results.Rows(Results_GridView.SelectedIndex).Item("ID")


        Using MatchResult As DataSet = HBSAcodeLibrary.MatchResult.ResultCard(resultsID)

            Dim cardHeader As DataRow = MatchResult.Tables(0).Rows(0)
            League_Literal.Text = cardHeader!League
            Section_Literal.Text = cardHeader!Section
            FixtureDate_Literal.Text = cardHeader.Item("FixtureDate")
            MatchDate_Literal.Text = cardHeader.Item("Match Date")
            HomeTeam_Literal.Text = cardHeader!Home
            AwayTeam_Literal.Text = cardHeader!Away
            HomeFrames_Literal.Text = cardHeader!H_Pts
            AwayFrames_Literal.Text = cardHeader!A_Pts

            Dim cardBody As DataTable = MatchResult.Tables(1)
            HomeHcap1_Literal.Text = cardBody.Rows(0).Item("Home H'cap")
            HomePlayer1_Literal.Text = cardBody.Rows(0)!HomePlayer
            HomeScore1_Literal.Text = cardBody.Rows(0)!HomeScore
            AwayHcap1_Literal.Text = cardBody.Rows(0).Item("Away H'cap")
            AwayPlayer1_Literal.Text = cardBody.Rows(0)!AwayPlayer
            AwayScore1_Literal.Text = cardBody.Rows(0)!AwayScore

            HomeHcap2_Literal.Text = cardBody.Rows(1).Item("Home H'cap")
            HomePlayer2_Literal.Text = cardBody.Rows(1)!HomePlayer
            HomeScore2_Literal.Text = cardBody.Rows(1)!HomeScore
            AwayHcap2_Literal.Text = cardBody.Rows(1).Item("Away H'cap")
            AwayPlayer2_Literal.Text = cardBody.Rows(1)!AwayPlayer
            AwayScore2_Literal.Text = cardBody.Rows(1)!AwayScore

            HomeHcap3_Literal.Text = cardBody.Rows(2).Item("Home H'cap")
            HomePlayer3_Literal.Text = cardBody.Rows(2)!HomePlayer
            HomeScore3_Literal.Text = cardBody.Rows(2)!HomeScore
            AwayHcap3_Literal.Text = cardBody.Rows(2).Item("Away H'cap")
            AwayPlayer3_Literal.Text = cardBody.Rows(2)!AwayPlayer
            AwayScore3_Literal.Text = cardBody.Rows(2)!AwayScore

            If League_Literal.Text.ToLower Like "*open*" Then
                HomeHcap4_Literal.Text = cardBody.Rows(3).Item("Home H'cap")
                HomePlayer4_Literal.Text = cardBody.Rows(3)!HomePlayer
                HomeScore4_Literal.Text = cardBody.Rows(3)!HomeScore
                AwayHcap4_Literal.Text = cardBody.Rows(3).Item("Away H'cap")
                AwayPlayer4_Literal.Text = cardBody.Rows(3)!AwayPlayer
                AwayScore4_Literal.Text = cardBody.Rows(3)!AwayScore
            Else
                HomeHcap4_Literal.Text = "&nbsp;"
                HomePlayer4_Literal.Text = "&nbsp;"
                HomeScore4_Literal.Text = "&nbsp;"
                AwayHcap4_Literal.Text = "&nbsp;"
                AwayPlayer4_Literal.Text = "&nbsp;"
                AwayScore4_Literal.Text = "&nbsp;"
            End If

            Dim homeBreaksTable As DataTable = MatchResult.Tables(2)
            Dim awayBreaksTable As DataTable = MatchResult.Tables(3)

            If homeBreaksTable.Rows.Count > 0 Then
                HomeBreaks_GridView.DataSource = homeBreaksTable
                HomeBreaks_GridView.DataBind()
                HomeBreaks_GridView.Visible = True
            Else
                HomeBreaks_GridView.Visible = False
            End If

            If awayBreaksTable.Rows.Count > 0 Then
                AwayBreaks_GridView.DataSource = awayBreaksTable
                AwayBreaks_GridView.DataBind()
                AwayBreaks_GridView.Visible = True
            Else
                AwayBreaks_GridView.Visible = False
            End If

        End Using

        ScoreCard_Panel.Visible = True

    End Sub

    Protected Sub Get_Button_Clicked(ByVal sender As Object, ByVal e As System.EventArgs) _
            Handles Get_Button.Click

        If Section_DropDownList.SelectedIndex < 1 Then

            Selection_Literal.Text = "<span style='color:red;'>Please select a league and section first.</span>"

        Else

            Selection_Literal.Text = "Select a league and section, then optionally a date and/or a team then click Show Results."

            Using resultsList As DataSet = HBSAcodeLibrary.MatchResult.ListResults _
                                                  (Section_DropDownList.SelectedValue,
                                                   If(MatchDate_DropDownList.SelectedValue.ToLower Like "*all*", Nothing, MatchDate_DropDownList.SelectedValue),
                                                   Team_DropDownList.SelectedValue
                                                  )
                Results_GridView.DataSource = resultsList.Tables(0)
                Results_GridView.DataBind()
                Results_GridView.Visible = True
                Session("Results") = resultsList.Tables(0)

            End Using

        End If


    End Sub

    Protected Sub Close_Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) _
        Handles Close_Button1.Click, Close_Button2.Click

        ScoreCard_Panel.Visible = False
        Results_GridView.SelectedIndex = -1

    End Sub

    Private Sub HomeBreaks_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) _
        Handles HomeBreaks_GridView.RowDataBound, AwayBreaks_GridView.RowDataBound

        For Each tc As TableCell In e.Row.Cells
            tc.BorderStyle = BorderStyle.None
        Next

    End Sub
End Class
