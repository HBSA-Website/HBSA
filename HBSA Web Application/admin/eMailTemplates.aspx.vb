Public Class EmailTemplates
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If (Session("adminDetails") Is Nothing OrElse Session("adminDetails").Rows.count = 0) _
        AndAlso Session("userType") <> "Printer" Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then

                Snapshot_Div.Attributes.Add("max-height", "500px")
                Populate_EmailTemplates_DropDownList()

                If Not Request.QueryString("EmailTemplate") Is Nothing Then
                    EmailTemplates_DropDownList.SelectedValue = Request.QueryString("EmailTemplate").ToString
                    EmailTemplates_DropDownList_SelectedIndexChanged(sender, e)
                End If


            End If
        End If

    End Sub

    Sub Populate_EmailTemplates_DropDownList()

        With EmailTemplates_DropDownList

            Using templates As DataTable = HBSAcodeLibrary.EmailTemplateData.EmailTemplateNames
                .Items.Clear()
                .Items.Add("**Select template**")
                For Each template As DataRow In templates.Rows
                    .Items.Add(template.Item(0))
                Next
                .Items.Add("**Create a new EmailTemplate**")
            End Using
        End With

    End Sub

    Protected Sub EmailTemplates_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles EmailTemplates_DropDownList.SelectedIndexChanged

        If EmailTemplates_DropDownList.SelectedIndex < 1 Then
            Snapshot_Div.Visible = False
            SnapShot_Literal.Text = ""
        Else
            If EmailTemplates_DropDownList.SelectedValue = "**Create a new EmailTemplate**" Then
                Response.Redirect("EmailTemplateEdit.aspx?EmailTemplate=" + EmailTemplates_DropDownList.SelectedValue)
            Else
                Snapshot_Div.Visible = True
                Using EmailTemplate As New HBSAcodeLibrary.EmailTemplateData(EmailTemplates_DropDownList.SelectedValue)
                    SnapShot_Literal.Text = EmailTemplate.eMailTemplateHTML
                End Using

            End If
        End If

    End Sub

    Protected Sub Update_Button_Click(sender As Object, e As EventArgs) Handles Update_Button.Click
        'Call the HTML editor page with this EmailTemplate
        '
        Response.Redirect("EmailTemplateEdit.aspx?EmailTemplate=" + EmailTemplates_DropDownList.SelectedValue)

    End Sub

    Protected Sub Delete_Button_Click(sender As Object, e As EventArgs) Handles Delete_Button.Click

        Delete_Literal.Text = EmailTemplates_DropDownList.SelectedValue
        confirmDelete.Visible = True

    End Sub

    Protected Sub ConfirmDelete_button_Click(sender As Object, e As EventArgs) Handles confirmDelete_button.Click

        Using template As New HBSAcodeLibrary.EmailTemplateData(EmailTemplates_DropDownList.SelectedValue)
            template.Delete()
        End Using

        confirmDelete.Visible = False

        Populate_EmailTemplates_DropDownList()
        EmailTemplates_DropDownList_SelectedIndexChanged(sender, e)

    End Sub

    Protected Sub CancelDelete_button_Click(sender As Object, e As EventArgs) Handles cancelDelete_button.Click

        confirmDelete.Visible = False

    End Sub
End Class