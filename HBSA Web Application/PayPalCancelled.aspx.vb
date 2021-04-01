Imports HBSAcodeLibrary.PayPalFunctions

Public Class PayPalCancelled
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'If PaymentOption = "PayPal" Then
        Dim test As New NVPAPICaller()

        Dim retMsg As String = ""
        Dim token As String = ""
        Dim finalPaymentAmount As String = ""
        Dim payerId As String = ""
        'Dim decoder As NVPCodec

        token = Request.Params("token")
        payerId = Request.Params("payerID") ' Session("payerId").ToString()
        'finalPaymentAmount = Session("payment_amt").ToString()


    End Sub

End Class