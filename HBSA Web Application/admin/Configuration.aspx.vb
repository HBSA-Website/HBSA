Imports HBSAcodeLibrary
Public Class Configuration
    Inherits System.Web.UI.Page
    Private Sub Configuration_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        End If

        Error_Literal.Text = ""
        PopulateGridView()

    End Sub
    Sub PopulateGridView()

        Using cfg As New HBSA_Configuration
            With GridView1
                .DataSource = cfg.Config
                .DataBind()
            End With

        End Using

    End Sub
    Protected Sub Insert_Button_Click(sender As Object, e As EventArgs) Handles Insert_Button.Click

        Key_TextBox.Text = ""
        Key_TextBox.Enabled = True
        Value_TextBox.Text = ""
        Value_TextBox.Enabled = True
        Edit_Literal.Text = "Enter the new details"
        Edit_Panel.Visible = True

    End Sub
    Protected Sub Start_LinkButton_Click(sender As Object, e As EventArgs) Handles Start_LinkButton.Click
        Main_Panel.Visible = True
    End Sub

    Private Sub GridView1_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles GridView1.RowEditing

        Key_TextBox.Text = GridView1.Rows(e.NewEditIndex).Cells(1).Text.Replace("&nbsp;", " ")
        Key_TextBox.Enabled = False
        Value_TextBox.Text = GridView1.Rows(e.NewEditIndex).Cells(2).Text.Replace("&nbsp;", " ")
        Value_TextBox.Enabled = True
        Edit_Literal.Text = "Amend the value"
        Edit_Panel.Visible = True

        e.Cancel = True

    End Sub
    Private Sub GridView1_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles GridView1.RowDeleting

        Key_TextBox.Text = GridView1.Rows(e.RowIndex).Cells(1).Text.Replace("&nbsp;", " ")
        Key_TextBox.Enabled = False
        Value_TextBox.Text = GridView1.Rows(e.RowIndex).Cells(2).Text.Replace("&nbsp;", " ")
        Value_TextBox.Enabled = False
        Edit_Literal.Text = "Click Submit to delete this configuration key"
        Edit_Panel.Visible = True

        e.Cancel = True

    End Sub
    Protected Sub Submit_Button_Click(sender As Object, e As EventArgs) Handles Submit_Button.Click

        If Key_TextBox.Text <> "" Then
            Try
                If Edit_Literal.Text = "Enter the new details" Then
                    HBSAcodeLibrary.HBSA_Configuration.Insert(Key_TextBox.Text.Trim, Value_TextBox.Text.Trim)
                ElseIf Edit_Literal.Text = "Amend the value" Then
                    HBSAcodeLibrary.HBSA_Configuration.update(Key_TextBox.Text.Trim, Value_TextBox.Text.Trim)
                Else
                    HBSAcodeLibrary.HBSA_Configuration.delete(Key_TextBox.Text.Trim)
                End If
            Catch ex As Exception
                Error_Literal.Text = "Error: " + ex.Message
            End Try

            PopulateGridView()

        End If

        Edit_Panel.Visible = False

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        PopulateGridView()
        Edit_Panel.Visible = False

    End Sub
End Class