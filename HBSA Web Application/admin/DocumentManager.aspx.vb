Imports System.IO

Public Class DocumentManager
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            populateDocs()
        End If

    End Sub
    Sub PopulateDocs()

        With Documents_DropDownList
            .Items.Clear()
            .Items.Add("**Select a document**")

            Dim DocumentsDirectory As New IO.DirectoryInfo(Server.MapPath("~/Documents/"))
            For Each document As IO.FileInfo In DocumentsDirectory.GetFiles()
                .Items.Add(document.Name)
            Next

        End With

    End Sub
    Protected Sub Upload_Button_Click(sender As Object, e As EventArgs) Handles UpLoad_Button.Click

        Try
            Dim filename As String = IO.Path.GetFileName(FileUploadControl.FileName)

            If filename = "" Then
                Status_Literal.Text = "<span style='color:red;'>ERROR: please choose a file, or select another document</span>"
            Else

                If filename = Documents_DropDownList.SelectedValue OrElse downLoadRow.Visible = False Then  'must match selected doc or be a new one
                    FileUploadControl.SaveAs(Server.MapPath("~/Documents/") & filename)
                    Status_Literal.Text = "<span style='color:darkgreen;font-size:larger;font-weight:bold;'>Document uploaded and stored.</span>"
                    populateDocs()
                Else
                    Status_Literal.Text = "<span style='color:red;font-size:larger;font-weight:bold;'>ERROR: The file could not be uploaded. The selected document filename (" & Documents_DropDownList.SelectedValue & ") differs from that chosen here (" & filename & ")</span>"
                End If

            End If

        Catch ex As Exception
            Status_Literal.Text = "<span style='color:red;font-size:larger;font-weight:bold;'>Error: The document could not be uploaded. The following error occured: " & ex.Message & "</span>"
        End Try

    End Sub

    Protected Sub Documents_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Documents_DropDownList.SelectedIndexChanged

        If Documents_DropDownList.SelectedIndex > 0 Then
            UpLoad_Panel.Visible = True
            downLoadRow.Visible = True
        Else
            UpLoad_Panel.Visible = False
        End If

    End Sub

    Protected Sub Download_Button_Click(sender As Object, e As EventArgs) Handles Download_Button.Click

        Try
            Status_Literal.Text = "<span style='color:darkgreen;font-size:larger;font-weight:bold;'>" & Documents_DropDownList.SelectedValue & " downloaded.</span>"
            Response.ContentType = "application/vnd.pdf"
            Response.AppendHeader("Content-Disposition", "attachment; filename=" & Documents_DropDownList.SelectedValue)
            Response.TransmitFile(Server.MapPath("~/Documents/" & Documents_DropDownList.SelectedValue))
            Response.Flush()

        Catch ResponseEnd As Threading.ThreadAbortException
            Status_Literal.Text = "This is as expected when Response.End is activated"

        Catch ex As Exception
            Status_Literal.Text = "<span style='color:red;font-size:larger;font-weight:bold;'>Error: The document could not be downloaded: " + ex.Message & "</span>"

        End Try

    End Sub

    Protected Sub NewDocument_Button_Click(sender As Object, e As EventArgs) Handles NewDocument_Button.Click

        downLoadRow.Visible = False
        UpLoad_Panel.Visible = True

    End Sub

    Protected Sub Delete_Button_Click(sender As Object, e As EventArgs) Handles Delete_Button.Click

        removeDoc.Visible = True
        Remove_Literal.Text = Documents_DropDownList.SelectedValue

    End Sub

    Protected Sub Confirm_Button_Click(sender As Object, e As EventArgs) Handles Confirm_Button.Click

        Try

            File.Delete(Server.MapPath("~/Documents/" & Documents_DropDownList.SelectedValue))
            removeDoc.Visible = False
            Status_Literal.Text = "<span style='color:darkgreen;font-size:larger;font-weight:bold;'>" & Documents_DropDownList.SelectedValue & " removed.</span>"
            populateDocs()

        Catch ex As Exception
            Status_Literal.Text = "<span style='color:red;font-size:larger;font-weight:bold;'>Error: The document could not be removed: " + ex.Message & "</span>"
        End Try

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click
        removeDoc.Visible = False
    End Sub

End Class