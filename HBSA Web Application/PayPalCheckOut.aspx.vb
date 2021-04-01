Public Class PayPalCheckout
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim PayPal As New HBSAcodeLibrary.PayPalFunctions.NVPAPICaller()
        Dim retMsg As String = ""
        Dim token As String = ""

        HBSAcodeLibrary.ActivityLog.LogActivity("in PayPalCheckout", Session("FineID"), Session("payment_amt"))
        If Session("payment_amt") IsNot Nothing Then

            Dim ret As Boolean = PayPal.StartExpressCheckout(Format(Session("payment_amt"), "#0.00").ToString(), CInt(Session("PaymentID")), token, retMsg, Session("Description"))
            If ret Then
                HBSAcodeLibrary.ActivityLog.LogActivity("redirecting to " & retMsg, Session("FineID"), token)

                Session("token") = token
                Response.Redirect(retMsg)
            Else
                Response.Redirect("PayPalAPIError.aspx?ErrorCode=ExpressCheckOutFailure&desc=" & retMsg.Replace(vbCrLf, "~|~"))
            End If
        Else
            Response.Redirect("PayPalAPIError.aspx?ErrorCode=AmtMissing")
        End If

    End Sub

End Class