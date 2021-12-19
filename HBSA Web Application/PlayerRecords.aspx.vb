Public Class PlayerRecords
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            populateLeagues()

        End If

    End Sub

    Protected Sub PopulateLeagues()

        PlayerRecords_GridView.Visible = False

        Using leaguesList As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues

            With League_DropDownList
                .Items.Clear()
                .Visible = True

                .DataSource = leaguesList
                .DataTextField = "League Name"
                .DataValueField = "ID"
                .DataBind()

                If leaguesList.Rows.Count > 1 Then
                    .Items.Insert(0, New ListItem("**Any League**", 0))
                End If

                .Enabled = True
                .SelectedIndex = 0
                League_DropDownList_SelectedIndexChanged(New Object, New System.EventArgs)

            End With

        End Using

    End Sub

    Protected Sub League_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles League_DropDownList.SelectedIndexChanged

        PlayerRecords_GridView.Visible = False

        If League_DropDownList.SelectedValue.StartsWith("**") Then
            Season_DropDownList.Items.Clear()

        Else

            Using Seasons As DataTable = HBSAcodeLibrary.PlayerData.GetPlayerRecordsSeasons(League_DropDownList.SelectedValue)

                With Season_DropDownList
                    .Items.Clear()
                    .Items.Add(New ListItem("All Seasons", 0))
                    For Each row As DataRow In Seasons.Rows
                        .Items.Add(New ListItem(row!Season - 1 & "-" & row!Season, row!Season))
                    Next
                End With

            End Using

        End If

    End Sub

    Protected Sub GetRecords_Button_Click(sender As Object, e As EventArgs) Handles GetRecords_Button.Click

        If League_DropDownList.SelectedIndex < 0 Then

            Error_Literal.Text = "Please select a league"

        Else

            Error_Literal.Text = ""

            Using playerRecords As DataTable = HBSAcodeLibrary.PlayerData.GetPlayerRecords(
                                                             League_DropDownList.SelectedValue,
                                                             Season_DropDownList.SelectedValue,
                                                             Name_TextBox.Text.Trim)
                Session("Player_Records") = playerRecords

                PlayerRecords_GridView.DataSource = playerRecords
                PlayerRecords_GridView.DataBind()
                PlayerRecords_GridView.Visible = True

                Download_Button.Visible = (Not playerRecords Is Nothing AndAlso playerRecords.Rows.Count > 0)

            End Using

        End If

    End Sub

    Private Sub PlayerRecords_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles PlayerRecords_GridView.RowDataBound

        With e.Row
            If .RowType = DataControlRowType.DataRow Then

                .Cells(0).HorizontalAlign = HorizontalAlign.Left
                .Cells(1).HorizontalAlign = HorizontalAlign.Left
                .Cells(2).HorizontalAlign = HorizontalAlign.Left
                .Cells(3).HorizontalAlign = HorizontalAlign.Center
                .Cells(4).HorizontalAlign = HorizontalAlign.Center
                .Cells(5).HorizontalAlign = HorizontalAlign.Center
                .Cells(6).HorizontalAlign = HorizontalAlign.Center
                .Cells(7).HorizontalAlign = HorizontalAlign.Left
                .Cells(8).HorizontalAlign = HorizontalAlign.Left

            End If
        End With

    End Sub

    <System.Web.Script.Services.ScriptMethod>
    <System.Web.Services.WebMethod>
    Public Shared Function SuggestPlayers(ByVal prefixText As String, ByVal count As Integer, ByVal contextKey As String) As List(Of String)

        Return HBSAcodeLibrary.PlayerData.GetSuggestedHistoricalPlayers(prefixText, count, CInt(contextKey))

    End Function

