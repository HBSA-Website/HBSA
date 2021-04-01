Public Class Handbook
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If HBSAcodeLibrary.Utilities.HandbookExists Then
            DownLoadContent_Button.Visible = True
            Handbook_Label.ForeColor = Drawing.Color.Black
            Handbook_Label.Text = "<i>The handbook Is an Adobe Acrobat file (pdf).<br/>" &
                                  "It will be downloadable from the displayed document if you so wish.<br/>"
        Else
            DownLoadContent_Button.Visible = False
            Handbook_Label.ForeColor = Drawing.Color.Red
            Handbook_Label.Text = "The handbook is not available as a digital download. <a href='Contact.aspx'>Contact us</a> to request a paper copy."
        End If

    End Sub
    Protected Sub DownloadContent_Button_Click(sender As Object, e As EventArgs) _
        Handles DownLoadContent_Button.Click

        Dim Handbook As IO.FileInfo = HBSAcodeLibrary.Utilities.Handbook()
        If Handbook Is Nothing Then
            'The handbook cannot be found. The page will refresh with message
        Else
            Dim path As String = Handbook.FullName
            Dim client As New Net.WebClient()
            Dim buffer As [Byte]() = client.DownloadData(path)

            If buffer IsNot Nothing Then
                Response.ContentType = "application/pdf"
                Response.AddHeader("content-length", buffer.Length.ToString())
                Response.BinaryWrite(buffer)
            End If

        End If
    End Sub

End Class