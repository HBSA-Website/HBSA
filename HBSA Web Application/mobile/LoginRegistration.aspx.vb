Imports HBSAcodeLibrary

Public Class LoginRegistration1
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Me.IsPostBack Then
            passwordTextBox.Attributes("value") = HiddenPassword.Value
            confirmPasswordTextBox.Attributes("value") = HiddenConfirm.Value
        Else

            If Request.Params("Profile") = 1 Then
                profiling.Value = True
                userIDhidden.Value = Request.Params("UserID")
                Dim teamUser As DataRow = HBSAcodeLibrary.UserData.LoginData(userIDhidden.Value)
                EmailTextBox.Text = teamUser!EmailAddress
                EmailTextBox.Enabled = False
                firstNameTextbox.Text = teamUser!FirstName
                surnameTextBox.Text = teamUser!Surname
                telephoneTextBox.Text = teamUser!Telephone
                deleteButton.Visible = True
            Else
                profiling.Value = False
                EmailTextBox.Text = ""
                EmailTextBox.Enabled = True
                firstNameTextbox.Text = ""
                surnameTextBox.Text = ""
                telephoneTextBox.Text = ""
                deleteButton.Visible = False
            End If

            PopulateLeagues(sender, e)

        End If

    End Sub

    Protected Sub PopulateLeagues(ByVal sender As Object, ByVal e As System.EventArgs)

        leagueDropDownList.Items.Clear()
        sectionDropDownList.Items.Clear()
        clubsDropDownList.Items.Clear()
        teamDropDownList.Items.Clear()

        Dim Leagues As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues

        With leagueDropDownList

            Dim ix As Integer = 0
            Dim userRow As DataRow
            If profiling.Value = True Then
                userRow = HBSAcodeLibrary.UserData.LoginData(userIDhidden.Value)
            Else
                userRow = Nothing
            End If

            .Items.Add(New ListItem("**Select a League**", "-1"))
            For Each league As DataRow In Leagues.Rows
                .Items.Add(New ListItem(league.Item("League Name"), league.Item("ID")))
                If profiling.Value = True Then
                    If league.Item("League Name") = userRow.Item("League") Then
                        ix = .Items.Count - 1
                    End If
                End If

            Next

            If profiling.Value = True Then
                .SelectedIndex = ix
                LeagueDropDownList_SelectedIndexChanged(sender, e)
                .Enabled = False
            Else
                .SelectedIndex = 0
                .Enabled = True
            End If

        End With

    End Sub
    Protected Sub LeagueDropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles leagueDropDownList.SelectedIndexChanged

        sectionDropDownList.Items.Clear()
        clubsDropDownList.Items.Clear()
        teamDropDownList.Items.Clear()

        If leagueDropDownList.SelectedIndex < 1 Then Exit Sub

        Dim sections As DataTable = HBSAcodeLibrary.LeagueData.GetSections(leagueDropDownList.SelectedValue)
        Dim userRow As DataRow
        If profiling.Value = True Then
            userRow = HBSAcodeLibrary.UserData.LoginData(userIDhidden.Value)
        Else
            userRow = Nothing
        End If

        Dim ix As Integer = 0

        With sectionDropDownList

            If sections.Rows.Count > 1 Then
                .Items.Add("**Select a division/section**")
            End If

            For Each row As DataRow In sections.Rows
                .Items.Add(New ListItem(IIf(row.Item("Section Name").trim = "", "(none)", row.Item("Section Name")), row.Item("ID")))
                If profiling.Value = True Then
                    If row.Item("Section Name") = userRow.Item("Section") Then
                        ix = .Items.Count - 1
                    End If
                End If
            Next

            If sections.Rows.Count < 2 Then
                .Enabled = False
                SectionDropDownList_SelectedIndexChanged(sender, e)
            Else
                If profiling.Value = True Then
                    .SelectedIndex = ix
                    .Enabled = False
                    SectionDropDownList_SelectedIndexChanged(sender, e)
                Else
                    .Enabled = True
                    .SelectedIndex = 0
                End If

            End If

        End With

    End Sub
    Protected Sub SectionDropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles sectionDropDownList.SelectedIndexChanged

        clubsDropDownList.Items.Clear()
        teamDropDownList.Items.Clear()

        If sectionDropDownList.SelectedIndex < 1 Then Exit Sub

        Dim clubs As DataTable = HBSAcodeLibrary.ClubData.GetClubs(sectionDropDownList.SelectedValue)
        Dim userRow As DataRow
        If profiling.Value = True Then
            userRow = HBSAcodeLibrary.UserData.LoginData(userIDhidden.Value)
        Else
            userRow = Nothing
        End If

        Dim ix As Integer = 0

        teamDropDownList.Items.Clear()

        With clubsDropDownList

            If clubs.Rows.Count > 1 Then
                .Items.Add("**Select a club**")
            End If

            For Each row As DataRow In clubs.Rows
                .Items.Add(New ListItem(row.Item("Club Name"), row.Item("ID")))
                If profiling.Value = True Then
                    If row.Item("Club Name") = userRow.Item("Club") Then
                        ix = .Items.Count - 1
                    End If
                End If
            Next

            If clubs.Rows.Count < 2 Then
                .Enabled = False
                ClubsDropDownList_SelectedIndexChanged(sender, e)
            Else
                If profiling.Value = True Then
                    .SelectedIndex = ix
                    .Enabled = False
                    ClubsDropDownList_SelectedIndexChanged(sender, e)
                Else
                    .Enabled = True
                    .SelectedIndex = 0
                End If

            End If

        End With

    End Sub
    Protected Sub ClubsDropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles clubsDropDownList.SelectedIndexChanged

        teamDropDownList.Items.Clear()

        If clubsDropDownList.SelectedIndex < 1 Then Exit Sub

        Dim teams As DataTable = HBSAcodeLibrary.TeamData.TeamLetters(sectionDropDownList.SelectedValue, clubsDropDownList.SelectedValue)
        Dim userRow As DataRow
        If profiling.Value = True Then
            userRow = HBSAcodeLibrary.UserData.LoginData(userIDhidden.Value)
        Else
            userRow = Nothing
        End If

        Dim ix As Integer = 0

        With teamDropDownList

            If teams.Rows.Count > 1 Then
                .Items.Add("**Select a team**")
            End If

            For Each row As DataRow In teams.Rows
                .Items.Add(New ListItem(row.Item("Team"), row.Item("ID")))
                If profiling.Value = True Then
                    If row.Item("Team") = userRow.Item("Team") Then
                        ix = .Items.Count - 1
                    End If
                End If
            Next

            If teams.Rows.Count < 2 Then
                .Enabled = False
                TeamDropDownList_SelectedIndexChanged(sender, e)
            Else
                If profiling.Value = True Then
                    .SelectedIndex = ix
                    .Enabled = False
                    TeamDropDownList_SelectedIndexChanged(sender, e)
                Else
                    .Enabled = True
                    .SelectedIndex = 0
                End If

            End If

        End With

    End Sub
    Protected Sub TeamDropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles teamDropDownList.SelectedIndexChanged

        If profiling.Value = True Then
            Next_Button0_Click(sender, e)
        End If

    End Sub

