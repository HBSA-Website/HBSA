Imports HBSAcodeLibrary

Public Class ClubLoginRegistration1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Me.IsPostBack Then
            passwordTextBox.Attributes("value") = HiddenPassword.Value
            confirmPasswordTextBox.Attributes("value") = HiddenConfirm.Value

        Else

            If Request.Params("Profile") = 1 Then
                profiling.Value = True
                removeButton.Visible = True
            Else
                profiling.Value = False
                removeButton.Visible = False
            End If
            clubIDhidden.Value = Request.Params("ClubID")

            PopulateClubs()

        End If

    End Sub

    Protected Sub PopulateClubs()

        Using clubsList As DataTable = ClubData.GetClubs(0)

            With clubsDropDownList
                .Items.Clear()

                .DataSource = clubsList
                .DataTextField = "Club Name"
                .DataValueField = "ID"
                .DataBind()

                .Items.Insert(0, New ListItem("**Select a Club**", "-1"))

                If profiling.Value = True Then
                    .SelectedValue = clubIDhidden.Value
                    .Enabled = False
                Else
                    .SelectedIndex = 0
                    .Enabled = True
                End If

                PopulateTextBoxes()

            End With

        End Using

    End Sub

    Protected Sub ClubsDropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles clubsDropDownList.SelectedIndexChanged

        Using ClubUser As New HBSAcodeLibrary.ClubUserData(clubsDropDownList.SelectedValue)

            If ClubUser.loggedIn Then
                submitButton.Visible = False
                statusLabel.Text = "<span style='color:red;'>There is a registration recorded for this club already.<br/>" &
                                    "To change it, <a href='ClubLogin.aspx'>Click here and use the <i>Change/Delete Registration</i> link</a> on the login page.<br/>" &
                                    "Enter the current credentials then remove the registration. <br/>" &
                                    "Then try the registration again. </span>"
            Else
                submitButton.Visible = True
                statusLabel.Text = ""
            End If

        End Using

    End Sub

    Protected Sub PopulateTextBoxes()

        If profiling.Value = True Then

            Using clubuser As New HBSAcodeLibrary.ClubUserData(clubIDhidden.Value)
                With clubuser
                    EmailTextBox.Text = .eMail
                    passwordTextBox.Text = "" '.Password
                    confirmPasswordTextBox.Text = "" '.Password
                    firstNameTextbox.Text = .FirstName
                    surnameTextBox.Text = .Surname
                    telephoneTextBox.Text = .Telephone
                End With
            End Using

            submitButton.Visible = True
            passwordComment.Visible = True

        Else

            EmailTextBox.Text = ""
            passwordTextBox.Text = "" '.Password
            confirmPasswordTextBox.Text = "" '.Password
            firstNameTextbox.Text = ""
            surnameTextBox.Text = ""
            telephoneTextBox.Text = ""

            submitButton.Visible = False
            'telephoneTextBox.Visible = False

        End If
    End Sub

#Region "Next/Prev buttons"

    Sub EnablePanel(formPanel As Object)

        For Each ctl As Control In panelsDiv.Controls
            If TypeOf ctl Is Panel Then
                If ctl.ClientID = formPanel.ID Then
                    ctl.Visible = True
                Else
                    ctl.Visible = False
                End If
            End If
        Next

        statusLabel.Text = ""

    End Sub

    Protected Sub Next_Button0_Click(sender As Object, e As EventArgs) Handles nextButton0.Click
        If ShowLogin() Then EnablePanel(passwordPanel)
    End Sub

    Protected Sub Next_Button1_Click(sender As Object, e As EventArgs) Handles nextButton1.Click
        If ShowPassword() Then
            EnablePanel(namePanel)
            HiddenPassword.Value = passwordTextBox.Text.Trim
            HiddenConfirm.Value = confirmPasswordTextBox.Text.Trim
        End If
    End Sub
    Function ShowLogin() As Boolean

        statusLabel.Text = ""

        If EmailTextBox.Text = "" Then
            statusLabel.Text = "Email address cannot be blank.<br/>"
        Else
            If Not HBSAcodeLibrary.Emailer.IsValidEmailAddress(EmailTextBox.Text.Trim) Then
                statusLabel.Text &= "The Email address is not valid.<br/>"
            Else
                If clubsDropDownList.SelectedIndex < 1 Then
                    statusLabel.Text = "Club name must be selected.<br/>"
                Else
                    loginLiteral.Text = EmailTextBox.Text & " of " & clubsDropDownList.SelectedItem.Text
                    Return True
                End If
            End If
        End If

        Return False

    End Function
    Function ShowPassword() As Boolean

        If passwordTextBox.Text.Trim <> confirmPasswordTextBox.Text.Trim Then
            statusLabel.Text += "Passwords must match exactly<br/>"
            Return False
        Else
            If passwordTextBox.Text.Trim.Length > 0 Then
                If passwordTextBox.Text.Trim.Length < 8 Then
                    statusLabel.Text += "Password must be a minimum of 8 characters.<br/>"
                    Return False
                End If
            Else
                If profiling.Value = False Then
                    statusLabel.Text += "Must have a password for new registration.<br/>"
                    Return False
                End If
            End If
            Session("Password") = passwordTextBox.Text.Trim
            Return True

        End If

    End Function
    Sub ShowName()

        If telephoneTextBox.Text.Trim <> "" Then
            Dim formattedNo = SharedRoutines.CheckValidPhoneNoForHuddersfield(telephoneTextBox.Text)
            If formattedNo.StartsWith("ERR") Then
                statusLabel.Text &= "Telephone number is invalid.<br/>"
            Else
                telephoneTextBox.Text = formattedNo
            End If
        End If
        If firstNameTextbox.Text.Trim = "" AndAlso
           surnameTextBox.Text.Trim = "" AndAlso
           telephoneTextBox.Text.Trim = "" Then
            statusLabel.Text &= "At least one of first name, surname or telephone must be entered.<br/>"
        End If

        If statusLabel.Text = "" Then
            nameLiteral.Text = firstNameTextbox.Text & "&nbsp;" & surnameTextBox.Text & "&nbsp;(" & telephoneTextBox.Text & ")"
        End If

    End Sub
    Protected Sub Prev_Button1_Click(sender As Object, e As EventArgs) Handles prevButton1.Click
        EnablePanel(loginPanel)
    End Sub
    Protected Sub Prev_Button2_Click(sender As Object, e As EventArgs) Handles prevButton2.Click
        EnablePanel(passwordPanel)
    End Sub

