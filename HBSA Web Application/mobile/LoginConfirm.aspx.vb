Public Class LoginConfirm1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            If Request.Params("UserID") Is Nothing Then
                Response.Redirect("Login.aspx")
            End If

            Dim user As New HBSAcodeLibrary.UserData(,, Request.Params("UserID"))
            With user

                Dim team As New HBSAcodeLibrary.TeamData(.TeamID)
                nameLiteral.Text = .FirstName & " " & .Surname
                EmailAddressLiteral.Text = .eMail
                teamLiteral.Text = (team.ClubName & " " & team.Team).Trim
                leagueLiteral.Text = team.LeagueName


                If Request.Params("confirm") Is Nothing Then
                    confirmTextBox.Text = ""
                    confirmTextBox.Enabled = True
                    statusLabel.Text = "If you arrived here after logging in, that is because your registration needs to be confirmed. " &
                                    "Enter your password, and the confirmation code <br/>" &
                                    "&nbsp;&nbsp;&nbsp;&nbsp;(this can be found in the email you should have received to confirm your registration).<br/><br/>" &
                                    "Then click confirm.</font>"

                Else
                    confirmTextBox.Text = Request.Params("confirm")
                    confirmTextBox.Enabled = False
                End If

            End With

        End If

    End Sub

    Protected Sub CancelButton_Click(sender As Object, e As EventArgs) Handles cancelButton.Click
        Response.Redirect("Login.aspx")
    End Sub

    Protected Sub ConfirmButton_Click(sender As Object, e As EventArgs) Handles confirmButton.Click

        If confirmButton.Text = "Confirm" Then

            Try
                Using UserData As New HBSAcodeLibrary.UserData(EmailAddressLiteral.Text.Trim, passwordTextBox.Text.Trim)
                    With UserData
                        If .loggedIn Then
                            If .Confirmed Then
                                Session("TeamID") = .TeamID
                                Session("Email") = EmailAddressLiteral.Text.Trim
                                Session("Password") = passwordTextBox.Text.Trim
                                statusLabel.ForeColor = Drawing.Color.Red
                                statusLabel.Text = "This login is already confirmed. Click 'Proceed'."
                                confirmButton.Text = "Proceed"
                            Else
                                .ConfirmCode = confirmTextBox.Text.Trim
                                Try

                                    .ConfirmUser()

                                    Session("TeamID") = .TeamID
                                    Session("Email") = EmailAddressLiteral.Text.Trim
                                    Session("Password") = passwordTextBox.Text.Trim
                                    statusLabel.ForeColor = Drawing.Color.DarkBlue
                                    statusLabel.Text = "Your login is now confirmed. Click 'Proceed'."
                                    confirmButton.Text = "Proceed"

                                Catch ex As Exception
                                    statusLabel.Text = "Your confirmation failed because " & ex.Message &
                                                       "<br/> Go back to the confirmation email you received and check the confirmation code, and click the link, or copy and paste it into your browser's address box.</font>"
                                    confirmButton.Text = "Return"

                                End Try

                            End If
                        Else
                            statusLabel.Text = "Your confirmation failed because the password is incorrect.<br/><br/>" &
                                                "Go back to the confirmation email you received, and click the hyperlink, or copy and paste it into your browser's address box.</font>"
                        End If
                    End With
                End Using

            Catch ex As Exception
                statusLabel.ForeColor = Drawing.Color.Red
                statusLabel.Text = "An error occurred.  Please contact HBSA with these details:" & vbCrLf & vbCrLf &
                                    ex.Message

            End Try

        ElseIf confirmButton.Text = "Proceed" Then
            Response.Redirect("Home.aspx")
        Else
            Response.Redirect("Login.aspx")

        End If


    End Sub
End Class