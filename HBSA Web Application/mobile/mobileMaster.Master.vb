Imports HBSAcodeLibrary

Public Class MobileMaster
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        ''ensure use of ssl
        'If Not Request.IsSecureConnection AndAlso Request.Url.DnsSafeHost.ToLower <> "localhost" Then
        '    Response.Redirect(Request.Url.ToString.Replace("http", "https"))
        'End If

        Using cfg As New HBSAcodeLibrary.HBSA_Configuration
            If CBool(cfg.Value("UnderMaintenance")) Then
                Response.Redirect("~/UnderMaintenance.aspx")
                Exit Sub
            End If
        End Using

        If Session("mobile") Then
            Dim Destination As String = Request.Url.Segments(Request.Url.Segments.Length - 1) 'Gives as the destination page filename
            Dim FilePath As String = Server.MapPath("~/mobile/" & Destination)
            Dim FileInf As New IO.FileInfo(FilePath)
            If Not FileInf.Exists Then
                Dim URL As String = Request.Url.ToString.Replace("mobile/", "")
                Response.Redirect(URL)
            End If

        End If

        For Each MenuRow As HtmlTableRow In leftMenu_Div.Rows
            For Each MenuItem As HtmlTableCell In MenuRow.Cells

                If MenuItem.ID = "League" Then
                    For Each SubMenuRow As HtmlTableRow In SubMenu_League_Table.Rows
                        For Each SubMenuItem As HtmlTableCell In SubMenuRow.Cells

                            If Not SubMenuItem.Attributes("class") Is Nothing Then

                                Dim classValue As String = SubMenuItem.Attributes("class").ToLower
                                If classValue Like "*season*" Then
                                    SubMenuItem.Visible = (HBSAcodeLibrary.HBSA_Configuration.CloseSeason And classValue Like "*close*") Or
                                                          (Not HBSAcodeLibrary.HBSA_Configuration.CloseSeason And Not classValue Like "*close*")
                                End If

                            End If

                        Next
                    Next
                End If

            Next
        Next

        EntryFormButton.Visible = HBSAcodeLibrary.HBSA_Configuration.CloseSeason And HBSAcodeLibrary.HBSA_Configuration.AllowLeaguesEntryForms
        resultButton.Visible = Not HBSAcodeLibrary.HBSA_Configuration.CloseSeason
        teamLoginButton.Visible = Not HBSAcodeLibrary.HBSA_Configuration.CloseSeason 'Or dbClasses.Configuration.AllowLeaguesEntryForms
        clubLoginButton.Visible = HBSAcodeLibrary.HBSA_Configuration.AllowCompetitionsEntryForms Or HBSAcodeLibrary.HBSA_Configuration.AllowLeaguesEntryForms
        finesButton.Visible = True
        AGMVoteButton.Visible = HBSAcodeLibrary.HBSA_Configuration.AllowAGMvote

        HandbookMenuItem.Visible = Utilities.HandbookExists

        AccessCode_TextBox.Text = ""
        AccessCode_Panel.Visible = False

        If Session("TeamID") Is Nothing Then
            Login_Literal.Text = ""
            Login_Button.Text = "Team Log in"
        Else
            If Not Session("Email") Is Nothing Then
                Using User As New HBSAcodeLibrary.UserData(Session("Email"), Session("Password"))
                    Using Team As New TeamData(User.TeamID)
                        Login_Literal.Text = (User.FirstName & " " & User.Surname & " of " & Team.ClubName & " " & Team.Team).Trim & " in " & Team.LeagueName & " " & Team.SectionName
                        Login_Button.Text = "Team Log out"
                        myRegistrationButton.Visible = True
                        PopulateAccessCode()
                    End Using
                End Using
            End If
        End If

        If Session("ClubLoginID") Is Nothing Then
            clubLoginRef.InnerText = "Club Log in"
            clubLogin_Literal.Text = ""
        Else
            clubLoginRef.InnerText = "Club Log out"
            clubLoginButton.Visible = True
            Using ClubUser As New HBSAcodeLibrary.ClubUserData(Session("ClubLoginID"))
                clubLogin_Literal.Text = ClubUser.FirstName & " " & ClubUser.Surname & " of " & ClubUser.ClubName
            End Using
            PopulateAccessCode()
        End If

        'set up advert
        If Session("NoAdverts") Is Nothing Then
            Dim RandomisedAdverts As HBSAcodeLibrary.Advert.RandomAdverts = HBSAcodeLibrary.Advert.RandomiseAdverts
            Session("NoAdverts") = RandomisedAdverts.noAdverts
            Session("Advertisers") = RandomisedAdverts.advertisers
            Session("LastAdvert") = RandomisedAdverts.lastAdvert
            Session("advertCounter") = RandomisedAdverts.advertCounter
        End If

        If Session("advertCounter") = 0 Then
            Dim NoAdverts As Integer = Session("NoAdverts")
            Dim Advertisers As DataTable = Session("Advertisers")
            Dim AdvertNo As Integer = Session("LastAdvert")
            Dim AdvertImg As HtmlImage = adImage

            AdvertNo += 1
            If AdvertNo = NoAdverts Then
                AdvertNo = 0
            End If

            Try
                Using ad As New HBSAcodeLibrary.Advert(Advertisers.Rows(AdvertNo)("Advertiser"))

                    advertURL.Value = ad.webURL
                    AdvertImg.Src = "data:image/JPEG;base64," & Convert.ToBase64String(ad.advertBinary)
                    AdvertImg.Alt = ad.advertiser
                    advertDiv.Visible = True

                End Using

                Session("LastAdvert") = AdvertNo

            Catch ex As Exception

                advertDiv.Visible = False

            End Try

        Else

            advertDiv.Visible = False

        End If

        If Session("advertCounter") = 5 Then
            Session("advertCounter") = 0
        Else
            Session("advertCounter") += 1
        End If

    End Sub

    Protected Sub NonMobile_Button_Click(sender As Object, e As EventArgs) Handles NonMobile_Button.Click

        Session("mobile") = Nothing
        If Not Session("caller") Is Nothing Then
            Response.Redirect(Session("caller").replace("/mobile", ""))
        Else
            Response.Redirect("../home.aspx")
        End If

    End Sub

    Private Sub Login_Button_Click(sender As Object, e As EventArgs) Handles Login_Button.Click

        If Login_Button.Text.ToLower Like "*out*" Then
            Session("TeamID") = Nothing
            Login_Literal.Text = ""
            Login_Button.Text = "Team log in"
            'MyProfile_Button.Visible = False
            Response.Redirect("Login.aspx")
        Else
            Session("LoginCaller") = Request.Url.ToString
            Response.Redirect("Login.aspx")
        End If

    End Sub
    Protected Sub PopulateAccessCode()
        Using cfg As New HBSA_Configuration

            Dim Password = cfg.Value("ViewPlayerDetailsAccessCode")
            If Not IsNothing(Password) AndAlso
                Password.Trim <> "" Then
                AccessCode_TextBox.Text = Password.Trim
                AccessCode_Panel.Visible = True
            End If

        End Using

    End Sub
    Protected Sub AccessCode_Button_Click(sender As Object, e As EventArgs) Handles AccessCode_Button.Click

        If AccessCode_Button.Text = "Show Access Code" Then
            AccessCode_TextBox.TextMode = TextBoxMode.SingleLine
            AccessCode_Button.Text = "Hide Access Code"
        Else
            AccessCode_TextBox.TextMode = TextBoxMode.Password
            AccessCode_Button.Text = "Show Access Code"
        End If

    End Sub

End Class