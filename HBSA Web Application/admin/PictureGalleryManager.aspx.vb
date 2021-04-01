Public Class PictureGalleryManager
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                UpLoad_Button.Attributes.Add("onclick", "loadDiv('loading')")
                'Download_Panel.Attributes.Add("max-height", "500px")
                populate_Categories_DropDownList()
                Message_Literal.Text = ""
            End If
        End If

    End Sub

    Sub Populate_Categories_DropDownList()

        With Category_DropDownList
            .Items.Clear()
            .Items.Add("**Select a category**")
            .Items.Add("**Insert a new category**")

            Dim Categories As DataTable = HBSAcodeLibrary.Pictures.Categories()
            For Each row As DataRow In Categories.Rows
                .Items.Add(row.Item(1))
            Next

        End With

    End Sub

    Protected Sub Category_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Category_DropDownList.SelectedIndexChanged

        EditCategory_RadioButton.Visible = False

        If Category_DropDownList.SelectedValue = "**Insert a new category**" Then
            PictureNames_DropDownList.Items.Clear()
            Cat_Literal.Text = "The categories with their display sequence are as follows:"
            Files_Literal.Text = ""
            Dim Categories As DataTable = HBSAcodeLibrary.Pictures.Categories()
            For Each row As DataRow In Categories.Rows
                Files_Literal.Text += "Seq = " & row.Item(0) & ", Cat = " & row.Item(1) & "<br/>"
            Next
            EditCategory_RadioButton_SelectedIndexChanged(sender, e)
        Else
            Populate_Pictures_DropDownList()
            EditCategory_RadioButton.Visible = True
            Cat_Literal.Text = "The pictures that can be managed for this category and with this facility are:"
        End If

    End Sub

    Sub Populate_Pictures_DropDownList()

        With PictureNames_DropDownList
            .Items.Clear()
            .Items.Add("**Select a picture**")
            .Items.Add("**Insert a new picture**")
            Files_Literal.Text = ""

            Dim fileNames As DataTable = HBSAcodeLibrary.Pictures.PictureNames(Category_DropDownList.SelectedValue)
            For Each row As DataRow In fileNames.Rows
                .Items.Add(New ListItem(row.Item(1), row.Item(0)))
                Files_Literal.Text += row.Item(1).Replace(" ", "&nbsp;") + "<br/>"
            Next

        End With

    End Sub

    Protected Sub UpLoad_Button_Click(ByVal sender As Object, ByVal e As EventArgs) Handles UpLoad_Button.Click

        If PictureNames_DropDownList.SelectedIndex < 1 Then

            Message_Literal.Text = "<span style='color:red;'>Please select a content file, or select **Insert a new picture**.</span>"

        Else

            Message_Literal.Text = ""

            If UploadFile.HasFile Then

                If UploadFile.PostedFile.ContentLength > 0 Then

                    If UploadFile.PostedFile.ContentLength < 2097153 Then

                        Dim ext As String = IO.Path.GetExtension(UploadFile.FileName).ToLower
                        If ext = ".bmp" OrElse ext = ".dib" OrElse ext = ".jpg" OrElse ext = ".jpeg" OrElse ext = ".jpe" OrElse
                           ext = ".jfif" OrElse ext = ".tif" OrElse ext = ".tiff" OrElse ext = ".gif" OrElse ext = ".png" OrElse ext = ".ico" Then
                            Try

                                Dim thisFileName As String = Left(IO.Path.GetFileNameWithoutExtension(UploadFile.FileName), 255)

                                If Description_TextBox.Text.Trim <> "" Then

                                    If PictureNames_DropDownList.SelectedIndex > 1 Then 'changing a file
                                        'remove the old file
                                        Using Picture As New HBSAcodeLibrary.Pictures(Category_DropDownList.SelectedValue, PictureNames_DropDownList.SelectedValue)
                                            IO.File.Delete(Server.MapPath("~/Picture Gallery/" & Picture.Category & "/" & Picture.Filename & Picture.Extension))
                                            Picture.Merge("", "")  'delete the database entry
                                        End Using
                                        populate_Pictures_DropDownList()
                                    End If

                                    UploadFile.SaveAs(Server.MapPath("~/Picture Gallery/" & Category_DropDownList.SelectedValue & "/" & UploadFile.FileName))

                                    'Load into db pictures table
                                    Using Picture As New HBSAcodeLibrary.Pictures(Category_DropDownList.SelectedValue,
                                                                                If(UpOrDownLoad.Items(0).Selected, thisFileName, PictureNames_DropDownList.SelectedItem.Text))
                                        Picture.Merge(ext, Description_TextBox.Text)
                                    End Using

                                    Message_Literal.Text = "<span style='color:DarkGreen;'>" & UploadFile.FileName & " has been uploaded as " &
                                                                    If(UpOrDownLoad.Items(0).Selected, Description_TextBox.Text, PictureNames_DropDownList.SelectedItem.Text) & ".</span>"
                                    Using Picture As New HBSAcodeLibrary.Pictures(Category_DropDownList.SelectedValue, PictureNames_DropDownList.SelectedValue)
                                        snapshot_image.ImageUrl = HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() & "/Picture Gallery/" & Picture.Category & "/" & UploadFile.FileName
                                        snapshot_image.AlternateText = PictureNames_DropDownList.SelectedValue
                                    End Using

                                Else

                                    Message_Literal.Text = "<span style='color:red;'>Please enter a description.</span> "

                                End If

                            Catch ex As Exception

                                Message_Literal.Text = "<span style='color:red;'>An error occurred: " & ex.Message & ".</span>"

                            End Try
                        Else

                            Message_Literal.Text = "<span style='color:red;'>The upload file must be a picture file (.bmp .dib .jpg .jpeg .jpe .jfif .tif .tiff .gif .png or .ico)"

                        End If

                    Else

                        Message_Literal.Text = "<span style='color:red;'>The maximum size allowed for a picture file is 2MB (2,097,152 characters). Edit your file to reduce the size.</span>"

                    End If

                Else

                    Message_Literal.Text = "<span style='color:red;'>Please select a file that contains data.</span>"

                End If

            Else

                Message_Literal.Text = "<span style='color:red'>Please select a file to upload.</span>"

            End If

        End If

        Dim ix As Integer = PictureNames_DropDownList.SelectedIndex
        populate_Pictures_DropDownList()
        PictureNames_DropDownList.SelectedIndex = ix

    End Sub

    Protected Sub PictureNames_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles PictureNames_DropDownList.SelectedIndexChanged

        UpOrDownLoad.Visible = PictureNames_DropDownList.SelectedIndex > 0
        UpLoad_Panel.Visible = False
        DownloadButtonRow.Visible = False
        Delete_Panel.Visible = False

        Message_Literal.Text = ""
        Description_Literal.Text = ""
        Description_TextBox.Text = ""

        If PictureNames_DropDownList.SelectedIndex = 1 Then
            UpOrDownLoad.Items(0).Selected = True
            UpOrDownLoad.Items(1).Selected = False
            UpOrDownLoad.Items(2).Selected = False
            UpOrDownLoad.Items(0).Text = "Insert"
            UpOrDownLoad.Enabled = False
            UpLoad_Panel.Visible = True
            UpLoad_Button.Text = "Upload the chosen file"
        Else
            UpOrDownLoad.Items(0).Selected = False
            UpOrDownLoad.Items(1).Selected = False
            UpOrDownLoad.Items(2).Selected = False
            UpOrDownLoad.Items(0).Text = "Change"
            UpOrDownLoad.Enabled = True
            UpLoad_Button.Text = "Upload to change the chosen file and its desciption"
            ChangingRadioList = True
            'Download_Panel.Visible = True

            Using Picture As New HBSAcodeLibrary.Pictures(Category_DropDownList.SelectedValue, PictureNames_DropDownList.SelectedValue)
                snapshot_image.ImageUrl = HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() & "/Picture Gallery/" & Picture.Category & "/" & Picture.Filename & Picture.Extension
                snapshot_image.AlternateText = PictureNames_DropDownList.SelectedValue
                Description_Literal.Text = Picture.Filename
                Description_TextBox.Text = Picture.Description
            End Using

        End If

        Message_Literal.Text = ""

    End Sub

    Dim ChangingRadioList As Boolean

    Protected Sub UpOrDownLoad_SelectedIndexChanged(sender As Object, e As EventArgs) Handles UpOrDownLoad.SelectedIndexChanged

        DownloadButtonRow.Visible = False
        Delete_Panel.Visible = False

        Using Picture As New HBSAcodeLibrary.Pictures(Category_DropDownList.SelectedValue, PictureNames_DropDownList.SelectedValue)

            snapshot_image.ImageUrl = HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() & "/Picture Gallery/" & Picture.Category & "/" & Picture.Filename & Picture.Extension
            snapshot_image.AlternateText = PictureNames_DropDownList.SelectedValue
            Description_Literal.Text = Picture.Filename

            If Not UpOrDownLoad.Items(0).Selected Then 'selected download or delete

                If UpOrDownLoad.Items(1).Selected Then 'delete
                    'ask for confirmation to delete
                    Delete_Literal.Text = "Do you really want to delete " & (Picture.Category & "/" & Picture.Filename).Replace(" ", "&nbsp;")
                    Delete_Panel.Visible = True
                    UpLoad_Panel.Visible = False
                Else 'offer download
                    DownloadButtonRow.Visible = True
                    'Download_Panel.Visible = True
                    Download_Button.Text = "Download " & PictureNames_DropDownList.SelectedValue & " now."
                End If

            Else 'selected change
                'Download_Panel.Visible = False
                If Not ChangingRadioList Then
                    UpLoad_Panel.Visible = True
                Else
                    ChangingRadioList = False
                End If
            End If

        End Using

        Message_Literal.Text = ""

    End Sub

    Protected Sub Download_Button_Click(sender As Object, e As EventArgs) Handles Download_Button.Click

        'stream the file to the user
        Dim PictureFileName As String
        Dim PictureFilePath As String
        Using Picture As New HBSAcodeLibrary.Pictures(Category_DropDownList.SelectedValue, PictureNames_DropDownList.SelectedValue)
            PictureFileName = Picture.Filename & Picture.Extension
            PictureFilePath = Server.MapPath("~/Picture Gallery/" & Picture.Category & "/" & PictureFileName)
        End Using

        Response.ContentType = "text/jpg"
        Response.AppendHeader("Content-Disposition", "attachment; filename=" & PictureFileName)
        Response.TransmitFile(PictureFilePath)
        Response.End()


    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        Delete_Literal.Text = ""
        Delete_Panel.Visible = False

    End Sub

    Protected Sub ConfirmDelete_Button_Click(sender As Object, e As EventArgs) Handles ConfirmDelete_Button.Click

        Using Picture As New HBSAcodeLibrary.Pictures(Category_DropDownList.SelectedValue, PictureNames_DropDownList.SelectedValue)

            Try
                Picture.Merge("", "")
                IO.File.Delete(Server.MapPath("~/Picture Gallery/" & Picture.Category & "/" & Picture.Filename & Picture.Extension))
                Message_Literal.Text = "Deleted"
            Catch ex As Exception
                Message_Literal.Text = "ERROR deleting " & Picture.Category & "/" & Picture.Filename & Picture.Extension &
                                       "<br> Contact support with the following:<br>" & ex.Message
            End Try

        End Using

        Dim selectedCategory As String = Category_DropDownList.SelectedValue
        Dim selectedPicture As String = PictureNames_DropDownList.SelectedValue

        populate_Categories_DropDownList()

        Try
            Category_DropDownList.SelectedValue = selectedCategory
            populate_Pictures_DropDownList()
            Try
                PictureNames_DropDownList.SelectedValue = selectedPicture
            Catch ex As Exception
                PictureNames_DropDownList.SelectedIndex = 0
            End Try
        Catch ex As Exception
            Category_DropDownList.SelectedIndex = 0
            PictureNames_DropDownList.Items.Clear()
        End Try

        Cancel_Button_Click(sender, e)

    End Sub

    Protected Sub EditCategory_RadioButton_SelectedIndexChanged(sender As Object, e As EventArgs) Handles EditCategory_RadioButton.SelectedIndexChanged

        'This exposes the category panel.  May be called by the Category selection being insert
        'Interrogate the category selector to determine if insert and if not the Radio button to determine whether to delete or amend

        Dim CategoryTable As DataTable = HBSAcodeLibrary.Pictures.PictureCategory(Category_DropDownList.SelectedValue)
        Sequence_TextBox.Text = CategoryTable.Rows(0).Item(0)
        Category_TextBox.Text = CategoryTable.Rows(0).Item(1)
        Category_Panel.Visible = True

        If Category_DropDownList.SelectedValue.ToLower Like "*insert*" Then
            Sequence_TextBox.Visible = True
            Sequence_TextBox.Text = ""
            Category_TextBox.Enabled = True
            Category_Literal.Text = "Enter the new category details below and click Submit to add them"

        Else
            If EditCategory_RadioButton.Items(0).Selected Then
                Sequence_TextBox.Visible = True
                Category_TextBox.Enabled = False
                Category_Literal.Text = "Enter the new sequence below and click Submit to change it"

            Else
                Sequence_TextBox.Visible = False
                Category_TextBox.Enabled = False
                Sequence_TextBox.Text = "-1"
                Category_Literal.Text = "To confirm deleting this category (and all pictures that are in it) click Submit"

            End If
        End If
    End Sub

    Protected Sub CategoryCancel_Button_Click(sender As Object, e As EventArgs) Handles CategoryCancel_Button.Click

        Category_Panel.Visible = False
        EditCategory_RadioButton.SelectedIndex = -1

    End Sub

    Protected Sub Category_Button_Click(sender As Object, e As EventArgs) Handles Category_Button.Click

        'Update db via merge
        Try

            Dim dir As New IO.DirectoryInfo(Server.MapPath("~/Picture Gallery/" & Category_TextBox.Text.Trim))

            If Sequence_TextBox.Text = "-1" Then 'delete files and directory
                For Each file As IO.FileInfo In dir.GetFiles()
                    file.Delete()
                Next
                dir.Delete()
            End If

            HBSAcodeLibrary.Pictures.MergePictureCategory(CInt(Sequence_TextBox.Text), Category_TextBox.Text)

            If Sequence_TextBox.Text = "-1" Then
                Message_Literal.Text = "The category " & Category_TextBox.Text & ", and all pictures within it, has been deleted"
            Else
                If Not dir.Exists Then
                    dir.Create()
                    Message_Literal.Text = "The category " & Category_TextBox.Text & " has been created"
                Else
                    Message_Literal.Text = "The category " & Category_TextBox.Text & " sequence has been changed"
                End If
            End If

            Category_Panel.Visible = False
            populate_Categories_DropDownList()
            PictureNames_DropDownList.Items.Clear()
            Cat_Literal.Text = ""
            Files_Literal.Text = ""
            EditCategory_RadioButton.SelectedIndex = -1

        Catch ex As Exception
            Category_Literal.Text = "<span style='color:red;'>Error: " & ex.Message & "<br/>" &
                                    "Please contact support.</span>"
        End Try
    End Sub
End Class
