Imports HBSAcodeLibrary

Public Class Clubs
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else
            If Not IsPostBack Then
                populateClubs()
            End If
        End If

    End Sub

    Sub PopulateClubs()

        Using allClubs As DataTable = HBSAcodeLibrary.ClubData.GetAllClubs()

            Session("ClubsData") = allClubs

            With Clubs_GridView
                .DataSource = allClubs
                .DataBind()
            End With

        End Using

    End Sub

    Private Sub Clubs_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Clubs_GridView.RowDataBound

        e.Row.Cells(1).Visible = False

    End Sub

    Private Sub Clubs_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Clubs_GridView.RowDeleting

        SubmitPlayer_Button.Text = "Delete"
        Err_Literal.Text = ""
        SubmitPlayer_Button.Visible = True

        Using Club As New HBSAcodeLibrary.ClubData(Clubs_GridView.Rows(e.RowIndex).Cells(1).Text)

            If Club.Teams.Rows.Count > 0 Then
                Err_Literal.Text = "Cannot remove " & Club.ClubName & " because it has " & Club.Teams.Rows.Count & " teams registered."
            End If
            If Club.Players.Rows.Count > 0 Then
                Err_Literal.Text += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cannot remove " & Club.ClubName & " because it has " & Club.Players.Rows.Count & " players registered."
            End If

            If Err_Literal.Text = "" Then
                FillEditTextBoxes(Club)
                EnableDisableTextBoxes(False)
                Edit_Literal.Text = "Do you really want to remove this club? <br/><br/>click Delete to remove it from the system, or click Cancel."
            Else
                Err_Literal.Text += "<br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To remove this club, remove it's registered players and teams first.<br/><br/>"
                Edit_Literal.Text = ""
                Add_Button.Focus() 'Ensure error msg is visible
                Edit_Panel.Visible = True
                SubmitPlayer_Button.Visible = False
            End If

        End Using

        e.Cancel = True

    End Sub

    Private Sub Clubs_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles Clubs_GridView.RowEditing, Clubs_GridView.RowEditing

        SubmitPlayer_Button.Text = "Save"
        Edit_Literal.Text = "Amend required club details here then click Save to record them in the system, or click Cancel."
        SubmitPlayer_Button.Visible = True
        Err_Literal.Text = ""

        FillEditTextBoxes(New HBSAcodeLibrary.ClubData(Clubs_GridView.Rows(e.NewEditIndex).Cells(1).Text))
        EnableDisableTextBoxes(True)

        e.Cancel = True

    End Sub

    Sub FillEditTextBoxes(Club As HBSAcodeLibrary.ClubData)

        With Club

            ID_TextBox.Text = .ID
            ClubName_TextBox.Text = .ClubName
            Address1_TextBox.Text = .Address1
            Address2_TextBox.Text = .Address2
            PostCode_TextBox.Text = .PostCode
            ContactName_TextBox.Text = .ContactName
            ClubUserEmail_Label.Text = .ClubLoginEMail
            ContactTelephone_TextBox.Text = .ContactTelNo
            ContactMobile_TextBox.Text = .ContactMobNo
            Tables_TextBox.Text = .MatchTables

        End With

        Edit_Panel.Visible = True

    End Sub

    Private Sub Clubs_GridView_Sorting(sender As Object, e As GridViewSortEventArgs) Handles Clubs_GridView.Sorting

        If Not IsNothing(Session("ClubsData")) Then
            Dim OrdersData As DataTable = Session("ClubsData")
            OrdersData.DefaultView.Sort = e.SortExpression & " " & GetSortDirection(e.SortExpression)
            With Clubs_GridView
                .PageIndex = 0
                .DataSource = OrdersData
                .DataBind()
            End With
        End If

    End Sub

    Private Function GetSortDirection(ByVal column As String) As String

        ' By default, set the sort direction to ascending.
        Dim sortDirection = "ASC"

        ' Retrieve the last column that was sorted.
        Dim sortExpression = TryCast(ViewState("SortExpression"), String)

        If sortExpression IsNot Nothing Then
            ' Check if the same column is being sorted.
            ' Otherwise, the default value can be returned.
            If sortExpression = column Then
                Dim lastDirection = TryCast(ViewState("SortDirection"), String)
                If lastDirection IsNot Nothing _
                  AndAlso lastDirection = "ASC" Then

                    sortDirection = "DESC"

                End If
            End If
        End If

        ' Save new values in ViewState.
        ViewState("SortDirection") = sortDirection
        ViewState("SortExpression") = column

        Return sortDirection

    End Function

    Protected Sub Add_Button_Click(sender As Object, e As EventArgs) Handles Add_Button.Click

        ID_TextBox.Text = "-1"
        ClubName_TextBox.Text = ""
        Address1_TextBox.Text = ""
        Address2_TextBox.Text = ""
        PostCode_TextBox.Text = ""
        ContactName_TextBox.Text = ""
        ClubUserEmail_Label.Text = ""
        ContactTelephone_TextBox.Text = ""
        ContactMobile_TextBox.Text = ""
        Tables_TextBox.Text = "1"

        SubmitPlayer_Button.Text = "Add"
        Edit_Literal.Text = "Enter the new club's details here then click Add to record them in the system, or click Cancel."

        EnableDisableTextBoxes(True)
        Edit_Panel.Visible = True

    End Sub

    Sub EnableDisableTextBoxes(enable As Boolean)

        ClubName_TextBox.Enabled = enable
        Address1_TextBox.Enabled = enable
        Address2_TextBox.Enabled = enable
        PostCode_TextBox.Enabled = enable
        ContactName_TextBox.Enabled = enable
        ContactTelephone_TextBox.Enabled = enable
        ContactMobile_TextBox.Enabled = enable
        Tables_TextBox.Enabled = enable

    End Sub

    Protected Sub CancelPlayer_Button_Click(sender As Object, e As EventArgs) Handles CancelPlayer_Button.Click

        Edit_Panel.Visible = False

    End Sub

    Protected Sub SubmitPlayer_Button_Click(sender As Object, e As EventArgs) Handles SubmitPlayer_Button.Click

        Err_Literal.Text = ""

        If SubmitPlayer_Button.Text <> "Delete" Then
            If ClubName_TextBox.Text.Trim = "" Then
                Err_Literal.Text = "Cannot have a club without a name.<br/>"
            End If
        Else
            ClubName_TextBox.Text = ""
        End If
        If ContactTelephone_TextBox.Text.Trim <> "" Then
            Dim FormattedNo As String = SharedRoutines.CheckValidPhoneNoForHuddersfield(ContactTelephone_TextBox.Text)
            If FormattedNo.StartsWith("ERR") Then
                Err_Literal.Text += "Invalid Telephone number.<br/>"
            Else
                ContactTelephone_TextBox.Text = FormattedNo
            End If
        End If
        If ContactMobile_TextBox.Text.Trim <> "" Then
            Dim FormattedNo As String = SharedRoutines.CheckValidPhoneNoForHuddersfield(ContactMobile_TextBox.Text)
            If FormattedNo.StartsWith("ERR") Then
                Err_Literal.Text += "Invalid Mobile telephone number.<br/>"
            Else
                ContactMobile_TextBox.Text = FormattedNo
            End If
        End If
        If SubmitPlayer_Button.Text <> "Delete" Then
            If ContactTelephone_TextBox.Text.Trim = "" AndAlso
           ContactMobile_TextBox.Text.Trim = "" Then
                Err_Literal.Text += "Must have one of Club telephone or a Mobile Phone no.<br/>"
            End If
        End If

        If Err_Literal.Text <> "" Then Exit Sub

        Using Club As New HBSAcodeLibrary.ClubData(CInt(ID_TextBox.Text))
            With Club
                .ID = CInt(ID_TextBox.Text)
                .ClubName = ClubName_TextBox.Text.Trim
                .Address1 = Address1_TextBox.Text.Trim
                .Address2 = Address2_TextBox.Text.Trim
                .PostCode = PostCode_TextBox.Text.Trim
                .ContactName = ContactName_TextBox.Text.Trim
                .ContactTelNo = ContactTelephone_TextBox.Text.Trim
                .ContactMobNo = ContactMobile_TextBox.Text.Trim
                .MatchTables = Tables_TextBox.Text

                Dim action As String = .Merge() ' This will insert/update/delete as required
                If action Is Nothing Then
                    Err_Literal.Text = "Error: Cannot delete/insert this club with ID=" & CInt(ID_TextBox.Text) & "<br/><br/>Please contact support."
                End If

                PopulateClubs()
                Edit_Panel.Visible = False

            End With
        End Using

    End Sub

    Protected Sub Emails_Button_Click(sender As Object, e As EventArgs) Handles Emails_Button.Click

        Emails_Panel.Visible = True
        PopulateLeagues(sender, e)

    End Sub

    Protected Sub Close_Emails_Button_Click(sender As Object, e As EventArgs) Handles Close_Emails_Button.Click
        Emails_Panel.Visible = False
    End Sub

    Sub PopulateLeagues(sender As Object, e As EventArgs)

        Dim Leagues As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues

        With League_DropDownList

            .Items.Clear()
            .DataSource = Leagues
            .DataTextField = "League Name"
            .DataValueField = "ID"
            .DataBind()
            .Items.Insert(0, New ListItem("**All leagues**", "0"))

        End With

        PopulateSections(sender, e)

    End Sub

    Protected Sub League_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles League_DropDownList.SelectedIndexChanged

        PopulateSections(sender, e)

    End Sub
    Sub PopulateSections(sender As Object, e As EventArgs)

        With Section_DropDownList

            .Items.Clear()

            If League_DropDownList.SelectedIndex < 1 Then

                .Visible = False
                sectionCell.Visible = False

            Else

                Dim Sections As DataTable = HBSAcodeLibrary.LeagueData.GetSections(League_DropDownList.SelectedValue)

                If Sections.Rows.Count < 2 Then
                    .Visible = False
                    sectionCell.Visible = False
                Else
                    .DataSource = Sections
                    .DataTextField = "Section Name"
                    .DataValueField = "ID"
                    .DataBind()
                    .Visible = True
                    sectionCell.Visible = True
                End If
            End If

            .Items.Insert(0, New ListItem("**All sections**", "0"))
            .SelectedIndex = 0

        End With

        Section_DropDownList_SelectedIndexChanged(sender, e)

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        Dim Emails As DataRow = HBSAcodeLibrary.ClubData.GetEMailAddresses(League_DropDownList.SelectedValue, Section_DropDownList.SelectedValue)
        Email_Link.NavigateUrl = "mailto:" & Emails.Item(0)
        Emails_TextBox.Text = Emails.Item(1)

    End Sub
End Class