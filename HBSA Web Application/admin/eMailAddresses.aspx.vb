Public Class EmailAddresses
    Inherits System.Web.UI.Page

    Protected Sub FindEmailAddresses_Button_Click(sender As Object, e As EventArgs) Handles FindEmailAddresses_Button.Click

        With EmailAddresses_GridView
            Dim EmailAddresses As DataTable = HBSAcodeLibrary.SharedRoutines.FindEmailAddresses(CurrentEmail_TextBox.Text)
            .DataSource = EmailAddresses
            .DataBind()
            Status_Literal.Text = ""
            NewEmailAddress.Visible = (.Rows.Count > 0)
            NewEmailAddress_TextBox.Text = ""
            Session("EmailAddresses") = EmailAddresses
        End With

    End Sub

    Protected Sub ChangeAddress_Button_Click(sender As Object, e As EventArgs) Handles ChangeAddress_Button.Click

        If HBSAcodeLibrary.Emailer.IsValidEmailAddress(NewEmailAddress_TextBox.Text) Then
            Try
                HBSAcodeLibrary.SharedRoutines.ReplaceEmailAddress(CurrentEmail_TextBox.Text, NewEmailAddress_TextBox.Text)
                Dim oldAddr As String = CurrentEmail_TextBox.Text
                CurrentEmail_TextBox.Text = NewEmailAddress_TextBox.Text
                FindEmailAddresses_Button_Click(sender, e)
                Status_Literal.Text = "All instances of " & oldAddr & " changed to " & CurrentEmail_TextBox.Text

            Catch ex As Exception
                Status_Literal.Text = "<span style='color:red;'>ERROR:" & ex.Message & "</span>"
                EmailAddresses_GridView.DataSource = Nothing
            End Try
        Else
            Status_Literal.Text = "<span style='color:red;'>ERROR: Please enter a valid (new) Email address" & "</span>"
        End If

    End Sub

    Private Sub EmailAddresses_GridView_SelectedIndexChanging(sender As Object, e As GridViewSelectEventArgs) Handles EmailAddresses_GridView.SelectedIndexChanging

        'Using the grid view select function to show full email address details from the selected row

        Dim EmailAddresses As DataTable = Session("EmailAddresses")
        Dim TableName As String = EmailAddresses.Rows(e.NewSelectedIndex).Item("Table_Name")
        Dim ColumnName As String = EmailAddresses.Rows(e.NewSelectedIndex).Item("Column_Name")

        Dim EmailDetail As DataTable = HBSAcodeLibrary.SharedRoutines.EmailAddressDetail(TableName, ColumnName, CurrentEmail_TextBox.Text.Trim)

        With EmailAddressDetail_GridView
            .DataSource = EmailDetail
            .DataBind()
        End With
        EmailAddress_Literal.Text = "Details for " & CurrentEmail_TextBox.Text.Trim & " (Table=" & TableName & ", Column=" & ColumnName & ")"
        Email_Panel.Visible = True

        e.Cancel = True

    End Sub

    Private Sub Close_Button_Clicked(sender As Object, e As EventArgs) Handles Close_Button.Click

        Email_Panel.Visible = False

    End Sub

    Protected Sub FindPhoneNos_Button_Click(sender As Object, e As EventArgs) Handles FindPhoneNos_Button.Click

        With PhoneNos_GridView
            Dim FormattedNo As String = HBSAcodeLibrary.SharedRoutines.CheckValidPhoneNoForHuddersfield(CurrentPhoneNo_TextBox.Text)
            Dim PhoneNos As DataTable = HBSAcodeLibrary.SharedRoutines.FindPhoneNos(FormattedNo)
            If PhoneNos.Rows.Count < 1 Then
                PhoneNos = HBSAcodeLibrary.SharedRoutines.FindPhoneNos(CurrentPhoneNo_TextBox.Text)
            Else
                CurrentPhoneNo_TextBox.Text = FormattedNo
            End If

            .DataSource = PhoneNos
            .DataBind()
            PhoneNoStatus_Literal.Text = ""
            NewPhoneNo.Visible = (.Rows.Count > 0)
            NewPhoneNo_TextBox.Text = ""
            Session("PhoneNos") = PhoneNos
            PhoneNos.Dispose()

        End With

    End Sub

    Protected Sub ChangePhoneNo_Button_Click(sender As Object, e As EventArgs) Handles ChangePhoneNo_Button.Click

        Dim FormattedNo As String = HBSAcodeLibrary.SharedRoutines.CheckValidPhoneNoForHuddersfield(NewPhoneNo_TextBox.Text)
        If Not FormattedNo.StartsWith("ERR") Then
            Try
                HBSAcodeLibrary.SharedRoutines.ReplacePhoneNo(CurrentPhoneNo_TextBox.Text, FormattedNo)
                Dim oldNo As String = CurrentPhoneNo_TextBox.Text
                CurrentPhoneNo_TextBox.Text = FormattedNo
                FindPhoneNos_Button_Click(sender, e)
                PhoneNoStatus_Literal.Text = "All instances of " & oldNo & " changed to " & FormattedNo

            Catch ex As Exception
                PhoneNoStatus_Literal.Text = "<span style='color:red;'>ERROR:" & ex.Message & "</span>"
                PhoneNos_GridView.DataSource = Nothing
            End Try
        Else
            PhoneNoStatus_Literal.Text = "<span style='color:red;'>" & FormattedNo & "<br/>Please enter a valid UK (new) phone number" & "</span>"
        End If

    End Sub

    Private Sub PhoneNos_GridView_SelectedIndexChanging(sender As Object, e As GridViewSelectEventArgs) Handles PhoneNos_GridView.SelectedIndexChanging

        'Using the grid view select function to show full phone number details from the selected row

        Dim PhoneNos As DataTable = Session("PhoneNos")
        Dim TableName As String = PhoneNos.Rows(e.NewSelectedIndex).Item("Table_Name")
        Dim ColumnName As String = PhoneNos.Rows(e.NewSelectedIndex).Item("Column_Name")

        Dim PhoneNoDetail As DataTable = HBSAcodeLibrary.SharedRoutines.PhoneNoDetail(TableName, ColumnName, CurrentPhoneNo_TextBox.Text.Trim)

        With PhoneNoDetail_GridView
            .DataSource = PhoneNoDetail
            .DataBind()
        End With
        PhoneNo_Literal.Text = "Details for " & CurrentPhoneNo_TextBox.Text.Trim & " (Table=" & TableName & ", Column=" & ColumnName & ")"
        PhoneNo_Panel.Visible = True

        e.Cancel = True

    End Sub

    Private Sub PhoneNoClose_Button_Clicked(sender As Object, e As EventArgs) Handles PhoneNoClose_Button.Click

        PhoneNo_Panel.Visible = False

    End Sub

End Class