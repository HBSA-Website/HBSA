Public Class Contact1
    Inherits System.Web.UI.Page
    Private Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Not IsPostBack Then

            Session("captchaString") = HBSAcodeLibrary.Captcha.SetCaptchaImage(captcha_Image, captcha_Textbox)

            With Destination_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("Choose where this email should go", ""))
                Using cfg As New HBSAcodeLibrary.HBSA_Configuration
                    .Items.Add(New ListItem("League Secretary", cfg.Value("LeagueSecretaryEmail")))
                    .Items.Add(New ListItem("Competitions Secretary", cfg.Value("CompetitionsSecretaryEmail")))
                End Using

            End With
        End If

    End Sub

    Protected Sub Send_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) _
        Handles Send_Button.Click

        status_Literal.Text = ""

        If from_TextBox.Text.Trim = "" OrElse
           name_TextBox.Text.Trim = "" OrElse
           club_TextBox.Text.Trim = "" OrElse
           body_TextBox.Text.Trim = "" OrElse
           captcha_Textbox.Text.Trim = "" Then
            status_Literal.Text += "<br /><span style='color:red;'>Please ensure all boxes are completed</span>"
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
        End If

        If status_Literal.Text = "" Then

            Using cfg As New HBSAcodeLibrary.HBSA_Configuration
                Dim toAddress As String = Destination_DropDownList.SelectedValue
                Dim ccAddress As String = cfg.Value("WebAdministratorEmail")
                Dim subject As String
                Dim body As String

                subject = "Web contact"
                body = "Message from HBSA website contact page: <br /><br />" &
                                 "From: " & from_TextBox.Text.Trim & "<br />" &
                                 "Name: " & name_TextBox.Text.Trim & "<br />" &
                                 "Club: " & club_TextBox.Text.Trim & "<br />" &
                                 If(Destination_DropDownList.SelectedItem.Text.ToLower Like "*competition*", "Competition: " & Competitions_DropDownList.SelectedItem.Text & "<br />", "") &
                                 "Body: " & body_TextBox.Text.Trim

                CompsRow.Visible = False

                Try
                    HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body,, from_TextBox.Text.Trim)
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
                                      "There was an error.  Please phone 0789 003 2041 for assistance and have the following information to hand:<br/>" &
                                      errorMessage & "</span>"

                End Try

            End Using

        End If

    End Sub

    Protected Sub CaptchaRefresh_Button_Click(sender As Object, e As EventArgs) Handles captchaRefresh_Button.Click

        'refresh captcha image
        Session("captchaString") = HBSAcodeLibrary.Captcha.SetCaptchaImage(captcha_Image, captcha_Textbox)

    End Sub

    Protected Sub Destination_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Destination_DropDownList.SelectedIndexChanged

        If Destination_DropDownList.SelectedItem.Text.ToLower Like "*competition*" Then
            CompsRow.Visible = True
            PopulateCompetitionsDropDown()
        Else
            CompsRow.Visible = False
        End If
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

End Class