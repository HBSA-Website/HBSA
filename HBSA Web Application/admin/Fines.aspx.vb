Public Class Fines
    Inherits System.Web.UI.Page
    Friend Enum FinesCols
        Details
        AddPayment
        MarkPaid
        ClubID
        ClubName
        Fine
        Outstanding
        FineID
        DateImposed
        Offence
        Comment
    End Enum

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
          OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        End If

        If Not IsPostBack Then

            populate_Clubs()
            GetFines()

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
            .Items.Insert(0, New ListItem("**All Clubs**", 0))
            .SelectedIndex = 0
        End With

    End Sub

    Protected Sub Owing_CheckBox_CheckedChanged(sender As Object, e As EventArgs) _
        Handles Owing_CheckBox.CheckedChanged,
                Clubs_DropDownList.SelectedIndexChanged

        GetFines()

    End Sub

    Sub GetFines()

        With Fines_GridView
            Dim FinesSummaryTable As DataTable = HBSAcodeLibrary.Fines.Summary(Owing_CheckBox.Checked, Clubs_DropDownList.SelectedValue)
            Session("FinesSummary") = FinesSummaryTable
            .DataSource = FinesSummaryTable
            .DataBind()
            Export_Button.Visible = FinesSummaryTable IsNot Nothing AndAlso FinesSummaryTable.Rows.Count > 0
        End With

    End Sub

    Private Sub Fines_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Fines_GridView.RowDataBound

        If e.Row.Cells.Count >= FinesCols.ClubID Then

            e.Row.Cells(FinesCols.ClubID).Visible = False
            e.Row.Cells(FinesCols.FineID).Visible = False

            If e.Row.RowType = DataControlRowType.DataRow Then
                If CDec(e.Row.Cells(FinesCols.Outstanding).Text) <= 0 Then
                    DirectCast((e.Row.Cells(FinesCols.AddPayment).Controls(0)), WebControl).Enabled = False
                    DirectCast((e.Row.Cells(FinesCols.MarkPaid).Controls(0)), WebControl).Enabled = False
                    e.Row.Cells(FinesCols.AddPayment).Text = ""
                    e.Row.Cells(FinesCols.MarkPaid).Text = ""
                Else
                    e.Row.Cells(FinesCols.Outstanding).ForeColor = Drawing.Color.Red
                End If

            End If
        End If

    End Sub
    Private Sub Fines_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) _
        Handles Fines_GridView.RowDeleting  'not deleting, but marking as paid

        Try

            Dim FineID As Integer = Fines_GridView.Rows(e.RowIndex).Cells(FinesCols.FineID).Text
            Dim outStanding As Decimal = CDec(Fines_GridView.Rows(e.RowIndex).Cells(FinesCols.Outstanding).Text)
            Dim clubID As Integer = Fines_GridView.Rows(e.RowIndex).Cells(FinesCols.ClubID).Text

            If outStanding <= 0 Then
                Status_Literal.Text = "There is no point marking paid with a zero amount outstanding."
                Exit Sub
            End If

            HBSAcodeLibrary.DebtsAndPayments.UpdatePayment(
                                    paymentID:=-1, 'negative indicates add a new payment
                                    clubID:=clubID,
                                    fineID:=FineID,
                                    paymentMethod:="Other",
                                    paymentReason:="Fine",
                                    amount:=outStanding,
                                    paymentFee:=0,
                                    note:="Marked paid",
                                    transactionID:=FineID,
                                    dateTimePaid:=HBSAcodeLibrary.Utilities.UKDateTimeNow(),
                                    paidBy:="Mark Paid",
                                    user:=Session("user"))
        Catch ex As Exception
            Status_Literal.Text = "ERROR, there was a problem saving this.<br/>" &
                                  "Please contact us and supply the details below:<br/><br/>" & ex.Message
        End Try

        e.Cancel = True

        GetFines()

    End Sub

    Private Sub Fines_GridView_SelectedIndexChanging(sender As Object, e As GridViewSelectEventArgs) _
        Handles Fines_GridView.SelectedIndexChanging

        'show payment details

        Dim PaymentsList As DataTable = HBSAcodeLibrary.Fines.PaymentsList(Fines_GridView.Rows(e.NewSelectedIndex).Cells(FinesCols.ClubID).Text,
                                                                           Fines_GridView.Rows(e.NewSelectedIndex).Cells(FinesCols.FineID).Text)

        PaymentsPanel_Literal.Text = "Payment&nbsp;Details&nbsp;for&nbsp;" & Fines_GridView.Rows(e.NewSelectedIndex).Cells(FinesCols.ClubName).Text
        Payments_GridView.DataSource = PaymentsList
        Payments_GridView.DataBind()
        Payments_Panel.Visible = True

        'show opportunity to add a payment unless it's fully paid up.
        AddPayment_Button.Visible = (Fines_GridView.Rows(e.NewSelectedIndex).Cells(FinesCols.Fine).Text <>
                                     Fines_GridView.Rows(e.NewSelectedIndex).Cells(FinesCols.Outstanding).Text)
        'add warning about rescinding a fine if payments have been made
        If PaymentsList.Rows.Count > 0 Then
            Rescind_Literal.Text = "WARNING: If this fine is rescinded ALL payments assigned to it will be discarded."
        Else
            Rescind_Literal.Text = ""
        End If
        'Preserve club details for the button on the details dialogue
        Session("ClubID") = Fines_GridView.Rows(e.NewSelectedIndex).Cells(FinesCols.ClubID).Text
        Session("FinesClubName") = Fines_GridView.Rows(e.NewSelectedIndex).Cells(FinesCols.ClubName).Text
        Session("FinesID") = Fines_GridView.Rows(e.NewSelectedIndex).Cells(FinesCols.FineID).Text

        'we don't really want to select this gridview row
        e.Cancel = True

    End Sub

    Protected Sub PaymentsClose_Button_Click(sender As Object, e As EventArgs) Handles PaymentsClose_Button.Click

        Payments_Panel.Visible = False

    End Sub

    Private Sub Fines_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles Fines_GridView.RowEditing

        'Preserve club details for the button on the details dialogue
        Session("ClubID") = Fines_GridView.Rows(e.NewEditIndex).Cells(FinesCols.ClubID).Text
        Session("FinesClubName") = Fines_GridView.Rows(e.NewEditIndex).Cells(FinesCols.ClubName).Text
        Session("FinesID") = Fines_GridView.Rows(e.NewEditIndex).Cells(FinesCols.FineID).Text

        OfferDialogueToAddAPayment()

        'we don't really want to edit this gridview row
        e.Cancel = True


    End Sub

    Protected Sub OfferDialogueToAddAPayment()

        AddPayment_Literal.Text = "Add&nbsp;a&nbsp;payment&nbsp;for&nbsp;" & Session("FinesClubName")
        DateTime__TextBox.Text = Format(HBSAcodeLibrary.Utilities.UKDateTimeNow(), "dd MMM yyyy hh:mm")
        PaymentMethod_DropDownList.SelectedIndex = 0
        PaymentReason_DropDownList.SelectedValue = "Fine"
        AmountPaid_TextBox.Text = "0.00"
        Note_TextBox.Text = ""
        FineID_TextBox.Text = Session("FinesID")
        FineID_TextBox.Enabled = False
        PaidBy_TextBox.Text = ""
        Status_Literal.Text = ""

        AddPayment_Panel.Visible = True

    End Sub

    Protected Sub AddPaymentClose_Button_Click(sender As Object, e As EventArgs) Handles AddPaymentClose_Button.Click
        AddPayment_Panel.Visible = False
    End Sub

    Protected Sub AddPayment_Button_Click(sender As Object, e As EventArgs) Handles AddPayment_Button.Click

        OfferDialogueToAddAPayment()
        PaymentsClose_Button_Click(sender, e)

    End Sub

    Protected Sub AddThisPayment_Button_Click(sender As Object, e As EventArgs) Handles AddThisPayment_Button.Click

        'add payment details entered in add a payment panel

        If PaymentMethod_DropDownList.SelectedIndex < 1 Then
            Status_Literal.Text = "Please select a payment method"
            Exit Sub
        End If

        Try

            If CDec(AmountPaid_TextBox.Text) = 0 Then
                Status_Literal.Text = "There is no point adding a payment with a zero amount."
                Exit Sub
            End If

            HBSAcodeLibrary.DebtsAndPayments.UpdatePayment(
                                    paymentID:=-1, 'negative indicates add a new payment
                                    clubID:=Session("ClubID"),
                                    fineID:=CInt(FineID_TextBox.Text), 'FinesID
                                    paymentMethod:=PaymentMethod_DropDownList.SelectedValue,
                                    paymentReason:=PaymentReason_DropDownList.SelectedValue,
                                    amount:=CDec(AmountPaid_TextBox.Text),
                                    paymentFee:=0,
                                    note:=Note_TextBox.Text.Trim,
                                    transactionID:=FineID_TextBox.Text.Trim,
                                    dateTimePaid:=CDate(DateTime__TextBox.Text),
                                    paidBy:=PaidBy_TextBox.Text.Trim,
                                    user:=Session("user")
                                                            )


            AddPayment_Panel.Visible = False

            GetFines()

        Catch ex As Exception
            Status_Literal.Text = "ERROR, there was a problem saving this data.<br/>See below, if you can correct the problem, make any changes and try again.<br/>" &
                                  "Otherwise please contact us and supply the details below:<br/><br/>" & ex.Message
        End Try

    End Sub

    Protected Sub Fine_Button_Click(sender As Object, e As EventArgs) Handles Fine_Button.Click

        'populate clubs
        With FineImposeClub_DropDownList

            Dim ClubsList As DataTable = HBSAcodeLibrary.ClubData.GetClubs(0)

            .Items.Clear()

            .DataSource = ClubsList
            .DataTextField = "Club Name"
            .DataValueField = "ID"
            .DataBind()

            .Items.Insert(0, New ListItem("**Select a Club**", "-1"))

        End With

        FineImposeAmount_TextBox.Text = "0.00"
        FineImposeComment_TextBox.Text = ""
        FineImposeOffence_TextBox.Text = ""
        FineImpose_Button.Text = "Impose the fine"
        FineImpose_Button.Visible = True
        FineImpose_Literal.Text = ""

        ImposeFine_Panel.Visible = True

    End Sub

    Protected Sub FineImposeCancel_Button_Click(sender As Object, e As EventArgs) Handles FineImposeCancel_Button.Click

        ImposeFine_Panel.Visible = False

    End Sub


    Protected Sub FineImpose_Button_Click(sender As Object, e As EventArgs) Handles FineImpose_Button.Click

        Dim errMsg As String = ""
        Dim FineAmount As Decimal

        If FineImposeClub_DropDownList.SelectedIndex < 1 Then
            errMsg += "<br />A club must be selected"
        End If
        If FineImposeOffence_TextBox.Text.Trim = "" Then
            errMsg += "<br />An offence must be recorded"
        End If

        Try
            FineAmount = CDec(FineImposeAmount_TextBox.Text)
            If FineAmount < 0.01 Then
                errMsg += "<br />An amount must be a positive decimal number greater than zero"
            End If
        Catch ex As Exception
            errMsg += "<br />An amount must be a valid decimal number"
        End Try

        If errMsg <> "" Then

            FineImpose_Literal.Text = "Please correct the following error(s), then try again." + errMsg
            FineImpose_Button.Text = "Impose the fine"
            FineImpose_Button.Visible = True

        Else


            If FineImpose_Button.Text = "Impose the fine" Then

                FineImpose_Literal.Text = "<span style='color:darkgreen;'>You are about to impose the fine shown above. Click 'Confirm' to impose it and send out the emails.</span>"
                FineImpose_Button.Text = "Confirm"

            Else
                'impose the fine
                Dim EmailAdressList As String = ""

                Try

                    'add the fine 
                    EmailAdressList =
                        HBSAcodeLibrary.Fines.ImposeFine(FineImposeClub_DropDownList.SelectedValue,
                                                   FineImposeOffence_TextBox.Text.Trim,
                                                   FineImposeComment_TextBox.Text.Trim,
                                                   CDec(FineImposeAmount_TextBox.Text))
                    FineImpose_Literal.Text = "Fine imposed and recorded."

                    'reshow fines summary
                    GetFines()

                Catch ex As Exception
                    FineImpose_Literal.Text = "Error imposing the fine: " & ex.Message
                End Try

                If FineImpose_Literal.Text = "Fine imposed and recorded." Then

                    'email all interested parties
                    FineImpose_Literal.Text = HBSAcodeLibrary.Emailer.SendFineImposedEmail(
                                                                       EmailAdressList,
                                                                       FineImposeClub_DropDownList.SelectedItem.Text,
                                                                       FineImposeOffence_TextBox.Text.Trim,
                                                                       FineImposeComment_TextBox.Text.Trim,
                                                                       CDec(FineImposeAmount_TextBox.Text))
                    If FineImpose_Literal.Text <> "" Then
                        FineImpose_Literal.Text = "<span style='color:darkgreen;'>Fine imposed and recorded.</span>" & FineImpose_Literal.Text
                    Else
                        FineImpose_Literal.Text = "<span style='color:darkgreen;'>Fine imposed and recorded.<br/> Emails sent to all interested parties.</span>"
                    End If

                End If

                FineImpose_Button.Visible = False

            End If

        End If

    End Sub

    Protected Sub Rescind_Button_Click(sender As Object, e As EventArgs) Handles Rescind_Button.Click

        HBSAcodeLibrary.Fines.RescindFine(Session("FinesID"), True)
        GetFines()

        Payments_Panel.Visible = False

    End Sub

    Protected Sub Remove_Button_Click(sender As Object, e As EventArgs) Handles Remove_Button.Click

        With Fines_GridView
            From_CalendarExtender.SelectedDate = .Rows(.Rows.Count - 1).Cells(FinesCols.DateImposed).Text
            To_CalendarExtender.SelectedDate = .Rows(0).Cells(FinesCols.DateImposed).Text
        End With
        From_TextBox.Text = Format(From_CalendarExtender.SelectedDate, "dd MMM yyyy")
        To_TextBox.Text = Format(To_CalendarExtender.SelectedDate, "dd MMM yyyy")

        RemoveFines_Literal.Text = "Choose start and end dates then click Remove to delete ALL fines <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;and payments between, and including, those dates."
        RemoveFines_Button.Text = "Remove"
        Remove_Panel.Visible = True

    End Sub

    Protected Sub RemoveFines_Button_Click(sender As Object, e As EventArgs) Handles RemoveFines_Button.Click

        If RemoveFines_Button.Text = "Remove" Then
            RemoveFines_Button.Text = "Confirm"
            RemoveFines_Literal.Text = "To delete ALL fines and payments listed here, between and including, these dates<br />" &
                                       "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;click Confirm."
        Else

            For Each FineRow As GridViewRow In Fines_GridView.Rows
                If CDate(FineRow.Cells(FinesCols.DateImposed).Text) >= CDate(From_TextBox.Text) AndAlso
                    CDate(FineRow.Cells(FinesCols.DateImposed).Text) <= CDate(To_TextBox.Text) Then

                    HBSAcodeLibrary.Fines.RescindFine(FineRow.Cells(FinesCols.FineID).Text, True)

                End If
            Next

            GetFines()
            RemoveFines_Button.Text = "Remove"
            Remove_Panel.Visible = False
        End If

    End Sub
    Protected Sub CancelRemoveFines_Button_Click(sender As Object, e As EventArgs) Handles CancelRemoveFines_Button.Click

        Remove_Panel.Visible = False

    End Sub

End Class