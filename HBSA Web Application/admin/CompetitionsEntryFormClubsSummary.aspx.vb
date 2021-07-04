Public Class CompetitionsEntryFormClubsSummary
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
            OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        Else

            If Not IsPostBack Then
                State_DropDownList_SelectedIndexChanged(sender, e)
            End If

        End If

    End Sub

    Protected Sub State_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) Handles State_DropDownList.SelectedIndexChanged

        With EntryFormsClubs_GridView
            Dim EntryFormsSummaryTable As DataTable = HBSAcodeLibrary.CompetitionEntryFormData.ClubsSummaryReport(State_DropDownList.SelectedValue)
            Session("CompEntryFormsSummary") = EntryFormsSummaryTable
            .DataSource = EntryFormsSummaryTable
            .DataBind()
            Export_Button.Visible = EntryFormsSummaryTable.Rows.Count > 0
        End With

    End Sub

    Private Sub EntryFormsClubs_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles EntryFormsClubs_GridView.RowDataBound

        If e.Row.Cells.Count > 2 Then
            e.Row.Cells(2).Visible = False
        End If

    End Sub

    Private Sub EntryFormsClubs_GridView_SelectedIndexChanging(sender As Object, e As GridViewSelectEventArgs) Handles EntryFormsClubs_GridView.SelectedIndexChanging

        'show payment details
        Dim PaymentsList As DataTable = HBSAcodeLibrary.DebtsAndPayments.PaymentsList(EntryFormsClubs_GridView.Rows(e.NewSelectedIndex).Cells(2).Text, "Competition Entry Fee")

        PaymentsPanel_Literal.Text = "Payment&nbsp;Details&nbsp;for&nbsp;" & EntryFormsClubs_GridView.Rows(e.NewSelectedIndex).Cells(3).Text
        Payments_GridView.DataSource = PaymentsList
        Payments_GridView.DataBind()
        Payments_Panel.Visible = True

        'show opportunity to add a payment unless it's fully paid up.
        AddPayment_Button.Visible = (EntryFormsClubs_GridView.Rows(e.NewSelectedIndex).Cells(5).Text <> EntryFormsClubs_GridView.Rows(e.NewSelectedIndex).Cells(6).Text)

        'Preserve club details for the button on the details dialogue
        Session("SummaryReportClubID") = EntryFormsClubs_GridView.Rows(e.NewSelectedIndex).Cells(2).Text
        Session("SummaryReportClubName") = EntryFormsClubs_GridView.Rows(e.NewSelectedIndex).Cells(2).Text

        'we don't really want to select this gridview row
        e.Cancel = True

    End Sub

    Protected Sub PaymentsClose_Button_Click(sender As Object, e As EventArgs) Handles PaymentsClose_Button.Click

        Payments_Panel.Visible = False

    End Sub


    Private Sub EntryFormsClubs_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles EntryFormsClubs_GridView.RowEditing

        'offer dialogue to add a payment
        Session("SummaryReportClubID") = EntryFormsClubs_GridView.Rows(e.NewEditIndex).Cells(2).Text
        Session("SummaryReportClubName") = EntryFormsClubs_GridView.Rows(e.NewEditIndex).Cells(3).Text

        OfferDialogueToAddAPayment()

        'we don't really want to edit this gridview row
        e.Cancel = True


    End Sub

    Protected Sub OfferDialogueToAddAPayment()

        AddPayment_Literal.Text = "Add&nbsp;a&nbsp;payment&nbsp;for&nbsp;" & Session("SummaryReportClubName")
        DateTime__TextBox.Text = Format(HBSAcodeLibrary.Utilities.UKDateTimeNow(), "dd MMM yyyy hh:mm")
        PaymentMethod_DropDownList.SelectedIndex = 0
        PaymentReason_DropDownList.SelectedIndex = 0
        AmountPaid_TextBox.Text = "0.00"
        PaymentFee_TextBox.Text = "0.00"
        Note_TextBox.Text = ""
        TransactionID_TextBox.Text = ""
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

            If CDec(AmountPaid_TextBox.Text) = 0 AndAlso
               CDec(PaymentFee_TextBox.Text) = 0 Then
                Status_Literal.Text = "There is no point adding a payment with a zero amount and no fee."
                Exit Sub
            End If

            HBSAcodeLibrary.DebtsAndPayments.UpdatePayment(
                                    paymentID:=-1, 'negative indicates add a new payment
                                    clubID:=Session("SummaryReportClubID"),
                                    fineID:=0,
                                    paymentMethod:=PaymentMethod_DropDownList.SelectedValue,
                                    paymentReason:=PaymentReason_DropDownList.SelectedValue,
                                    amount:=CDec(AmountPaid_TextBox.Text),
                                    paymentFee:=CDec(PaymentFee_TextBox.Text),
                                    note:=Note_TextBox.Text.Trim,
                                    transactionID:=TransactionID_TextBox.Text.Trim,
                                    dateTimePaid:=CDate(DateTime__TextBox.Text),
                                    paidBy:=PaidBy_TextBox.Text.Trim,
                                    user:=Session("AdminUser")
                                                            )


            AddPayment_Panel.Visible = False

            State_DropDownList_SelectedIndexChanged(sender, e)

        Catch ex As Exception
            Status_Literal.Text = "ERROR, there was a problem saving this data.<br/>See below, if you can correct the problem, make any changes and try again.<br/>" &
                                  "Otherwise please contact us and supply the details below:<br/><br/>" & ex.Message
        End Try

    End Sub

End Class