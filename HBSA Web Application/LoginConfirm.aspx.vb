Imports HBSAcodeLibrary
Partial Class LoginConfirm
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            Dim Params As System.Collections.Specialized.NameValueCollection = Request.QueryString
            Dim keyCounter As Integer = 0
            If Not Params Is Nothing Then
                For Each key As String In Params.AllKeys

                    If key.ToLower = "userid" Then

                        Using u As UserData = New UserData(id:=CInt(Params.Item(key)))

                            email_TextBox.Text = u.eMail

                            Using teamData As New TeamData(u.TeamID)
                                With teamData
                                    keyCounter += 1
                                    ClubName_TextBox.Text = .ClubName
                                    TeamLetter_TextBox.Text = .Team
                                    Section_TextBox.Text = .SectionName
                                    League_TextBox.Text = .LeagueName
                                End With
                            End Using

                        End Using

                    End If

                    If key.ToLower = "confirm" Then
                        keyCounter += 1
                        Confirm_TextBox.Text = Params.Item(key)
                    End If
                Next
            End If

            If keyCounter <> 2 Then
                Status_Label.Text = "<span style='color:blue;'>If you arrived here after logging in, that is because your registration needs to be confirmed.<br/><br>" &
                                    "Enter only your password, and the confirmation code <br/>" &
                                    "&nbsp;&nbsp;&nbsp;&nbsp;(this can be found in the email you should have received to confirm your registration).<br/><br/>" &
                                    "Then click confirm.</span>"

                email_TextBox.Text = Session("Email")
                Using teamData As New TeamData(Session("TeamID"))
                    With teamData
                        ClubName_TextBox.Text = .ClubName
                        TeamLetter_TextBox.Text = .Team
                        Section_TextBox.Text = .SectionName
                        League_TextBox.Text = .LeagueName
                    End With
                End Using

            Else
                Status_Label.Text = "<span style='color:blue;'>Enter your password, then click confirm.</span>"

            End If
        End If

    End Sub

    Protected Sub Confirm_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Confirm_Button.Click

        If Confirm_Button.Text = "Confirm" Then

            Try
                Using UserData As New HBSAcodeLibrary.UserData(email_TextBox.Text.Trim, Password_TextBox.Text.Trim)
                    With UserData
                        If .loggedIn Then
                            If .Confirmed Then
                                Session("TeamID") = .TeamID
                                Session("Email") = email_TextBox.Text.Trim
                                Session("Password") = Password_TextBox.Text.Trim
                                Status_Label.ForeColor = Drawing.Color.Red
                                Status_Label.Text = "This login is already confirmed. Click 'Proceed'."
                                Confirm_Button.Text = "Proceed"
                            Else
                                .ConfirmCode = Confirm_TextBox.Text.Trim
                                Try

                                    .ConfirmUser()

                                    Session("TeamID") = .TeamID
                                    Session("Email") = email_TextBox.Text.Trim
                                    Session("Password") = Password_TextBox.Text.Trim
                                    Status_Label.ForeColor = Drawing.Color.DarkBlue
                                    Status_Label.Text = "Your login is now confirmed. Click 'Proceed'."
                                    Confirm_Button.Text = "Proceed"

                                Catch ex As Exception
                                    Status_Label.Text = "Your confirmation failed because " & ex.Message &
                                                       "<br/> Go back to the confirmation email you received and check the confirmation code, and click the link, or copy and paste it into your browser's address box.</font>"
                                    Confirm_Button.Text = "Return"

                                End Try

                            End If
                        Else
                            Status_Label.Text = "Your confirmation failed because the password is incorrect.  Correct it and try again.<br/><br/>"
                        End If
                    End With
                End Using

            Catch ex As Exception
                Status_Label.ForeColor = Drawing.Color.Red
                Status_Label.Text = "An error occurred.  Please contact HBSA with these details:" & vbCrLf & vbCrLf &
                                    ex.Message

            End Try

        ElseIf Confirm_Button.Text = "Proceed" Then
            If Session("LoginCaller") Is Nothing Then
                Response.Redirect("Home.aspx")
            Else
                Response.Redirect(Session("LoginCaller"))
            End If
        Else
            Response.Redirect("Login.aspx")

        End If
    End Sub

    Protected Sub Cancel_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        Response.Redirect("Home.aspx")

    End Sub

End Class
