Public Class ClubsWithoutClubLogin
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Using clubs As DataTable = HBSAcodeLibrary.EntryFormData.ClubsWithoutLogin

            With ClubsWithoutLogin_GridView
                .DataSource = clubs
                .DataBind()
            End With

        End Using
    End Sub

End Class