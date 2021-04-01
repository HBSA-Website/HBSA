Public Class EntryFormsDownload
    Inherits System.Web.UI.Page

    Protected Sub Download_Button_Click(sender As Object, e As EventArgs) _
            Handles DownloadOpen_Button.Click, DownloadVets_Button.Click, DownloadBilliards_Button.Click,
                    DownloadSnookerComps_Button.Click, DownLoadVetsComps_Button.Click, DownLoadBilliardsComps_Button.Click


        Dim filename As String = ""

        Select Case DirectCast(sender, Button).ID
            Case "DownloadOpen_Button"
                filename = "Entry Form Snooker.pdf"
            Case "DownloadVets_Button"
                filename = "Entry Form Vets.pdf"
            Case "DownloadBilliards_Button"
                filename = "Entry Form Billiards.pdf"
            Case "DownloadSnookerComps_Button"
                filename = "Competition_Entry_Form_Snooker.pdf"
            Case "DownLoadVetsComps_Button"
                filename = "Competition_Entry_Form_Vets.pdf"
            Case "DownLoadBilliardsComps_Button"
                filename = "Competition_Entry_Form_Billiards.pdf"

        End Select

        Response.ContentType = "application/vnd.pdf"
        Response.AppendHeader("Content-Disposition", "attachment; filename=" & filename)
        Response.TransmitFile(Server.MapPath("Documents/" & filename))
        Response.End()

    End Sub

    Protected Sub Type_RadioButtonList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Type_RadioButtonList.SelectedIndexChanged

        Leagues_Panel.Visible = Type_RadioButtonList.Items(0).Selected
        Competitions_Panel.Visible = Not Leagues_Panel.Visible

    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Not IsPostBack Then

            With Type_RadioButtonList

                If HBSAcodeLibrary.HBSA_Configuration.AllowCompetitionsEntryForms AndAlso HBSAcodeLibrary.HBSA_Configuration.CloseSeason Then
                    ChooserTable.Visible = True
                Else
                    .Enabled = False
                    ChooserTable.Visible = False
                    If HBSAcodeLibrary.HBSA_Configuration.CloseSeason Then
                        .Items(0).Selected = True
                    End If
                    If HBSAcodeLibrary.HBSA_Configuration.AllowCompetitionsEntryForms Then
                        .Items(1).Selected = True
                    End If

                    Type_RadioButtonList_SelectedIndexChanged(sender, e)

                End If


            End With

        End If

    End Sub
End Class