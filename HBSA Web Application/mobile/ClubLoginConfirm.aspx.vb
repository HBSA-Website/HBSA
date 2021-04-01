Public Class ClubLoginConfirm1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            If Request.Params("ClubID") Is Nothing Then
                Response.Redirect("ClubLogin.aspx")
            End If

            Dim ClubUser As New HBSAcodeLibrary.ClubUserData(Request.Params("ClubID"))
            With ClubUser

                clubIdHidden.Value = .ClubID
                clubNameLiteral.Text = .ClubName
                email_Literal.Text = .eMail
                If Request.Params("confirm") Is Nothing Then
                    confirmTextBox.Text = ""
                Else
                    confirmTextBox.Text = Request.Params("confirm")
                End If

            End With

        End If

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles cancelButton.Click

        Response.Redirect("ClubLogin.aspx")

    End Sub

    Protected Sub Confirm_Button_Click(sender As Object, e As EventArgs) Handles confirmButton.Click

        Using ClubUser As New HBSAcodeLibrary.ClubUserData(email_Literal.Text, passwordTextBox.Text.Trim)

            With ClubUser

                If Not .loggedIn Then

                    statusLabel.Text = "The password is incorrect, please try again"

                Else

                    .ConfirmationCode = confirmTextBox.Text

                    Try

                        .ConfirmClubUser()
                        statusLabel.Text = "The registration is now confirmed.  Use the links above for your next activity"
                        confirmButton.Visible = False
                        cancelButton.Text = "Return"

                    Catch ex As Exception

                        If ex.Message Like "*Confirmation failed*" Then
                            statusLabel.Text = "<span style='color:red;'>Confirmation failed.  Correct the confirmation code and try again.</span><br/>" &
                                                "If you believe the password and verification codes are correct please contact us with details from the contacts page."
                        Else
                            statusLabel.Text = "<span style='color:red;'>Database ERROR. Please contact us (using the contacts page) and supply the following message:<br/><br/>" &
                                                ex.Message & ".</span>"

                        End If

                    End Try

                End If

            End With
        End Using

    End Sub

End Class