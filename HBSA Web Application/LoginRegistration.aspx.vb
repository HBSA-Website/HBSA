Imports System.IO
Imports HBSAcodeLibrary

Partial Class LoginRegistration
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            Session("captchaString") = HBSAcodeLibrary.Captcha.SetCaptchaImage(captcha_Image, captcha_Textbox)

            Using leaguesList As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues
                With League_DropDownList
                    .Items.Clear()
                    .DataSource = leaguesList
                    .DataTextField = "League Name"
                    .DataValueField = "ID"
                    .DataBind()
                    .Items.Insert(0, New ListItem("**Select a league**", 0))
                    .SelectedIndex = 0
                End With

            End Using

        End If

    End Sub

#Region "Drop Downs control"
    Protected Sub League_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles League_DropDownList.SelectedIndexChanged

        Using sectionsInfo As DataTable = HBSAcodeLibrary.LeagueData.GetSections(League_DropDownList.SelectedValue)

            With Section_DropDownList
                .Visible = True
                .Items.Clear()
                .DataSource = sectionsInfo
                .DataTextField = "Section Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select a division/section**", 0))
                If sectionsInfo.Rows.Count < 2 Then
                    .Enabled = False
                    Section_DropDownList_SelectedIndexChanged(sender, e)
                Else
                    .Enabled = True
                End If

                .SelectedIndex = 0

                Club_DropDownList.Visible = False
                TeamLetter_DropDownList.Visible = False

            End With

        End Using

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        Using clubsList As DataTable = HBSAcodeLibrary.ClubData.GetClubs(Section_DropDownList.SelectedValue)

            With Club_DropDownList
                .Items.Clear()
                .DataSource = clubsList
                .DataTextField = "Club Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select a club**", 0))
                .Visible = True
                TeamLetter_DropDownList.Visible = False
                .SelectedIndex = 0
            End With

        End Using

    End Sub

    Protected Sub Club_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Club_DropDownList.SelectedIndexChanged

        Using teamList As DataTable = HBSAcodeLibrary.TeamData.TeamLetters(Section_DropDownList.SelectedValue, Club_DropDownList.SelectedValue)

            With TeamLetter_DropDownList

                .Visible = True
                .Items.Clear()

                If teamList.Rows.Count > 1 Then
                    .Items.Add("** Select a team **")
                    .Enabled = True
                Else
                    .Enabled = False
                End If

                For Each row As DataRow In teamList.Rows
                    .Items.Add(New ListItem(IIf(row.Item("Team").trim = "", "(none)", row.Item("Team")), row.Item("ID")))
                Next

                .SelectedIndex = 0

            End With

        End Using

    End Sub

    Protected Sub Return_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Return_Button.Click

        Session("TeamID") = Nothing
        Response.Redirect("Login.aspx")

    End Sub
#End Region
    Protected Sub Register_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Register_Button.Click

        If Register_Button.Text = "Return" Then
            Response.Redirect("Login.aspx")
        Else
            Status_Label.Text = ""

            If Not HBSAcodeLibrary.Emailer.IsValidEmailAddress(email_TextBox.Text.Trim) Then
                Status_Label.Text &= "The Email address is not valid.<br/>"
            End If
            If Password_TextBox.Text.Trim <> ConfirmPassword_TextBox.Text Then
                Status_Label.Text &= "Passwords must match exactly<br/>"
            End If
            If Password_TextBox.Text.Trim.Length < 8 Then
                Status_Label.Text &= "Password must be a minimum of 8 characters.<br/>"
            End If
            If Club_DropDownList.SelectedIndex < 1 Then
                Status_Label.Text &= "Club name must be selected.<br/>"
            End If
            If Telephone_TextBox.Text.Trim <> "" Then
                Dim formattedNo = SharedRoutines.CheckValidPhoneNoForHuddersfield(Telephone_TextBox.Text)
                If formattedNo.StartsWith("ERR") Then
                    Status_Label.Text &= "Telephone number is invalid.<br/>"
                Else
                    Telephone_TextBox.Text = formattedNo
                End If
            End If

            If Status_Label.Text <> "" Then
                Status_Label.Text = "<span style='color:red'>" & Status_Label.Text & "</span"
                Exit Sub
            End If

            If Session("captchaString").ToString() <> captcha_Textbox.Text Then
                Status_Label.Text += "<br /><span style='color:red;'>Human check failed, please try again.</span>"
            Else
                CaptchaRefresh_Button_Click(sender, e)
            End If

            If Status_Label.Text = "" Then
                Try

                    'generate a random code for confirmation
                    Dim RandomKey As String = HBSAcodeLibrary.Utilities.GenerateRandomKey()
                    Dim UserID As Integer

                    Using user As New HBSAcodeLibrary.UserData()

                        With user
                            .eMail = email_TextBox.Text.Trim
                            .NewPassword = Password_TextBox.Text.Trim
                            .FirstName = FirstName_TextBox.Text.Trim
                            .Surname = Surname_TextBox.Text.Trim
                            .Telephone = Telephone_TextBox.Text.Trim
                            .TeamID = TeamLetter_DropDownList.SelectedValue

                            'create the new login and get the ID
                            UserID = .CreateUser(RandomKey)

                        End With

                    End Using

                    'send email with link and code
                    Status_Label.Text = ""

                    Send_Email(RandomKey, UserID, TeamLetter_DropDownList.SelectedValue)

                    If Status_Label.Text = "" Then
                        Status_Label.ForeColor = Drawing.Color.DarkGreen
                        Status_Label.Text = "Your registration request has been recorded.  You will soon receive an email to the address you entered. This will contain a confirmation code which you should enter to be able to proceed."
                        Register_Button.Text = "Return"
                    End If

                Catch ex As Exception
                    Status_Label.ForeColor = Drawing.Color.Red
                    Status_Label.Text = "Error: " & ex.Message
                End Try
            Else
                Status_Label.ForeColor = Drawing.Color.Red

            End If

        End If

    End Sub

    Sub Send_Email(ByVal ConfirmationCode As String, ByVal UserID As Integer, TeamID As Integer)

        Dim toAddress As String
        Dim subject As String
        Dim body As String

        Using Team As New HBSAcodeLibrary.TeamData(TeamID)
            subject = "HBSA Results card login registration " & Team.ClubName & " " & Team.Team & "."
        End Using

        body = "Your HBSA team login registration has been recorded.  In order to proceed please " &
                     "<a href='" & HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() & "/LoginConfirm.aspx" &
                                        "?userID=" & UserID &
                                        "&confirm=" & ConfirmationCode &
                                        "'>Click here to verify your registration.</a><br /><br />" &
                   "Alternatively  verify your details by logging in at the login page.  You will be directed to the confirmation " &
                   "screen where you should enter your details and your confirmation code which is " & ConfirmationCode &
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

            Status_Label.ForeColor = Drawing.Color.Red
            Status_Label.Text = "Your HBSA Results card login registration has been recorded. <br/>" &
                                "However the email requesting confirmation could NOT been sent. <br/>" &
                                "There was an error.  Please phone 0789 003 2041 for assistance and have the following information to hand:<br/>" &
                                           errorMessage

        End Try

    End Sub

    Protected Sub CaptchaRefresh_Button_Click(sender As Object, e As EventArgs) Handles captchaRefresh_Button.Click

        'refresh captcha image
        Session("captchaString") = HBSAcodeLibrary.Captcha.SetCaptchaImage(captcha_Image, captcha_Textbox)

    End Sub

End Class
