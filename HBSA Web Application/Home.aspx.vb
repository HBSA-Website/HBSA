Partial Class Home
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If HBSAcodeLibrary.HBSA_Configuration.CloseSeason Then

            HandicapChanges_Literal.Visible = False
            HandicapChanges_GridView.Visible = False
            NewRegistrations_Literal.Visible = False
            NewRegistrations_GridView.Visible = False

        Else

            Dim HandicapChanges As DataTable = HBSAcodeLibrary.SharedRoutines.HandicapChangesReport
            If HandicapChanges.Rows.Count > 0 Then
                With HandicapChanges_GridView
                    .DataSource = HandicapChanges
                    .DataBind()
                End With
                HandicapChangesDiv.Visible = True
                'NewHandicapsTitleDiv.Visible = True
            Else
                HandicapChangesDiv.Visible = False
                'NewHandicapsTitleDiv.Visible = False
            End If

            NewRegistrationsDiv.Visible = False

            Using FixturesData As New HBSAcodeLibrary.FixturesData(1)

                If Not FixturesData.Dates Is Nothing AndAlso
                   FixturesData.Dates.Rows.Count > 0 AndAlso
                   HBSAcodeLibrary.Utilities.UKDateTimeNow() > DateAdd(DateInterval.Day, -7, FixturesData.Dates.Rows(0).Item("FixtureDate")) Then
                    'i.e. don't report this until a week before season's first match

                    Dim NewRegistrations As DataTable = HBSAcodeLibrary.SharedRoutines.NewRegistrationsReport
                    If NewRegistrations.Rows.Count > 0 Then
                        With NewRegistrations_GridView
                            .DataSource = NewRegistrations
                            .DataBind()
                        End With
                        NewRegistrationsDiv.Visible = True
                    End If

                End If

            End Using

        End If

        Dim HomePageArticles As DataTable = HBSAcodeLibrary.HomeContent.HomePageArticles
        HomePage_Literal.Text = ""

        Dim rowNo As Integer = 0
        For Each ArticleRow As DataRow In HomePageArticles.Rows

            Using Article As New HBSAcodeLibrary.HomeContent(ArticleRow!ID)

                rowNo += 1
                HomePage_Literal.Text += "<div id='TitleDiv" & Format(rowNo, "000") &
                                            "' style='width: 100%; font-size: 14px; font-weight: bold; background-color: #CCFFCC; border-style: solid; border-width: 1px;' " &
                                            "onclick='swapDiv(""ArticleDiv" & Format(rowNo, "000") & """,""TitleImg" & Format(rowNo, "000") & """);' onmouseover='this.style.cursor=""pointer"";'>" &
                                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img id = 'TitleImg" & Format(rowNo, "000") & "' height=""24"" src='Images/PointDownSmall.bmp' alt='Expand'/>" &
                                            "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & Format(Article.dateTimeLodged, "dd MMM yyyy") & "&nbsp;&nbsp;&nbsp;&nbsp;" & vbCrLf & Article.title & "</div>"
                HomePage_Literal.Text += "<div id=""ArticleDiv" & Format(rowNo, "000") & """ style=""display:none; border:1px solid black;padding:5px;"">" & Article.articleHTML & "</div><hr />" & vbCrLf

            End Using

        Next

    End Sub
End Class
