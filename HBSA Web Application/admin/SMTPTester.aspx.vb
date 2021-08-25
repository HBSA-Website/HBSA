Public Class SMTPTester
    Inherits System.Web.UI.Page

    ReadOnly Footer As String = "<br/><br/><i>Please do not reply to this email because it sent from an automatic sender, and the mail box is not monitored.<br>" +
                            "If you wish to contact the league please use the web site and go to the contact page, or <a href='" +
                            HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() + "/Contact.aspx'> click here </a>.</i><br/><br/>" +
                            "<strong>Huddersfield Billiards and Snooker Web Site</strong>"
    'Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    'End Sub

    Protected Sub ShowButtons(vis As Boolean)

        SendViaLibrary_Button.Visible = vis
        SenddotNET_Button.Visible = vis
        SendMailkit_Button.Visible = vis
        Retry_Button.Visible = Not vis

    End Sub
    Protected Sub SenddotNET_Button_Click(sender As Object, e As EventArgs) Handles SenddotNET_Button.Click

        ShowButtons(False)

        ' setup the SMTP client
        Dim smtp = New System.Net.Mail.SmtpClient(SMTPServer_TextBox.Text.Trim, System.Convert.ToInt32(SMTP_Port_TextBox.Text.Trim))
        With smtp
            .Credentials = New System.Net.NetworkCredential(SMTPUser_TextBox.Text.Trim, SMTP_PWord_TextBox.Text.Trim)
            .EnableSsl = SMTP_SSL_CheckBox.Checked
            .DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network
        End With

        Try

            Using message = New System.Net.Mail.MailMessage()

                ' set up the message
                message.From = New System.Net.Mail.MailAddress(From_TextBox.Text.Trim, "HBSA Website")

                ' set the list of recipients
                For Each address As String In To_TextBox.Text.Trim.Split(";")
                    message.To.Add(address)
                Next
                ' set the list of cc
                If cc_TextBox.Text.Trim <> "" Then
                    For Each address As String In cc_TextBox.Text.Trim.Split(";")
                        message.CC.Add(address)
                    Next
                End If

                message.IsBodyHtml = True
                message.Body = "Via .NET SMTPClient <br/>" +
                               "Port: " + SMTP_Port_TextBox.Text.Trim +
                               "   SSL/SSL: " + SMTP_SSL_CheckBox.Checked.ToString + "<br/><br/>" +
                               Message_TextBox.Text + Footer
                message.Subject = Subject_TextBox.Text.Trim

                smtp.Send(message)
                Status_Literal.Text = "eMail sent - check the recipient received it."

            End Using

        Catch ex As Exception

            Status_Literal.Text = "ERROR sending the eMail<br/><br/>" + ex.ToString

        End Try

        smtp.Dispose()

    End Sub

    Protected Sub SendMailkit_Button_Click(sender As Object, e As EventArgs) Handles SendMailkit_Button.Click

        ShowButtons(False)

        ' setup the SMTP client
        Using smtpClient = New MailKit.Net.Smtp.SmtpClient()

            Try

                Dim mimeMessage = New MimeKit.MimeMessage()

                ' set up the message
                mimeMessage.From.Add(New MimeKit.MailboxAddress("HBSA Website", From_TextBox.Text.Trim))

                ' set the list of recipients
                For Each address As String In To_TextBox.Text.Trim.Split(";")
                    mimeMessage.To.Add(New MimeKit.MailboxAddress("", address))
                Next

                ' set the list of cc
                If cc_TextBox.Text.Trim <> "" Then
                    For Each address As String In cc_TextBox.Text.Trim.Split(";")
                        mimeMessage.Cc.Add(New MimeKit.MailboxAddress("", address))
                    Next
                End If

                mimeMessage.Subject = Subject_TextBox.Text.Trim
                mimeMessage.Body = New MimeKit.TextPart("html") With {.Text = "Via MailKit SMTPClient <br/>" +
                                                                              "Port: " + SMTP_Port_TextBox.Text.Trim +
                                                                              "   SSL/SSL: " + SMTP_SSL_CheckBox.Checked.ToString + "<br/><br/>" +
                                                                               Message_TextBox.Text + Footer}


                smtpClient.Connect(SMTPServer_TextBox.Text.Trim, System.Convert.ToInt32(SMTP_Port_TextBox.Text.Trim), SMTP_SSL_CheckBox.Checked)
                smtpClient.Authenticate(SMTPUser_TextBox.Text.Trim, SMTP_PWord_TextBox.Text.Trim)

                smtpClient.Send(mimeMessage)
                smtpClient.Disconnect(True)

                Status_Literal.Text = "eMail sent - check the recipient received it."

            Catch ex As Exception

                Status_Literal.Text = "ERROR sending the eMail<br/><br/>" + ex.ToString

            End Try

        End Using

    End Sub
    Protected Sub Retry_Button_Click(sender As Object, e As EventArgs) Handles Retry_Button.Click

        ShowButtons(True)
        Status_Literal.Text = ""

    End Sub

    Protected Sub SendViaLibrary_Button_Click(sender As Object, e As EventArgs) Handles SendViaLibrary_Button.Click

        ShowButtons(False)

        Using cfg As New HBSAcodeLibrary.HBSA_Configuration()

            HBSAcodeLibrary.Emailer.Send_eMail(To_TextBox.Text.Trim,
                                           Subject_TextBox.Text.Trim,
                                            "Via HBSA Code Library <br/>" +
                                               "Server: " + cfg.Value("SMTPServer") + "  User " + cfg.Value("SMTPServerUsername") +
                                               "Port: " + cfg.Value("SMTPport") +
                                               "   SSL/SSL: " + cfg.Value("SMTPssl") + "<br/><br/>" +
                                               Message_TextBox.Text,
                                           cc_TextBox.Text.Trim,
                                           ReplyTo_TextBox.Text.Trim,
                                           0, "PeteG")

            Status_Literal.Text = "eMail sent - check the recipient received it."

        End Using

    End Sub


End Class