#Region "gridview paging"
    Private Sub PlayerRecords_GridView_DataBound(ByVal sender As Object, ByVal e As System.EventArgs) Handles PlayerRecords_GridView.DataBound

        With PlayerRecords_GridView

            'locate the pager controls
            Dim PagerRow As GridViewRow = .TopPagerRow
            SetPagerRow(PagerRow)
            PagerRow = .BottomPagerRow
            SetPagerRow(PagerRow)

            .SelectedIndex = -1
            '            Next_Button.Visible = False

        End With

    End Sub

    Protected Sub SetPagerRow(ByVal PagerRow As GridViewRow)

        If PagerRow Is Nothing Then Return
        Dim PageDD As DropDownList = PagerRow.Cells(0).FindControl("PagerPages_DropDown")
        Dim PageCount As Literal = PagerRow.Cells(0).FindControl("PageCount_Label")

        'set up the pager drop down
        If Not PageDD Is Nothing Then
            PageDD.Items.Clear()
            For ix As Integer = 0 To PlayerRecords_GridView.PageCount - 1
                PageDD.Items.Add((ix + 1).ToString)
            Next
            Try
                PageDD.SelectedIndex = PlayerRecords_GridView.PageIndex
            Catch ex As Exception
            End Try
        End If

        'set the page count
        If Not PageCount Is Nothing Then
            PageCount.Text = " of " & PlayerRecords_GridView.PageCount.ToString
        End If

        'enable appropriate buttons
        Dim FirstCommand As ImageButton = PagerRow.Cells(0).FindControl("PagerFirst_Button")
        Dim PrevCommand As ImageButton = PagerRow.Cells(0).FindControl("PagerPrev_Button")
        Dim NextCommand As ImageButton = PagerRow.Cells(0).FindControl("PagerNext_Button")
        Dim LastCommand As ImageButton = PagerRow.Cells(0).FindControl("PagerLast_Button")
        FirstCommand.Enabled = False
        FirstCommand.ImageUrl = "~/Images/BlueCircle-First-Disabled.png"
        PrevCommand.Enabled = False
        PrevCommand.ImageUrl = "~/Images/BlueCircle-Previous-Disabled.png"
        NextCommand.Enabled = False
        NextCommand.ImageUrl = "~/Images/BlueCircle-Next-Disabled.png"
        LastCommand.Enabled = False
        LastCommand.ImageUrl = "~/Images/BlueCircle-Last-Disabled.png"

        If PlayerRecords_GridView.PageIndex > 0 Then
            FirstCommand.Enabled = True
            FirstCommand.ImageUrl = "~/Images/BlueCircle-First.png"
            PrevCommand.Enabled = True
            PrevCommand.ImageUrl = "~/Images/BlueCircle-Previous.png"
        End If
        If PlayerRecords_GridView.PageIndex < PlayerRecords_GridView.PageCount - 1 Then
            NextCommand.Enabled = True
            NextCommand.ImageUrl = "~/Images/BlueCircle-Next.png"
            LastCommand.Enabled = True
            LastCommand.ImageUrl = "~/Images/BlueCircle-Last.png"
        End If

        Dim RowsPerPageDD As DropDownList = PagerRow.Cells(0).FindControl("RowsPerPage_DropDown")
        With RowsPerPageDD
            .Items.Clear()
            .Items.Add("10")
            .Items.Add("25")
            .Items.Add("50")
            .Items.Add("100")
            .SelectedValue = PlayerRecords_GridView.PageSize
        End With
    End Sub

    Protected Sub PagerDD_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        With PlayerRecords_GridView
            .PageIndex = sender.SelectedIndex
            .DataSource = Session("Player_Records")
            .DataBind()
        End With

    End Sub

    Protected Sub PagerCommand(ByVal sender As Object, ByVal e As CommandEventArgs)

        With PlayerRecords_GridView
            Select Case e.CommandArgument.ToString.ToLower
                Case "first"
                    .PageIndex = 0
                Case "next"
                    .PageIndex += 1
                Case "prev"
                    .PageIndex -= 1
                Case "last"
                    .PageIndex = .PageCount - 1
            End Select

            .DataSource = Session("Player_Records")
            .DataBind()

        End With

    End Sub

    Protected Sub RowsPerPage_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        With PlayerRecords_GridView
            Dim startIndex = .PageSize * .PageIndex

            .PageSize = sender.SelectedValue
            .PageIndex = startIndex / .PageSize

            .DataSource = Session("Player_Records")
            .DataBind()

        End With

    End Sub

    Protected Sub Download_Button_Click(sender As Object, e As EventArgs) Handles Download_Button.Click

        Response.Redirect("CreateAndDownloadFile.aspx?source=Player_Records&fileName=Player Records")

    End Sub
#End Region

End Class