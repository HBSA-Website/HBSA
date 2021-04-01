Public Class MissingResults
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Just load the grid view
        Using missingResults As DataTable = HBSAcodeLibrary.MatchResult.MissingResults

            With MissingResults_GridView

                .DataSource = missingResults
                .DataBind()

            End With

        End Using

    End Sub

End Class