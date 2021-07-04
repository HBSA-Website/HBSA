Imports HBSAcodeLibrary.PayPalFunctions

Public Class PayPalConfirm
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'First call: get PayPal checkout details and show them for approval
        If Not IsPostBack Then

            Dim test As New NVPAPICaller()

            Dim retMsg As String = ""
            Dim token As String = ""
            Dim finalPaymentAmount As String = ""
            Dim payerId As String = ""
            Dim decoder As NVPCodec = New NVPCodec()

            token = Request.Params("token") 'Session("token").ToString()
            payerId = Request.Params("payerID") ' Session("payerId").ToString()
            finalPaymentAmount = Format(Session("payment_amt"), "#0.00").ToString()

            Dim ret As Boolean = test.GetDetails(token, decoder, retMsg)

            If ret Then

                Dim TransactionId As String = decoder("PAYMENTINFO_0_TRANSACTIONID")

                Dim amt As String = Format(Session("payment_amt"), "#0.00").ToString() 'decoder("PAYMENTINFO_0_AMT")

                ' our payment ID returned
                Dim PaymentID As Integer = CInt(decoder("INVNUM"))
                ' Payee's name & email
                Session("PaymentID") = PaymentID

                Dim PaidBy As String = decoder("FIRSTNAME") & " " & decoder("LASTNAME")
                Dim PayeeID As String = decoder("EMAIL")
                If Not PayeeID Is Nothing AndAlso Not PayeeID = "" Then
                    PaidBy += " (" & PayeeID & ")"
                End If
                Session("PaidBy") = PaidBy

                Amount_Literal.Text = Format(CDec(amt), "0.00")
                PaymentID_Literal1.Text = PaymentID

                If CStr(Session("PaymentReason")).ToLower Like "*competition*" Then

                    Using Comp As New HBSAcodeLibrary.CompetitionEntryFormData(Session("ClubID"))

                        Club_Literal.Text = Comp.ClubName
                        FullAmount_Literal.Text = Format(Comp.EntryFormFee, "0.00")

                    End Using

                ElseIf CStr(Session("PaymentReason")).ToLower Like "*fine*" Then

                    Using Fine As New HBSAcodeLibrary.Fines(Session("FineID"))

                        Club_Literal.Text = Fine.ClubName
                        FullAmount_Literal.Text = Format(Fine.Amount, "0.00")

                    End Using

                ElseIf CStr(Session("PaymentReason")).ToLower Like "*entry*" Then

                    Using Comp As New HBSAcodeLibrary.EntryFormData(Session("ClubID"))

                        Club_Literal.Text = Comp.ClubName
                        FullAmount_Literal.Text = Format(Comp.EntryFormFee + Comp.TeamFees, "0.00")

                    End Using

                End If

                Confirm_Panel.Visible = True
                Paid_Panel.Visible = False

            Else

                Response.Redirect("PayPalAPIError.aspx?ErrorCode=GetDetailsFailure&desc=" & retMsg.Replace(vbCrLf, "~|~"))

            End If

        End If

    End Sub

    Protected Sub Confirm_Button_Click(sender As Object, e As EventArgs) Handles Confirm_Button.Click


        'If PaymentOption = "PayPal" Then
        Dim test As New NVPAPICaller()

        Dim retMsg As String = ""
        Dim token As String = ""
        Dim finalPaymentAmount As String = ""
        Dim payerId As String = ""
        Dim decoder As NVPCodec = New NVPCodec()

        token = Session("token").ToString() 'Request.Params("token")
        payerId = Request.Params("payerID") ' Session("payerId").ToString()
        finalPaymentAmount = Format(Session("payment_amt"), "#0.00").ToString()

        Dim ret As Boolean = test.ConfirmPayment(finalPaymentAmount, token, payerId, decoder, retMsg)
        If ret Then
            ' Unique transaction ID of the payment. Note: If the PaymentAction of the request was Authorization or Order, this value is your AuthorizationID for use with the Authorization & Capture APIs. 
            Dim TransactionId As String = decoder("PAYMENTINFO_0_TRANSACTIONID")

            'Dim status As String = decoder("PAYMENTINFO_0_PAYMENTSTATUS")
            'Dim pending As String = decoder("PAYMENTINFO_0_PENDINGREASON")

            ' The type of transaction Possible values: l cart l express-checkout 
            'Dim transactionType As String = decoder("PAYMENTINFO_0_TRANSACTIONTYPE")

            ' Indicates whether the payment is instant or delayed. Possible values: l none l echeck l instant 
            'Dim paymentType As String = decoder("PAYMENTINFO_0_PAYMENTTYPE")

            ' Time/date stamp of payment 
            Dim orderTime As String = decoder("PAYMENTINFO_0_ORDERTIME")

            ' The final amount charged, including any shipping and taxes from your Merchant Profile. 
            Dim amt As String = decoder("PAYMENTINFO_0_AMT")

            ' A three-character currency code for one of the currencies listed in PayPay-Supported Transactional Currencies. Default: USD. 
            'Dim currencyCode As String = decoder("PAYMENTINFO_0_CURRENCYCODE")

            ' PayPal fee amount charged for the transaction 
            Dim feeAmt As String = decoder("PAYMENTINFO_0_FEEAMT")

            ' Amount deposited in your PayPal account after a currency conversion. 
            'Dim settleAmt As String = decoder("PAYMENTINFO_0_SETTLEAMT")

            ' Tax charged on the transaction. 
            'Dim taxAmt As String = decoder("PAYMENTINFO_0_TAXAMT")

            '' Exchange rate if a currency conversion occurred. Relevant only if your are billing in their non-primary currency. If 
            'Dim exchangeRate As String = decoder("PAYMENTINFO_0_EXCHANGERATE")

            Dim PaymentID As Integer = Session("PaymentID")
            Dim PaidBy As String = Session("PaidBy")

            'update payment details
            HBSAcodeLibrary.DebtsAndPayments.UpdatePayment(
                                    Session("ClubID"),
                                    Session("FineID"),
                                    "PayPal",
                                    Session("PaymentReason"),
                                    CDec(amt),
                                    CDec(feeAmt),
                                    Note_TextBox.Text.Trim,
                                    TransactionId,
                                    orderTime,
                                    PaidBy,
                                    If(Session("user") Is Nothing, Session("AdminUser"), Session("user")),
                                    PaymentID
                                    )

            Paid_Literal.Text = Format(CDec(amt), "0.00")
            PaymentID_Literal.Text = PaymentID
            TransactionID_Literal.Text = TransactionId

            If CStr(Session("PaymentReason")).ToLower Like "*competition*" Then

                Using Comp As New HBSAcodeLibrary.CompetitionEntryFormData(Session("ClubID"))

                    Club_Literal.Text = Comp.ClubName
                    FullAmount_Literal.Text = Format(Comp.EntryFormFee, "0.00")
                    If Comp.EntryFormFee - Comp.AmountPaid > 0 Then
                        Outstanding_Literal.Text = "<span style='color:red;'>The amount left to pay is &pound;" & Format(Comp.EntryFormFee - Comp.AmountPaid, "0.00") & "</span>"
                    Else
                        Outstanding_Literal.Text = "The entry fee is fully paid."
                    End If
                    Payments_gridview.DataSource = Comp.Payments
                    Payments_gridview.DataBind()

                End Using

            ElseIf CStr(Session("PaymentReason")).ToLower Like "*fine*" Then

                Using Fine As New HBSAcodeLibrary.Fines(Session("FineID"))

                    Club_Literal.Text = Fine.ClubName
                    FullAmount_Literal.Text = Format(Fine.Amount, "0.00")
                    If Fine.Amount - Fine.AmountPaid > 0 Then
                        Outstanding_Literal.Text = "<span style='color:red;'>The amount left to pay is &pound;" & Format(Fine.Amount - Fine.AmountPaid, "0.00") & "</span>"
                    Else
                        Outstanding_Literal.Text = "The fine is fully paid."
                    End If
                    Payments_gridview.DataSource = Fine.Payments
                    Payments_gridview.DataBind()

                End Using

            ElseIf CStr(Session("PaymentReason")).ToLower Like "*league*" Then

                Using TeamEntry As New HBSAcodeLibrary.EntryFormData(Session("ClubID"))

                    Club_Literal.Text = TeamEntry.ClubName
                    FullAmount_Literal.Text = Format(TeamEntry.EntryFormFee + TeamEntry.ClubFee, "0.00")
                    If TeamEntry.ClubFee + TeamEntry.TeamFees - TeamEntry.AmountPaid > 0 Then
                        Outstanding_Literal.Text = "<span style='color:red;'>The amount left to pay is &pound;" & Format(TeamEntry.ClubFee + TeamEntry.TeamFees - TeamEntry.AmountPaid, "0.00") & "</span>"
                    Else
                        Outstanding_Literal.Text = "The entry fee is fully paid."
                    End If
                    Payments_gridview.DataSource = TeamEntry.Payments
                    Payments_gridview.DataBind()

                End Using


            End If

            'set up receipt print area
            TodaysDate_Receipt_Literal.Text = Format(HBSAcodeLibrary.Utilities.UKDateTimeNow(), "dd MMM yyyy")
            PaidBy_Receipt_Literal.Text = PaidBy
                ClubName_Receipt_Literal.Text = Club_Literal.Text
                Amount_Receipt_Literal.Text = Paid_Literal.Text
                PaymentID_Receipt_Literal.Text = PaymentID

                Confirm_Panel.Visible = False
                Paid_Panel.Visible = True

            Else
                Response.Redirect("PayPalAPIError.aspx?ErrorCode=ConfirmPaymentFailure&desc=" & retMsg.Replace(vbCrLf, "~|~"))
        End If
        'End If


    End Sub

    Private Sub Payments_gridview_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Payments_gridview.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.Cells.Count > 3 Then
                e.Row.Cells(3).Text = Context.Server.HtmlDecode(e.Row.Cells(3).Text)
            End If
        End If
    End Sub

End Class