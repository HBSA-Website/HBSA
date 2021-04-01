Public Class PictureGallery
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            With Room_DropDownList

                .Items.Clear()

                .DataSource = HBSAcodeLibrary.Pictures.Categories
                .DataTextField = "Category"
                '.DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Choose a room**"))
                .SelectedIndex = 0

            End With

        End If

        If Room_DropDownList.SelectedIndex > 0 Then
            CreateButtons()
        End If

    End Sub

    Protected Sub CreateButtons()

        Dim Category As String = Room_DropDownList.SelectedValue
        Dim Dir As New IO.DirectoryInfo(Server.MapPath("Picture Gallery\" & Category))

        Dim Filenames() As IO.FileInfo = Dir.GetFiles()

        For Each ctl As Control In Thumbnails_Panel.Controls
            If TypeOf ctl Is ImageButton Then
                Dim thumb As ImageButton = ctl
                Thumbnails_Panel.Controls.Remove(thumb)
            End If
        Next

        Using InfoPage As New HBSAcodeLibrary.ContentData("Gallery - " & Category)
            Text_Literal.Text = InfoPage.ContentHTML
        End Using

        Dim counter As Integer = 0
        For Each file As IO.FileInfo In Filenames

            Using Picture As New HBSAcodeLibrary.Pictures(Category, file.Name.Replace(file.Extension, ""))

                Dim thumb As New HtmlImage With {
                    .ID = "Thumb" & counter,
                    .Src = "Picture Gallery/" & Category & "/" & file.Name,
                    .Alt = Picture.Description
                }
                thumb.Attributes.Add("title", Picture.Description)
                thumb.Attributes.Add("class", "thumbNail")
                thumb.Attributes.Add("onmouseover", "this.style.cursor='pointer")
                thumb.Attributes.Add("onclick", "showPicture(" & counter & ");")

                Thumbnails_Panel.Controls.Add(thumb)

                counter += 1


            End Using

        Next

        PicturesCount_Hidden.Value = counter

    End Sub


End Class