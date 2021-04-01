

Public Class LoginReset1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            Try
                Dim EncryptedID As String = Request.Params("ResetPassword")
                populatePage(EncryptedID)
            Catch ex As Exception
                Status_Label.Text = "<span style='color:red;'>No identifier... Click Return</span>"
                Save_Button.Visible = False
            End Try
        End If

    End Sub

    Sub PopulatePage(EncryptedID As String)

        Using Encrypter As New HBSAcodeLibrary.AES_EncryptDecrypt("HBSA Web Site", "HBSA Reset Password")

            Dim ID = CInt(Encrypter.DecryptData(EncryptedID))
            Dim LoginDataRow As DataRow = HBSAcodeLibrary.UserData.LoginData(ID)
            If Not LoginDataRow Is Nothing Then

                Using pwd As New HBSAcodeLibrary.PasswordReset(LoginDataRow!EmailAddress, ID)
                    If pwd.ID = 0 Then
                        Dim cfg As New HBSAcodeLibrary.HBSA_Configuration
                        Status_Label.Text = "<span style='color:red;'>This password reset does not exist, or may have expired... Click Return</span>" &
                                            "<br>Note that a password reset is only valid for " & cfg.Value("PasswordResetExpiry") & " hours after the reset request."

                    Else

                        Email_cell.InnerText = LoginDataRow!EmailAddress
                        team_cell.InnerText = LoginDataRow!Club & " " & LoginDataRow!Team & " (" & LoginDataRow!League & " " & LoginDataRow!Section & ")"
                        Password_TextBox.Text = ""
                        ConfirmPassword_TextBox.Text = ""
                        UserID_Hidden.Value = EncryptedID
                        LoginDataRow = Nothing

                    End If

                End Using

            Else

                Status_Label.Text = "<span style='color:red;'>The given identifier does not relate to a valid login... Click Return</span>"
                Save_Button.Visible = False

            End If

        End Using



    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        Response.Redirect("login.aspx")

    End Sub

    Protected Sub Save_Button_Click(sender As Object, e As EventArgs) Handles Save_Button.Click

        Password_TextBox.Text = Password_TextBox.Text.Trim
        If Password_TextBox.Text.Length < 8 Then
            Status_Label.Text = "<span style='color:red;'>Passwords must be at least 8 characters long.</span>"
            Exit Sub
        ElseIf Password_TextBox.Text <> ConfirmPassword_TextBox.Text.Trim Then
            Status_Label.Text = "<span style='color:red;'>Confirm password must be exactly the same as Password.</span>"
            Exit Sub
        End If



        Dim EncryptedID As String = UserID_Hidden.Value

        Using Encrypter As New HBSAcodeLibrary.AES_EncryptDecrypt("HBSA Web Site", "HBSA Reset Password")

            Dim ID = CInt(Encrypter.DecryptData(EncryptedID))

            Try
                HBSAcodeLibrary.UserData.LoginPasswordReset(ID, HBSAcodeLibrary.Utilities.RFC2898_Hash(Password_TextBox.Text))
                Status_Label.Text = "Your password has been reset.  Click return to login."
                Save_Button.Visible = False

            Catch ex As Exception
                Status_Label.Text = "<span style='color:red;'>Error resetting the password.  Please contact us and supply the following information:</span><br/>" & ex.Message
            End Try


        End Using

    End Sub

End Class