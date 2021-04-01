Public Class WeeklyResultsReport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            populateLeagues()

        End If

    End Sub

    Protected Sub PopulateLeagues()

        Using leaguesList As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues()

            With League_DropDownList
                .Items.Clear()
                .Visible = True
                .DataSource = leaguesList
                .DataTextField = "League Name"
                .DataValueField = "ID"
                .DataBind()
                If leaguesList.Rows.Count > 1 Then
                    .Items.Insert(0, New ListItem("**Select a League**", 0))
                End If

                .SelectedIndex = 0

            End With

        End Using

    End Sub

    Protected Sub League_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles League_DropDownList.SelectedIndexChanged

        If League_DropDownList.SelectedValue.StartsWith("**") Then
            FixtureDate_DropDownList.Items.Clear()

        Else

            Using fixtureList As DataSet = HBSAcodeLibrary.FixturesData.GetFixtureDatesForLeague(League_DropDownList.SelectedValue)

                With FixtureDate_DropDownList
                    .Items.Clear()
                    .Items.Add(New ListItem("All fixture dates", 0))
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

        Using results As DataTable = HBSAcodeLibrary.MatchResult.WeeklyResultsForExaminer(League_DropDownList.SelectedValue, FixtureDate_DropDownList.SelectedValue)

            With Results_GridView
                .DataSource = results
                .DataBind()
            End With

        End Using

    End Sub
End Class