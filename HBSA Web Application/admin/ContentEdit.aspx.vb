Public Class ContentEdit
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Session("adminDetails") Is Nothing OrElse Session("adminDetails").Rows.count = 0) _
        AndAlso Session("userType") <> "Printer" Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                If Request.QueryString("Content") Is Nothing Then
                    If Session("Caller") = Request.Url.AbsolutePath Then
                        Response.Redirect("adminhome.aspx")
                    Else
                        Response.Redirect(Session("Caller"))
                    End If
                Else
                    ContentName_HiddenField.Value = Request.QueryString("Content").ToString

                    PopulatePage()
                End If
            End If
        End If

    End Sub

    Sub PopulatePage()

        If ContentName_HiddenField.Value = "**Create a new content**" Then
            Date_Literal.Text = Format(HBSAcodeLibrary.Utilities.UKDateTimeNow(), "dd MMMM yyyy HH:mm")
            'contentEditorTextBox.Text = ""
            contentEditorBox.Text = ""
            ContentName_TextBox.Enabled = True
            ContentName_TextBox.Text = ""
            ContentName_TextBox.Focus()
        Else

            Using content As New HBSAcodeLibrary.ContentData(ContentName_HiddenField.Value)
                ContentName_TextBox.Text = content.ContentName
                ContentName_TextBox.Enabled = False
                Date_Literal.Text = Format(content.dateTimeLodged, "dd MMMM yyyy HH:mm")
                contentEditorBox.Text = content.ContentHTML
                contentEditorBox.Focus()

            End Using

        End If

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click, Cancel_Button1.Click

        Response.Redirect("ContentManager.aspx?Content=" & ContentName_HiddenField.Value)

    End Sub

    Protected Sub Submit_Button_Click(sender As Object, e As EventArgs) Handles Submit_Button.Click, Submit_Button1.Click

        Using content As New HBSAcodeLibrary.ContentData(ContentName_HiddenField.Value)

            content.ContentHTML = ContentEditorBox.Text ' contentEditorTextBox.Content

            If ContentName_HiddenField.Value = "**Create a new content**" Then
                If ContentName_TextBox.Text = "" Then
                    Message_Literal.Text = "<span style='color: red;'>There must be a Content Name when creating a new content.</span>"
                    Exit Sub
                Else
                    content.ContentName = ContentName_TextBox.Text
                    content.Create()
                    ContentName_HiddenField.Value = ContentName_TextBox.Text
                End If
            Else
                content.Update()
            End If

        End Using

        Response.Redirect("ContentManager.aspx?Content=" & ContentName_HiddenField.Value)

    End Sub
End Class