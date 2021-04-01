

Partial Class _InfoPage
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            Title_Literal.Text = Request.QueryString("Title").ToString

            Using InfoPage As New HBSAcodeLibrary.ContentData(Request.QueryString("Subject").ToString)
                HTML_Literal.Text = InfoPage.ContentHTML
            End Using

            'Try to prevent the browser from using any cached data
            Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1))
            Response.Cache.SetCacheability(HttpCacheability.NoCache)
            Response.Cache.SetNoStore()

        Catch ex As Exception
            HTML_Literal.Text = "<br/><br/><span style='color:red;'><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & ex.Message & ". Select another option.</strong></span>"
        End Try

    End Sub
End Class