#Region "Next/Prev buttons"

    Sub EnablePanel(formPanel As Object)

        For Each ctl As Control In panelsDiv.Controls
            If TypeOf ctl Is Panel Then
                If ctl.ClientID = formPanel.ID Then
                    ctl.Visible = True
                Else
                    ctl.Visible = False
                End If
            End If
        Next

    End Sub

    Protected Sub Next_Button0_Click(sender As Object, e As EventArgs) Handles nextButton0.Click
        statusLabel.Text = ""
        If ShowLogin() Then EnablePanel(passwordPanel)
    End Sub

    Protected Sub Next_Button1_Click(sender As Object, e As EventArgs) Handles nextButton1.Click
        statusLabel.Text = ""
        If ShowPassword() Then
            EnablePanel(namePanel)
            HiddenPassword.Value = passwordTextBox.Text.Trim
            HiddenConfirm.Value = confirmPasswordTextBox.Text.Trim
        End If
    End Sub
    Function ShowLogin() As Boolean

        If EmailTextBox.Text = "" Then
            statusLabel.Text += "Email address cannot be blank.<br/>"
        End If

        If leagueDropDownList.SelectedIndex < 1 Then
            statusLabel.Text += "A League must be selected.<br/>"
        End If
        If sectionDropDownList.Items.Count > 1 AndAlso sectionDropDownList.SelectedIndex < 1 Then
            statusLabel.Text += "A Division/Section must be selected.<br/>"
        End If
        If clubsDropDownList.Items.Count > 1 AndAlso clubsDropDownList.SelectedIndex < 1 Then
            statusLabel.Text += "A Club must be selected.<br/>"
        End If
        If teamDropDownList.Items.Count > 1 AndAlso teamDropDownList.SelectedIndex < 1 Then
            statusLabel.Text += "A Team Letter must be selected.<br/>"
        End If

        If statusLabel.Text = "" Then
            loginLiteral.Text = EmailTextBox.Text & " of " & (clubsDropDownList.SelectedItem.Text & " " & teamDropDownList.SelectedItem.Text).Trim &
                                " in the " & leagueDropDownList.SelectedItem.Text & " league"
            Return True
        Else
            Return False
        End If

    End Function
    Function ShowPassword() As Boolean

        If passwordTextBox.Text.Trim <> confirmPasswordTextBox.Text.Trim Then
            statusLabel.Text += "Passwords must match exactly<br/>"
            Return False
        Else
            If passwordTextBox.Text.Trim.Length > 0 Then
                If passwordTextBox.Text.Trim.Length < 8 Then
                    statusLabel.Text += "Password must be a minimum of 8 characters.<br/>"
                    Return False
                End If
            Else
                If profiling.Value = False Then
                    statusLabel.Text += "Must have a password for new registration.<br/>"
                    Return False
                End If
            End If

            Return True
        End If

    End Function
    Function ShowName() As Boolean

        statusLabel.Text = ""
        If (firstNameTextbox.Text & surnameTextBox.Text & telephoneTextBox.Text).Trim = "" Then
            statusLabel.Text += "At least one of First name or Surname must be entered.<br/>"
            Return False
        Else
            nameLiteral.Text = firstNameTextbox.Text & "&nbsp;" & surnameTextBox.Text & "&nbsp;(" & telephoneTextBox.Text & ")"
            Return True
        End If

    End Function
    Protected Sub Prev_Button1_Click(sender As Object, e As EventArgs) Handles prevButton1.Click
        statusLabel.Text = ""
        EnablePanel(loginPanel)
    End Sub
    Protected Sub Prev_Button2_Click(sender As Object, e As EventArgs) Handles prevButton2.Click
        statusLabel.Text = ""
        EnablePanel(passwordPanel)
    End Sub

