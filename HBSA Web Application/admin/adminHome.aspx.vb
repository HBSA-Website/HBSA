Partial Class adminHome
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("UserType") = "Printer" Then
            Response.Redirect("ContentManager.aspx")
        End If

        If (Session("adminDetails") Is Nothing OrElse Session("adminDetails").Rows.count = 0) Then

            LoggedIn_Panel.Visible = False
            LoggedOut_Panel.Visible = True
            ' Session("Caller") = Nothing

        Else

            Using cfg As New HBSAcodeLibrary.HBSA_Configuration
                If CBool(cfg.Value("UnderMaintenance")) Then
                    Response.Redirect("Settings.aspx")
                End If
            End Using

            If Session("Caller") Is Nothing Then
                Dim adminDetails As System.Data.DataRow = Session("adminDetails").rows(0)
                Welcome_Literal.Text = "Welcome " & adminDetails!Forename & " " & adminDetails!Surname
                LoggedIn_Panel.Visible = True
                LoggedOut_Panel.Visible = False
                Login_Button.Attributes.Add("onmouseover", "this.style.cursor='pointer'")
            Else
                Response.Redirect(Session("Caller"))
            End If

        End If

    End Sub


    Protected Sub Login_Button_Click(sender As Object, e As EventArgs) Handles Login_Button.Click

        Dim adminDetails As DataTable = HBSAcodeLibrary.SharedRoutines.CheckAdminLogin(UserName_TextBox.Text.Trim, Password_TextBox.Text.Trim)

        If (adminDetails Is Nothing OrElse adminDetails.Rows.Count = 0) _
        AndAlso Session("UserType") <> "Printer" Then

            Status_Literal.Text = "<span style='color:red;'>Login failed with these credentials.<br/>Correct them and try again, or click Forgotten Password.</span><br/>Make sure your email address is correct."
            Session("user") = Nothing
            Session("adminDetails") = Nothing
            Session("UserType") = Nothing

        Else

            Session("UserType") = adminDetails.Rows(0).Item("Function")
            If Session("UserType") = "Printer" Then
                Session("user") = Nothing
                Session("adminDetails") = Nothing
            Else
                Session("adminDetails") = adminDetails
                Session("user") = adminDetails.Rows(0).Item("username")
                Session("UserType") = Nothing
            End If

        End If

        Page_Load(sender, e)

    End Sub
End Class
