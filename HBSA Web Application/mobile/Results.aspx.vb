Public Class Results1
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Close_Button1.Attributes.Add("onclick", "hideDiv('divResultCard');")
        'Close_Button2.Attributes.Add("onclick", "hideDiv('divResultCard');")

        If Not IsPostBack Then

            PopulateSections()

        End If

    End Sub
    Protected Sub PopulateSections()

        'Results_GridView.Visible = False

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
        'Results_GridView.Visible = False

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

                'Results_GridView.Visible = False
                Session("Results") = Nothing

            End Using

        End If

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
                Results_Div.InnerHtml = HBSAcodeLibrary.Utilities.BuildMobileActiveTable _
                    (resultsList.Tables(0), 1, 5, "ActiveDetailDiv", "ScoreCard") _
                        .Replace("hFrames", "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;").Replace("aFrames", "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")

            End Using

        End If


    End Sub

End Class