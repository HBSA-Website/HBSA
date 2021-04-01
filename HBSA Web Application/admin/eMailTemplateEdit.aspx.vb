Public Class EmailTemplateEdit
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Session("adminDetails") Is Nothing OrElse Session("adminDetails").Rows.count = 0) _
        AndAlso Session("userType") <> "Printer" Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                If Request.QueryString("EmailTemplate") Is Nothing Then
                    If Session("Caller") = Request.Url.AbsolutePath Then
                        Response.Redirect("adminhome.aspx")
                    Else
                        Response.Redirect(Session("Caller"))
                    End If
                Else
                    EmailTemplateName_HiddenField.Value = Request.QueryString("EmailTemplate").ToString
                    PopulatePage()
                End If
            End If
        End If

    End Sub

    Sub PopulatePage()

        If EmailTemplateName_HiddenField.Value = "**Create a new EmailTemplate**" Then
            Date_Literal.Text = Format(HBSAcodeLibrary.Utilities.UKDateTimeNow(), "dd MMMM yyyy HH:mm")
            EmailTemplateEditorTextBox.Text = ""
            EmailTemplateName_TextBox.Enabled = True
            EmailTemplateName_TextBox.Text = ""
            EmailTemplateName_TextBox.Focus()
        Else

            Using EmailTemplate As New HBSAcodeLibrary.EmailTemplateData(EmailTemplateName_HiddenField.Value)
                EmailTemplateName_TextBox.Text = EmailTemplate.eMailTemplateName
                EmailTemplateName_TextBox.Enabled = False
                Date_Literal.Text = Format(EmailTemplate.dateTimeLodged, "dd MMMM yyyy HH:mm")
                EmailTemplateEditorTextBox.Text = EmailTemplate.eMailTemplateHTML
                EmailTemplateEditorTextBox.Focus()

                Dim EmailVariablesID As String = EmailTemplate.eMailTemplateName + "Variables"
                Dim EmailVariablesTable As HtmlTable = UpdatePanel1.FindControl(EmailVariablesID)
                If Not IsNothing(EmailVariablesTable) Then
                    EmailVariablesTable.Visible = True
                End If

            End Using

        End If

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        Response.Redirect("EmailTemplates.aspx?EmailTemplate=" & EmailTemplateName_HiddenField.Value)

    End Sub

    Protected Sub Submit_Button_Click(sender As Object, e As EventArgs) Handles Submit_Button.Click

        Using EmailTemplate As New HBSAcodeLibrary.EmailTemplateData(EmailTemplateName_HiddenField.Value)

            EmailTemplate.eMailTemplateHTML = EmailTemplateEditorTextBox.Text ' EmailTemplateEditorTextBox.EmailTemplate

            If EmailTemplateName_HiddenField.Value = "**Create a new EmailTemplate**" Then
                If EmailTemplateName_TextBox.Text = "" Then
                    Message_Literal.Text = "<span style='color: red;'>There must be a EmailTemplate Name when creating a new EmailTemplate.</span>"
                    Exit Sub
                Else
                    EmailTemplate.eMailTemplateName = EmailTemplateName_TextBox.Text
                    EmailTemplate.Create()
                    EmailTemplateName_HiddenField.Value = EmailTemplateName_TextBox.Text
                End If
            Else
                EmailTemplate.Update()
            End If

        End Using

        Response.Redirect("EmailTemplates.aspx?EmailTemplate=" & EmailTemplateName_HiddenField.Value)

    End Sub
End Class