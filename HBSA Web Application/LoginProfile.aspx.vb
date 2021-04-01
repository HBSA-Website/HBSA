Imports HBSAcodeLibrary
Partial Class LoginProfile
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If IsNothing(Session("TeamID")) Then
            Response.Redirect("Login.aspx")
        End If

        If Not IsPostBack Then

            Using TeamData As New TeamData(Session("TeamID"))

                populateLeagues()
                League_DropDownList.SelectedValue = TeamData.LeagueID
                League_DropDownList_SelectedIndexChanged(sender, e)
                Section_DropDownList.SelectedValue = TeamData.SectionID
                Section_DropDownList_SelectedIndexChanged(sender, e)
                Club_DropDownList.SelectedValue = TeamData.ClubID
                Club_DropDownList_SelectedIndexChanged(sender, e)
                Team_DropDownList.SelectedValue = TeamData.ID

                Using Userdata As New HBSAcodeLibrary.UserData(Session("Email"), Session("Password"))
                    FirstName_TextBox.Text = Userdata.FirstName
                    Surname_TextBox.Text = Userdata.Surname
                    Telephone_TextBox.Text = Userdata.Telephone
                    email_TextBox.Text = Userdata.eMail
                    Password_TextBox.Text = "" 'Userdata.Password
                    ConfirmPassword_TextBox.Text = "" 'Userdata.Password
                End Using

            End Using

        End If

    End Sub

    Protected Sub PopulateLeagues()

        Using leaguesInfo As DataTable = HBSAcodeLibrary.LeagueData.GetLeagues

            With League_DropDownList
                .Items.Clear()
                .DataSource = leaguesInfo
                .DataTextField = "League Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select a league**", 0))
            End With

        End Using

    End Sub

    Protected Sub Register_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Register_Button.Click

        Status_Label.Text = ""

        If Password_TextBox.Text.Trim <> ConfirmPassword_TextBox.Text Then
            Status_Label.Text &= "Passwords must match exactly<br/>"
        End If
        If email_TextBox.Text.Trim = "" Then
            Status_Label.Text &= "Email address cannot be blank.<br/>"
        Else
            If Not Emailer.IsValidEmailAddress(email_TextBox.Text.Trim) Then
                Status_Label.Text &= "Invalid Email address.<br/>"
            End If
        End If
            If Password_TextBox.Text.Trim.Length > 0 And Password_TextBox.Text.Trim.Length < 8 Then
            Status_Label.Text &= "Password must be a minimum of 8 characters.<br/>"
        End If
        If Club_DropDownList.SelectedItem.Text.Trim = "" Then
            Status_Label.Text &= "Club name cannot be blank.<br/>"
        End If
        If Telephone_TextBox.Text.Trim <> "" Then
            Dim formattedNo As String = SharedRoutines.CheckValidPhoneNoForHuddersfield(Telephone_TextBox.Text.Trim)
            If formattedNo.StartsWith("ERR") Then
                Status_Label.Text = "Invalid telephone number<br/>"
            Else
                Telephone_TextBox.Text = formattedNo
            End If
        End If

        If League_DropDownList.SelectedItem.Text.StartsWith("**") Or
           Section_DropDownList.SelectedItem.Text.StartsWith("**") Or
           Club_DropDownList.SelectedItem.Text.StartsWith("**") Or
           Team_DropDownList.SelectedValue = 0 Then
            Status_Label.Text &= "Please select one each, of league, section, club and team letter.<br/>"
        End If

        If Status_Label.Text = "" Then

            Try

                'change the new login

                Using user As New HBSAcodeLibrary.UserData(email_TextBox.Text.Trim, Session("Password"))

                    With user
                        .NewPassword = If(Password_TextBox.Text.Trim = "", "", Password_TextBox.Text.Trim)
                        .TeamID = Team_DropDownList.SelectedValue
                        .FirstName = FirstName_TextBox.Text.Trim
                        .Surname = Surname_TextBox.Text.Trim
                        .Telephone = Telephone_TextBox.Text.Trim

                        user.UpdateUser()

                    End With

                End Using

                If Status_Label.Text = "" Then
                    Status_Label.ForeColor = Drawing.Color.DarkGreen
                    Status_Label.Text = "Your new registration details have been saved."
                    If Password_TextBox.Text.Trim <> "" Then
                        Session("Password") = Password_TextBox.Text.Trim
                    End If
                End If

            Catch ex As Exception
                Status_Label.ForeColor = Drawing.Color.Red
                Status_Label.Text = "An error occurred. Please use the contacts page for help, and supply the following:<br/><br/>" & ex.Message
            End Try
        Else
            Status_Label.ForeColor = Drawing.Color.Red

        End If

    End Sub

    Protected Sub Delete_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Delete_Button.Click

        If Delete_Button.Text = "Remove Permanently" Then
            Try

                Using user As New HBSAcodeLibrary.UserData(email_TextBox.Text.Trim, IIf(Password_TextBox.Text.Trim = "", Session("Password"), Password_TextBox.Text.Trim))
                    user.DeleteUser()
                End Using

                Delete_Button.Text = "Return"
                Register_Button.Visible = False
                Status_Label.Text = "<span style='color:red;'><strong>Removed.  Click return.</strong></span>"
                Session("TeamID") = Nothing
            Catch ex As Exception
                Status_Label.ForeColor = Drawing.Color.Red
                Status_Label.Text = "An error occurred. Please use the contacts page for help, and supply the following:<br/><br/>" & ex.Message
            End Try
        ElseIf Delete_Button.Text = "Return" Then
            Response.Redirect("Login.aspx")
        Else
            Delete_Button.Text = "Remove Permanently"
            Status_Label.ForeColor = Drawing.Color.Red
            Status_Label.Font.Bold = True
            Status_Label.Text = "Click Remove again to confirm you want to permanently remove this registration."
        End If

    End Sub

