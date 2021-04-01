Public Class Adverts2
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            populate_Adverts_DropDownList()
        End If

    End Sub

    Sub Populate_Adverts_DropDownList()

        With Adverts_DropDownList
            .Items.Clear()
            .Items.Add("**Select an advertiser**")

            Dim Advertisers As DataTable = HBSAcodeLibrary.Advert.Adverts
            For Each row As DataRow In Advertisers.Rows
                .Items.Add(row.Item("Advertiser"))
            Next

        End With

    End Sub

    Protected Sub Adverts__DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Adverts_DropDownList.SelectedIndexChanged

        If Adverts_DropDownList.SelectedIndex > 0 Then

            Using ad As New HBSAcodeLibrary.Advert(Adverts_DropDownList.SelectedValue)

                snapshot_img.Src = "data:image/JPEG;base64," & Convert.ToBase64String(ad.advertBinary) '.ImageUrl = "~/Advert.ashx?Advertiser=" & ad.advertiser
                snapshot_img.Alt = Adverts_DropDownList.SelectedItem.Text
                snapshot_img.Attributes.Add("target", "_blank")
                WebURL_Literal.Text = ad.webURL
                snapshot_link.HRef = ad.webURL

            End Using

        End If

    End Sub

End Class