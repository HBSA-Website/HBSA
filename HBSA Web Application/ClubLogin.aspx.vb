Imports AjaxControlToolkit
Imports CKEditor.NET
Imports HBSAcodeLibrary

Public Class ClubLogin
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'If Not (HBSAcodeLibrary.HBSA_Configuration.AllowCompetitionsEntryForms Or HBSAcodeLibrary.HBSA_Configuration.AllowLeaguesEntryForms) Then 'No team login

        '    If Not HBSAcodeLibrary.HBSA_Configuration.CloseSeason() Then
        '        Server.Transfer("Login.aspx")
        '    Else
        '        status_Literal.Text = "<span style='color:red;'><b>***** No logins allowed at the moment... *****</b></span>"
        '        Club_DropDownList.Visible = False
        '        password_TextBox.Visible = False
        '        Login_Button.Visible = False
        '    End If

        'End If

        If Not IsPostBack Then
            Session("ClubLoginID") = Nothing

            With Club_DropDownList
                .Items.Clear()
                .DataSource = HBSAcodeLibrary.ClubUserData.ClubsAndUsers
                .DataTextField = "Club"
                .DataValueField = "EmailAddress"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select your club**", "0"))
            End With

        End If

    End Sub
    Protected Sub Club_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Club_DropDownList.SelectedIndexChanged

        If Club_DropDownList.SelectedIndex < 1 Then
            ClubDetail_Literal.Text = ""
            detailRow.Visible = False
            passwordRow.Visible = False
            profileRow.Visible = False
            loginRow.Visible = False
            status_Literal.Text = ""
        Else
            If Club_DropDownList.SelectedValue = "" Then
                Response.Redirect("ClubLoginRegistration.aspx")
            Else
                Using clubLogin As New HBSAcodeLibrary.ClubUserData(-9, Club_DropDownList.SelectedValue) 'Club ID of -9 gets data using login email address only
                    ClubDetail_Literal.Text = clubLogin.eMail & " (" & clubLogin.FirstName & " " & clubLogin.Surname & ", " & clubLogin.Telephone & ")"
                End Using
                detailRow.Visible = True
                passwordRow.Visible = True
                profileRow.Visible = True
                loginRow.Visible = True
                status_Literal.Text = "Enter your password and click Login or Change/Delete<br />Or Click Forgotten password."
            End If
        End If

    End Sub

    Protected Sub Login_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) _
             Handles Login_Button.Click

        status_Literal.Text = ""
        Session("ClubLoginID") = Nothing

        If Club_DropDownList.SelectedIndex < 1 Then
            status_Literal.Text = "<span style='color:red;'>Please Select a club.</span>"
            Exit Sub
        End If

        Try

            Using _clubUserData As New HBSAcodeLibrary.ClubUserData(Club_DropDownList.SelectedValue, password_TextBox.Text.Trim)

                With _clubUserData
                    If .loggedIn Then
                        Session("ClubLoginID") = .ClubID

                        If .Confirmed Then

                            Session("ClubUserEmail") = Club_DropDownList.SelectedValue.Trim
                            Session("user") = Club_DropDownList.SelectedValue.Trim

                            If Session("ClubLoginCaller") Is Nothing Then
                                If Not Session("LoginCaller") Is Nothing Then
                                    Response.Redirect(Session("LoginCaller"))
                                Else
                                    If HBSAcodeLibrary.HBSA_Configuration.AllowCompetitionsEntryForms Then
                                        Response.Redirect("CompetitionsEntryForm.aspx")
                                    Else
                                        Response.Redirect("EntryForm.aspx")
                                    End If

                                End If
                            Else
                                Response.Redirect(Session("ClubLoginCaller"))
                            End If

                        Else

                            Response.Redirect("ClubLoginConfirm.aspx?ClubID=" & .ClubID)

                        End If

                    Else

                        status_Literal.Text = "<span style='color:red;'>Login failed with these credentials.<br/>Correct them and try again, or click Forgotten Password.</span>"
                        Password_Button.Visible = True

                    End If

                End With

            End Using

        Catch ex As Exception

            If Not TypeOf ex Is System.Threading.ThreadAbortException Then
                status_Literal.Text = "An error occurred.  Please contact HBSA with these details:<br/><br/>" &
                                  ex.Message
            End If
        End Try

    End Sub
    Protected Sub Forgotten_Password(sender As Object, e As System.EventArgs) Handles Password_Button.Click

        If Club_DropDownList.SelectedIndex < 1 Then
            status_Literal.Text = "<span style='color:red;'>Please Select a club.</span>"
            Exit Sub
        End If

        If Club_DropDownList.SelectedValue = "" Then
            status_Literal.Text = "<span style='color:red;'>Please register a login first.</span>"
            Exit Sub
        End If

        Dim ClubLogin As HBSAcodeLibrary.ClubUserData = New HBSAcodeLibrary.ClubUserData(-9, Club_DropDownList.SelectedValue) 'Club ID of -9 gets data using login email address only

        If Not ClubLogin Is Nothing AndAlso ClubLogin.loggedIn Then

            Dim cfg As New HBSAcodeLibrary.HBSA_Configuration

            'store the password reset request
            Using pwd As New PasswordReset
                pwd.emailAddress = ClubLogin.eMail
                pwd.ID = ClubLogin.ClubID
                Try
                    pwd.Insert()
                Catch ex As Exception
                    status_Literal.Text = "<span style='color:red;'>An ERROR occurred." &
                                             "<br>Please contact us and supply the following: " & ex.Message & ".</span>"
                    Dim body As String = "A club password reset request failed for: " & ClubLogin.eMail &
                                                                       " linked to " & ClubLogin.ClubName &
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
                Dim EncryptedID = Server.UrlEncode(Encrypter.EncryptData(ClubLogin.ClubID))

                Dim body As String = "<br/>You have requested a password reset for: " & Club_DropDownList.SelectedItem.Text &
                                             "<br/><br/><a href='" & HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() & "/ClubLoginReset.aspx?ResetPassword=" & EncryptedID & "'>" &
                                             "Click here to be taken to the Club Login password reset page where you will be able to set up a new password.</a>" &
                                             "<br>This password reset is only valid for " & cfg.Value("PasswordResetExpiry") & " hours, after which it will expire and not work." &
                                             "<br>If you need help contact us via the web site contact page."

                ClubLogin = Nothing

                Dim toAddress As String = Club_DropDownList.SelectedValue
                Dim subject As String = "HBSA Club login password reset."

                Try
                    HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body)
                    status_Literal.Text = "An Email has been sent to " & toAddress & " with the password reset request." &
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

        Else

            Password_Button.Visible = True
            status_Literal.Text = "<span style='color:red;'>There is no registration for " & Club_DropDownList.SelectedItem.Text & "." & "</span>"
        End If

    End Sub

    Protected Sub Profile_Button_Click(sender As Object, e As EventArgs) Handles Profile_Button.Click

        If Club_DropDownList.SelectedIndex < 1 Then
            status_Literal.Text = "<span style='color:red;'>Please Select a club.</span>"
            Exit Sub
        End If

        If Club_DropDownList.SelectedValue = "" Then
            status_Literal.Text = "<span style='color:red;'>Please register a login first.</span>"
            Exit Sub
        End If

        Try

            Using _clubUserData As New HBSAcodeLibrary.ClubUserData(Club_DropDownList.SelectedValue, password_TextBox.Text)

                With _clubUserData
                    If .loggedIn Then
                        Session("ClubLoginID") = .ClubID
                        Response.Redirect("ClubLoginRegistration.aspx?Profile=1&ClubID=" & .ClubID)
                    Else
                        status_Literal.Text = "<span style='color:red;'>The password is incorrect.<br/>Correct it and try again, or click Forgotten Password.</span>"
                        password_TextBox.Text = ""
                    End If
                End With

            End Using

        Catch ex As Exception
            status_Literal.Text = "<span style='color:red;'>An error occurred.  Please contact HBSA with these details:<br/><br/>" &
                                  ex.Message

        End Try

    End Sub

End Class