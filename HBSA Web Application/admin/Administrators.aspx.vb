Imports HBSAcodeLibrary
Public Class Administrators
    Inherits System.Web.UI.Page
    Enum AdminCol
        command
        Username
        Password
        Forename
        Surname
        Email
        [Function]
    End Enum
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
            OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        End If

        If Not IsPostBack Then
            PopulateGridView()
        End If

    End Sub
    Private Sub PopulateGridView()
        With Administrators_GridView
            .DataSource = HBSAcodeLibrary.Administrator.GetAdministrators()
            .DataBind()
        End With
    End Sub
    Private Sub Administrators_GridView_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles Administrators_GridView.RowUpdating

        If e.NewValues("password") = "************" Or e.NewValues("password") = "" Then
            'restore the original (hashed) password
            Dim OldPasswords() As String = Session("OldPasswords")
            e.NewValues("password") = OldPasswords(e.RowIndex)
        Else
            e.NewValues("password") = HBSAcodeLibrary.Utilities.RFC2898_Hash(e.NewValues("password"))
        End If

    End Sub
    Private Sub Administrators_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Administrators_GridView.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            If (e.Row.RowState = DataControlRowState.Normal Or e.Row.RowState = DataControlRowState.Alternate) Then

                'store old password (hashed)
                If Session("OldPasswords") Is Nothing Then
                    Dim p(0) As String
                    Session("OldPasswords") = p
                End If

                Dim OldPasswords() As String = Session("OldPasswords")
                If OldPasswords.Length <= e.Row.RowIndex Then
                    ReDim Preserve OldPasswords(e.Row.RowIndex)
                End If
                OldPasswords(e.Row.RowIndex) = CType(e.Row.Cells(AdminCol.Password), TableCell).Text
                Session("OldPasswords") = OldPasswords

                'Obfuscate the password in the grid view
                If CType(e.Row.Cells(AdminCol.Password), TableCell).Text <> "Enter a new password" Then
                    CType(e.Row.Cells(AdminCol.Password), TableCell).Text = "************"
                End If

            Else
                If CType(e.Row.Cells(AdminCol.Password).Controls(0), TextBox).Text <> "Enter a new password" Then
                    CType(e.Row.Cells(AdminCol.Password).Controls(0), TextBox).Text = "************"
                End If
            End If


        End If

    End Sub
    Protected Sub NewAdministrator_Button_Click(sender As Object, e As EventArgs) Handles NewAdministrator_Button.Click

        Using adm As Administrator = New Administrator()

            editType_Literal.Text = "Complete required details and click 'Add this administrator', or 'Cancel'."

            EditPanel_Literal.Text = "Add&nbsp;a&nbsp;new&nbsp;administrator"

            FillEditPanel(adm, "Add this administrator")

        End Using

    End Sub
    Private Sub Administrators_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles Administrators_GridView.RowEditing

        With Administrators_GridView.Rows(e.NewEditIndex)

            Using adm As Administrator = New Administrator(.Cells(AdminCol.Username).Text)

                editType_Literal.Text = "Change required details and click 'Amend this administrator', or 'Cancel'.<br>" &
                                    "Note:  if the password is left blank, or with asterisks it will NOT be changed.<br>" &
                                    "       anything else in the password field will cause the password to be changed."

                EditPanel_Literal.Text = "Amend&nbsp;an&nbsp;administrator"
                FillEditPanel(adm, "Amend this administrator")

            End Using

        End With

        e.Cancel = True

    End Sub
    Private Sub Administrators_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Administrators_GridView.RowDeleting

        With Administrators_GridView.Rows(e.RowIndex)

            Using adm As Administrator = New Administrator(.Cells(AdminCol.Username).Text)

                editType_Literal.Text = "Click 'Delete this administrator' to confirm deletion or 'Cancel'."
                EditPanel_Literal.Text = "Delete&nbsp;an&nbsp;administrator"
                FillEditPanel(adm, "Delete this administrator")

            End Using

        End With

        e.Cancel = True

    End Sub
    Sub FillEditPanel(adm As Administrator, command As String)

        editStatus_Literal.Text = ""

        editUsername_textbox.Text = adm.Username
        editPassword_textbox.Text = ""
        editPassword_Hidden.Value = adm.Password
        editFunction_Textbox.Text = adm.Function
        editForename_TextBox.Text = adm.Forename
        editSurname_TextBox.Text = adm.Surname
        editEmail_Textbox.Text = adm.Email

        editUsername_textbox.Enabled = command.ToLower.StartsWith("add")
        editPassword_textbox.Enabled = Not command.ToLower.StartsWith("delete")
        editFunction_Textbox.Enabled = Not command.ToLower.StartsWith("delete")
        editForename_TextBox.Enabled = Not command.ToLower.StartsWith("delete")
        editSurname_TextBox.Enabled = Not command.ToLower.StartsWith("delete")
        editEmail_Textbox.Enabled = Not command.ToLower.StartsWith("delete")

        'Edit_Panel.Visible = True
        divEditAdministrator.Style("display") = "block"
        editAdministrator_Button.Text = command

    End Sub
    Protected Sub CancelEdit_Button_Click(sender As Object, e As EventArgs) Handles CancelEdit_Button.Click
        'Edit_Panel.Visible = False
        divEditAdministrator.Style("display") = "none"
    End Sub

    Protected Sub EditAdministrator_Button_Click(sender As Object, e As EventArgs) Handles editAdministrator_Button.Click

        Try

            If editAdministrator_Button.Text.StartsWith("Delete") Then

                Using adm As Administrator = New Administrator(editUsername_textbox.Text.Trim)
                    adm.Delete()
                End Using

            Else

                If ValidDetails() Then
                    Using adm As Administrator = New Administrator()
                        With adm
                            .Username = editUsername_textbox.Text.Trim
                            .Function = editFunction_Textbox.Text
                            .Forename = editForename_TextBox.Text
                            .Surname = editSurname_TextBox.Text
                            .Email = editEmail_Textbox.Text

                            If editAdministrator_Button.Text.StartsWith("Amend") Then
                                If editPassword_textbox.Text.Trim = "" OrElse
                               editPassword_textbox.Text.Trim = "************" Then
                                    .Password = editPassword_Hidden.Value
                                Else
                                    .Password = Utilities.RFC2898_Hash(editPassword_textbox.Text.Trim)
                                End If
                                .Amend()
                            Else
                                .Password = Utilities.RFC2898_Hash(editPassword_textbox.Text.Trim)
                                .Insert()
                            End If

                        End With
                    End Using

                End If
            End If

            PopulateGridView()
            'Edit_Panel.Visible = False
            divEditAdministrator.Style("display") = "none"

        Catch ex As Exception
            editStatus_Literal.Text = "ERROR: " & ex.Message
        End Try

    End Sub
    Function ValidDetails() As Boolean

        Dim errMsg As String = ""

        If editUsername_textbox.Text.Trim = "" Then
            errMsg += "The username cannot be blank<br/>"
        End If

        If editPassword_textbox.Text.Trim = "" OrElse editPassword_textbox.Text.Trim = "************" Then
            If editAdministrator_Button.Text.StartsWith("Add") Then
                errMsg += "A new administrator must have a password<br/>"
            End If
        Else
            If editPassword_textbox.Text.Trim.Length < 6 Then
                errMsg += "The password must be at least 6 characters long<br/>"
            End If
        End If

        If editSurname_TextBox.Text.Trim = "" Then
            errMsg += "There must be a surname<br/>"
        End If

        If Not Emailer.IsValidEmailAddress(editEmail_Textbox.Text) Then
            errMsg += "The email address format is invalid<br/>"
        End If

        If errMsg = "" Then
            Return True
        Else
            Throw New Exception(errMsg)
            Return False
        End If

    End Function

End Class