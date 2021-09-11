Public Class PlayerRegistrationRequest1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            Session("captchaString") = HBSAcodeLibrary.Captcha.SetCaptchaImage(captcha_Image, captcha_Textbox)
            PopulateSections()

        End If


    End Sub

    Protected Sub PopulateSections()

        Using dt As DataTable = HBSAcodeLibrary.LeagueData.GetSections(0)

            With Section_DropDownList
                .Items.Clear()
                .Visible = True
                .DataSource = dt
                .DataTextField = "Section Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, "**Select a division/section**")
                .SelectedIndex = 0
            End With

        End Using

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        If Section_DropDownList.SelectedIndex > 0 Then

            Over80Row.Visible = Section_DropDownList.SelectedItem.Text.ToLower Like "*vet*"
            Over80_CheckBox.Checked = False

            Team_Literal.Text = ""
            Using Teams As DataTable = HBSAcodeLibrary.TeamData.GetTeams(Section_DropDownList.SelectedValue)
                With Team_DropDownList
                    .Items.Clear()
                    For Each team As DataRow In Teams.Rows
                        .Items.Add(New ListItem(team!Team, team!TeamID))
                    Next
                    '.DataTextField = "Team"
                    '.DataValueField = "TeamID"
                    '.DataBind()
                    .Items.Insert(0, New ListItem("** Select a team **", 0))
                    .SelectedIndex = 0
                End With
            End Using
        Else
            Team_Literal.Text = "<br />Select a division/section first."
        End If

    End Sub
    Protected Sub Send_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) _
        Handles Send_Button.Click

        status_Literal.Text = ""

        If RequesterEmail_TextBox.Text.Trim = "" OrElse
           RequesterName_TextBox.Text = "" OrElse
           PlayerName_TextBox.Text.Trim = "" OrElse
           Team_DropDownList.SelectedIndex < 1 Then
            status_Literal.Text += "<br />Please ensure all required entries are completed/selected"
        End If

        Dim Handicap As Integer
        Try
            Handicap = CInt(Handicap_TextBox.Text)
        Catch ex As Exception
            status_Literal.Text += "<br />Enter a valid handicap (numeric)"
        End Try

        If Session("captchaString").ToString() <> captcha_Textbox.Text Then
            status_Literal.Text += "<br />Human check failed, please try again."
        Else
            Session("captchaString") = HBSAcodeLibrary.Captcha.SetCaptchaImage(captcha_Image, captcha_Textbox)
            captcha_Textbox.Text = ""
        End If

        If Not HBSAcodeLibrary.Emailer.IsValidEmailAddress(RequesterEmail_TextBox.Text.Trim) Then
            status_Literal.Text += "<br />Requester email is invalid."
        End If
        If PlayerEmail_TextBox.Text.Trim <> "" AndAlso
            Not HBSAcodeLibrary.Emailer.IsValidEmailAddress(PlayerEmail_TextBox.Text.Trim) Then
            status_Literal.Text += "<br />Player email is invalid."
        End If
        If PlayerTelNo_TextBox.Text.Trim <> "" Then
            Dim phoneNo As String = HBSAcodeLibrary.SharedRoutines.CheckValidPhoneNoForHuddersfield(PlayerTelNo_TextBox.Text.Trim)
            If phoneNo.ToUpper.StartsWith("ERROR") Then
                status_Literal.Text += "<br />Player's phone No is invalid (" + phoneNo + ")"
            Else
                PlayerTelNo_TextBox.Text = phoneNo
            End If
        End If

        If status_Literal.Text <> "" Then
            status_Literal.Text = "<span style='color:red;'>" + status_Literal.Text.Substring(6) + "</span>"
            Exit Sub
        End If

        'validated, send the email

        Using cfg As New HBSAcodeLibrary.HBSA_Configuration
            Dim toAddress As String = cfg.Value("HandicapCommittee")
            Dim ccAddress As String = cfg.Value("WebAdministratorEmail") + ";" + cfg.Value("LeagueSecretaryEmail")
            Dim subject As String = "Player Registration Request"
            Dim body As String = "<b>A player registration has been requested.</b> and the request forwarded to the handicap committee.<br/><br/>" &
                                 "Please check this player for history and/or being a member of another team.<br/>If it is considered that it is OK to register him/her check or allocate a handicap.<br/>" &
                                 "In the admin section look for this player (may be registered as deleted, or may belong to another team).  Then amend an existing player or add a new player.<br/><br/>" &
                                 "Finally communicate your decision and action to the requester (his/her email should be shown below.<br/><br/>" &
                                 "Requested by: " & RequesterName_TextBox.Text.Trim & " (eMail:" & RequesterEmail_TextBox.Text.Trim & ")<br/>" &
                                 "<br/>Player Name: " & PlayerName_TextBox.Text.Trim &
                                        If(PlayerEmail_TextBox.Text.Trim <> "", " (eMail:" + PlayerEmail_TextBox.Text.Trim + ")", "") &
                                        If(PlayerTelNo_TextBox.Text.Trim <> "", " (TelNo:" + PlayerTelNo_TextBox.Text.Trim + ")", "") &
                                 "<br/>Division/Section: " & Section_DropDownList.SelectedItem.Text &
                                 "<br/>Handicap: " & Handicap_TextBox.Text.Trim &
                                 "<br/>Team: " & Team_DropDownList.SelectedItem.Text &
                                 If(Over80Row.Visible,
                                     "<br/>Over 80: " & If(Over80_CheckBox.Checked, "YES", "NO"), "") &
                                 "<br/><u>Comments etc.</u><br/>" & body_TextBox.Text.Trim.Replace(vbCrLf, "<br/>").Replace(vbLf, "<br/>").Replace(vbCr, "<br/>")
            Try
                HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body, ccAddress)
                status_Literal.Text = "<span style='color:blue;'>Your message has been sent to the HBSA Committee.</span>"

            Catch ex As Exception
                Dim errorMessage As String
                errorMessage = ex.Message
                Dim innerEx As Exception = ex.InnerException
                While Not IsNothing(innerEx)
                    errorMessage += "<br/>    " & innerEx.Message
                    innerEx = innerEx.InnerException
                End While

                status_Literal.Text = "<span style='color:red;'>Your message has NOT been sent.<br/><br/>" &
                                      "There was an error.  Please contact the League Secretary for assistance and have the following information to hand:<br/>" &
                                      errorMessage & "</span>"
            End Try

        End Using

    End Sub
    Protected Function eMailAddress(Box As TextBox) As String
        Return Box.Text.Trim
    End Function
    Protected Sub CaptchaRefresh_Button_Click(sender As Object, e As EventArgs) Handles captchaRefresh_Button.Click

        'refresh captcha image
        Session("captchaString") = HBSAcodeLibrary.Captcha.SetCaptchaImage(captcha_Image, captcha_Textbox)
        status_Literal.Text = ""
        captcha_Textbox.Text = ""

    End Sub
End Class