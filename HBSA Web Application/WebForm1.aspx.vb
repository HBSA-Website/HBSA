Public Class WebForm1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub View(sender As Object, e As EventArgs)

        'Response.Redirect("/Documents/Entry Form Vets.pdf")
        image.ImageUrl = "Images/balls.jpg"

        Dim embed As String = "<object data=""{0}"" type=""application/pdf"" style=""width:100%;height:100vh;"">"
        embed += "If you are unable to view file, you can download from <a href = ""{0}"">here</a>"
        embed += " or download <a target = ""_blank"" href = ""http://get.adobe.com/reader/"">Adobe PDF Reader</a> to view the file."
        embed += "</object>"
        ltEmbed.Text = String.Format(embed, ResolveUrl("~/Documents/Entry Form Vets.pdf"))


    End Sub

    Protected Sub UploadButton_Click(sender As Object, e As EventArgs) Handles UploadButton.Click

        If FileUploadControl.HasFile Then
            Try
                Dim filenme As String = System.IO.Path.GetFileName(FileUploadControl.FileName)
                FileUploadControl.SaveAs(Server.MapPath("/Documents/") & filenme)
                StatusLabel.Text = "uploaded"
            Catch ex As Exception
                StatusLabel.Text = "failed: " & ex.Message
            End Try
        End If
    End Sub

End Class