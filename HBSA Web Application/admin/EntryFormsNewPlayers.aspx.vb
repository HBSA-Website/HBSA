Public Class EntryFormsNewPlayers
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Using NewPlayers As DataTable = HBSAcodeLibrary.EntryFormData.EntryFormsNewPlayers()

            With EntryFormsNewPlayers_GridView
                .DataSource = NewPlayers
                .DataBind()
            End With

        End Using

    End Sub

End Class