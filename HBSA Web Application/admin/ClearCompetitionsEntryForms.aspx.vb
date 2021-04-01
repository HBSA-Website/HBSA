Public Class ClearCompetitionsEntryForms
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub ClearCompsEntryForms_Button_Click(sender As Object, e As EventArgs) Handles ClearCompsEntryForms_Button.Click

        If ClearCompsEntryForms_Button.Text Like "*clear*" Then
            HBSAcodeLibrary.CompetitionEntryFormData.ClearCompetitionsEntryForms()
            ClearCompsEntryForms_Button.Text = "Click here to go to the home page, or select an option from above."
            ClearCompsEntryForms_Literal.Text = "All entry forms have been cleared."
        Else
            Response.Redirect("adminHome.aspx")
        End If

    End Sub
End Class