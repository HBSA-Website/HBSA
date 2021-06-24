Imports System.ComponentModel
Imports System.Security.Cryptography
Imports HBSAcodeLibrary

Public Class ClubLoginRegistration
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            Session("captchaString") = HBSAcodeLibrary.Captcha.SetCaptchaImage(captcha_Image, captcha_Textbox)
            PopulateClubs()

        End If

    End Sub

    Protected Sub PopulateClubs()

        Using clubsList As DataTable = HBSAcodeLibrary.ClubData.GetClubs(0)

            With Club_DropDownList
                .Items.Clear()

                .DataSource = clubsList
                .DataTextField = "Club Name"
                .DataValueField = "ID"
                .DataBind()

                .Items.Insert(0, New ListItem("**Select a Club**", "-1"))

                If Request.Params("Profile") = 1 Then
                    .SelectedValue = Request.Params("ClubID")
                    .Enabled = False
                Else
                    .SelectedIndex = 0
                    .Enabled = True
                End If

                PopulateTextBoxes()

            End With

        End Using

    End Sub

    Protected Sub Club_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Club_DropDownList.SelectedIndexChanged

        Using ClubUser As New HBSAcodeLibrary.ClubUserData(Club_DropDownList.SelectedValue)

            If ClubUser.loggedIn Then
                submitButton.Visible = False
                Status_Literal.Text = "<span style='color:red;'>There is a registration recorded for this club already.<br/>" &
                                    "To change it, <a href='ClubLogin.aspx'>Click here and use the <i>Change/Delete Registration</i> link</a> on the login page.<br/>" &
                                    "Enter the current credentials then remove the registration. <br/>" &
                                    "Then try the registration again. </span>"
            Else
                submitButton.Visible = True
                Status_Literal.Text = ""
            End If

        End Using

    End Sub

    Protected Sub PopulateTextBoxes()

        If Not IsNothing(Request.Params("Profile")) AndAlso Request.Params("Profile") Then

            Using clubuser As New HBSAcodeLibrary.ClubUserData(Request.Params("ClubID"))
                With clubuser
                    email_TextBox.Text = .eMail
                    RegistrationPassword_TextBox.Attributes.Add("autocomplete", "new-password")
                    RegistrationPassword_TextBox.Text = ""
                    ConfirmPassword_TextBox.Attributes.Add("autocomplete", "new-password")
                    ConfirmPassword_TextBox.Text = ""
                    FirstName_TextBox.Text = .FirstName
                    Surname_TextBox.Text = .Surname
                    Telephone_TextBox.Text = .Telephone
                End With
            End Using

            submitButton.Visible = True
            Password_Comment.Visible = True
            Password_Literal.Text = "New Password (optional):"
            'help_Column.visible = False

        Else

            email_TextBox.Text = ""
            RegistrationPassword_TextBox.Attributes.Add("autocomplete", "new-password")
            RegistrationPassword_TextBox.Text = ""
            ConfirmPassword_TextBox.Attributes.Add("autocomplete", "new-password")
            ConfirmPassword_TextBox.Text = ""
            FirstName_TextBox.Text = ""
            Surname_TextBox.Text = ""
            Telephone_TextBox.Text = ""

            submitButton.Visible = False
            Password_Comment.Visible = False
            Password_Literal.Text = "Password:"
            'help_Column.Visible = True

        End If
    End Sub

    Protected Sub Return_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Return_Button.Click

        Response.Redirect("ClubLogin.aspx")

    End Sub

    Protected Sub SubmitButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles submitButton.Click

        Status_Literal.Text = ""

        Using ClubUser As New HBSAcodeLibrary.ClubUserData(Club_DropDownList.SelectedValue)

            With ClubUser

                If Not IsNothing(Request.Params("Profile")) Then
                    'If Password_TextBox.Text.Trim = "" AndAlso
                    '   ConfirmPassword_TextBox.Text.Trim = "" Then 'retain password if both textboxes are blank when updating
                    '    Password_TextBox.Text = "*********" '.Password
                    '    ConfirmPassword_TextBox.Text = "*********" '.Password
                    'End If
                Else

                    Club_DropDownList_SelectedIndexChanged(sender, e) 'Check it's ok to proceed

                End If

                If Status_Literal.Text = "" Then

                    If RegistrationPassword_TextBox.Text.Trim <> ConfirmPassword_TextBox.Text Then
                        Status_Literal.Text &= "Passwords must match exactly<br/>"
                    End If
                    If email_TextBox.Text.Trim = "" Then
                        Status_Literal.Text &= "Email address cannot be blank.<br/>"
                    End If
                    If RegistrationPassword_TextBox.Text.Trim.Length > 0 Then
                        If RegistrationPassword_TextBox.Text.Trim.Length < 8 Then
                            Status_Literal.Text &= "Password must be a minimum of 8 characters.<br/>"
                        End If
                    End If
                    If Club_DropDownList.SelectedIndex < 1 Then
                        Status_Literal.Text &= "Club name must be selected.<br/>"
                    End If
                    If FirstName_TextBox.Text.Trim = "" AndAlso
                       Surname_TextBox.Text.Trim = "" AndAlso
                       Telephone_TextBox.Text.Trim = "" Then
                        Status_Literal.Text &= "There must be at least a firstname, Surname or Telephone number.<br/>"
                    End If

                    If Session("captchaString").ToString() <> captcha_Textbox.Text Then
                        Status_Literal.Text += "<br /><span style='color:red;'>Human check failed, please try again.</span>"
                    Else
                        CaptchaRefresh_Button_Click(sender, e)
                    End If

                    If Status_Literal.Text = "" Then

                        Dim oldEmail As String = ""
                        If Not IsNothing(Request.Params("Profile")) Then
                            'if the email address is changing need to inform both emails of the change
                            If email_TextBox.Text.Trim.ToLower <> .eMail.ToLower Then
                                oldEmail = .eMail
                            End If
                        End If

                        Try

                            'generate a random code for confirmation
                            Dim RandomKey As String = HBSAcodeLibrary.Utilities.GenerateRandomKey()

                            'merge the login

                            .ClubID = Club_DropDownList.SelectedValue

                            .eMail = email_TextBox.Text.Trim
                            .Password = RegistrationPassword_TextBox.Text.Trim
                            .ConfirmationCode = RandomKey
                            .FirstName = FirstName_TextBox.Text.Trim
                            .Surname = Surname_TextBox.Text.Trim
                            .Telephone = Telephone_TextBox.Text.Trim

                            .MergeClubUser()

                            Status_Literal.Text = ""

                            'send email with link and code
                            Send_Email(RandomKey, Club_DropDownList.SelectedValue, oldEmail)

                            If Status_Literal.Text = "" Then
                                Status_Literal.Text = " <span style='color:navy;'>Your club's registration request has been recorded.<br/>" &
                                                        "You should soon receive an email to the address you entered, provided it is a valid Email address.<br/>" &
                                                        "This will contain a confirmation code which you should use to confirm this registration.</span>"
                                submitButton.Visible = False
                            End If

                        Catch ex As Exception

                            Status_Literal.Text = "<span style='color:red;font-size:larger;'><b>Error: "

                            If ex.Message Like "*Cannot insert the value NULL into column 'Password'*" Then
                                Status_Literal.Text += "A password must be entered."
                            Else
                                Status_Literal.Text += ex.Message
                            End If
                            Status_Literal.Text += "</b></span>"
                        End Try

                    Else

                        Status_Literal.Text = "<span style='color:red;font-size:larger;'><b>" & Status_Literal.Text & "<b></span>"

                    End If


                End If

            End With

        End Using

    End Sub

    Sub Send_Email(ByVal ConfirmationCode As String, ByVal ClubID As Integer, oldEmail As String)

        Dim toAddress As String
        Dim subject As String
        Dim body As String

        Using ClubData As New HBSAcodeLibrary.ClubData(ClubID)
            subject = "HBSA Club login registration for " & ClubData.ClubName & "."
        End Using

        body = "Your HBSA Club login registration has been recorded or changed.  In order to proceed please confirm your details.<br/><br>" &
               "<a href='" & HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() & "/ClubLoginConfirm.aspx?ClubID=" & ClubID & "&confirm=" & ConfirmationCode &
                                            "'>Click here to verify your registration.</a><br/><br/>" &
               "Alternatively log in at the Club login page (Go to Competitions >> On line entry form).  " &
                       "You will be directed to the confirmation screen where you should enter your password and your confirmation code which is " &
                       ConfirmationCode & ".<br /><br />" &
                        "<br/><br/>Sincerely yours<br/> HBSA"

        toAddress = email_TextBox.Text.Trim

        Try

            HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body)

        Catch ex As Exception

            Dim errorMessage As String = ""
            'errorMessage = ex.Message
            Dim innerEx As Exception = ex.InnerException
            While Not IsNothing(innerEx)
                errorMessage += "<br/>    " & innerEx.Message
                innerEx = innerEx.InnerException
            End While

            Status_Literal.Text = "<span style='color:navy;'>Your HBSA Club login registration has been recorded.</span> <br/>" &
                                  "<span style='color:red;'>However the email requesting confirmation could NOT been sent. <br/>" &
                                  "There was an error.  Please phone 0789 003 2041 for assistance and have the following information to hand:<br/>" &
                                           errorMessage & "</span>"

        End Try

        If oldEmail <> "" Then

            body = "Your HBSA Club login registration has been changed such that you are no longer the registered representative for your club.<br/><br/>" &
                       "The new login email address is " & email_TextBox.Text.Trim & "." &
                        "<br/><br/>Sincerely yours<br/> HBSA"

            toAddress = oldEmail

            Try

                HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body)

            Catch ex2 As Exception

                Dim errorMessage As String
                errorMessage = ex2.Message
                Dim innerEx2 As Exception = ex2.InnerException
                While Not IsNothing(innerEx2)
                    errorMessage += "<br/>    " & innerEx2.Message
                    innerEx2 = innerEx2.InnerException
                End While

                Status_Literal.Text = "<span style='color:red;'>The message to " & oldEmail & "has NOT been sent. <br/>" &
                                           "There was an error.  Please use the contact page and supply the following information:<br/>" &
                                           errorMessage & "</span>"

            End Try

        End If

    End Sub

    Protected Sub CaptchaRefresh_Button_Click(sender As Object, e As EventArgs) Handles captchaRefresh_Button.Click

        'refresh captcha image
        Session("captchaString") = HBSAcodeLibrary.Captcha.SetCaptchaImage(captcha_Image, captcha_Textbox)

    End Sub

End Class