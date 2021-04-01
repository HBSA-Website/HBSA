Public Class Fines1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Session("LoginCaller") = Request.Url.AbsolutePath

        If Session("ClubLoginID") Is Nothing Then

            If Session("teamID") Is Nothing Then

                If Not HBSAcodeLibrary.HBSA_Configuration.CloseSeason Then
                    Response.Redirect("Login.aspx")
                Else
                    Response.Redirect("ClubLogin.aspx")
                End If
            Else
                Using Teamdata As HBSAcodeLibrary.TeamData = New HBSAcodeLibrary.TeamData(Session("teamID"))
                    Session("ClubID") = Teamdata.ClubID
                End Using
            End If

        Else
            Session("ClubID") = Session("ClubLoginID")
        End If

        If Not IsPostBack Then

            GetFines()

        End If

    End Sub

    Sub GetFines()

        With Fines_GridView
            Dim FinesSummaryTable As DataTable = HBSAcodeLibrary.Fines.Summary(Owing_CheckBox.Checked, Session("ClubID"))
            Session("FinesSummary") = FinesSummaryTable
            .DataSource = FinesSummaryTable
            .DataBind()
            Export_Button.Visible = FinesSummaryTable IsNot Nothing AndAlso FinesSummaryTable.Rows.Count > 0
        End With

    End Sub

    Private Sub Fines_GridView_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles Fines_GridView.RowDataBound

        If e.Row.Cells.Count > 2 Then

            e.Row.Cells(2).Visible = False
            e.Row.Cells(6).Visible = False

            If e.Row.RowType = DataControlRowType.DataRow Then
                If e.Row.Cells(5).Text = "0.00" Then
                    DirectCast((e.Row.Cells(1).Controls(0)), WebControl).Enabled = False
                    e.Row.Cells(1).Text = ""
                End If

            End If
        End If

    End Sub

    Private Sub Fines_GridView_SelectedIndexChanging(sender As Object, e As GridViewSelectEventArgs) Handles Fines_GridView.SelectedIndexChanging

        'show payment details
        Dim PaymentsList As DataTable = HBSAcodeLibrary.Fines.PaymentsList(Fines_GridView.Rows(e.NewSelectedIndex).Cells(2).Text,
                                                                     Fines_GridView.Rows(e.NewSelectedIndex).Cells(6).Text)

        PaymentsPanel_Literal.Text = "Payment&nbsp;Details&nbsp;for&nbsp;" & Fines_GridView.Rows(e.NewSelectedIndex).Cells(3).Text
        Payments_GridView.DataSource = PaymentsList
        Payments_GridView.DataBind()
        Payments_Panel.Visible = True

        'show opportunity to add a payment unless it's fully paid up.
        'PayNow_Button.Visible = (Fines_GridView.Rows(e.NewSelectedIndex).Cells(5).Text <> Fines_GridView.Rows(e.NewSelectedIndex).Cells(6).Text)

        'Preserve club details for the button on the details dialogue
        Session("FinesClubName") = Fines_GridView.Rows(e.NewSelectedIndex).Cells(3).Text
        Session("FinesID") = Fines_GridView.Rows(e.NewSelectedIndex).Cells(6).Text

        'we don't really want to select this gridview row
        e.Cancel = True

    End Sub

    Protected Sub PaymentsClose_Button_Click(sender As Object, e As EventArgs) Handles PaymentsClose_Button.Click

        Payments_Panel.Visible = False

    End Sub

    'Private Sub Fines_GridView_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles Fines_GridView.RowEditing

    '    'Preserve club details for the button on the details dialogue
    '    Session("FinesClubName") = Fines_GridView.Rows(e.NewEditIndex).Cells(3).Text
    '    Session("FinesID") = Fines_GridView.Rows(e.NewEditIndex).Cells(6).Text
    '    Session("GridRowIndex") = e.NewEditIndex

    '    OfferDialogueToPay(Fines_GridView.Rows(e.NewEditIndex))

    '    'we don't really want to edit this gridview row
    '    e.Cancel = True

    'End Sub

    'Protected Sub OfferDialogueToPay(GridRow As GridViewRow)

    '    Offence_Literal.Text = GridRow.Cells(8).Text
    '    Comment_Literal.Text = GridRow.Cells(9).Text
    '    Fine_Literal.Text = Format(CDec(GridRow.Cells(4).Text), "#0.00")
    '    AmountToPay_TextBox.Text = Format(CDec(GridRow.Cells(5).Text), "#0.00")
    '    Note_TextBox.Text = ""
    '    Session("Description") = "Fine payment for " & GridRow.Cells(3).Text & "(FinesID = " & GridRow.Cells(6).Text & ")"
    '    Session("FineID") = CInt(GridRow.Cells(6).Text)

    '    PayPal_Button0.Visible = CDec(GridRow.Cells(5).Text) > 0

    '    AddPayment_Panel.Visible = True

    'End Sub

    'Protected Sub AddPaymentClose_Button_Click(sender As Object, e As EventArgs) Handles AddPaymentClose_Button.Click
    '    AddPayment_Panel.Visible = False
    'End Sub

    'Protected Sub PayNow_Button_Button_Click(sender As Object, e As EventArgs) Handles PayNow_Button.Click

    '    OfferDialogueToPay(Fines_GridView.Rows(Session("GridRowIndex")))
    '    PaymentsClose_Button_Click(sender, e)

    'End Sub

    'Protected Sub PayPal_Button_Click(sender As Object, e As ImageClickEventArgs) Handles PayPal_Button0.Click

    '    Dim amount As Decimal
    '    Try
    '        amount = CDec(AmountToPay_TextBox.Text)
    '    Catch ex As Exception
    '        amount = 0
    '    End Try

    '    If amount <= 0 Then

    '        Status_Literal.Text = "Amount to pay must be a valid monetary value greater than zero."

    '    Else

    '        If amount > CDec(Fine_Literal.Text) Then

    '            Status_Literal.Text = "Amount to pay must be less than or equal to the fine.."

    '        Else
    '            'Request to pay via PayPal
    '            Session("PaymentID") = dbClasses.PayPalCredentials.nextPaymentID(Session("ClubID"))    'get next paymentID
    '            Session("PaymentReason") = "Fine"
    '            Session("payment_amt") = CDec(AmountToPay_TextBox.Text)

    '            dbClasses.ActivityLog.LogActivity("calling PayPalCheckout", Session("FineID"), Session("Description"))
    '            Response.Redirect("PayPalCheckOut.aspx")

    '        End If

    '    End If

    'End Sub

    Protected Sub Owing_CheckBox_CheckedChanged(sender As Object, e As EventArgs) Handles Owing_CheckBox.CheckedChanged

        GetFines()

    End Sub
End Class