Public Class PrivacyReports
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                populateClubs()
            End If
        End If

    End Sub

    Protected Sub PopulateClubs()


        Club_DropDownList.Items.Clear()

        Dim clubs As DataTable = HBSAcodeLibrary.ClubData.GetClubs(0)

        With Club_DropDownList
            .Items.Clear()
            .Visible = True

            .Items.Add(New ListItem("** Select clubs **", ""))

            If clubs.Rows.Count > 1 Then
                .Items.Add(New ListItem("**All Clubs**", 0))
            End If

            For Each row As DataRow In clubs.Rows
                .Items.Add(New ListItem(row.Item("Club Name"), row.Item("ID")))
            Next

            .Enabled = (clubs.Rows.Count > 1)

            .SelectedIndex = 0

        End With

    End Sub

    Protected Sub Report_Button_Click(sender As Object, e As EventArgs) Handles report_Button.Click

        Err_Literal.Text = ""
        If Club_DropDownList.SelectedIndex < 1 Then
            Err_Literal.Text &= "select a Club or all clubs<br/>"
        End If
        If type_DropDownList1.SelectedIndex < 1 Then
            Err_Literal.Text &= "select an entry form type<br/>"
        End If
        If Privacy_DropDownList.SelectedIndex < 1 Then
            Err_Literal.Text &= "select privacy accepted or not or either<br/>"
        End If

        If Err_Literal.Text = "" Then

            With PrivacyReport_GridView

                Dim PrivacyReport As DataTable = HBSAcodeLibrary.SharedRoutines.PrivacyReport(Club_DropDownList.SelectedValue,
                                                                                              type_DropDownList1.SelectedValue,
                                                                                              Privacy_DropDownList.SelectedValue
                                                                                             )
                .DataSource = PrivacyReport
                .DataBind()
            End With

        Else

            Err_Literal.Text = "ERROR: " & Err_Literal.Text.Substring(0, Err_Literal.Text.Length - 5)

        End If

    End Sub

End Class