
Imports HBSAcodeLibrary
Public Class UserDetails
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load


        If Session("adminDetails") Is Nothing _
               OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        End If

        If Not IsPostBack Then
            Populate_Clubs()
            Populate_Leagues()
        End If

    End Sub

    Sub Populate_Clubs()

        Dim ClubsTable As DataTable = HBSAcodeLibrary.ClubData.GetClubs

        With Clubs_DropDownList
            .Items.Clear()
            .DataSource = ClubsTable
            .DataTextField = "Club Name"
            .DataValueField = "ID"
            .DataBind()
            .Items.Insert(0, New ListItem("Any", 0))
        End With

    End Sub

    Sub Populate_Leagues()

        Dim LeaguesTable As DataTable = LeagueData.GetLeagues

        With Leagues_DropDownList
            .Items.Clear()
            .DataSource = LeaguesTable
            .DataTextField = "League Name"
            .DataValueField = "ID"
            .DataBind()
            .Items.Insert(0, New ListItem("Any", 0))
        End With

    End Sub

    Protected Sub GetReport_Button_Click(sender As Object, e As EventArgs) Handles GetReport_Button.Click

        Dim UsersTable As DataTable = HBSAcodeLibrary.UserData.UserList(Clubs_DropDownList.SelectedValue,
                                                                  Team_DropDownList.SelectedValue,
                                                                  Leagues_DropDownList.SelectedValue,
                                                                  Type_DropDownList.SelectedValue,
                                                                  Confirmed_DropDownList.SelectedValue)

        With Users_GridView

            .DataSource = UsersTable
            Try
                .DataBind()
            Catch ex As Exception
                'we've been getting invalid index when data table is empty
            End Try

        End With

    End Sub

    Protected Sub Type_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles Type_DropDownList.SelectedIndexChanged

        Team_Row.Visible = (Type_DropDownList.SelectedValue = "Team")

    End Sub

    Private Sub Users_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Users_GridView.RowDataBound

        e.Row.Cells(2).Visible = False
        e.Row.Cells(7).Visible = False
        e.Row.Cells(8).Visible = False

    End Sub

    Sub Populate_EditBox(RowIx As Integer, Command As String)

        editUser_Button.Text = Command

        'populate drop downs

        Dim ClubTeamNamesTable As DataTable = HBSAcodeLibrary.UserData.UsersClubsTeams(Type_DropDownList.SelectedValue)
        With editClubTeam_DropdownList
            .Items.Clear()
            .DataSource = ClubTeamNamesTable
            .DataTextField = "Name"
            .DataValueField = "ID"
            .DataBind()
        End With

        Select Case Command
            Case "Delete"
                EditType_Literal.Text = "To remove this user click Delete or click Cancel to keep."
            Case "Change"
                EditType_Literal.Text = "Enter required details and click Change or click Cancel to leave as is."
            Case "Add"
                EditType_Literal.Text = "Enter required details and click Add or click Cancel."
        End Select

        EditPanel_Literal.Text = Command & "&nbsp;<span style= 'color:red'>" & Type_DropDownList.SelectedValue & "</span>&nbsp;User"

        If Command = "Add" Then

            Password_Hidden.Value = ""
            UserID_Hidden.Value = ""

            'populate Boxes
            EditEmail_Textbox.Text = ""
            editPassword_textbox.Text = ""
            editConfirmed_CheckBox.Checked = True
            editForename_TextBox.Text = ""
            editSurname_TextBox.Text = ""
            editTelephone_Textbox.Text = ""

            EditClubTeamHeader.InnerText = Type_DropDownList.SelectedValue
            editClubTeam_DropdownList.Items.Insert(0, New ListItem("** Select a " & Type_DropDownList.SelectedValue & " **"))
            editClubTeam_DropdownList.SelectedIndex = 0

        Else
            With Users_GridView.Rows(RowIx)

                'preserve details for database access
                Password_Hidden.Value = .Cells(2).Text
                UserID_Hidden.Value = .Cells(8).Text

                'populate Boxes
                EditEmail_Textbox.Text = .Cells(1).Text.Replace("&nbsp;", "")
                editPassword_textbox.Text = .Cells(2).Text.Replace("&nbsp;", "")
                editConfirmed_CheckBox.Checked = .Cells(3).Text
                editForename_TextBox.Text = .Cells(4).Text.Replace("&nbsp;", "")
                editSurname_TextBox.Text = .Cells(5).Text.Replace("&nbsp;", "")
                editTelephone_Textbox.Text = .Cells(6).Text.Replace("&nbsp;", "")

                Try
                    editClubTeam_DropdownList.SelectedValue = .Cells(7).Text
                Catch ex As Exception
                End Try

            End With

        End If

        EnableDisableEditBoxControls(Command)
        Status_Literal.Text = ""
        Edit_Panel.Visible = True

    End Sub

    Sub EnableDisableEditBoxControls(Command)

        Select Case Command

            Case "Delete"
                EditEmail_Textbox.Enabled = False
                editPassword_textbox.Enabled = False
                editConfirmed_CheckBox.Enabled = False
                editConfirmed_CheckBox.Attributes.Add("autopostback", "false")
                editClubTeam_DropdownList.Enabled = False
                editForename_TextBox.Enabled = False
                editSurname_TextBox.Enabled = False
                editTelephone_Textbox.Enabled = False

            Case "Change"
                EditEmail_Textbox.Enabled = False
                editPassword_textbox.Enabled = True
                editConfirmed_CheckBox.Enabled = Not editConfirmed_CheckBox.Checked
                editClubTeam_DropdownList.Enabled = True
                editForename_TextBox.Enabled = True
                editSurname_TextBox.Enabled = True
                editTelephone_Textbox.Enabled = True

            Case "Add"
                EditEmail_Textbox.Enabled = True
                editPassword_textbox.Enabled = True
                editConfirmed_CheckBox.Enabled = True
                editClubTeam_DropdownList.Enabled = True
                editForename_TextBox.Enabled = True
                editSurname_TextBox.Enabled = True
                editTelephone_Textbox.Enabled = True

        End Select

    End Sub

    Private Sub Users_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles Users_GridView.RowDeleting

        Populate_EditBox(e.RowIndex, "Delete")
        e.Cancel = True

    End Sub

    Private Sub Users_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles Users_GridView.RowEditing

        Populate_EditBox(e.NewEditIndex, "Change")
        e.Cancel = True

    End Sub

    Protected Sub NewUser_Button_Click(sender As Object, e As EventArgs) Handles NewUser_Button.Click

        Populate_EditBox(0, "Add")

    End Sub

    Protected Sub CancelEdit_Button_Click(sender As Object, e As EventArgs) Handles CancelEdit_Button.Click

        Edit_Panel.Visible = False

    End Sub

    Protected Sub EditUser_Button_Click(sender As Object, e As EventArgs) Handles editUser_Button.Click

        Status_Literal.Text = ""

        If Status_Literal.Text <> "" Then Exit Sub

        Try

            If Type_DropDownList.SelectedValue = "Team" Then

                Select Case editUser_Button.Text
                    Case "Delete"
                        EditPanel_Literal.Text = "<span style='color:red'>Click Confirm Delete to remove this user from the system.</span>"
                        editUser_Button.Text = "Confirm Delete"

                    Case "Confirm Delete"
                        Using user As New HBSAcodeLibrary.UserData(EditEmail_Textbox.Text.Trim, , UserID_Hidden.Value)
                            user.DeleteUser()
                        End Using
                        editUser_Button.Text = "Submit"
                        Edit_Panel.Visible = False
                        GetReport_Button_Click(sender, e)

                    Case "Change"

                        If editTelephone_Textbox.Text.Trim <> "" Then
                            Dim FormattedNo = SharedRoutines.CheckValidPhoneNoForHuddersfield(editTelephone_Textbox.Text)
                            If FormattedNo.StartsWith("ERR") Then
                                Status_Literal.Text = FormattedNo & "<br/>"
                            Else
                                editTelephone_Textbox.Text = FormattedNo
                            End If
                        End If

                        If Status_Literal.Text <> "" Then Exit Sub

                        Using user As New HBSAcodeLibrary.UserData(EditEmail_Textbox.Text.Trim, , UserID_Hidden.Value)
                            With user

                                If editConfirmed_CheckBox.Checked Then
                                    .ConfirmUser()
                                End If

                                If editPassword_textbox.Text <> Password_Hidden.Value Then
                                    .NewPassword = editPassword_textbox.Text.Trim
                                Else
                                    .NewPassword = ""
                                End If
                                .FirstName = editForename_TextBox.Text.Trim
                                .Surname = editSurname_TextBox.Text.Trim
                                .Telephone = editTelephone_Textbox.Text.Trim
                                .TeamID = editClubTeam_DropdownList.SelectedValue

                                .UpdateUser()

                            End With
                        End Using

                        editUser_Button.Text = "Submit"
                        Edit_Panel.Visible = False
                        GetReport_Button_Click(sender, e)

                    Case "Add"

                        If editPassword_textbox.Text.Trim.Length < 8 Then
                            Status_Literal.Text += "Must enter a password of at least 8 characters long.<br/>"
                        End If
                        If editClubTeam_DropdownList.SelectedIndex < 1 Then
                            Status_Literal.Text += "Must select a team.<br/>"
                        End If
                        If EditEmail_Textbox.Text.Trim = "" Then
                            Status_Literal.Text += "Must enter an Email address.<br/>"
                        Else
                            If Not Emailer.IsValidEmailAddress(EditEmail_Textbox.Text.Trim) Then
                                Status_Literal.Text += "Invalid Email address.<br/>"
                            End If
                        End If
                        If editTelephone_Textbox.Text.Trim <> "" Then
                            Dim FormattedNo = SharedRoutines.CheckValidPhoneNoForHuddersfield(editTelephone_Textbox.Text)
                            If FormattedNo.StartsWith("ERR") Then
                                Status_Literal.Text = FormattedNo + "<br/>"
                            Else
                                editTelephone_Textbox.Text = FormattedNo
                            End If
                        End If

                        If Status_Literal.Text <> "" Then Exit Sub

                        Using user As New HBSAcodeLibrary.UserData()
                            With user
                                .eMail = EditEmail_Textbox.Text.Trim
                                .NewPassword = editPassword_textbox.Text.Trim
                                .FirstName = editForename_TextBox.Text.Trim
                                .Surname = editSurname_TextBox.Text.Trim
                                .Telephone = editTelephone_Textbox.Text.Trim
                                .TeamID = editClubTeam_DropdownList.SelectedValue

                                .CreateUser(HBSAcodeLibrary.Utilities.GenerateRandomKey())

                            End With
                        End Using

                        If editConfirmed_CheckBox.Checked Then
                            Using user As New HBSAcodeLibrary.UserData(EditEmail_Textbox.Text.Trim, editPassword_textbox.Text.Trim)
                                user.ConfirmUser()
                            End Using
                        End If

                        Edit_Panel.Visible = False
                        GetReport_Button_Click(sender, e)

                End Select

            Else 'Type_DropDownList.SelectedValue = "Club" Then

                Select Case editUser_Button.Text
                    Case "Delete"
                        EditPanel_Literal.Text = "<span style='color:red'>Click Confirm Delete to remove this user from the system.</span>"
                        editUser_Button.Text = "Confirm Delete"

                    Case "Confirm Delete"
                        Using user As New HBSAcodeLibrary.ClubUserData(UserID_Hidden.Value)
                            user.eMail = "" 'blank email ddress causes delete
                            user.MergeClubUser()
                        End Using

                        editUser_Button.Text = "Submit"
                        Edit_Panel.Visible = False
                        GetReport_Button_Click(sender, e)

                    Case "Change"

                        Using user As New HBSAcodeLibrary.ClubUserData(UserID_Hidden.Value)
                            With user

                                If editConfirmed_CheckBox.Checked Then
                                    .ConfirmClubUser()
                                End If

                                If editPassword_textbox.Text <> Password_Hidden.Value Then
                                    .Password = editPassword_textbox.Text.Trim
                                Else
                                    .Password = ""
                                End If
                                .FirstName = editForename_TextBox.Text.Trim
                                .Surname = editSurname_TextBox.Text.Trim
                                .Telephone = editTelephone_Textbox.Text.Trim

                                .MergeClubUser()

                            End With
                        End Using

                        editUser_Button.Text = "Submit"
                        Edit_Panel.Visible = False
                        GetReport_Button_Click(sender, e)

                    Case "Add"

                        If editPassword_textbox.Text.Trim.Length < 8 Then
                            Status_Literal.Text = "Must enter a password of at least 8 characters long."
                            Exit Sub
                        End If

                        Using user As New HBSAcodeLibrary.ClubUserData()
                            With user
                                .eMail = EditEmail_Textbox.Text.Trim
                                .Password = editPassword_textbox.Text.Trim
                                .FirstName = editForename_TextBox.Text.Trim
                                .Surname = editSurname_TextBox.Text.Trim
                                .Telephone = editTelephone_Textbox.Text.Trim
                                .ClubID = editClubTeam_DropdownList.SelectedValue
                                If editConfirmed_CheckBox.Checked Then
                                    .ConfirmationCode = "Confirmed"
                                Else
                                    .ConfirmationCode = HBSAcodeLibrary.Utilities.GenerateRandomKey()
                                End If
                                .MergeClubUser()

                            End With
                        End Using

                        Edit_Panel.Visible = False
                        GetReport_Button_Click(sender, e)

                End Select

            End If

        Catch ex As Exception

            Status_Literal.Text = "ERROR occurred: " & ex.Message

        End Try

    End Sub

End Class