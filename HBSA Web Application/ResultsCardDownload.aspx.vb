
Partial Class ResultsCardDownload
    Inherits System.Web.UI.Page

    Protected Sub Download_Button_Click(sender As Object, e As EventArgs) _
            Handles DownloadOpen_Button.Click, DownloadVets_Button.Click, DownloadBilliards_Button.Click

        Dim filename As String

        Select Case DirectCast(sender, Button).ID
            Case "DownloadOpen_Button"
                filename = "Results Sheet Open.pdf"
            Case "DownloadVets_Button"
                filename = "Results Sheet Vets.pdf"
            Case "DownloadBilliards_Button"
                filename = "Results Sheet Billiards.pdf"
            Case Else
                filename = "Results Sheet.pdf"
        End Select

        Response.ContentType = "application/vnd.pdf"
        Response.AppendHeader("Content-Disposition", "attachment; filename=" & filename)
        Response.TransmitFile(Server.MapPath("Documents/" & filename))
        Response.End()

    End Sub
End Class
