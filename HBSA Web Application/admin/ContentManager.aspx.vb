
Partial Class ContentManager
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If (Session("adminDetails") Is Nothing OrElse Session("adminDetails").Rows.count = 0) _
        AndAlso Session("userType") <> "Printer" Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                Snapshot_Panel.Attributes.Add("max-height", "400px")
                populate_WebPages_DropDownList()

                If Not Request.QueryString("Content") Is Nothing Then
                    WebPages_DropDownList.SelectedValue = Request.QueryString("Content").ToString
                    WebPages_DropDownList_SelectedIndexChanged(sender, e)
                End If

            End If
        End If

    End Sub

    Sub Populate_WebPages_DropDownList()

        With WebPages_DropDownList
            .Items.Clear()
            .Items.Add("**Select content**")
            Files_Literal.Text = ""

            Dim fileNames As DataTable = HBSAcodeLibrary.ContentData.ContentNames
            For Each row As DataRow In fileNames.Rows
                .Items.Add(row.Item(0))
                Files_Literal.Text += row.Item(0).replace(" ", "&nbsp;") + "<br/>"
            Next
            .Items.Add("**Create a new content**")

        End With

    End Sub

    Protected Sub WebPages_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles WebPages_DropDownList.SelectedIndexChanged

        If WebPages_DropDownList.SelectedIndex < 1 Then
            ButtonsRow.Visible = False
            Snapshot_Panel.Visible = False
            SnapShot_Literal.Text = ""
        Else
            ButtonsRow.Visible = True

            If WebPages_DropDownList.SelectedValue = "**Create a new content**" Then
                Response.Redirect("ContentEdit.aspx?Content=" + WebPages_DropDownList.SelectedValue)
            Else
                Snapshot_Panel.Visible = True
                Delete_Button.Visible = True
                Update_Button.Text = "Update the selected content"
                Using Content As New HBSAcodeLibrary.ContentData(WebPages_DropDownList.SelectedValue)
                    SnapShot_Literal.Text = Content.ContentHTML
                End Using

            End If
        End If

    End Sub

    Protected Sub Update_Button_Click(sender As Object, e As EventArgs) Handles Update_Button.Click
        'Call the HTML editor page with this content
        '
        Response.Redirect("ContentEdit.aspx?Content=" + WebPages_DropDownList.SelectedValue)

    End Sub

    Protected Sub Delete_Button_Click(sender As Object, e As EventArgs) Handles Delete_Button.Click

        Delete_Literal.Text = WebPages_DropDownList.SelectedValue
        confirmDelete.Visible = True

    End Sub

    Protected Sub ConfirmDelete_button_Click(sender As Object, e As EventArgs) Handles confirmDelete_button.Click

        Using Content As New HBSAcodeLibrary.ContentData(WebPages_DropDownList.SelectedValue)
            Content.Delete()
        End Using

        confirmDelete.Visible = False

        Populate_WebPages_DropDownList()
        WebPages_DropDownList_SelectedIndexChanged(sender, e)

    End Sub

End Class
