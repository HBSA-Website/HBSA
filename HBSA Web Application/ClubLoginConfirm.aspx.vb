Public Class ClubLoginConfirm
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            If Request.Params("ClubID") Is Nothing Then
                Response.Redirect("ClubLogin.aspx")
            End If

            Dim ClubUser As New HBSAcodeLibrary.ClubUserData(Request.Params("ClubID"))
            With ClubUser

                ClubID_Label.Text = .ClubID
                ClubName_Literal.Text = .ClubName
                email_Literal.Text = .eMail
                If Request.Params("confirm") Is Nothing Then
                    Confirm_TextBox.Text = ""
                Else
                    Confirm_TextBox.Text = Request.Params("confirm")
                End If

            End With

        End If

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        Response.Redirect("ClubLogin.aspx")

    End Sub

    Protected Sub Confirm_Button_Click(sender As Object, e As EventArgs) Handles Confirm_Button.Click

        Using ClubUser As New HBSAcodeLibrary.ClubUserData(email_Literal.Text, Password_TextBox.Text.Trim)

            With ClubUser

                If Not .loggedIn Then

                    Status_Label.Text = "The password is incorrect, please try again"

                Else

                    .ConfirmationCode = Confirm_TextBox.Text

                    Try
                        .ConfirmClubUser()
                        Status_Label.Text = "The registration is now confirmed.  Use the links above for your next activity"
                        Confirm_Button.Visible = False
                        Cancel_Button.Text = "Return"

                    Catch ex As Exception

                        If ex.Message Like "*Confirmation failed*" Then
                            Status_Label.Text = "<span style='color:red;'>Confirmation failed.  Correct the confirmation code and try again.</span><br/>" &
                                                "If you believe the password and verification codes are correct please contact us with details from the contacts page."
                        Else
                            Status_Label.Text = "<span style='color:red;'>Database ERROR. Please contact us (using the contacts page) and supply the following message:<br/><br/>" &
                                                ex.Message & ".</span>"

                        End If

                    End Try

                End If

            End With
        End Using

    End Sub

End Class