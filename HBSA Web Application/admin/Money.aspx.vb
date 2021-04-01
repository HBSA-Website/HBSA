Public Class Money
    Inherits System.Web.UI.Page
    Friend Enum MoneyCols
        Details
        AddPayment
        MarkPaid
        ClubID
        ClubName
        Reason
        State
        Amount
        Paid
        FineID
    End Enum

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Session("adminDetails") Is Nothing _
          OrElse Session("adminDetails").Rows.count = 0 Then

            Session("Caller") = Request.Url.AbsolutePath
            Response.Redirect("adminhome.aspx")

        End If

        If Not IsPostBack Then

            GetSummary()

        End If

    End Sub

    Protected Sub Owing_CheckBox_CheckedChanged(sender As Object, e As EventArgs) Handles Owing_CheckBox.CheckedChanged

        GetSummary()

    End Sub

    Sub GetSummary()

        With MoneySummary_GridView

            Using Money As New HBSAcodeLibrary.DebtsAndPayments(Owing_CheckBox.Checked, SummaryPaymentReason_DropDownList.SelectedValue)

                .DataSource = Money.moneySummary
                .DataBind()

                Export_Button.Visible = If(Money.moneySummary Is Nothing, False, Money.moneySummary.Rows.Count > 0)

                If Export_Button.Visible Then
                    Session("MoneySummary") = Money.moneySummary
                Else
                    .EmptyDataText = "No " & If(SummaryPaymentReason_DropDownList.SelectedValue = "", "debts/payments", SummaryPaymentReason_DropDownList.SelectedItem.Text) & " recorded."
                End If

            End Using

        End With

    End Sub

    Private Sub MoneySummary_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles MoneySummary_GridView.RowDataBound

        If e.Row.Cells.Count > 2 Then

            e.Row.Cells(MoneyCols.ClubID).Visible = False

            If e.Row.Cells.Count >= MoneyCols.FineID Then
                e.Row.Cells(MoneyCols.FineID).Visible = False
            End If

            If e.Row.RowType = DataControlRowType.DataRow Then

                'hide payment button if paid up
                If CDec(e.Row.Cells(MoneyCols.Amount).Text) <= CDec(e.Row.Cells(MoneyCols.Paid).Text.Replace("&nbsp;", 0)) Then
                    DirectCast((e.Row.Cells(MoneyCols.AddPayment).Controls(0)), WebControl).Enabled = False
                    e.Row.Cells(MoneyCols.AddPayment).Text = ""
                    DirectCast((e.Row.Cells(MoneyCols.MarkPaid).Controls(0)), WebControl).Enabled = False
                    e.Row.Cells(MoneyCols.MarkPaid).Text = ""
                Else
                    e.Row.Cells(MoneyCols.Paid).ForeColor = Drawing.Color.Red
                    e.Row.Cells(MoneyCols.State).ForeColor = Drawing.Color.Red
                End If

            End If

        End If

    End Sub

    Protected Sub SummaryPaymentReason_DropDownList_SelectedIndexChanged(sender As Object, e As EventArgs) _
        Handles SummaryPaymentReason_DropDownList.SelectedIndexChanged

        GetSummary()

    End Sub
    Private Sub MoneySummary_GridView_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles MoneySummary_GridView.RowDeleting

        'really mark as paid
        Try
            Dim FineID As Integer = MoneySummary_GridView.Rows(e.RowIndex).Cells(MoneyCols.FineID).Text
            Dim outStanding As Decimal = CDec(MoneySummary_GridView.Rows(e.RowIndex).Cells(MoneyCols.Amount).Text) _
                                         - CDec(MoneySummary_GridView.Rows(e.RowIndex).Cells(MoneyCols.Paid).Text.Replace("&nbsp;", 0))
            Dim clubID As Integer = MoneySummary_GridView.Rows(e.RowIndex).Cells(MoneyCols.ClubID).Text
            Dim reason As String = MoneySummary_GridView.Rows(e.RowIndex).Cells(MoneyCols.Reason).Text

            If outStanding <= 0 Then
                Status_Literal.Text = "There is no point marking paid with a zero amount outstanding."
                Exit Sub
            End If

            HBSAcodeLibrary.DebtsAndPayments.UpdatePayment(
                                    paymentID:=-1, 'negative indicates add a new payment
                                    clubID:=clubID,
                                    fineID:=FineID,
                                    paymentMethod:="Other",
                                    paymentReason:=reason,
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

        GetSummary()


    End Sub

    Private Sub MoneySummary_GridView_SelectedIndexChanging(sender As Object, e As GridViewSelectEventArgs) Handles MoneySummary_GridView.SelectedIndexChanging

        'identify grid view row
        Dim MoneySummaryRow As GridViewRow = MoneySummary_GridView.Rows(e.NewSelectedIndex)

        'show payment details

        Dim PaymentsList As DataTable

        Select Case MoneySummaryRow.Cells(MoneyCols.Reason).Text
            Case "League Entry Fee", "Competition Entry Fee"
                PaymentsList = HBSAcodeLibrary.DebtsAndPayments.PaymentsList(MoneySummaryRow.Cells(MoneyCols.ClubID).Text,
                                                                             MoneySummaryRow.Cells(MoneyCols.Reason).Text)

            Case "Fine"
                PaymentsList = HBSAcodeLibrary.Fines.PaymentsList(MoneySummaryRow.Cells(MoneyCols.ClubID).Text, MoneySummaryRow.Cells(MoneyCols.FineID).Text)

            Case Else
                PaymentsList = Nothing

        End Select

        PaymentsPanel_Literal.Text = "Payment&nbsp;Details&nbsp;for&nbsp;" & MoneySummaryRow.Cells(MoneyCols.Reason).Text
        Payments_GridView.DataSource = PaymentsList
        Payments_GridView.DataBind()
        Payments_Panel.Visible = True

        'show opportunity to add a payment unless it's fully paid up.
        AddPayment_Button.Visible = (CDec(MoneySummaryRow.Cells(MoneyCols.Amount).Text) > CDec(MoneySummaryRow.Cells(MoneyCols.Paid).Text))

        'Preserve club details for the button on the details dialogue
        Session("MoneyClubID") = CInt(MoneySummaryRow.Cells(MoneyCols.ClubID).Text)
        Session("MoneyClubName") = MoneySummaryRow.Cells(MoneyCols.ClubName).Text
        Session("MoneyFinesID") = CInt(MoneySummaryRow.Cells(MoneyCols.FineID).Text)
        Session("MoneyPaymentReason") = MoneySummaryRow.Cells(MoneyCols.Reason).Text
        Session("MoneyOwing") = CDec(MoneySummaryRow.Cells(MoneyCols.Amount).Text) - CDec(MoneySummaryRow.Cells(MoneyCols.Paid).Text)

        'we don't really want to select this gridview row
        e.Cancel = True

    End Sub

    Protected Sub PaymentsClose_Button_Click(sender As Object, e As EventArgs) Handles PaymentsClose_Button.Click
        Payments_Panel.Visible = False
    End Sub

    Private Sub MoneySummary_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles MoneySummary_GridView.RowEditing

        'identify grid view row
        Dim MoneySummaryRow As GridViewRow = MoneySummary_GridView.Rows(e.NewEditIndex)

        'Preserve club details for the button on the details dialogue
        Session("MoneyClubID") = CInt(MoneySummaryRow.Cells(MoneyCols.ClubID).Text)
        Session("MoneyClubName") = MoneySummaryRow.Cells(MoneyCols.ClubName).Text
        Session("MoneyFinesID") = CInt(MoneySummaryRow.Cells(MoneyCols.FineID).Text)
        Session("MoneyPaymentReason") = MoneySummaryRow.Cells(MoneyCols.Reason).Text
        Session("MoneyOwing") = CDec(MoneySummaryRow.Cells(MoneyCols.Amount).Text) - CDec(MoneySummaryRow.Cells(MoneyCols.Paid).Text)

        OfferDialogueToAddAPayment()

        'we don't really want to edit this gridview row
        e.Cancel = True


    End Sub

    Protected Sub OfferDialogueToAddAPayment()

        AddPayment_Literal.Text = "Add&nbsp;a&nbsp;payment&nbsp;for&nbsp;" & Session("MoneyClubName")
        DateTime__TextBox.Text = Format(HBSAcodeLibrary.Utilities.UKDateTimeNow(), "dd MMM yyyy hh:mm")
        PaymentMethod_DropDownList.SelectedIndex = 0
        PaymentReason_DropDownList.SelectedValue = Session("MoneyPaymentReason")
        AmountPaid_TextBox.Text = "" 'Format(Session("MoneyOwing"), "#0.00")
        Note_TextBox.Text = ""
        FineID_TextBox.Text = Session("MoneyFinesID")
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

        Try

            If CDec(AmountPaid_TextBox.Text) = 0 Then
                Status_Literal.Text = "There is no point adding a payment with a zero amount."
                Exit Sub
            End If

            HBSAcodeLibrary.DebtsAndPayments.UpdatePayment(
                                    paymentID:=-1, 'negative indicates add a new payment
                                    clubID:=Session("MoneyClubID"),
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

            GetSummary()

        Catch ex As Exception
            Status_Literal.Text = "ERROR, there was a problem saving this data.<br/>See below, if you can correct the problem, make any changes and try again.<br/>" &
                                  "Otherwise please contact us and supply the details below:<br/><br/>" & ex.Message
        End Try

    End Sub

End Class