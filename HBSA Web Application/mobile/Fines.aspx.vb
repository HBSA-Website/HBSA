Imports HBSAcodeLibrary
Public Class Fines2
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Session("LoginCaller") = Request.Url.AbsolutePath

        If Session("ClubLoginID") Is Nothing Then

            If Session("teamID") Is Nothing Then

                Response.Redirect("ClubLogin.aspx")

            Else

                Using Teamdata As HBSAcodeLibrary.TeamData = New HBSAcodeLibrary.TeamData(Session("teamID"))
                    Session("ClubID") = Teamdata.ClubID
                End Using
            End If

        Else
            Session("ClubID") = Session("ClubLoginID")
        End If

        If Not IsPostBack Then
            GetFines()
        End If

    End Sub
    Sub GetFines()

        Using FinesSummaryTable As DataTable = HBSAcodeLibrary.Fines.Summary(Owing_CheckBox.Checked, Session("ClubID"), True)
            Fines_Div.InnerHtml = Utilities.BuildMobileActiveTable(FinesSummaryTable, 1,, "ActiveDetailDiv", "Fine")
        End Using

    End Sub

    Protected Sub Owing_CheckBox_CheckedChanged(sender As Object, e As EventArgs) Handles Owing_CheckBox.CheckedChanged
        GetFines()
    End Sub
End Class