#End Region

    Protected Sub SubmitButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles submitButton.Click

        statusLabel.Text = ""

        ShowName()

        Using ClubUser As New HBSAcodeLibrary.ClubUserData(clubsDropDownList.SelectedValue)

            With ClubUser

                If profiling.Value = False Then
                    ClubsDropDownList_SelectedIndexChanged(sender, e) 'New registration - Check it doesn't already exist (will fill statusLabel)
                End If

                If statusLabel.Text = "" Then

                    ShowName()
                    ShowLogin()


                    If statusLabel.Text = "" Then

                        Dim oldEmail As String = ""
                        If profiling.Value = True Then
                            'if the email address is changing need to inform both emails of the change
                            If EmailTextBox.Text.Trim.ToLower <> .eMail.ToLower Then
                                oldEmail = .eMail
                            End If
                        End If

                        Try

                            'generate a random code for confirmation
                            Dim RandomKey As String = HBSAcodeLibrary.Utilities.GenerateRandomKey()

                            'merge the login

                            .ClubID = clubsDropDownList.SelectedValue

                            .eMail = EmailTextBox.Text.Trim
                            .Password = Session("Password")
                            .ConfirmationCode = RandomKey
                            .FirstName = firstNameTextbox.Text.Trim
                            .Surname = surnameTextBox.Text.Trim
                            .Telephone = telephoneTextBox.Text.Trim

                            .MergeClubUser()

                            statusLabel.Text = ""

                            'send email with link and code
                            Send_Email(RandomKey, clubsDropDownList.SelectedValue, oldEmail)

                            If statusLabel.Text = "" Then
                                statusLabel.Text = " <span style='color:navy;'>Your club's registration request has been recorded.<br/>" &
                                                        "You should soon receive an email to the address you entered, provided it is a valid Email address.<br/>" &
                                                        "This will contain a confirmation code which you should use to confirm this registration.</span>"
                                submitButton.Visible = False
                            End If

                        Catch ex As Exception

                            If ex.Message.ToLower.Contains("primary key") Then
                                statusLabel.Text = "This email password combination already exists for another club,</font>"
                            Else
                                statusLabel.Text = "<span style='color:red;'>Error: " & ex.Message & "</span>"
                            End If

                        End Try

                    Else

                        statusLabel.Text = "<span style='color:red;'>" & statusLabel.Text & "</span>"

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
               "<a href='" & HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() & "/mobile/ClubLoginConfirm.aspx?ClubID=" & ClubID & "&confirm=" & ConfirmationCode &
                                            "'>Click here to verify your registration.</a><br/><br/>" &
               "Alternatively log in at the Club login page (Go to Competitions >> On line entry form).  " &
                       "You will be directed to the confirmation screen where you should enter your password and your confirmation code which is " &
                       ConfirmationCode & ".<br /><br />" &
                        "<br/><br/>Sincerely yours<br/> HBSA"

        toAddress = EmailTextBox.Text.Trim

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

            statusLabel.Text = "<span style='color:navy;'>Your HBSA Club login registration has been recorded.</span> <br/>" &
                                  "<span style='color:red;'>However the email requesting confirmation could NOT been sent. <br/>" &
                                  "There was an error.  Please phone 0789 003 2041 for assistance and have the following information to hand:<br/>" &
                                           errorMessage & "</span>"

        End Try

        If oldEmail <> "" Then

            body = "Your HBSA Club login registration has been changed such that you are no longer the registered representative for your club.<br/><br/>" &
                       "The new login email address is " & EmailTextBox.Text.Trim & "." &
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

                statusLabel.Text = "<span style='color:red;'>The message to " & oldEmail & "has NOT been sent. <br/>" &
                                           "There was an error.  Please use the contact page and supply the following information:<br/>" &
                                           errorMessage & "</span>"

            End Try

        End If

    End Sub

    Protected Sub DeleteButton_Click(sender As Object, e As EventArgs) Handles deleteButton.Click

        EnablePanel(deletePanel)
        removeButton.Visible = False
        deleteLabel.Text = "Touch 'Remove Permantly' to remove this Club's login registration"

    End Sub

    Protected Sub DeleteCancelButton_Click(sender As Object, e As EventArgs) Handles deleteCancelButton.Click

        EnablePanel(loginPanel)
        If profiling.Value = True Then
            removeButton.Visible = True
        End If

    End Sub

    Protected Sub DeleteConfirmButton_Click(sender As Object, e As EventArgs) Handles deleteConfirmButton.Click

        Using user As New HBSAcodeLibrary.ClubUserData(clubIDhidden.Value)
            user.eMail = "" 'this signifies delete in merge
            user.MergeClubUser()
            Session("ClubLoginID") = Nothing
            Session.Clear()
            statusLabel.Text = "<a href='ClubLogin.aspx'>This club's registration has been removed. Touch here to return.</a>"
            deleteRow.Visible = False
        End Using

    End Sub


End Class