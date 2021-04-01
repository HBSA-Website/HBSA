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

        Err_Literal.Text = ""

        If Team_DropDownList.SelectedIndex < 1 Then
            Err_Literal.Text += "Please select team. "
        End If
        If Points_TextBox.Text.Trim = "" Then
            Err_Literal.Text += "Please enter a points value. "
        End If
        If Comments_TextBox.Text = "" Then
            Err_Literal.Text += "Please enter a comment. "

        End If

        If Err_Literal.Text <> "" Then
            Exit Sub
        End If

        Try
            Using team As TeamData = New TeamData(Team_DropDownList.SelectedValue)
                team.UpdateLeaguePointsAdjustment(Adjustment_DropDown.SelectedValue & Points_TextBox.Text,
                                                  Comments_TextBox.Text.Trim,
                                                  Session("adminDetails").rows(0)!username)
            End Using

            PopulateGridView()
            Edit_Panel.Visible = False

        Catch ex As Exception
            Err_Literal.Text = "Exception saving adjustment:<br/>" & ex.Message

        End Try


    End Sub


    Protected Sub Adjustments_GridView_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Adjustments_GridView.SelectedIndexChanged

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
        Comments_TextBox.Text = Adjustments_GridView.Rows(ix).Cells(6).Text

        Edit_Panel.Visible = True

    End Sub

    Protected Sub Add_Button_Click(sender As Object, e As EventArgs) Handles Add_Button.Click

        Section_DropDownList.SelectedIndex = 0
        Section_DropDownList.Enabled = True
        Section_DropDownList_SelectedIndexChanged(sender, e)
        Team_DropDownList.Enabled = True

        Adjustment_DropDown.SelectedValue = "-"
        Points_TextBox.Text = ""
        Comments_TextBox.Text = ""

        Edit_Panel.Visible = True

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        Edit_Panel.Visible = False

    End Sub

End Class
