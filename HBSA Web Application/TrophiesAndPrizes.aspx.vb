Public Class TrophiesAndPrizes
    Inherits System.Web.UI.Page

    'Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    '    If Not IsPostBack Then
    '        populateReports(sender, e)
    '    Else
    '        'WinnerCell_TextBox.Text = ""
    '    End If

    'End Sub

    'Sub PopulateReports(ByVal sender As Object, ByVal e As System.EventArgs)

    '    With Report_DropDownList

    '        Dim AwardTypes As DataTable = HBSAcodeLibrary.AwardsTemplate.AwardTypes

    '        .Items.Clear()

    '        .DataSource = AwardTypes
    '        .DataTextField = "Description"
    '        .DataValueField = "AwardType"
    '        .DataBind()

    '        .Items.Insert(0, New ListItem("All awards", "0"))

    '        .SelectedIndex = 0
    '        Report_DropDownList_SelectedIndexChanged(sender, e)

    '    End With

    'End Sub

    'Private Sub Report_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) _
    '        Handles Report_DropDownList.SelectedIndexChanged

    '    Status_Literal.Text = ""

    '    With Awards_GridView
    '        Using _Awards As New HBSAcodeLibrary.AwardsObj

    '            Dim AwardsReport As DataTable = _Awards.Report(Report_DropDownList.SelectedValue)

    '            .DataSource = AwardsReport
    '            .DataBind()

    '            ExportCells.Visible = AwardsReport.Rows.Count > 0

    '            Session("TrophiesAndPrizes") = AwardsReport

    '        End Using

    '    End With

    'End Sub

    'Private Sub Awards_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Awards_GridView.RowDataBound

    '    For ix = 5 To e.Row.Cells.Count - 1
    '        e.Row.Cells(ix).Visible = False
    '    Next

    'End Sub

End Class