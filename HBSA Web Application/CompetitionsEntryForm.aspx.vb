Imports HBSAcodeLibrary
Public Class CompetitionsEntryForm
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Session("ClubLoginCaller") = Request.Url.AbsolutePath

        If Not IsPostBack Then

            Season_Literal.Text = CStr(Year(Today)) & " - " & CStr(Year(Today) + 1)

            populateClubs()

            Using HeaderText As New ContentData("EntryFormHeader_Competitions")
                Head_Literal.Text = HeaderText.ContentHTML
            End Using

        End If

    End Sub

    Protected Sub PopulateClubs()

        Using clubs As DataTable = EntryFormData.GetClubs()

            With Club_DropDownList
                .Items.Clear()

                .Items.Add(New ListItem("**Select a Club**", "-1"))

                For Each row As DataRow In clubs.Rows
                    .Items.Add(New ListItem(row.Item("Club Name"), row.Item("ClubID")))
                Next

                .Enabled = False
                .Visible = False

                .SelectedIndex = 0

                If Not Session("adminDetails") Is Nothing AndAlso Session("adminDetails").Rows.count > 0 Then
                    'admin user - enable club selection and proceed
                    Club_Selector_Literal.Text += "<span style='color:red;'> You are logged in as an administrator. Select the required club.</span>"
                    Club_DropDownList.Enabled = True
                    Populate_Competitions()
                    CompetitionsPanel.Visible = True
                    .Visible = True
                    .Enabled = True

                ElseIf Not HBSA_Configuration.AllowCompetitionsEntryForms Then
                    'user entry forms disallowed
                    Club_Selector_Literal.Text = "&nbsp;&nbsp;&nbsp;&nbsp;<span style='color:red;'>Entry forms for competitions are not open.<br/><br/>" &
                                                         "&nbsp;&nbsp;&nbsp;&nbsp;Please try later</span>"
                ElseIf IsNothing(Session("ClubLoginID")) Then
                    ' not logged in
                    Club_Selector_Literal.Text = "&nbsp;&nbsp;&nbsp;&nbsp;<span style='color:red;'>You are not logged in.&nbsp;&nbsp;&nbsp;&nbsp;" &
                                                 "<i>(You need to log in as a registered club user (different from the standard login)<i><br/><br/>" &
                                                                                "&nbsp;&nbsp;&nbsp;&nbsp;<a href=""ClubLogin.aspx"" >Log in</a> with the credentials that are registered to your club.</span>"
                Else
                    'we have a logged in user, select & fix the club

                    Using User As New ClubUserData(Session("ClubLoginID"))
                        .SelectedValue = User.ClubID
                        .Visible = True
                        .Enabled = False
                        Club_Selector_Literal.Text = "You are registered to " & .SelectedItem.Text & "."
                        Populate_Competitions()
                        CompetitionsPanel.Visible = True
                        Club_DropDownList_SelectedIndexChanged(New Object, New EventArgs)
                    End Using

                End If

            End With

        End Using

    End Sub

    Protected Sub Club_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Club_DropDownList.SelectedIndexChanged

        ShowState()
        Competitions_GridView.SelectedIndex = -1
        Entrants_GridView.DataSource = Nothing
        Entrants_GridView.DataBind()
        Entrants_DropDownList.Visible = False
        Entrant2_DropDownList.Visible = False

    End Sub

    Sub ShowState()

        Using compEntryForm As New CompetitionEntryFormData(Club_DropDownList.SelectedValue)

            Session("Fixed") = False
            submitEntryForm_Button.Visible = True
            SaveCompetition_Button.Visible = True
            Entrant2_DropDownList.Visible = True
            Entrants_DropDownList.Visible = True
            Entrant2_CheckBox.Visible = True
            Entrants_CheckBox.Visible = True
            SortBy_Literal.Visible = True
            SortBy_DropDownList.Visible = True

            Select Case compEntryForm.State
                Case CompetitionEntryFormData.WIP.NotEntered
                    Club_WIP_Literal.Text = "Select a competition And proceed."
                    compEntryForm.State = CompetitionEntryFormData.WIP.InProgress
                    compEntryForm.MergeClubData()

                Case CompetitionEntryFormData.WIP.InProgress
                    Club_WIP_Literal.Text = "Welcome back, please proceed."

                Case CompetitionEntryFormData.WIP.Submitted
                    Club_WIP_Literal.Text = "This club has already submitted an entry form." &
                                            " However you may make changes but you must SUBMIT it again for it to be effective."
                    If compEntryForm.AmountPaid < compEntryForm.EntryFormFee Then

                        Club_WIP_Literal.Text &= "<br/><br/>The total fee due for this club's entry is <span style='color:red;'>" & Format(compEntryForm.EntryFormFee, "£0.00") & "</span><br/>"
                        If compEntryForm.AmountPaid > 0 Then
                            Club_WIP_Literal.Text &= "The amount already paid is <span style='color:red;'>" & Format(compEntryForm.AmountPaid, "£0.00") & "</span><br/>"
                        End If
                        Club_WIP_Literal.Text &= "<br/>Please send a payment of <span style='color:red;'>" & Format(compEntryForm.EntryFormFee - compEntryForm.AmountPaid, "£0.00") & "</span>" &
                                                " to the League Treasurer or the League Secretary.</font><br/>"
                        Using InfoPage As New ContentData("Payments")
                            Club_WIP_Literal.Text = InfoPage.ContentHTML
                        End Using

                        '" < font size='3'>or click the Pay Now button:</font>" &
                        '"You will be taken to a PayPal page where you can pay using your PayPal account <b>OR</b>" &
                        '" a debit/credit card. <span style='color:red;'>To use a debit or credit card Click this button then use the <b>'Check out as a Guest'</b> or the <b>'Pay by Debit or Credit Card' button</b> option on the PayPal Login Page.</span>"
                        Session("payment_amt") = compEntryForm.EntryFormFee - compEntryForm.AmountPaid
                        Session("ClubID") = Club_DropDownList.SelectedValue
                        Session("Description") = "Competition Entry Fee for " & Club_DropDownList.SelectedItem.Text
                        'PayPal_Button0.Visible = True
                        'Else
                        'PayPal_Button0.Visible = False
                    End If

                Case CompetitionEntryFormData.WIP.Fixed
                    Club_WIP_Literal.Text = "This club has already submitted an entry form and it has been finalised." &
                                                  " To make changes contact the Competitions secretary (<a href='Contact.aspx' >via the contact page</a>)."
                    submitEntryForm_Button.Visible = False
                    SaveCompetition_Button.Visible = False
                    Entrant2_DropDownList.Visible = False
                    Entrants_DropDownList.Visible = False
                    Entrant2_CheckBox.Visible = False
                    Entrants_CheckBox.Visible = False
                    SortBy_Literal.Visible = False
                    SortBy_DropDownList.Visible = False
                    Session("Fixed") = True

                Case Else
                    Club_WIP_Literal.Text = "This club has an invalid competitions entry form state." &
                                                  " Please contact the us (<a href='Contact.aspx' >via the contact page</a>)."
                    submitEntryForm_Button.Visible = False
                    SaveCompetition_Button.Visible = False
                    Entrant2_DropDownList.Visible = False
                    Entrants_DropDownList.Visible = False
                    Entrant2_CheckBox.Visible = False
                    Entrants_CheckBox.Visible = False
                    SortBy_Literal.Visible = False
                    SortBy_DropDownList.Visible = False
                    Session("Fixed") = True


            End Select
        End Using

    End Sub

    Sub Populate_Competitions()

        Using competitions As DataTable = CompetitionData.GetCompetitions()

            With Competitions_GridView
                .DataSource = competitions
                .DataBind()
            End With

        End Using

        divHCapMsg.Style("display") = "none"

    End Sub

    Private Sub Entrants_CheckBox_CheckedChanged(sender As Object, e As EventArgs) Handles Entrants_CheckBox.CheckedChanged, Entrant2_CheckBox.CheckedChanged

        Dim CompetitionID As Integer = Competitions_GridView.SelectedRow.Cells(1).Text

        Using comp As New CompetitionData(CompetitionID)
            'preserve selections
            Dim value1 = Entrants_DropDownList.SelectedValue
            Dim value2 = Entrant2_DropDownList.SelectedValue

            Populate_Entrants(comp)

            'restore selections
            Try
                Entrants_DropDownList.SelectedValue = value1
            Catch ex As Exception
                Entrants_DropDownList.SelectedIndex = 0
            End Try
            Try
                Entrant2_DropDownList.SelectedValue = value2
            Catch ex As Exception
                Entrant2_DropDownList.SelectedIndex = 0
            End Try

        End Using

    End Sub

    Private Sub Competitions_GridView_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Competitions_GridView.SelectedIndexChanged

        Entrants_CheckBox_CheckedChanged(sender, e)

        Dim CompetitionID As Integer = Competitions_GridView.SelectedRow.Cells(1).Text
        Using comp As New CompetitionData(CompetitionID)
            Comment_Literal.Text = comp.Comment.Replace(vbCrLf, "<br/>")
            Fee_Literal.Text = " Entry Fee: " & Format(comp.EntryFee, "£0.00")
        End Using

        divHCapMsg.Style("display") = "none"

    End Sub

    Sub Populate_Entrants(comp As CompetitionData)

        NonClub_Literal.Visible = (comp.competitionType <> CompetitionType.Teams)
        Dim ClubID As Integer = Club_DropDownList.SelectedValue
        SaveCompetition_Literal.Text = ""
        'Submit_Literal.Text = ""

        With Entrants_DropDownList
            .Items.Clear()
            .Items.Add(New ListItem("**Select an entrant**", -1))
            Using entrants As DataSet = comp.PotentialEntrants(ClubID, Entrants_CheckBox.Checked, SortBy_DropDownList.SelectedValue)

                Dim PotentialEntrants As DataTable = entrants.Tables(0)
                For Each row As DataRow In PotentialEntrants.Rows
                    .Items.Add(New ListItem(row.Item("Entrant"), row.Item("ID")))
                Next

                With Entrants_GridView
                    .DataSource = entrants.Tables(1)
                    .DataBind()
                End With

            End Using

            Entrants_DropDownList.Visible = True And Not Session("Fixed")
            Entrants_CheckBox.Visible = True And Not Session("Fixed")
            SortBy_Literal.Visible = (comp.competitionType <> CompetitionType.Teams) And Not Session("Fixed")
            SortBy_DropDownList.Visible = (comp.competitionType <> CompetitionType.Teams) And Not Session("Fixed")

        End With

        If comp.competitionType = CompetitionType.Pairs Then 'pairs

            With Entrant2_DropDownList
                .Items.Clear()
                .Items.Add(New ListItem("**Select an entrant**", -1))
                Using entrants As DataSet = comp.PotentialEntrants(ClubID, Entrant2_CheckBox.Checked, SortBy_DropDownList.SelectedValue)
                    Dim PotentialEntrants As DataTable = entrants.Tables(0)
                    For Each row As DataRow In PotentialEntrants.Rows
                        .Items.Add(New ListItem(row.Item("Entrant"), row.Item("ID")))
                    Next
                End Using
            End With

            Entrant2_DropDownList.Visible = True And Not Session("Fixed")
            Entrant2_CheckBox.Visible = True And Not Session("Fixed")
        Else
            Entrant2_DropDownList.Visible = False
            Entrant2_CheckBox.Visible = False

        End If

    End Sub

    Private Sub Entrants_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) _
            Handles Entrants_DropDownList.SelectedIndexChanged,
                    Entrant2_DropDownList.SelectedIndexChanged

        divHCapMsg.Style("display") = "none"

        If Entrants_DropDownList.SelectedValue = Entrant2_DropDownList.SelectedValue Then
            notQualified_Literal.Text = "Cannot have the same player selected in pairs"
            divHCapMsg.Style("display") = "block"
            Exit Sub
        End If

        Dim CompetitionID As Integer = Competitions_GridView.SelectedRow.Cells(1).Text

        Using comp As New CompetitionData(CompetitionID)

            If Entrants_DropDownList.SelectedIndex < 1 Then
                Exit Sub
            End If

            If Not comp.IsQualified(Entrants_DropDownList.SelectedValue) Then
                ShowQualificationFailure(Entrants_DropDownList.SelectedItem.Text, comp.LeagueID)
                Exit Sub
            End If

            If comp.competitionType = CompetitionType.Pairs Then 'pairs competition - needs two entrants

                If Entrant2_DropDownList.SelectedIndex < 1 Then Exit Sub 'wait until both entrants have been selected

                If Entrants_DropDownList.SelectedValue = Entrant2_DropDownList.SelectedValue Then
                    notQualified_Literal.Text = "Cannot have the same player selected twice in pairs"
                    divHCapMsg.Style("display") = "block"
                    Exit Sub
                End If

                If Not comp.IsQualified(Entrant2_DropDownList.SelectedValue) Then
                    ShowQualificationFailure(Entrant2_DropDownList.SelectedItem.Text, comp.LeagueID)
                    Exit Sub
                End If

                comp.CompetitionEntryFormMerge(Club_DropDownList.SelectedValue, Entrants_DropDownList.SelectedValue, Entrant2_DropDownList.SelectedValue)
                Populate_Entrants(comp)

            Else

                comp.CompetitionEntryFormMerge(Club_DropDownList.SelectedValue, Entrants_DropDownList.SelectedValue)
                Populate_Entrants(comp)

            End If

        End Using

    End Sub
    Private Sub ShowQualificationFailure(Player As String, LeagueID As Integer)

        Using cfg As New HBSA_Configuration()
            Using league As New LeagueData(LeagueID)

                notQualified_Literal.Text = "<b>" & Player & " does not qualify for entry to this HBSA competition.</b><br /><br/>" &
                                        "In order to qualify for an this competition a player must have played at least " &
                                        cfg.Value("EntryFormNoQualifyingMatches") &
                                        " matches in the " & league.LeagueName & " league since the start of last season, " &
                                         " or for a newly registered player, have played " &
                                        cfg.Value("EntryFormNoQualifyingMatchesNewReg") &
                                         " matches since the start of this season.<br /><br />" &
                                         "If you wish To make a special application please <a href='Contact.aspx' target='_blank'> " &
                                         "contact the Competitions Secretary.</a>"
            End Using
        End Using

        divHCapMsg.Style("display") = "block"

    End Sub
    Private Sub Entrants_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Entrants_GridView.RowDataBound

        With e.Row

            If .Cells.Count > 2 Then

                .Cells(1).Visible = False

                If .RowType = DataControlRowType.DataRow Then

                    Dim dr As DataRow = .DataItem.row
                    Dim TelNotxtBox As TextBox = .FindControl("TelNo_TextBox")
                    TelNotxtBox.Text = If(IsDBNull(dr("TelNo")), "", dr("TelNo"))
                    Dim EmailtxtBox As TextBox = .FindControl("Email_TextBox")
                    EmailtxtBox.Text = If(IsDBNull(dr("Email")), "", dr("Email"))
                End If
            End If

        End With

    End Sub

    Private Sub Entrants_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Entrants_GridView.RowDeleting

        Dim CompetitionID As Integer = Competitions_GridView.SelectedRow.Cells(1).Text
        Using comp As New CompetitionData(CompetitionID)

            Dim EntrantID As Integer = Entrants_GridView.Rows(e.RowIndex).Cells(1).Text
            comp.CompetitionEntryFormMerge(Club_DropDownList.SelectedValue, EntrantID, -1) 'Entrant2 as -1 implies delete
            Populate_Entrants(comp)

        End Using


    End Sub
    Function CheckCompetitionEntry() As String

        Dim TelNo As String
        Dim Email As String

        Dim returnMsg As String = ""

        'Check that each entrant in the current Entrants_GridView has the required valid data
        For Each Entrant As GridViewRow In Entrants_GridView.Rows

            TelNo = DirectCast(Entrant.FindControl("TelNo_TextBox"), TextBox).Text.Trim
            Email = DirectCast(Entrant.FindControl("Email_TextBox"), TextBox).Text.Trim

            Dim errMsg As String = ""
            If Not Email = "" AndAlso Not Emailer.IsValidEmailAddress(Email) Then
                errMsg += "Invalid Email address. "
            End If
            If Not TelNo = "" Then
                If SharedRoutines.CheckValidPhoneNoForHuddersfield(TelNo).StartsWith("ERR") Then
                    errMsg += "Invalid tel no. "
                End If
            End If
            If TelNo = "" And Email = "" Then
                errMsg += "Must have at least a telephone number or an email address. "
            End If
            If errMsg <> "" Then
                returnMsg += Entrant.Cells(2).Text & ": " & "<span style='color:red'>" & errMsg & "</span><br/>"
            End If
        Next

        Return returnMsg

    End Function
    Public Sub SaveCompetitionEntry(CompetitionID As Integer)

        'Save the current competition
        Dim TelNo As String
        Dim Email As String
        Dim EntrantID As Integer

        For Each Entrant As GridViewRow In Entrants_GridView.Rows

            EntrantID = Entrant.Cells(1).Text
            TelNo = SharedRoutines.CheckValidPhoneNoForHuddersfield(
                            DirectCast(Entrant.FindControl("TelNo_TextBox"), TextBox).Text.Trim)
            Email = DirectCast(Entrant.FindControl("Email_TextBox"), TextBox).Text.Trim

            Using comp As New CompetitionData(CompetitionID)

                If comp.competitionType = CompetitionType.Teams Then 'update team contact
                    Using team As New TeamData(EntrantID)
                        team.eMail = Email
                        team.TelNo = TelNo
                        team.Merge()
                    End Using
                Else 'update player
                    Using player As New PlayerData(EntrantID)
                        player.eMail = Email
                        player.TelNo = TelNo
                        player.Merge(Session("user"))
                    End Using
                End If

            End Using

        Next

    End Sub

    Protected Sub SaveCompetition_Button_Click(sender As Object, e As EventArgs) Handles SaveCompetition_Button.Click

        SaveCompetition_Literal.Text = CheckCompetitionEntry()
        If SaveCompetition_Literal.Text = "" Then
            SaveCompetitionEntry(Competitions_GridView.SelectedRow.Cells(1).Text)
            Using comp As New CompetitionData(Competitions_GridView.SelectedRow.Cells(1).Text)
                Populate_Entrants(comp)
            End Using
            SaveCompetition_Literal.Text = "Saved.  Select a competition, or stop for now (your data so far is saved) or submit your entry. "
        End If

    End Sub

    Protected Sub Show_Button_Click(sender As Object, e As EventArgs) Handles Show_Button.Click

        Response.Redirect("EntryFormShowDetail.aspx?ClubID=" & Club_DropDownList.SelectedValue & "&Form=Competition")

    End Sub

    Private Sub Competitions_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Competitions_GridView.RowDataBound

        e.Row.Cells(1).Visible = False

    End Sub

    Protected Sub EntryForm_Submit_Button_Click(sender As Object, e As EventArgs) Handles submitEntryForm_Button.Click

        If Not privacyCheckBox.Checked Then
            Submit_Literal.Text = "<br /><span style='font-size:larger;font-weight:bold;'>ERROR: You must tick the consent box above to indicate your consent to our " &
                                  "<a href='InfoPage.aspx?Subject=Privacy Statement&Title=Privacy Policy' target='_blank'>privacy policy</a> in order to submit an entry form.</span>"
            Exit Sub
        End If

        Dim _ClubID As Integer = Club_DropDownList.SelectedValue
        Submit_Literal.Text = ""
        'PayPal_Button.Visible = False
        Const indent = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"

        Using compEntryForm As New CompetitionEntryFormData(Club_DropDownList.SelectedValue)

            'check each entrant has correct data: cycle each competition and mimic save
            For Each Competition As GridViewRow In Competitions_GridView.Rows

                'create entrants gridview
                Dim CompetitionID As Integer = Competition.Cells(1).Text
                Using comp As New CompetitionData(CompetitionID)
                    Populate_Entrants(comp)

                    'check entrants and ensure the comp entrants are saved
                    Dim err As String = CheckCompetitionEntry()
                    If err <> "" Then
                        Submit_Literal.Text += comp.Name + "<br/>" + indent +
                            err.Replace("<br/>", "<br/>" + indent)
                    Else
                        SaveCompetitionEntry(CompetitionID)
                    End If

                End Using
                If Submit_Literal.Text.EndsWith("<br/>" + indent) Then
                    Submit_Literal.Text = Submit_Literal.Text.Substring(0, Submit_Literal.Text.Length - indent.Length)
                End If

            Next

            If Submit_Literal.Text = "" Then

                'if no errors update WIP & PrivacyAccepted
                Try
                    compEntryForm.State = CompetitionEntryFormData.WIP.Submitted
                    compEntryForm.privacyAccepted = privacyCheckBox.Checked
                    compEntryForm.MergeClubData()

                Catch ex As Exception

                    Submit_Literal.Text = "<br /><span style='font-size:larger;font-weight:bold;'>There was an error submitting the entry form." & "<br/><a href='contact.aspx'>Please contact us and supply the following.</a></span><br/><br/>" & ex.ToString

                End Try

                'send email alert
                Using cfg As New HBSA_Configuration

                    Dim ccAddress As String = New ClubData(Club_DropDownList.SelectedValue).ClubLoginEMail

                    If Session("ClubUserEmail") Like "*@*" Then
                        ccAddress += ";" & Session("ClubUserEmail")
                    End If
                    Dim toAddress As String = cfg.Value("TreasurerEmail") & ";" & cfg.Value("CompetitionsSecretaryEmail")
                    Dim subject As String = "Web site competitions entry form alert (" & compEntryForm.ClubName & ")"
                    Dim body As String
                    Using InfoPage As New ContentData("Payments")
                        body = "A competitions entry form has been submitted by " & compEntryForm.ClubName & ". Payment due Is: " & Format(compEntryForm.EntryFormFee - compEntryForm.AmountPaid, "£0.00") &
                               "<br/><br/>Details can be found by logging on with your Club Login details, then select Competitions >> On line entry forms." &
                               "<br/><br/>" & InfoPage.ContentHTML
                    End Using

                    Try
                        Emailer.Send_eMail(toAddress, subject, body, ccAddress)

                        Session("payment_amt") = compEntryForm.EntryFormFee - compEntryForm.AmountPaid
                        Session("ClubID") = Club_DropDownList.SelectedValue
                        Session("Description") = "Competition Entry Fee for " & Club_DropDownList.SelectedItem.Text

                        Submit_Literal.Text = "<span style='color:darkblue;'><br/>This entry form has been submitted And will be passed to the HBSA.<br/>"
                        If compEntryForm.AmountPaid < compEntryForm.EntryFormFee Then
                            Submit_Literal.Text &= "The total fee due for this club's entry is <span style='color:red;'>" & Format(compEntryForm.EntryFormFee, "£0.00") & "</span><br/>"
                            If compEntryForm.AmountPaid > 0 Then
                                Submit_Literal.Text &= "The amount already paid is <span style='color:red;'>" & Format(compEntryForm.AmountPaid, "£0.00") & "</span><br/>"
                            End If
                            Submit_Literal.Text &= "<br/>Please send a payment of <span style='color:red;'>" & Format(compEntryForm.EntryFormFee - compEntryForm.AmountPaid, "£0.00") & "</span>" &
                                                " to the League Treasurer or the Competitions Secretary. <a href=""InfoPage.aspx?Subject=Officials&Title=Officials"">(see H.B.& S. Association >> Officials for address etc.)</a></span><br/>" '&

                            Using InfoPage As New ContentData("Payments")
                                Submit_Literal.Text &= InfoPage.ContentHTML
                            End Using

                            '" <span style="font-size:3'>or click the Pay Now button:</span>" &
                            '"You will be taken to a PayPal page where you can pay using your PayPal account <b>OR</b>" &
                            '" a debit/credit card. <span style='color:navy;'>To use a debit or credit card Click this button then use the <b>'Check out as a Guest'</b> or the <b>'Pay by Debit or Credit Card'</b> option on the PayPal Login Page.</span>"

                            'PayPal_Button.Visible = True

                        Else
                            Submit_Literal.Text += "There is nothing outstanding to pay."
                        End If

                    Catch eMex As Exception
                        Submit_Literal.Text = "There was an error sending the confirmation email, but the entry form has been submitted OK: " & "<br/><a href='contact.aspx'>Please contact us and supply the following.</a><br/><br/>" & eMex.ToString
                    End Try

                End Using

            Else
                Submit_Literal.Text = "<span style='color:red;'>ERRORS:</span><br/>" + Submit_Literal.Text + "<span style='color:red;'>Please correct the errors and try again.</span>"
            End If

        End Using


    End Sub

    Protected Sub SortBy_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles SortBy_DropDownList.SelectedIndexChanged

        'repopulate the entrants lists as the sort order has changed
        Entrants_CheckBox_CheckedChanged(sender, e)

    End Sub

    'Protected Sub PayPal_Button_Click(sender As Object, e As ImageClickEventArgs) Handles PayPal_Button.Click, PayPal_Button0.Click

    '    'Request to pay via PayPal
    '    Session("PaymentID") = dbClasses.PayPalCredentials.nextPaymentID(Club_DropDownList.SelectedValue)    'get next paymentID
    '    Session("PaymentReason") = "Competition Entry Fee"
    '    Session("FineID") = 0
    '    Response.Redirect("PayPalCheckOut.aspx")

    'End Sub
End Class