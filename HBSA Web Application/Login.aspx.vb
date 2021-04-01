
Imports HBSAcodeLibrary
Partial Class Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If HBSAcodeLibrary.HBSA_Configuration.CloseSeason() Then 'No team login

            If (HBSAcodeLibrary.HBSA_Configuration.AllowCompetitionsEntryForms Or HBSAcodeLibrary.HBSA_Configuration.AllowLeaguesEntryForms) Then
                Server.Transfer("ClubLogin.aspx")
            Else
                status_Literal.Text = "<span style='color:red;'><b>***** No logins allowed at the moment... *****</b></span>"
                email_TextBox.Visible = False
                password_TextBox.Visible = False
                Login_Button.Visible = False
            End If

        End If


        If Not IsPostBack Then
            'populate team dropdownlist
            With RequestTeam_DropDownList
                .Items.Clear()
                .DataSource = SharedRoutines.FullteamList()
                .DataTextField = "Team"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select your team**", "0"))
            End With
        End If

    End Sub

    Protected Sub Login_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) _
             Handles Login_Button.Click

        status_Literal.Text = ""

        Try

            Using UserData As New HBSAcodeLibrary.UserData(email_TextBox.Text.Trim, password_TextBox.Text.Trim)

                With UserData
                    If .loggedIn Then
                        Session("TeamID") = .TeamID
                        Using TeamData As New TeamData(.TeamID)

                            Session("Email") = UserData.eMail
                            Session("Password") = password_TextBox.Text.Trim
                            Session("UserID") = UserData.UserID
                            Session("UserName") = UserData.FirstName & " " & UserData.Surname
                            Session("user") = UserData.eMail

                            If .Confirmed Then
                                If Session("LoginCaller") Is Nothing Then
                                    Response.Redirect("Login.aspx")
                                Else
                                    Response.Redirect(Session("LoginCaller"))
                                End If

                            Else

                                Response.Redirect("LoginConfirm.aspx")

                            End If

                        End Using
                    Else

                        Dim adminDetails As DataTable = HBSAcodeLibrary.SharedRoutines.CheckAdminLogin(email_TextBox.Text.Trim, password_TextBox.Text.Trim)

                        Try

                            Session("UserType") = adminDetails.Rows(0).Item("Function")

                            If Session("UserType") = "Printer" Then
                                Session("user") = Nothing
                                Session("adminDetails") = Nothing
                            Else
                                Session("adminDetails") = adminDetails
                                Session("user") = adminDetails.Rows(0).Item("username")
                                Session("UserType") = Nothing
                            End If
                        Catch ex As Exception

                        End Try

                        If (Session("adminDetails") Is Nothing OrElse Session("adminDetails").Rows.count = 0) _
                        AndAlso Session("UserType") <> "Printer" Then
                            status_Literal.Text = "<span style='color:red;'>Login failed with these credentials.<br/>Correct them and try again, or click Forgotten Password.</span><br/>Make sure your email address is correct."
                            Password_Button.Visible = True
                        Else

                            Response.Redirect("admin/adminHome.aspx")

                        End If

                    End If
                End With

            End Using

        Catch ex As Exception
            status_Literal.Text = "<span style='color:red;'>An error occurred.  Please contact HBSA with these details:</span><br/><br/>" &
                                  ex.Message

        End Try


    End Sub

    Protected Sub Register_Button_Click(sender As Object, e As System.EventArgs) Handles Register_Button.Click

        Response.Redirect("LoginRegistration.aspx")

    End Sub

    Protected Sub Forgotten_Password(sender As Object, e As System.EventArgs) Handles Password_Button.Click

        Request_Literal.Text = "Reset&nbsp;Password&nbsp;reset"
        RequestPasswordHeader.Visible = False
        RequestPassword.Visible = False
        RequestTeamHeader.Visible = True
        RequestTeam.Visible = True
        RequestEmail_TextBox.Text = email_TextBox.Text
        Instruction_Literal.Text = "Enter your login email address and click Submit (or Cancel to go back)."
        status_Literal.Text = ""
        Request_Panel.Visible = True

    End Sub

    Protected Sub Profile_Button_Click(sender As Object, e As EventArgs) Handles Profile_Button.Click

        Request_Literal.Text = "Request&nbsp;My&nbsp;Registration&nbsp;Details"
        RequestPasswordHeader.Visible = True
        RequestPassword.Visible = True
        RequestTeamHeader.Visible = False
        RequestTeam.Visible = False
        RequestEmail_TextBox.Text = email_TextBox.Text
        RequestPassword_TextBox.Text = password_TextBox.Text
        Instruction_Literal.Text = "Enter your login details and click Submit (or Cancel to go back)."
        status_Literal.Text = ""
        Request_Panel.Visible = True

    End Sub

    Protected Sub SubmitRequest_Button_Click(sender As Object, e As EventArgs) Handles SubmitRequest_Button.Click

        If Request_Literal.Text Like "*Registration*" Then
            RequestProfile()
        Else
            RequestPasswordReset()
        End If

    End Sub

    Protected Sub RequestPasswordReset()

        If RequestEmail_TextBox.Text.Trim = "" Then

            Password_Button.Visible = True
            status_Literal.Text = "<span style='color:red;'>Please enter your email address, then click ""Forgotten Password"".</span>"

        ElseIf RequestTeam_DropDownList.SelectedIndex < 1 Then

            Password_Button.Visible = True
            status_Literal.Text = "<span style='color:red;'>Please select your team, then click ""Forgotten Password"".</span>"

        Else

            Dim LoginDataRow As DataRow = HBSAcodeLibrary.UserData.LoginData(RequestEmail_TextBox.Text.Trim, RequestTeam_DropDownList.SelectedValue)

            If Not LoginDataRow Is Nothing Then

                Dim cfg As New HBSAcodeLibrary.HBSA_Configuration

                'store the password reset request
                Using pwd As New HBSAcodeLibrary.PasswordReset
                    pwd.emailAddress = RequestEmail_TextBox.Text.Trim
                    pwd.ID = LoginDataRow!ID
                    Try
                        pwd.Insert()
                    Catch ex As Exception
                        status_Literal.Text = "<span style='color:red;'>An ERROR occurred." &
                                             "<br>Please contact us and supply the following: " & ex.Message & ".</span>"
                        Dim body As String = "A team password reset request failed for: " & RequestEmail_TextBox.Text.Trim &
                                                                       " linked to " & RequestTeam_DropDownList.SelectedItem.Text &
                                                                       "<br>" & ex.ToString
                        Dim toAddress As String = cfg.Value("WebAdministratorEmail")
                        Dim subject As String = "HBSA Results card login password reset."
                        Try
                            HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body)
                        Catch ex2 As Exception

                        End Try

                        Exit Sub

                    End Try

                End Using

                Using Encrypter As New HBSAcodeLibrary.AES_EncryptDecrypt("HBSA Web Site", "HBSA Reset Password")
                    Dim EncryptedID = Server.UrlEncode(Encrypter.EncryptData(LoginDataRow!ID))

                    Dim body As String = "<br/>You have requested a password reset for: " & RequestEmail_TextBox.Text.Trim & " linked to " & RequestTeam_DropDownList.SelectedItem.Text &
                                             "<br/><br/><a href='" & HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() & "/LoginReset.aspx?ResetPassword=" & EncryptedID & "'>" &
                                             "Click here to be taken to the Team Login password reset page where you will be able to set up a new password.</a>" &
                                             "<br>This password reset is only valid for " & cfg.Value("PasswordResetExpiry") & " hours, after which it will expire and not work." &
                                             "<br>If you need help contact us via the web site contact page."

                    LoginDataRow = Nothing

                    Dim toAddress As String = RequestEmail_TextBox.Text.Trim
                    Dim subject As String = "HBSA Team login password reset."

                    Try
                        HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body)
                        status_Literal.Text = "<span style='color:red;'>An Email has been sent to " & toAddress & " with the password reset request." &
                                             "<br>This password reset is only valid for " & cfg.Value("PasswordResetExpiry") & " hours, after which it will expire and not work.</span>"

                    Catch ex As Exception
                        Dim errorMessage As String
                        errorMessage = ex.Message
                        Dim innerEx As Exception = ex.InnerException
                        While Not IsNothing(innerEx)
                            errorMessage += "<br/>    " & innerEx.Message
                            innerEx = innerEx.InnerException
                        End While

                        status_Literal.Text = "<span style='color:red;'>Your Email has NOT been sent. <br/>" &
                                                           "There was an error.  Please use the contacts page for assistance and add the following information:<br/>" &
                                                           errorMessage & "</span>"
                    End Try

                End Using

                Request_Panel.Visible = False

            Else

                Password_Button.Visible = True
                status_Literal.Text = "<span style='color:red;'>There is no registration with this email address and club (" & email_TextBox.Text.Trim & " for " & RequestTeam_DropDownList.SelectedItem.Text & ")." &
                                              "<br/>Correct the Email address and/or the selected club and click 'Forgotten Password' or click 'Cancel'</span>"
                email_TextBox.Text = RequestEmail_TextBox.Text
            End If

        End If

    End Sub

    Protected Sub RequestProfile()

        status_Literal.Text = ""

        Try

            Using UserData As New HBSAcodeLibrary.UserData(RequestEmail_TextBox.Text.Trim, RequestPassword_TextBox.Text.Trim)

                With UserData
                    If .loggedIn Then
                        Session("TeamID") = .TeamID
                        Using TeamData As New TeamData(.TeamID)

                            Session("Email") = UserData.eMail
                            Session("Password") = RequestPassword_TextBox.Text.Trim
                            Session("UserID") = UserData.UserID
                            Session("UserName") = UserData.FirstName & " " & UserData.Surname
                            Session("user") = UserData.eMail

                            If .Confirmed Then
                                Response.Redirect("LoginProfile.aspx")
                            Else
                                Response.Redirect("LoginConfirm.aspx")
                            End If

                        End Using
                    Else

                        status_Literal.Text = "<span style='color:red;'>These login credentials are incorrect.<br/>Correct them and try again, or click Forgotten Password.</span><br/>Make sure your email address is correct."
                        email_TextBox.Text = RequestEmail_TextBox.Text
                        password_TextBox.Text = RequestPassword_TextBox.Text
                    End If
                End With

            End Using

        Catch ex As Exception
            status_Literal.Text = "<span style='color:red;'>An error occurred.  Please contact HBSA with these details:</span><br/><br/>" &
                                  ex.Message

        End Try

        Request_Panel.Visible = False

    End Sub

    Protected Sub CancelRequest_Button_Click(sender As Object, e As EventArgs) Handles CancelRequest_Button.Click

        Request_Panel.Visible = False

    End Sub

End Class
