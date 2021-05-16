Public Class EntryFormsDownload1
    Inherits System.Web.UI.Page
    Private Sub EntryFormType_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles EntryFormType_DropDownList.SelectedIndexChanged

        Select Case EntryFormType_DropDownList.SelectedValue
            Case 0
                Selection_Panel.Visible = True
                Leagues_Panel.Visible = False
                Competitions_Panel.Visible = False
            Case 1
                Selection_Panel.Visible = False
                Leagues_Panel.Visible = True
                Competitions_Panel.Visible = False
            Case 2
                Selection_Panel.Visible = False
                Leagues_Panel.Visible = False
                Competitions_Panel.Visible = True
        End Select

    End Sub
    'Protected Sub Download_Button_Click(sender As Object, e As EventArgs) _
    '        Handles DownloadOpen_Button.Click, DownloadVets_Button.Click, DownloadBilliards_Button.Click,
    '                DownloadSnookerComps_Button.Click, DownLoadVetsComps_Button.Click, DownLoadBilliardsComps_Button.Click

    '    Dim filename As String = ""

    '    Select Case DirectCast(sender, Button).ID
    '        Case "DownloadOpen_Button"
    '            filename = "Entry Form Snooker.pdf"
    '        Case "DownloadVets_Button"
    '            filename = "Entry Form Vets.pdf"
    '        Case "DownloadBilliards_Button"
    '            filename = "Entry Form Billiards.pdf"
    '        Case "DownloadSnookerComps_Button"
    '            filename = "Competition_Entry_Form_Snooker.pdf"
    '        Case "DownLoadVetsComps_Button"
    '            filename = "Competition_Entry_Form_Vets.pdf"
    '        Case "DownLoadBilliardsComps_Button"
    '            filename = "Competition_Entry_Form_Billiards.pdf"

    '    End Select

    '    Response.ContentType = "application/vnd.pdf"
    '    Response.AppendHeader("Content-Disposition", "attachment; filename=" & filename)
    '    Response.TransmitFile(Server.MapPath("../Documents/" & filename))
    '    Response.End()

    'End Sub
End Class