#End Region
    Protected Sub SubmitButton_Click(sender As Object, e As EventArgs) Handles submitButton.Click

        If submitButton.Text = "Return" Then
            Response.Redirect("Login.aspx")
        Else
            statusLabel.Text = ""

            If Not HBSAcodeLibrary.Emailer.IsValidEmailAddress(EmailTextBox.Text.Trim) Then
                statusLabel.Text &= "The Email address is not valid.<br/>"
            End If
            If HiddenPassword.Value <> HiddenConfirm.Value Then
                statusLabel.Text &= "Passwords must match exactly<br/>"
            End If

            If HiddenPassword.Value.Length = 0 Then
                If profiling.Value = False Then
                    statusLabel.Text &= "New registration must have a password.<br/>"
                End If
            Else
                If HiddenPassword.Value.Length < 8 Then
                    statusLabel.Text &= "Password must be a minimum of 8 characters.<br/>"
                End If
            End If
            If clubsDropDownList.SelectedIndex < 1 Then
                statusLabel.Text &= "Club name must be selected.<br/>"
            End If
            If telephoneTextBox.Text.Trim <> "" Then
                Dim formattedNo = SharedRoutines.CheckValidPhoneNoForHuddersfield(telephoneTextBox.Text)
                If formattedNo.StartsWith("ERR") Then
                    statusLabel.Text &= "Telephone number is invalid.<br/>"
                Else
                    telephoneTextBox.Text = formattedNo
                End If
            End If

            If statusLabel.Text <> "" Then Exit Sub

            If ShowName() AndAlso ShowLogin() Then

                Try

                    'generate a random code for confirmation
                    Dim RandomKey As String = HBSAcodeLibrary.Utilities.GenerateRandomKey()

                    Dim user As HBSAcodeLibrary.UserData

                    If profiling.Value = True Then
                        user = New HBSAcodeLibrary.UserData(EmailTextBox.Text.Trim, , userIDhidden.Value)
                    Else
                        user = New HBSAcodeLibrary.UserData
                    End If

                    With user
                        .eMail = EmailTextBox.Text.Trim
                        .NewPassword = HiddenPassword.Value
                        .TeamID = teamDropDownList.SelectedValue
                        .FirstName = firstNameTextbox.Text.Trim
                        .Surname = surnameTextBox.Text.Trim
                        .Telephone = telephoneTextBox.Text.Trim

                        If profiling.Value = True Then
                            user.UpdateUser(RandomKey)
                        Else
                            userIDhidden.Value = user.CreateUser(RandomKey)
                        End If

                    End With

                    user.Dispose()

                    'send email with link and code
                    statusLabel.Text = ""

                    Send_Email(RandomKey, userIDhidden.Value, teamDropDownList.SelectedValue)

                    If statusLabel.Text = "" Then
                        statusLabel.ForeColor = Drawing.Color.Navy
                        statusLabel.Text = "Your team registration request has been recorded.<br/>" &
                                       "You should soon receive an email to the address you entered, provided it is a valid Email address.<br/>" &
                                       "This will contain a confirmation code which you should use to confirm this registration."
                        submitButton.Text = "Return"
                    End If

                Catch ex As Exception

                    statusLabel.ForeColor = Drawing.Color.Red
                    statusLabel.Text = "Error: " & ex.Message

                End Try

            End If

        End If

    End Sub

    Sub Send_Email(ByVal ConfirmationCode As String, ByVal UserID As Integer, TeamID As Integer)

        Dim toAddress As String
        Dim subject As String
        Dim body As String

        Using Team As New HBSAcodeLibrary.TeamData(TeamID)
            subject = "HBSA Results card login registration " & Team.ClubName & " " & Team.Team & "."
        End Using

        body = "Your HBSA team login registration has been " & If(profiling.Value, "changed", "recorded") & ".  In order to proceed please " &
                     "<a href='" & HBSAcodeLibrary.SiteRootURL.GetSiteRootUrl() & "/mobile/LoginConfirm.aspx" &
                                        "?userID=" & UserID &
                                        "&confirm=" & ConfirmationCode &
                                        "'>Click here to verify your registration.</a><br /><br />" &
                   "Alternatively  verify your details by logging in at the login page.  You will be directed to the confirmation " &
                   "screen where you should enter your details and your confirmation code which is " & ConfirmationCode &
                    "<br/><br/>Sincerely yours<br/> HBSA"

        toAddress = EmailTextBox.Text.Trim

        Try
            HBSAcodeLibrary.Emailer.Send_eMail(toAddress, subject, body)
        Catch ex As Exception
            Dim errorMessage As String = ""
            'errorMessage = ex.Message
            Dim innerEx As Exception = ex.InnerException
            While Not IsNothing(innerEx)
                errorMessage += "<br/>    " & innerEx.Message
                innerEx = innerEx.InnerException
            End While

            statusLabel.ForeColor = Drawing.Color.Red
            statusLabel.Text = "Your HBSA Results card login registration has been " & If(profiling.Value, "changed", "recorded") & ". <br/>" &
                                "However the email requesting confirmation could NOT been sent. <br/>" &
                                "There was an error.  Please phone 0789 003 2041 for assistance and have the following information to hand:<br/>" &
                                           errorMessage

        End Try

    End Sub

    Protected Sub DeleteButton_Click(sender As Object, e As EventArgs) Handles deleteButton.Click

        EnablePanel(deletePanel)
        removeButton.Visible = False
        deleteLabel.Text = "Touch 'Remove Permantly' to remove this Club's login registration"

    End Sub

    Protected Sub DeleteCancelButton_Click(sender As Object, e As EventArgs) Handles deleteCancelButton.Click

        EnablePanel(loginPanel)

    End Sub

    Protected Sub DeleteConfirmButton_Click(sender As Object, e As EventArgs) Handles deleteConfirmButton.Click

        Using user As New HBSAcodeLibrary.UserData(, , userIDhidden.Value)
            user.DeleteUser()
            Session("TeamID") = Nothing
            Session.Clear()
            statusLabel.Text = "<a href='Login.aspx'>This club's registration has been removed. Touch here to return.</a>"
            deleteRow.Visible = False
        End Using

    End Sub

End Class