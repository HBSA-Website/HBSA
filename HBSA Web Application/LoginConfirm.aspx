<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.LoginConfirm" Codebehind="LoginConfirm.aspx.vb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

            <div style="text-align:center; " class="auto-style3">
                <h3><asp:Literal ID="Header_Literal" runat="server">Team Representative's Login Confirmation</asp:Literal></h3>
            </div>

    <div style="font-family: Verdana; color:blue; font-size:11pt; width:100%;" >
        <table style="width:auto; margin-left:auto; margin-right:auto;">
            <tr>
                <td colspan="3">Enter your details and click Confirm:</td>
            </tr>
            <tr>
                <td></td>
                <td>NOTE:</td>
                <td>You will need a separate registration for each team in your club.</td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td>These can have the same email address but will need a different password for each team. 
                    <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Therefore, ensure you enter the correct team letter for the password.</td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td>You cannot use the same email address more than once for a particular team.</td>
            </tr>
        </table>

    <br />
    <table style="width:auto; margin-left:auto; margin-right:auto; background:#ccffcc;: 1px solid #000000">
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Your email address:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="email_TextBox" runat="server" BorderWidth="0px" Width="220px"></asp:TextBox></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Password:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Password_TextBox" runat="server" BorderWidth="0px" Width="220px" TextMode="Password"></asp:TextBox></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
               Club name:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="ClubName_TextBox" runat="server" BorderWidth="0px" 
                    Width="220px" Enabled="False"></asp:TextBox></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Team Letter:</td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="TeamLetter_TextBox" runat="server" BorderWidth="0px" 
                    Width="220px" Enabled="False"></asp:TextBox>
            </td>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
               League:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="League_TextBox" runat="server" BorderWidth="0px" 
                    Width="220px" Enabled="False"></asp:TextBox></td>
            <td><asp:Button ID="Cancel_Button" runat="server" Text="Cancel" Height="25px" Width="121px" /></td>
        </tr>
        <tr>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                League section:</td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Section_TextBox" runat="server" BorderWidth="0px" 
                    Width="220px" Enabled="False"></asp:TextBox>
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Confirmation Code:</td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Confirm_TextBox" runat="server" BorderWidth="0px" 
                    Width="220px" ></asp:TextBox></td>
        <td>
            <asp:Button ID="Confirm_Button" runat="server" Text="Confirm" Height="25px" Width="121px" /></td>
        </tr>
        <tr>
        <td colspan="3" style="width:480px">
            <asp:Label ID="Status_Label" runat="server" 
                       ForeColor="Blue"></asp:Label></td>
        </tr>
    </table>

    </div>
    
</asp:Content>

