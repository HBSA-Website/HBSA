Public Class EmailMonitor
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
        OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else

            Close_Button.Attributes.Add("onclick", "hideDiv('Email_Div');")

            If Not IsPostBack Then

                From_CalendarExtender.SelectedDate = DateAdd(DateInterval.Day, -6, Today)
                To_CalendarExtender.SelectedDate = DateAdd(DateInterval.Day, 1, Today)
                From_TextBox.Text = Format(From_CalendarExtender.SelectedDate, "dd MMM yyyy")
                To_TextBox.Text = Format(To_CalendarExtender.SelectedDate, "dd MMM yyyy")

                FillGrid()

            End If

        End If

    End Sub

    Sub FillGrid()

        Dim FromDate As Date
        Dim ToDate As Date

        Try
            FromDate = CDate(From_TextBox.Text)
        Catch ex As Exception
            Status_Literal.Text = "The from date is invalid, please correct and try again."
            Exit Sub
        End Try

        Try
            ToDate = CDate(To_TextBox.Text)
        Catch ex As Exception
            Status_Literal.Text = "The To date is invalid, please correct and try again."
            Exit Sub
        End Try

        Status_Literal.Text = ""

        FromDate = DateAdd(DateInterval.Hour, CInt(FromHour_DropDown.SelectedValue), FromDate)
        FromDate = DateAdd(DateInterval.Minute, CInt(FromMinute_DropDown.SelectedValue), FromDate)

        ToDate = DateAdd(DateInterval.Hour, CInt(ToHour_DropDown.SelectedValue), ToDate)
        ToDate = DateAdd(DateInterval.Minute, CInt(ToMinute_DropDown.SelectedValue), ToDate)

        Using Emails As DataTable = HBSAcodeLibrary.Emailer.Get_eMailList _
                                        (CDate(From_TextBox.Text),
                                         CDate(To_TextBox.Text),
                                         SubjectFilter_TextBox.Text.Trim)
            With Emails_GridView

                .DataSource = Emails
                .DataBind()

            End With

            Session("EmailsList") = Emails

        End Using

    End Sub

    Private Sub Emails_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Emails_GridView.RowDataBound

        If e.Row.Cells.Count > 2 Then
            e.Row.Cells(e.Row.Cells.Count - 1).Visible = False
            e.Row.Cells(e.Row.Cells.Count - 2).Visible = False
        End If

    End Sub

    Private Sub Emails_GridView_Send(sender As Object, e As GridViewEditEventArgs) Handles Emails_GridView.RowEditing

        'Using the grid view edit function to send an email from the selected row

        Dim EmailTable As DataTable = Session("EmailsList")
        With EmailTable.Rows(e.NewEditIndex)

            Status_Literal.Text = ""

            Dim adminDetails As System.Data.DataRow = Session("adminDetails").rows(0)

            Try

                HBSAcodeLibrary.Emailer.Send_eMail(.Item("ToAddresses"), .Item("Subject") & " (Resend)", .Item("body"), .Item("CCAdresses"), .Item("ReplyTo"), , adminDetails!Forename & " " & adminDetails!Surname)
                Status_Literal.Text = "The Email has been sent."

            Catch ex As Exception
                Dim errorMessage As String
                errorMessage = ex.Message
                Dim innerEx As Exception = ex.InnerException
                While Not IsNothing(innerEx)
                    errorMessage += "<br/>    " & innerEx.Message
                    innerEx = innerEx.InnerException
                End While

                Status_Literal.Text += "<span style='color:red;'>Your email has NOT been sent. <br/>" &
                                                "There was an error.  Please contact support and <strong>supply the following information:</strong><br/>" &
                                              errorMessage & "</span>"


            End Try

        End With

        e.Cancel = True

    End Sub

    Private Sub Emails_GridView_ShowEMail(sender As Object, e As GridViewSelectEventArgs) Handles Emails_GridView.SelectedIndexChanging

        'Using the grid view select function to show full email details from the selected row

        Dim EmailTable As DataTable = Session("EmailsList")
        With EmailTable.Rows(e.NewSelectedIndex)
            From_Literal.Text = .Item("Sender").ToString
            To_Literal.Text = .Item("ToAddresses")
            Reply_To_Literal.Text = .Item("ReplyTo")
            CC_Literal.Text = .Item("CCAddresses")
            BCC_Literal.Text = .Item("BCCAddresses")
            Sent_Literal.Text = .Item("DateTimeSent")
            Subject_Literal.Text = .Item("Subject")
            Body_Literal.Text = .Item("body")
        End With

        Email_Panel.Visible = True

        e.Cancel = True

    End Sub

    Protected Sub Send_Button_Click(sender As Object, e As EventArgs) Handles Send_Button.Click

        Dim EmailTable As DataTable = Session("EmailsList")
        Status_Literal.Text = ""

        Try

            Dim adminDetails As System.Data.DataRow = Session("adminDetails").rows(0)

            HBSAcodeLibrary.Emailer.Send_eMail(To_Literal.Text.Replace(", ", ";"), Subject_Literal.Text & " (Resend)", Body_Literal.Text, , , , adminDetails!Forename & " " & adminDetails!Surname)
            Status_Literal.Text = "The Email has been sent."

        Catch ex As Exception
            Dim errorMessage As String
            errorMessage = ex.Message
            Dim innerEx As Exception = ex.InnerException
            While Not IsNothing(innerEx)
                errorMessage += "<br/>    " & innerEx.Message
                innerEx = innerEx.InnerException
            End While

            Status_Literal.Text += "<span style='color:red;'>Your email has NOT been sent. <br/>" &
                                            "There was an error.  Please contact support and <strong>supply the following information:</strong><br/>" &
                                          errorMessage & "</span>"


        End Try

        Email_Panel.Visible = False

    End Sub

    Protected Sub Close_Button_Click(sender As Object, e As EventArgs) Handles Close_Button.Click

        Email_Panel.Visible = False
        Status_Literal.Text = ""


    End Sub

    Protected Sub GetEmails_Button_Click(sender As Object, e As EventArgs) Handles GetEmails_Button.Click

        FillGrid()
        Status_Literal.Text = ""

        From_CalendarExtender.SelectedDate = CDate(From_TextBox.Text)
        To_CalendarExtender.SelectedDate = CDate(To_TextBox.Text)

    End Sub

    'Protected Sub ImageButton_Click(sender As Object, e As ImageClickEventArgs) Handles To_ImageButton.Click

    '    Dim dat As New DateTime
    '    Dim tBox As TextBox = To_TextBox 'If(sender.ID Like "*From*", From_TextBox, To_TextBox)
    '    Dim Calendar As Calendar = To_Calendar 'If(sender.ID Like "*From*", From_Calendar, To_Calendar)
    '    'Dim otherCalendar As Calendar = If(sender.ID Like "*To*", From_Calendar, To_Calendar)

    '    Calendar.Visible = Not Calendar.Visible
    '    'otherCalendar.Visible = False

    '    If Calendar.Visible Then
    '        If DateTime.TryParse(tBox.Text, dat) Then
    '            Calendar.SelectedDate = dat
    '        End If
    '        Calendar.Attributes.Add("style", "position:absolute")
    '    End If

    'End Sub

    'Protected Sub Calendar_SelectionChanged(sender As Object, e As EventArgs) Handles To_Calendar.SelectionChanged

    '    'Dim tBox As TextBox = If(sender.ID Like "*From*", From_TextBox, To_TextBox)
    '    'Dim Calendar As Calendar = If(sender.ID Like "*From*", From_Calendar, To_Calendar)

    '    To_TextBox.Text = To_Calendar.SelectedDate.ToString("dd MMM yyyy")

    '    To_Calendar.Visible = False

    'End Sub
End Class