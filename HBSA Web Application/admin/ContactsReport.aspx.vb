Public Class ContactsReport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
          OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        End If

        If Not IsPostBack Then    'set up the report ready to download

            Session("ContactsReport") = HBSAcodeLibrary.SharedRoutines.ContactsReport()

        End If

    End Sub

End Class