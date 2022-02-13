
Partial Class Contact
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

            With League_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("** Select a League **", 0))
                Using Leagues As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues
                    For Each League As DataRow In Leagues.Rows
                        .Items.Add(New ListItem(League.Item("League Name"), League!ID))
                    Next
                End Using
            End With

        End If

    End Sub
    Protected Sub CaptchaRefresh_Button_Click(sender As Object, e As EventArgs) Handles captchaRefresh_Button.Click

        'refresh captcha image
        Session("captchaString") = HBSAcodeLibrary.Captcha.SetCaptchaImage(captcha_Image, captcha_Textbox)

    End Sub
    Sub ClearContactControls()

        For Each ctl As Control In Contact_Panel.Controls
            If TypeOf (ctl) Is TextBox Then
                CType(ctl, TextBox).Text = ""
            ElseIf TypeOf (ctl) Is DropDownList Then
                CType(ctl, DropDownList).SelectedIndex = 0
            ElseIf TypeOf (ctl) Is CheckBox Then
                CType(ctl, CheckBox).Checked = False
            End If
        Next
    End Sub
    Protected Sub Destination_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Destination_DropDownList.SelectedIndexChanged

        CompsRow.Visible = False
        ShowHideHcapRows(False)
        Agreement_Panel.Visible = False
        Check1.SelectedIndex = -1
        Check2.SelectedIndex = -1
        Check3.SelectedIndex = -1
        Contact_Panel.Visible = True
        'ClearContactControls()

        If Destination_DropDownList.SelectedItem.Text.ToLower Like "*competition*" Then
            CompsRow.Visible = True
            PopulateCompetitionsDropDown()
        ElseIf Destination_DropDownList.SelectedItem.Text.ToLower Like "*handicap*" Then
            ShowHideHcapRows(True)
            Agreement_Panel.Visible = True
            Contact_Panel.Visible = False
        End If

    End Sub
    Sub ShowHideHcapRows(show As Boolean)

        HcapRow1.Visible = show
        HcapRow2.Visible = show
        HcapRow3.Visible = show
        HcapRow4.Visible = show
        HcapRow5.Visible = show
        HcapRow6.Visible = show

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
           (Destination_DropDownList.SelectedItem.Text.ToLower Like "*handicap*" AndAlso
                        Clubs_DropDownList.SelectedIndex < 1) Then
            status_Literal.Text += "<br /><span style='color:red;'>Please ensure all required boxes are completed</span>"
        End If

        If Destination_DropDownList.SelectedIndex < 1 Then
            status_Literal.Text += "<br /><span style='color:red;'>Please select where the email should be sent to</span>"
        End If

        If Session("captchaString") Is Nothing Then
            status_Literal.Text += "<br /><span style='color:red;'>Session has expired, please try again.</span>"
            CaptchaRefresh_Button_Click(sender, e)
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
            Dim TelNo = HBSAcodeLibrary.SharedRoutines.CheckValidPhoneNoForHuddersfield(Phone_TextBox.Text)
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
            Else
                Using LeagueData = New HBSAcodeLibrary.LeagueData(League_DropDownList.SelectedValue)
                    Try
                        Dim HCap = CInt(Handicap_TextBox.Text.Trim)
                        If HCap < LeagueData.MinHandicap Then
                            status_Literal.Text += "<br /><span style='color:red;'>The handicap must be greater than " &
                                           LeagueData.MinHandicap & " for the " &
                                           League_DropDownList.SelectedItem.Text & " League.</span>"
                        ElseIf HCap > LeagueData.MaxHandicap Then
                            status_Literal.Text += "<br /><span style='color:red;'>The handicap must be less than " &
                                               LeagueData.MaxHandicap & " for the " &
                                               League_DropDownList.SelectedItem.Text & " League.</span>"
                        End If

                    Catch ex As Exception
                        status_Literal.Text += "<br /><span style='color:red;'>" &
                            "Please enter a numeric handicap"

                        If LeagueData.MinHandicap = -2147483648 Then
                            If LeagueData.MaxHandicap <> 2147483647 Then
                                status_Literal.Text += " lower than " & LeagueData.MaxHandicap
                            End If
                        End If
                        If LeagueData.MaxHandicap = 2147483647 Then
                            If LeagueData.MinHandicap <> -2147483648 Then
                                status_Literal.Text += " greater than " & LeagueData.MinHandicap
                            End If
                        End If
                        status_Literal.Text += ".</span>"
                    End Try
                End Using
            End If
            If Team_DropDownList.SelectedIndex < 1 Then
                status_Literal.Text += "<br /><span style='color:red;'>Please select a team letter.</span>"
            End If
            If PlayerPhone_TextBox.Text.Trim <> "" Then
                TelNo = HBSAcodeLibrary.SharedRoutines.CheckValidPhoneNoForHuddersfield(PlayerPhone_TextBox.Text)
                If TelNo.StartsWith("ERROR: ") Then
                    status_Literal.Text += "<br /><span style='color:red;'>Invalid Player's Phone No. " & TelNo.Substring(7) & "</span>"
                Else
                    PlayerPhone_TextBox.Text = TelNo
                End If
            End If

            If Reasons_TextBox.Text.Trim = "" Then
                status_Literal.Text += "<br /><span style='color:red;'>Please enter the reasoning for the handicap..</span>"
            End If

            If Not (Check1.SelectedIndex = 0 AndAlso
                    Check2.SelectedIndex = 0 AndAlso
                    Check3.SelectedIndex = 0) Then
                status_Literal.Text += "<br /><span style='color:red;'>You must select yes to all the questions to indicate you have read them and agree to comply.</span>"
            End If
        End If

        If status_Literal.Text = "" Then

            Using cfg As New HBSAcodeLibrary.HBSA_Configuration
                Dim toAddress As String = Destination_DropDownList.SelectedValue
                Dim subject As String
                Dim body As String

                subject = "Web contact"
                body = "<b><u>Message from HBSA website contact page:</u></b> <br /><br />"

                body += "<table>"

                body += "<tr><td>From:</td><td>" & Email_TextBox.Text.Trim & "</td></tr>" &
                       "<tr><td>Name:</td><td>" & Name_TextBox.Text.Trim & "</td></tr>" &
                       "<tr><td>Phone:</td><td>" & Phone_TextBox.Text.Trim & "</td></tr>" &
                       "<tr><td>Club:</td><td>" & Clubs_DropDownList.SelectedItem.Text & "</td></tr>" &
                       "<tr><td></td><td></td></tr>"

                If Destination_DropDownList.SelectedItem.Text.ToLower Like "*competition*" Then
                    body += "<tr><td>Competition:</td><td>" & Competitions_DropDownList.SelectedItem.Text & "</td></tr>" &
                            "<tr><td></td><td></td></tr>"
                End If

                If Destination_DropDownList.SelectedItem.Text.ToLower Like "*handicap*" Then
                    body += "<tr><td colspan='2'><u><b>Handicap/Registration Request:</b></u></td></tr>" &
                            "<tr><td>Player's Name:</td><td>" & Player_TextBox.Text & "</td></tr>" &
                            "<tr><td>Player's Phone No:</td><td>" & PlayerPhone_TextBox.Text & "</td></tr>" &
                            "<tr><td>League:</td><td>" & League_DropDownList.SelectedItem.Text & "</td></tr>" &
                            "<tr><td>Team:</td><td>" & Team_DropDownList.SelectedValue & "</td></tr>" &
                            "<tr><td>Suggested Handicap:</td><td>" & Handicap_TextBox.Text & "</td></tr>" &
                            "<tr><td style='vertical-align: top;'>Reasons for Handicap:</td><td>" & Reasons_TextBox.Text.Replace(vbLf, "<br />") & "</td></tr>" &
                            "<tr><td></td><td></td></tr>"
                End If

                body += "<tr><td style='vertical-align: top;'>Message:</td><td>" & body_TextBox.Text.Trim.Replace(vbLf, "<br />") & "</td></tr>"

                body += "</table>	"

                Try
                    HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body)

                    If Copy_CheckBox.Checked Then
                        body = body.Replace("Message from HBSA website contact page:",
                                            "Requested copy of Message from HBSA website contact page:")
                        HBSAcodeLibrary.Emailer.Send_eMail(Email_TextBox.Text.Trim, subject, body)
                    End If

                    MessageSent_Literal.Text = "<span style='color:blue;'>Your message has been sent to the " & Destination_DropDownList.SelectedItem.Text & ".</span>"
                    Contact_Panel.Visible = False
                    MessageSent_Panel.Visible = True
                    ClearContactControls()

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
    Protected Sub CheckRadioButton_selectedIndexChanged(sender As Object, e As EventArgs) _
        Handles Check1.SelectedIndexChanged, Check2.SelectedIndexChanged, Check3.SelectedIndexChanged

        If Check1.SelectedIndex = 0 AndAlso
           Check2.SelectedIndex = 0 AndAlso
           Check3.SelectedIndex = 0 Then
            Agreement_Panel.Visible = False
            Contact_Panel.Visible = True
        End If

    End Sub

End Class
