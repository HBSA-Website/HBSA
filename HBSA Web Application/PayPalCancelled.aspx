<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="PayPalCancelled.aspx.vb" Inherits="HBSA_Web_Application.PayPalCancelled" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <p>
        PayPal Cancelled.</p>
    <p>
        &nbsp;</p>
    <p>
        Your PayPal transaction did not complete.<br />
        <br />
        This can be caused by several things.  For example clicking cancel, insufficient PayPal funds, credit card authorisation failure (PayPal will have already stated this), session timeout etc.&nbsp; It is recommended that you check the account that you used to try and pay us.&nbsp; If funds have left your account for this transaction, please contact us immediately when we will rectify the problem.<br /><br />
        If circumtances have changed you can return to the Entry Form, or Fine Payment, and try again if you wish (you may have to click Submit again in order to pay).</p>
</asp:Content>