#Region "Drop Downs control"
    Protected Sub League_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles League_DropDownList.SelectedIndexChanged

        Using sectionsInfo As DataTable = HBSAcodeLibrary.LeagueData.GetSections(League_DropDownList.SelectedValue)

            With Section_DropDownList
                .Visible = True
                .Items.Clear()
                .DataSource = sectionsInfo
                .DataTextField = "Section Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select a division/section**", 0))
                If sectionsInfo.Rows.Count < 2 Then
                    .Enabled = False
                    Section_DropDownList_SelectedIndexChanged(sender, e)
                Else
                    .Enabled = True
                End If

                .SelectedIndex = 0

                Club_DropDownList.Visible = False
                Team_DropDownList.Visible = False

            End With

        End Using

    End Sub

    Protected Sub Section_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Section_DropDownList.SelectedIndexChanged

        Using clubsList As DataTable = HBSAcodeLibrary.ClubData.GetClubs(Section_DropDownList.SelectedValue)

            With Club_DropDownList
                .Items.Clear()
                .DataSource = clubsList
                .DataTextField = "Club Name"
                .DataValueField = "ID"
                .DataBind()
                .Items.Insert(0, New ListItem("**Select a club**", 0))
                .Visible = True
                Team_DropDownList.Visible = False
                .SelectedIndex = 0
            End With

        End Using

    End Sub
    Protected Sub Club_DropDownList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Club_DropDownList.SelectedIndexChanged

        Using teamList As DataTable = HBSAcodeLibrary.TeamData.TeamLetters(Section_DropDownList.SelectedValue, Club_DropDownList.SelectedValue)

            With Team_DropDownList

                .Visible = True
                .Items.Clear()

                If teamList.Rows.Count = 0 Then
                    .Items.Add(New ListItem(" ", 9999))
                    .Enabled = False
                ElseIf teamList.Rows.Count > 0 Then
                    .DataSource = teamList
                    .DataTextField = "Team"
                    .DataValueField = "ID"
                    .DataBind()
                    .Items.Insert(0, New ListItem("** Select a team **", 0))
                    .Enabled = True
                    .SelectedIndex = 0
                Else
                    .Enabled = False
                End If

            End With

        End Using

    End Sub

    Protected Sub Return_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Return_Button.Click

        Session("TeamID") = Nothing
        Response.Redirect("Login.aspx")

    End Sub
#End Region

End Class
