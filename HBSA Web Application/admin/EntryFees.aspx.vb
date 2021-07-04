

Public Class EntryFees
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
       OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        End If

        If Not IsPostBack Then

            Error_Literal.Text = ""

            Using Leagues As DataTable = HBSAcodeLibrary.LeagueData.AllLeagues

                With League_DropDownList

                    .DataSource = Leagues
                    .DataTextField = "League Name"
                    .DataValueField = "ID"
                    .DataBind()

                    .Items.Insert(0, New ListItem("Not League dependent", 0))
                    .Items.Insert(0, New ListItem("**select a league**", -1))

                    .SelectedIndex = 0

                End With

            End Using

            populateGridView()

        End If

    End Sub
    Protected Sub Insert_Button_Click(sender As Object, e As EventArgs) Handles Insert_Button.Click

        Edit_Literal.Text = "Insert the new details"
        Entity_TextBox.Text = ""
        League_DropDownList.SelectedIndex = 0

        Fee_TextBox.Text = 0
        Entity_TextBox.Enabled = True
        League_DropDownList.Enabled = True
        Fee_TextBox.Enabled = True

        Edit_Panel.Visible = True

    End Sub
    Sub PopulateGridView()

        Error_Literal.Text = ""

        With Fees_GridView
            .DataSource = HBSAcodeLibrary.EntryFormData.GetFees()
            .DataBind()
        End With
    End Sub

    Private Sub Fees_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Fees_GridView.RowDeleting

        With Fees_GridView

            Edit_Literal.Text = "Delete this fee"
            Entity_TextBox.Text = .Rows(e.RowIndex).Cells(1).Text.Replace("&nbsp;", "")
            League_DropDownList.SelectedValue = .Rows(e.RowIndex).Cells(2).Text.Replace("&nbsp;", "")
            Fee_TextBox.Text = .Rows(e.RowIndex).Cells(4).Text

        End With

        Entity_TextBox.Enabled = False
        League_DropDownList.Enabled = False
        Fee_TextBox.Enabled = False

        Edit_Panel.Visible = True

        e.Cancel = True

    End Sub

    Private Sub Fees_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles Fees_GridView.RowEditing

        With Fees_GridView

            Edit_Literal.Text = "Amend this fee"
            Entity_TextBox.Text = .Rows(e.NewEditIndex).Cells(1).Text.Replace("&nbsp;", "")
            League_DropDownList.SelectedValue = .Rows(e.NewEditIndex).Cells(2).Text
            Fee_TextBox.Text = .Rows(e.NewEditIndex).Cells(4).Text

        End With

        Entity_TextBox.Enabled = False
        League_DropDownList.Enabled = False
        Fee_TextBox.Enabled = True

        Edit_Panel.Visible = True

        e.Cancel = True

    End Sub
    Protected Sub Submit_Click(sender As Object, e As EventArgs) Handles Submit_button.Click

        Try

            If Entity_TextBox.Text.Trim <> "" Then
                If Edit_Literal.Text.ToLower.StartsWith("delete") Then

                    HBSAcodeLibrary.EntryFormData.DeleteFee(Entity_TextBox.Text.Trim, League_DropDownList.SelectedValue, Session("AdminUser"))

                Else
                    If League_DropDownList.SelectedIndex > 0 Then

                        If Edit_Literal.Text.ToLower.StartsWith("insert") Then

                            HBSAcodeLibrary.EntryFormData.InsertNewFee(Entity_TextBox.Text.Trim, League_DropDownList.SelectedValue, CDec(Fee_TextBox.Text), Session("AdminUser"))
                        Else
                            HBSAcodeLibrary.EntryFormData.UpdateFee(Entity_TextBox.Text.Trim, League_DropDownList.SelectedValue, CDec(Fee_TextBox.Text), Session("AdminUser"))
                        End If

                    Else
                        Error_Literal.Text = "Please select a league"
                        Exit Sub
                    End If

                End If
            Else
                Error_Literal.Text = "The Entity cannot be blank"
                Exit Sub
            End If

            populateGridView()
            Edit_Panel.Visible = False

        Catch ex As Exception
            Error_Literal.Text = "Error: " + ex.Message
        End Try

    End Sub

    Private Sub Fees_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Fees_GridView.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Cells(4).Text = Format(CDec(e.Row.Cells(4).Text), "£0.00")
            e.Row.Cells(2).Visible = False
        End If
    End Sub

    Private Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click
        Edit_Panel.Visible = False
    End Sub
End Class