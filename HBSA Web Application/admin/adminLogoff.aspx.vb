
Partial Class admin_adminLogoff
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Session("adminDetails") = Nothing
        Response.Redirect("adminHome.aspx")

    End Sub
End Class
