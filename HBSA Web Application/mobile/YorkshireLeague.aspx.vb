Public Class YorkshireLeague1
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        'Using FileInfo As New InfoFiles(Server.MapPath("InfoFiles/Yorkshire.htm"))
        '    HTML_Literal.Text = FileInfo.HTML
        'End Using

        Using YorkshirePage As New HBSAcodeLibrary.ContentData("Yorkshire")
            HTML_Literal.Text = YorkshirePage.ContentHTML
        End Using

    End Sub
End Class