Public Class NotePad
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else

            If Not IsPostBack Then

                Using NotePad As New HBSAcodeLibrary.NotePad(Session("AdminUser"))
                    Administrator_Literal.Text = NotePad.Administrator
                    Notes_TextBox.Text = NotePad.Notes
                End Using

            End If

        End If

    End Sub

    Protected Sub Notes_TextBox_TextChanged(sender As Object, e As EventArgs) Handles Save_Button.Click

        Using NotePad As New HBSAcodeLibrary.NotePad(Session("AdminUser"))
            NotePad.Notes = Notes_TextBox.Text
            NotePad.update()
            Notes_Literal.Text = "<span style='color:red'>Notes saved</span>"
        End Using

    End Sub
End Class