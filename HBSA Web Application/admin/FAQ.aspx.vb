Public Class FAQ
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else

            If Not IsPostBack Then

                Using NotePad As New HBSAcodeLibrary.NotePad("FAQ")
                    contentEditorTextBox.Text = NotePad.Notes
                End Using

            End If

        End If

    End Sub

    Protected Sub Notes_TextBox_TextChanged(sender As Object, e As EventArgs) Handles Save_Button.Click, Save_Button2.Click

        Using NotePad As New HBSAcodeLibrary.NotePad("FAQ")
            NotePad.Notes = contentEditorTextBox.Text
            NotePad.update()
            FAQ_Literal.Text = "<span style='color:red'>FAQ saved</span>"
        End Using

    End Sub

End Class