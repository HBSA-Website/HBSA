Imports HBSAcodeLibrary
Partial Class admin_PointsAdjuster
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                PopulateGridView()
                PopulateSections()
            End If
        End If

    End Sub

    Protected Sub PopulateGridView()

        Using dt As DataTable = SharedRoutines.ListAdjustedPoints
            Adjustments_GridView.DataSource = dt
            Adjustments_GridView.DataBind()
        End Using

    End Sub
    Protected Sub PopulateSections()

        Using dt As DataTable = LeagueData.GetSections(0)

            With Section_DropDownList
                .Items.Clear()
                .Visible = True
                .DataSource = dt
                .DataTextField = "Section Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select a division/section**", 0))

                .Enabled = True
                .SelectedIndex = 0

            End With

        End Using

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        If Section_DropDownList.SelectedValue.StartsWith("**") Then
            Team_DropDownList.Items.Clear()
        Else

            Using teams As DataTable = TeamData.GetTeams(Section_DropDownList.SelectedValue)

                With Team_DropDownList
                    .Items.Clear()
                    .DataSource = teams
                    .DataTextField = "Team"
                    .DataValueField = "TeamID"
                    .DataBind()
                    .Items.Insert(0, New ListItem("** Select a team **", 0))
                End With

            End Using

        End If

    End Sub

    Protected Sub Save_Button_Click(sender As Object, e As EventArgs) Handles Save_Button.Click

        Dim Adjustment As Decimal

        Status_Literal.Text = ""

        If Team_DropDownList.SelectedIndex < 1 Then
            Status_Literal.Text += "Please select team. "
        End If
        If Points_TextBox.Text.Trim = "" Then
            Status_Literal.Text += "Please enter a points value. "
        Else
            Try
                Adjustment = Math.Abs(CDec(Points_TextBox.Text.Trim))
            Catch ex As Exception
                Status_Literal.Text += "Please enter a valid points value. "
            End Try
        End If
        If Reason_TextBox.Text.Trim = "" Then
            Status_Literal.Text += "Please enter a reason. "
        End If

        If Status_Literal.Text <> "" Then
            Exit Sub
        End If

        Using team As TeamData = New TeamData(Team_DropDownList.SelectedValue)
            Try
                team.UpdateLeaguePointsAdjustment(Adjustment_DropDown.SelectedValue & Adjustment.ToString,
                                              Reason_TextBox.Text.Trim,
                                              Session("adminDetails").rows(0)!username)
                Dim teamName As String = (team.ClubName + " " + team.Team).Trim + " (" + team.SectionName + ")"
                If Adjustment = 0 Then
                    Status_Literal.Text = "Adjustment deleted for " + teamName
                Else
                    Status_Literal.Text = "Adjustment recorded for " + teamName
                End If

                If SendEmail_CheckBox.Checked AndAlso Adjustment <> 0 Then
                    Using Club As New ClubData(team.ClubID)
                        Dim Status As String = HBSAcodeLibrary.Emailer.SendPointsAdjustmentEmail(
                                                                          Club.ClubLoginEMail & ";" & team.Contact,
                                                                          If(Adjustment_DropDown.SelectedValue = "-", "A deduction", "An addition"),
                                                                          Adjustment.ToString,
                                                                          (team.ClubName & " " & team.Team).Trim,
                                                                          team.SectionName, Reason_TextBox.Text.Trim)
                        If Status = "" Then
                            Status = "eMails sent."
                        Else
                            Status = "<span style='color:red'>" + Status + "</span>"
                        End If
                        Status_Literal.Text += " - " + Status
                    End Using
                End If
            Catch ex As Exception
                Status_Literal.Text += "<br/><span style='color:red'>ERROR occurred: <br/>" & ex.Message
            End Try
        End Using

        PopulateGridView()
        Edit_Panel.Visible = False

    End Sub


    Protected Sub Adjustments_GridView_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Adjustments_GridView.SelectedIndexChanged

        Status_Literal.Text = ""
        Dim ix As Integer = Adjustments_GridView.SelectedIndex

        Section_DropDownList.SelectedValue = Adjustments_GridView.Rows(ix).Cells(1).Text
        Section_DropDownList_SelectedIndexChanged(sender, e)
        Team_DropDownList.SelectedValue = Adjustments_GridView.Rows(ix).Cells(2).Text
        Section_DropDownList.Enabled = False
        Team_DropDownList.Enabled = False

        If CInt(Adjustments_GridView.Rows(ix).Cells(5).Text) < 0 Then
            Adjustment_DropDown.SelectedValue = "-"
        Else
            Adjustment_DropDown.SelectedValue = "+"
        End If
        Points_TextBox.Text = Math.Abs(CInt(Adjustments_GridView.Rows(ix).Cells(5).Text)).ToString
        Reason_TextBox.Text = Adjustments_GridView.Rows(ix).Cells(6).Text

        Edit_Panel.Visible = True

    End Sub

    Protected Sub Add_Button_Click(sender As Object, e As EventArgs) Handles Add_Button.Click

        Section_DropDownList.SelectedIndex = 0
        Section_DropDownList.Enabled = True
        Section_DropDownList_SelectedIndexChanged(sender, e)
        Team_DropDownList.Enabled = True

        Adjustment_DropDown.SelectedValue = "-"
        Points_TextBox.Text = ""
        Reason_TextBox.Text = ""
        Status_Literal.Text = ""

        Edit_Panel.Visible = True

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        Edit_Panel.Visible = False

    End Sub

End Class
