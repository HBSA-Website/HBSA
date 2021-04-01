Public Class Adverts
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                UpLoad_Button.Attributes.Add("onclick", "loadDiv('loading')")
                Download_Panel.Attributes.Add("max-height", "500px")
                populate_Adverts_DropDownList()
                Message_Literal.Text = ""
            End If
        End If

    End Sub

    Sub Populate_Adverts_DropDownList()

        With Adverts_DropDownList
            .Items.Clear()
            .Items.Add("**Select an advert**")
            .Items.Add("**Insert a new advert**")
            Files_Literal.Text = ""

            Dim fileNames As DataTable = HBSAcodeLibrary.Advert.Adverts
            For Each row As DataRow In fileNames.Rows
                .Items.Add(row.Item("Advertiser"))
                Files_Literal.Text += row.Item("Advertiser").Replace(" ", "&nbsp;") + "<br/>"
            Next

        End With

    End Sub

    Protected Sub UpLoad_Button_Click(ByVal sender As Object, ByVal e As EventArgs) Handles UpLoad_Button.Click

        If Adverts_DropDownList.SelectedIndex < 1 Then

            Message_Literal.Text = "<span style='color:red;'>Please select a content file, or select **Insert a new picture**.</span>"

        Else

            Message_Literal.Text = ""
            Dim ext As String = ""
            Dim AdvertBinary() As Byte = {}

            If Advertiser_TextBox.Text.Trim <> "" Then

                If UploadFile.HasFile Then

                    If UploadFile.PostedFile.ContentLength > 0 Then

                        If UploadFile.PostedFile.ContentLength < 2097153 Then

                            ext = IO.Path.GetExtension(UploadFile.FileName).ToLower
                            If ext = ".bmp" OrElse ext = ".dib" OrElse ext = ".jpg" OrElse ext = ".jpeg" OrElse ext = ".jpe" OrElse
                               ext = ".jfif" OrElse ext = ".tif" OrElse ext = ".tiff" OrElse ext = ".gif" OrElse ext = ".png" OrElse ext = ".ico" Then
                                Try

                                    Dim PictureBinaryStream = UploadFile.PostedFile.InputStream
                                    Dim PictureBinaryReader As IO.BinaryReader = New IO.BinaryReader(PictureBinaryStream)
                                    AdvertBinary = PictureBinaryReader.ReadBytes(PictureBinaryStream.Length)

                                    Message_Literal.Text = "<span style='color:DarkGreen;'>" & UploadFile.FileName & " has been uploaded as " &
                                                                If(UpOrDownLoad.Items(0).Selected, Left(IO.Path.GetFileNameWithoutExtension(UploadFile.FileName), 31),
                                                                                                   Adverts_DropDownList.SelectedItem.Text) & ".</span>"
                                Catch ex As Exception

                                    Message_Literal.Text = "<span style='color:red;'>An error occurred: " & ex.Message & ".</span>"
                                    Exit Sub

                                End Try

                            Else

                                Message_Literal.Text = "<span style='color:red;'>The upload file must be a picture file (.bmp .dib .jpg .jpeg .jpe .jfif .tif .tiff .gif .png or .ico)"
                                Exit Sub

                            End If

                        Else

                            Message_Literal.Text = "<span style='color:red;'>The maximum size allowed for an advert picture file is 2MB (2,097,152 characters). Edit your file to reduce the size.</span>"
                            Exit Sub

                        End If

                    Else

                        Message_Literal.Text = "<span style='color:red;'>Please select a file that contains data.</span>"
                        Exit Sub

                    End If

                End If

                'Load db adverts table
                Using ad As New HBSAcodeLibrary.Advert(Adverts_DropDownList.SelectedValue)
                    If ext <> "" Then ad.extension = ext
                    ad.advertiser = Advertiser_TextBox.Text.Trim
                    ad.webURL = WebURL_TextBox.Text.Trim
                    If ad.webURL <> "" AndAlso Not ad.webURL.ToLower.StartsWith("http") Then
                        ad.webURL = "http://" & ad.webURL
                    End If

                    ad.advertBinary = AdvertBinary
                    ad.Merge()

                    snapshot_image.ImageUrl = "~/Advert.ashx?Advertiser=" & ad.advertiser
                    snapshot_image.AlternateText = Adverts_DropDownList.SelectedItem.Text
                    Advertiser_Literal.Text = ad.advertiser
                    Advertiser_TextBox.Text = ad.advertiser
                    Advertiser_TextBox.Enabled = False
                    WebURL_TextBox.Text = ad.webURL
                    Download_Panel.Visible = True

                    populate_Adverts_DropDownList()
                    Adverts_DropDownList.SelectedValue = ad.advertiser
                    Message_Literal.Text = "<span style='color:DarkGreen;'>Advert uploaded/changed.</span>"

                End Using

            Else

                Message_Literal.Text = "<span style='color:red;'>There must be an advertiser.</span>"

            End If
        End If

    End Sub

    Protected Sub Adverts__DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Adverts_DropDownList.SelectedIndexChanged

        UpOrDownLoad.Visible = Adverts_DropDownList.SelectedIndex > 0
        UpLoad_Panel.Visible = False
        Download_Button.Visible = False
        Delete_Panel.Visible = False

        Message_Literal.Text = ""
        Advertiser_Literal.Text = ""
        WebURL_TextBox.Text = ""

        If Adverts_DropDownList.SelectedIndex = 1 Then
            UpOrDownLoad.Items(0).Selected = True
            UpOrDownLoad.Items(1).Selected = False
            UpOrDownLoad.Items(2).Selected = False
            UpOrDownLoad.Items(0).Text = "Insert"
            UpOrDownLoad.Enabled = False
            UpLoad_Panel.Visible = True
            Advertiser_TextBox.Enabled = True
            Advertiser_TextBox.Text = ""
        Else
            UpOrDownLoad.Items(0).Selected = False
            UpOrDownLoad.Items(1).Selected = False
            UpOrDownLoad.Items(2).Selected = False
            UpOrDownLoad.Items(0).Text = "Change"
            UpOrDownLoad.Enabled = True
            ChangingRadioList = True
            Download_Panel.Visible = True
            Advertiser_TextBox.Enabled = False

            Using ad As New HBSAcodeLibrary.Advert(Adverts_DropDownList.SelectedValue)
                snapshot_image.ImageUrl = "~/Advert.ashx?Advertiser=" & ad.advertiser
                snapshot_image.AlternateText = Adverts_DropDownList.SelectedItem.Text
                Advertiser_Literal.Text = ad.advertiser
                Advertiser_TextBox.Text = ad.advertiser
                WebURL_TextBox.Text = ad.webURL
            End Using

        End If

        Message_Literal.Text = ""

    End Sub

    Dim ChangingRadioList As Boolean

    Protected Sub UpOrDownLoad_SelectedIndexChanged(sender As Object, e As EventArgs) Handles UpOrDownLoad.SelectedIndexChanged

        Download_Button.Visible = False
        Delete_Panel.Visible = False

        If Not UpOrDownLoad.Items(0).Selected Then 'selected download or delete

            Download_Panel.Visible = True

            Using ad As New HBSAcodeLibrary.Advert(Adverts_DropDownList.SelectedValue)
                snapshot_image.ImageUrl = "~/Advert.ashx?Advertiser=" & ad.advertiser
                snapshot_image.AlternateText = Adverts_DropDownList.SelectedItem.Text
                Advertiser_Literal.Text = ad.advertiser

                If UpOrDownLoad.Items(1).Selected Then 'delete
                    'ask for confirmation to delete
                    Delete_Literal.Text = "Do you really want to delete the advert for " & ad.advertiser
                    Delete_Panel.Visible = True
                Else 'offer download
                    Download_Button.Visible = True
                    Download_Button.Text = "Download " & Adverts_DropDownList.SelectedValue & " now."
                End If
            End Using

        Else 'selected upload/change
            Download_Panel.Visible = True
            If Not ChangingRadioList Then

                UpLoad_Panel.Visible = True
                If UpOrDownLoad.Items(0).Text = "Change" Then

                    Using ad As New HBSAcodeLibrary.Advert(Adverts_DropDownList.SelectedValue)
                        snapshot_image.ImageUrl = "~/Advert.ashx?Advertiser=" & ad.advertiser
                        snapshot_image.AlternateText = Adverts_DropDownList.SelectedItem.Text
                        Advertiser_Literal.Text = ad.advertiser
                        Advertiser_TextBox.Text = ad.advertiser
                        WebURL_TextBox.Text = ad.webURL
                    End Using

                Else
                    Advertiser_Literal.Text = ""
                    Advertiser_TextBox.Text = ""
                End If

            Else
                ChangingRadioList = False 'x
            End If

        End If

        Message_Literal.Text = ""

    End Sub

    Protected Sub Download_Button_Click(sender As Object, e As EventArgs) Handles Download_Button.Click

        'stream the content HTML to the user as a file
        Dim PictureBinary As Byte()
        Dim ext As String
        Using ad As New HBSAcodeLibrary.Advert(Adverts_DropDownList.SelectedValue)
            PictureBinary = ad.advertBinary
            ext = ad.extension
        End Using

        Response.Buffer = True
        Response.Charset = ""
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.ContentType = "text/jpg"
        Response.AddHeader("Content-Disposition", "attachment; filename = " & Adverts_DropDownList.SelectedItem.Text & ext)
        Response.BinaryWrite(PictureBinary)
        Response.Flush()
        Response.End()

    End Sub

    Protected Sub Cancel_Button_Click(sender As Object, e As EventArgs) Handles Cancel_Button.Click

        Delete_Literal.Text = ""
        Delete_Panel.Visible = False

    End Sub

    Protected Sub ConfirmDelete_Button_Click(sender As Object, e As EventArgs) Handles ConfirmDelete_Button.Click

        Using ad As New HBSAcodeLibrary.Advert(Adverts_DropDownList.SelectedValue)

            ad.extension = "" 'set extension to nothing to delete an advert
            ad.Merge()
            Message_Literal.Text = "Deleted"

        End Using

        populate_Adverts_DropDownList()
        Adverts_DropDownList.SelectedIndex = 0
        
        Cancel_Button_Click(sender, e)

    End Sub


End Class