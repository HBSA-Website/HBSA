Public Class WeeklyResultsReport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            populateLeagues()

        End If

    End Sub

    Protected Sub PopulateLeagues()

        With League_DropDownList

            Using SectionsList As DataTable = HBSAcodeLibrary.LeagueData.GetSections(0)

                .Items.Clear()
                .Visible = True
                For Each Section As DataRow In SectionsList.Rows
                    If CInt(Section!ID) = 10 Then
                        .Items.Add(New ListItem("Billiards", CInt(Section!ID)))
                    Else
                        .Items.Add(New ListItem(Section.Field(Of String)("Section Name"), CInt(Section!ID)))
                    End If
                Next

                .DataBind()

            End Using

            Using leaguesList As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues

                For Each League As DataRow In leaguesList.Rows
                    If CInt(League!ID) <> 3 Then
                        .Items.Add(New ListItem("All sections in " & League.Field(Of String)("League Name"), CInt(League!ID) + 100))
                    End If
                Next

            End Using

            If .Items.Count > 1 Then
                    .Items.Insert(0, New ListItem("**Select a Section or League**", 0))
                End If

            .SelectedIndex = 0

        End With

    End Sub

    Protected Sub League_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles League_DropDownList.SelectedIndexChanged

        If League_DropDownList.SelectedValue.StartsWith("**") Then
            FixtureDate_DropDownList.Items.Clear()

        Else

            Using fixtureList As DataSet = HBSAcodeLibrary.FixturesData.GetFixtureDatesForLeague(League_DropDownList.SelectedValue)

                With FixtureDate_DropDownList
                    .Items.Clear()
                    '.Items.Add(New ListItem("All fixture dates", 0))
                    For Each row As DataRow In fixtureList.Tables(1).Rows
                        If row!FixtureDate <= Today Then
                            .Items.Add(New ListItem(row!Fixturedate, row!WeekNo))
                        Else
                            Exit For
                        End If
                    Next

                    'determine most recent fixture and select it.
                    .SelectedIndex = .Items.Count - 1  'start at the last fixture in the list
                    'Look for the fixture immediately before now
                    For ix As Integer = 2 To .Items.Count - 1
                        If CDate(.Items(ix).Text) > HBSAcodeLibrary.Utilities.UKDateTimeNow() Then
                            .SelectedIndex = ix - 1
                            Exit For
                        End If
                    Next

                End With

                FixtureDate_DropDownList_SelectedIndexChanged(sender, e)

            End Using

        End If

    End Sub

    Protected Sub FixtureDate_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles FixtureDate_DropDownList.SelectedIndexChanged

        Err_Literal.Text = ""

        Dim SectionID As Integer = 0
        Dim LeagueID As Integer = 0
        If League_DropDownList.SelectedValue > 100 Then
            LeagueID = League_DropDownList.SelectedValue Mod 100
        Else
            SectionID = League_DropDownList.SelectedValue
        End If

        Using results As DataSet = HBSAcodeLibrary.MatchResult.WeeklyResults(LeagueID, SectionID, FixtureDate_DropDownList.SelectedItem.Text)
            Dim WR As New StringBuilder("<b>" + results.Tables(0).Rows(0).ItemArray(0).ToString() + "</b><br/><hr/>")
            For Each match As DataRow In results.Tables(1).Rows
                WR.Append("<b>" & match!Home & " " & match!H_Pts & " v " & match!Away & " " & match!A_Pts & " (" & match!Section & ")</b><br/>")
                WR.Append((match!HomePlayer1 & " (" & match!HomeHandicap1 & ") " & match!HomePlayer1Score & ", " & match!AwayPlayer1 & " (" & match!AwayHandicap1 & ") " & match!AwayPlayer1Score).Replace("-", "&#8209;") & ", " &
                          (match!HomePlayer2 & " (" & match!HomeHandicap2 & ") " & match!HomePlayer2Score & ", " & match!AwayPlayer2 & " (" & match!AwayHandicap2 & ") " & match!AwayPlayer2Score).Replace("-", "&#8209;") & ", " &
                          (match!HomePlayer3 & " (" & match!HomeHandicap3 & ") " & match!HomePlayer3Score & ", " & match!AwayPlayer3 & " (" & match!AwayHandicap3 & ") " & match!AwayPlayer3Score).Replace("-", "&#8209;")
                         )
                If Not match!Homeplayer4 Is DBNull.Value Then
                    WR.Append(", " & (match!HomePlayer4 & " (" & match!HomeHandicap4 & ") " & match!HomePlayer4Score & ", " & match!AwayPlayer4 & " (" & match!AwayHandicap4 & ") " & match!AwayPlayer4Score)).Replace("-", "&#8209;")
                End If

                Dim Breaks() As DataRow = results.Tables(2).Select("MatchResultID = " & match!ID)
                If Breaks.Length > 0 Then
                    WR.Append("<br/><b>Breaks: </b>")
                    For Each break As DataRow In Breaks
                        If break!MatchResultID = match!ID Then
                            WR.Append(break!Player & " " & break!Break & ", ")
                        End If
                    Next
                    WR.Remove(WR.Length - 2, 2)
                End If

                WR.Append("<hr/>")

            Next

            Results_Literal.Text = WR.ToString()

        End Using

    End Sub
End Class