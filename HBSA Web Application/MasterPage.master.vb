Imports HBSAcodeLibrary
Imports System.Data.SqlClient

Partial Class MasterPage
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        'ensure use of ssl
        If Not Request.IsSecureConnection AndAlso Request.Url.DnsSafeHost.ToLower <> "localhost" Then
            Response.Redirect(Request.Url.ToString.Replace("http", "https"))
        End If

        Using cfg As New HBSAcodeLibrary.HBSA_Configuration
            If CBool(cfg.Value("UnderMaintenance")) Then
                Response.Redirect("UnderMaintenance.aspx")
                Exit Sub
            End If
        End Using

        If Session("mobile") Then
            Dim Destination As String = Request.Url.Segments(Request.Url.Segments.Length - 1) 'Gives as the destination page filename
            Dim FilePath As String = Server.MapPath("~/mobile/" & Destination)
            Dim FileInf As New IO.FileInfo(FilePath)
            If FileInf.Exists Then
                Dim URL As String = Request.Url.ToString.Replace(Destination, "mobile/" & Destination)
                Response.Redirect(URL)
            End If
        End If

        For Each MenuRow As HtmlTableRow In Menu_Div.Rows
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

        HandbookMenuItem.Visible = Utilities.HandbookExists

        If Not IsPostBack Then
            Dim Pagename As String = Page.ToString().Replace("ASP.", "").Replace("_aspx", "")

            If Pagename.ToLower.Trim = "infopage" Then
                Pagename += "/" + Request.QueryString("Subject").ToString
            End If

            Using SenderPage As New HBSAcodeLibrary.PageCounter(Pagename)

                With SenderPage

                    Dim Count As Integer = .HitCounter + 1
                    Page_Literal.Text = " (" & .PageName & " " & Count & ")"
                    .Merge(Count)

                End With

            End Using

        End If

        Version_Literal.Text = GetType(MasterPage).Assembly.GetName().Version.ToString ' My.Application.Info.Version.ToString
        HitCount_Literal.Text = If(Session("HitCount"), "No hit count available")

        EntryForm_Button.Visible = HBSAcodeLibrary.HBSA_Configuration.CloseSeason And HBSAcodeLibrary.HBSA_Configuration.AllowLeaguesEntryForms
        MatchResult_Button.Visible = Not HBSAcodeLibrary.HBSA_Configuration.CloseSeason
        'AGM_Vote_Button.Visible = HBSAcodeLibrary.HBSA_Configuration.AllowAGMvote

        Login_button.Visible = Not HBSAcodeLibrary.HBSA_Configuration.CloseSeason 'Or dbClasses.Configuration.AllowLeaguesEntryForms

        ClubLogin_Button.Visible = HBSAcodeLibrary.HBSA_Configuration.AllowCompetitionsEntryForms Or HBSAcodeLibrary.HBSA_Configuration.AllowLeaguesEntryForms

        Fines_Button.Visible = True

        If Session("adminDetails") Is Nothing OrElse Session("adminDetails").Rows.count = 0 Then
            Admin_Button.Visible = False
        Else
            Admin_Button.Visible = True
        End If

        If Session("TeamID") Is Nothing Then
            Login_Literal.Text = ""
            Login_button.Text = "Team Log in"
        Else
            Using User As New HBSAcodeLibrary.UserData(Session("Email"), Session("Password"))
                Using Team As New TeamData(User.TeamID)

                    Login_Literal.Text = (User.FirstName & " " & User.Surname & " of " & Team.ClubName & " " & Team.Team).Trim & " in " & Team.LeagueName & " " & Team.SectionName
                    Login_button.Text = "Team Log out"
                    Login_button.Visible = True
                    MyProfile_Button.Visible = True

                End Using
            End Using
        End If

        If Session("ClubLoginID") Is Nothing Then
            ClubLogin_Button.Text = "Club Log in"
            ClubLogin_Literal.Text = ""
        Else
            ClubLogin_Button.Text = "Club Log out"
            ClubLogin_Button.Visible = True
            Using ClubUD As New HBSAcodeLibrary.ClubUserData(Session("ClubLoginID"))
                ClubLogin_Literal.Text = ClubUD.FirstName & " " & ClubUD.Surname & " of " & ClubUD.ClubName
            End Using
        End If

        'set up side adverts
        If Session("NoAdverts") Is Nothing OrElse Session("NoAdverts") < 1 Then
            Dim RandomisedAdverts As HBSAcodeLibrary.Advert.RandomAdverts = HBSAcodeLibrary.Advert.RandomiseAdverts
            Session("NoAdverts") = RandomisedAdverts.NoAdverts
            Session("Advertisers") = RandomisedAdverts.Advertisers
            Session("LastAdvert") = RandomisedAdverts.LastAdvert
            Session("advertCounter") = RandomisedAdverts.advertCounter
        End If

        Dim NoAdverts As Integer = Session("NoAdverts")
        Dim Advertisers As DataTable = Session("Advertisers")
        Dim AdvertNo As Integer = Session("LastAdvert")
        Dim adLink() As HtmlAnchor = {adLink6, adLink2, adLink3, adLink4, adLink5}
        Dim adImg() As HtmlImage = {adImage6, adImage2, adImage3, adImage4, adImage5}

        For ix As Integer = 0 To adLink.GetUpperBound(0)
            AdvertNo += 1
            If AdvertNo = NoAdverts Then
                AdvertNo = 0
            End If
            Using ad As New HBSAcodeLibrary.Advert(Advertisers.Rows(AdvertNo)("Advertiser"))
                adLink(ix).HRef = ad.WebURL
                adImg(ix).Src = "data:image/JPEG;base64," & Convert.ToBase64String(ad.AdvertBinary)
                adImg(ix).Alt = ad.advertiser
                adImg(ix).Attributes.Add("target", "_blank")
            End Using

        Next

        Session("LastAdvert") = AdvertNo

    End Sub

    Protected Sub ClubLogin_Button_Click(sender As Object, e As EventArgs) Handles ClubLogin_Button.Click

        If ClubLogin_Button.Text.ToLower Like "*out*" Then
            Session("ClubLoginID") = Nothing
            ClubLogin_Literal.Text = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
            ClubLogin_Button.Text = "Club Log in"
            Response.Redirect("ClubLogin.aspx")
        Else
            Session("LoginCaller") = Request.Url.ToString
            Response.Redirect("ClubLogin.aspx")
        End If

    End Sub

    Protected Sub Login_button_Click(sender As Object, e As EventArgs) Handles Login_button.Click

        If Login_button.Text.ToLower Like "*out*" Then
            Session("TeamID") = Nothing
            Login_Literal.Text = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
            Login_button.Text = "Team log in"
            MyProfile_Button.Visible = False
            Response.Redirect("Login.aspx")
        Else
            Session("LoginCaller") = Request.Url.ToString
            Response.Redirect("Login.aspx")
        End If

    End Sub

    Protected Sub MyProfile_Button_Click(sender As Object, e As EventArgs) Handles MyProfile_Button.Click
        Response.Redirect("LoginProfile.aspx")
    End Sub

    Protected Sub Contact_Button_Click(sender As Object, e As EventArgs) Handles Contact_Button.Click
        Response.Redirect("contact.aspx")
    End Sub

    Protected Sub SiteMap_Button_Click(sender As Object, e As EventArgs) Handles SiteMap_Button.Click
        Response.Redirect("SiteMap.aspx")
    End Sub

    Protected Sub MatchResult_Button_Click(sender As Object, e As EventArgs) Handles MatchResult_Button.Click
        Response.Redirect("MatchResult.aspx")
    End Sub

    Protected Sub EntryForm_Button_Click(sender As Object, e As EventArgs) Handles EntryForm_Button.Click
        Response.Redirect("EntryForm.aspx")
    End Sub

    Protected Sub Admin_Button_Click(sender As Object, e As EventArgs) Handles Admin_Button.Click

        If Not Session("adminDetails") Is Nothing AndAlso Session("adminDetails").Rows.count > 0 Then

            If Not Session("Caller") Is Nothing Then
                Response.Redirect(Session("Caller"))
            Else
                Response.Redirect("admin/adminHome.aspx")
            End If

        End If

    End Sub

    Protected Sub Fines_Button_Click(sender As Object, e As EventArgs) Handles Fines_Button.Click
        Response.Redirect("Fines.aspx")
    End Sub

    Protected Sub Covid_19_Compliance_Button_Click(sender As Object, e As EventArgs) Handles Covid_19_Compliance_Button.Click
        Response.Redirect("Covid-19-Compliance.aspx")
    End Sub

    'Protected Sub AGM_Vote_Button_Click(sender As Object, e As EventArgs) Handles AGM_Vote_Button.Click
    '    Response.Redirect("AGM_Vote.aspx")
    'End Sub
End Class


