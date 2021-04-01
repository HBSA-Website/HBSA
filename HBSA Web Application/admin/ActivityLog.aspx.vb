Public Class ActivityLog
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            From_CalendarExtender.SelectedDate = DateAdd(DateInterval.Day, -6, Today)
            To_CalendarExtender.SelectedDate = DateAdd(DateInterval.Day, 1, Today)
            From_TextBox.Text = Format(From_CalendarExtender.SelectedDate, "dd MMM yyyy")
            To_TextBox.Text = Format(To_CalendarExtender.SelectedDate, "dd MMM yyyy")

            With Action_DropDownList
                .DataSource = HBSAcodeLibrary.ActivityLog.ActivityLogActions
                .DataTextField = "Action"
                .DataValueField = "Value"
                .DataBind()
                .Items.Insert(0, New ListItem("** All Actions **", ""))
            End With

            GetActivityLog_Button_Click(sender, e)

        End If
    End Sub

    Protected Sub GetActivityLog_Button_Click(sender As Object, e As EventArgs) Handles GetActivityLog_Button.Click

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

        With Activity_GridView

            .DataSource = HBSAcodeLibrary.ActivityLog.ActivityReport(FromDate, ToDate,
                                                               Activity_TextBox.Text,
                                                               Action_DropDownList.SelectedValue,
                                                               What_TextBox.Text)
            .DataBind()

        End With

        From_CalendarExtender.SelectedDate = FromDate
        To_CalendarExtender.SelectedDate = ToDate
        From_TextBox.Text = Format(From_CalendarExtender.SelectedDate, "dd MMM yyyy")
        To_TextBox.Text = Format(To_CalendarExtender.SelectedDate, "dd MMM yyyy")

    End Sub

    Protected Sub To_TextBox_TextChanged(sender As Object, e As EventArgs) Handles To_TextBox.TextChanged

    End Sub
End Class