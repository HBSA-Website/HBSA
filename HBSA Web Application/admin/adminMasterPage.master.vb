
Partial Class admin_adminMasterPage
    Inherits System.Web.UI.MasterPage


    Private Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        ''ensure use of ssl
        'If Not Request.IsSecureConnection AndAlso
        '   Request.Url.DnsSafeHost.ToLower <> "localhost" Then
        '    Response.Redirect(Request.Url.ToString.Replace("http", "https"))
        'End If

        Using cfg As New HBSAcodeLibrary.HBSA_Configuration
            If CBool(cfg.Value("UnderMaintenance")) Then
                UnderMaintLiteral.Text = "Beware:  web site is under maintenance.  You should only be changing the setting for this."
            Else
                UnderMaintLiteral.Text = ""
            End If
        End Using

        If Not Request.Url.ToString.ToLower Like "*adminhome*" Then
            If (Session("adminDetails") Is Nothing OrElse Session("adminDetails").Rows.count = 0) AndAlso
                Session("UserType") <> "Printer" Then

                Session("Caller") = Request.Url.AbsolutePath
                Response.Redirect("adminhome.aspx")

            End If

        End If

        Dim CloseSeason As Boolean = HBSAcodeLibrary.HBSA_Configuration.CloseSeason
        CloseFixtureDates.Visible = CloseSeason
        CloseFixtureGrids.Visible = CloseSeason
        CloseLook.Visible = CloseSeason
        CloseTeams.Visible = CloseSeason

    End Sub

End Class

