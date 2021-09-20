Public Class ContactUsTest
    Inherits System.Web.UI.Page
    Private Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Not IsPostBack Then

            Session("captchaString") = HBSAcodeLibrary.Captcha.SetCaptchaImage(captcha_Image, captcha_Textbox)

            With Destination_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("** Choose where this email should go **", ""))
                Using cfg As New HBSAcodeLibrary.HBSA_Configuration
                    .Items.Add(New ListItem("Handicap Secretary (new players / handicap queries)", cfg.Value("HandicapCommittee")))
                    .Items.Add(New ListItem("League Secretary", cfg.Value("LeagueSecretaryEmail")))
                    .Items.Add(New ListItem("Competitions Secretary", cfg.Value("CompetitionsSecretaryEmail")))
                End Using
            End With

            With Clubs_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("** Choose your club **", "-1"))
                Using Clubs As DataTable = HBSAcodeLibrary.ClubData.GetClubs()
                    For Each club As DataRow In Clubs.Rows
                        .Items.Add(New ListItem(club.Item("Club Name"), club!ID))
                    Next
                End Using
            End With

        End If

    End Sub
    Protected Sub CaptchaRefresh_Button_Click(sender As Object, e As EventArgs) Handles captchaRefresh_Button.Click

        'refresh captcha image
        Session("captchaString") = HBSAcodeLibrary.Captcha.SetCaptchaImage(captcha_Image, captcha_Textbox)

    End Sub

    Protected Sub Destination_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Destination_DropDownList.SelectedIndexChanged

        CompsRow.Visible = False
        ShowHideHcapRows(False)

        If Destination_DropDownList.SelectedItem.Text.ToLower Like "*competition*" Then
            CompsRow.Visible = True
            PopulateCompetitionsDropDown()
        ElseIf Destination_DropDownList.SelectedItem.Text.ToLower Like "*handicap*" Then
            ShowHideHcapRows(True)
        End If

    End Sub
    Sub ShowHideHcapRows(show As Boolean)

        HcapRow1.Visible = show
        HcapRow2.Visible = show
        HcapRow3.Visible = show
        HcapRow4.Visible = show
        HcapRow5.Visible = show

    End Sub
    Sub PopulateCompetitionsDropDown()

        Using comps As DataTable = HBSAcodeLibrary.CompetitionData.GetCompetitions(1)

            With Competitions_DropDownList
                .Items.Clear()
                .Visible = True
                .Enabled = True

                If comps.Rows.Count > 0 Then

                    .Items.Add(New ListItem("**Select a Competition**", 0))
                    For Each row As DataRow In comps.Rows
                        .Items.Add(New ListItem(row.Item("Name"), row.Item("ID")))
                    Next
                    .Items.Add(New ListItem("Not competition related", -1))

                    .SelectedIndex = 0

                Else

                    .Items.Add(New ListItem("** No Competitions have been drawn yet. **", 0))
                    .Enabled = False

                End If

            End With

        End Using

    End Sub
    Protected Sub Send_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) _
        Handles Send_Button.Click

        status_Literal.Text = ""

        If Email_TextBox.Text.Trim = "" OrElse
           Name_TextBox.Text.Trim = "" OrElse
           body_TextBox.Text.Trim = "" OrElse
           Clubs_DropDownList.SelectedIndex < 1 OrElse
           captcha_Textbox.Text.Trim = "" Then
            status_Literal.Text += "<br /><span style='color:red;'>Please ensure all required boxes are completed</span>"
        End If

        If Destination_DropDownList.SelectedIndex < 1 Then
            status_Literal.Text += "<br /><span style='color:red;'>Please select where the email should be sent to</span>"
        End If

        If Session("captchaString").ToString() <> captcha_Textbox.Text Then
            status_Literal.Text += "<br /><span style='color:red;'>Human check failed, please try again.</span>"
        Else
            CaptchaRefresh_Button_Click(sender, e)
        End If

        If Destination_DropDownList.SelectedItem.Text.ToLower Like "*competition*" Then
            If Competitions_DropDownList.SelectedIndex < 1 Then
                status_Literal.Text += "<br /><span style='color:red;'>Please select a competition or choose 'Not competition related'.</span>"
            End If
        ElseIf Destination_DropDownList.SelectedItem.Text.ToLower Like "*handicap*" Then
            If Phone_TextBox.Text.Trim = "" Then
                status_Literal.Text += "<br /><span style='color:red;'>Please enter a telephone number for Handicap/Registration requests.</span>"
            Else
                Dim TelNo = HBSAcodeLibrary.SharedRoutines.CheckValidPhoneNoForHuddersfield(Phone_TextBox.Text.Trim)
                If TelNo.StartsWith("ERROR: ") Then
                    status_Literal.Text += "<br /><span style='color:red;'>Invalid Phone No. " & TelNo.Substring(7) & "</span>"
                Else
                    Phone_TextBox.Text = TelNo
                End If
                If Player_TextBox.Text.Trim = "" Then
                    status_Literal.Text += "<br /><span style='color:red;'>Please enter the Player's name for Handicap/Registration requests.</span>"
                End If
                If League_DropDownList.SelectedIndex < 1 Then
                    status_Literal.Text += "<br /><span style='color:red;'>Please select a league for Handicap/Registration requests.</span>"
                End If
                If Team_TextBox.Text.Trim = "" Then
                    status_Literal.Text += "<br /><span style='color:red;'>Please enter the Player's Club and Team for Handicap/Registration requests.</span>"
                End If
                If Handicap_TextBox.Text.Trim = "" Then
                    status_Literal.Text += "<br /><span style='color:red;'>Please enter a suggested handicap.</span>"
                End If
                If Reasons_TextBox.Text.Trim = "" Then
                    status_Literal.Text += "<br /><span style='color:red;'>Please enter the reasoning for the handicap..</span>"
                End If
            End If
        End If

        If status_Literal.Text = "" Then

            Using cfg As New HBSAcodeLibrary.HBSA_Configuration
                Dim toAddress As String = Destination_DropDownList.SelectedValue
                Dim ccAddress As String = cfg.Value("WebAdministratorEmail")
                Dim subject As String
                Dim body As String

                subject = "Web contact"
                body = "Message from HBSA website contact page: <br /><br />" &
                                 "From: " & Email_TextBox.Text.Trim & "<br />" &
                                 "Name: " & Name_TextBox.Text.Trim & "<br />" &
                                 "Club: " & Clubs_DropDownList.SelectedItem.Text & "<br /><br />"

                If Destination_DropDownList.SelectedItem.Text.ToLower Like "*competition*" Then
                    body += "Competition: " & Competitions_DropDownList.SelectedItem.Text & "<br /><br />"
                End If

                If Destination_DropDownList.SelectedItem.Text.ToLower Like "*handicap*" Then
                    body += "<u><b>Handicap/Registration Request:</b></u><br />" &
                                        "Player's Name: " & Player_TextBox.Text & "<br />" &
                                        "League: " & League_DropDownList.SelectedItem.Text & "<br />" &
                                        "Club / Team: " & Team_TextBox.Text & "<br />" &
                                        "Suggested Handicap: " & Handicap_TextBox.Text & "<br />" &
                                        "Reasons for Handicap: " & Reasons_TextBox.Text.Replace(vbLf, "<br />") & "<br /><br />"
                End If

                body += "Body: " & body_TextBox.Text.Trim.Replace(vbLf, "<br />")

                Try
                    HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body,, Email_TextBox.Text.Trim)
                    status_Literal.Text = "<span style='color:blue;'>Your message has been sent to the " & Destination_DropDownList.SelectedItem.Text & ".</span>"

                Catch ex As Exception
                    Dim errorMessage As String
                    errorMessage = ex.Message
                    Dim innerEx As Exception = ex.InnerException
                    While Not IsNothing(innerEx)
                        errorMessage += "<br/>    " & innerEx.Message
                        innerEx = innerEx.InnerException
                    End While

                    status_Literal.Text = "<span style='color:red;'>Your message has NOT been sent.<br/><br/>" &
                                      "There was an error.  Please contact us for assistance and have the following information to hand:<br/>" &
                                      errorMessage & "</span>"

                End Try

            End Using

        End If

    End Sub


End Class