Public Class helpFAQ
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Using helpFAQ As New HBSAcodeLibrary.NotePad("FAQ")
            HTML_Literal.Text = helpFAQ.Notes
        End Using

    End Sub

End Class