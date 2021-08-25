<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="SMTPTester.aspx.vb" Inherits="HBSA_Web_Application.SMTPTester" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .table-style {
            border-style: solid;
            border-width: 1px;
            padding: 25px;
        }
        .BigCheckBox input {
            width: 20px;
            height: 20px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div>
        <h1>SMTP Tester<br />
        </h1>

    </div>
    <table class="table-style">
        <tr>
            <td><strong>SMTP Item</strong></td>
            <td><strong>Value</strong></td>
        </tr>
        <tr>
            <td>From Address</td>
            <td>
                <asp:TextBox ID="From_TextBox" runat="server" Width="620px">website@huddersfieldsnooker.com</asp:TextBox>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>Reply To Address</td>
            <td>
                <asp:TextBox ID="ReplyTo_TextBox" runat="server" Width="620px">webmaster@huddersfieldsnooker.com</asp:TextBox>
            </td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>To Address</td>
            <td>
                <asp:TextBox ID="To_TextBox" runat="server" Width="620px">petegilbert7@gmail.com</asp:TextBox>
            </td>
            <td>Separate muliple addresses with semi-colon (;)</td>
        </tr>
        <tr>
            <td>cc Address</td>
            <td>
                <asp:TextBox ID="cc_TextBox" runat="server" Width="620px"></asp:TextBox></td>
            <td>Leave blank for no cc</td>
        </tr>
        <tr>
            <td>SMTP Server Name</td>
            <td>
                <asp:TextBox ID="SMTPServer_TextBox" runat="server" Width="620px">huddersfieldsnooker.com</asp:TextBox></td>
            <td>Uses setting with HBSACodeLibrary</td>
        </tr>
        <tr>
            <td>SMTP Username</td>
            <td>
                <asp:TextBox ID="SMTPUser_TextBox" runat="server" Width="620px">website@huddersfieldsnooker.com</asp:TextBox></td>
            <td>Uses setting with HBSACodeLibrary</td>
        </tr>
        <tr>
            <td>SMTP Password</td>
            <td>
                <asp:TextBox ID="SMTP_PWord_TextBox" runat="server" Width="620px">Sn00ker1</asp:TextBox></td>
            <td>Uses setting with HBSACodeLibrary</td>
        </tr>
        <tr>
            <td>SMTP SSL/TSL</td>
            <td>
                <asp:CheckBox ID="SMTP_SSL_CheckBox" CssClass="BigCheckBox" runat="server" Text="&nbsp;" Checked="true" /></td>
            <td>Uses setting with HBSACodeLibrary</td>
        </tr>
        <tr>
            <td>SMTP Port number</td>
            <td>
                <asp:TextBox ID="SMTP_Port_TextBox" runat="server" Width="80px">587</asp:TextBox></td>
            <td>Uses setting with HBSACodeLibrary</td>
        </tr>
        <tr>
            <td></td>
        </tr>
        <tr>
            <td>Subject</td>
            <td>
                <asp:TextBox ID="Subject_TextBox" runat="server" Width="620px">Testing SMTP client</asp:TextBox></td>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>Message Body</td>
            <td colspan="2">
                <asp:TextBox ID="Message_TextBox" runat="server" Width="1000px" Height="90px" TextMode="MultiLine"></asp:TextBox></td>
        </tr>
        <tr>
            <td></td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td colspan="2">
                <asp:Button ID="SenddotNET_Button" runat="server" Text="Send using System.Net.Mail.SmtpClient" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="SendMailkit_Button" runat="server" Text="Send using MailKit.Net.Smtp.SmtpClient" />
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="SendViaLibrary_Button" runat="server" Text="Send using the HBSA Code Library email sender" />
                <asp:Button ID="Retry_Button" runat="server" Text="Set up tp try again" Visible="false" />
            </td>
        </tr>
    </table>
    <br />
    <span style="color: red">
        <asp:Literal ID="Status_Literal" runat="server"></asp:Literal></span>

</asp:Content>
