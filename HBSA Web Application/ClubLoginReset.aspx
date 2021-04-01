<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="ClubLoginReset.aspx.vb" Inherits="HBSA_Web_Application.ClubLoginReset" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="width:100%; text-align: center;" >
        <span style="font-family: Verdana; font-size:12pt;font-weight:600" >
        <br /><u>Club Login Password Reset</u><br />
        <br />
        Enter a new password, and confirm the password<br />
        Click Save (or Cancel to ignore this request).<br /></span>
    </div>
    <br />
    <%--<div style="text-align:center;">--%>
    <table style="width:auto; margin-left:auto; margin-right:auto; border-top-width: thin; border-left-width: thin; font-size: 11pt; 
                  border-left-color: #000000; border-bottom-width: thin; border-bottom-color: #000000;
                  color: #000000; border-top-color: #000000; font-family: Verdana; border-right-width: thin; 
                  border-right-color: #000000;">
        <tr style="height:30px">
            <td style="border-right: #000000 1px solid; border-top: #000000 1px solid; font-size: 9pt; vertical-align: middle; border-left: #000000 1px solid; color: #000000; border-bottom: #000000 1px solid; font-family: Verdana; text-align: right">Your email address:</td>
            <td runat="server" ID="Email_cell" style=" border-right: #000000 1px solid; border-top: #000000 1px solid; font-size: 9pt; border-left: #000000 1px solid; color: #000000; border-bottom: #000000 1px solid; font-family: Verdana; text-align: left;">            </td>
        </tr>
       <tr style="height:30px">
            <td style="border-right: #000000 1px solid; border-top: #000000 1px solid; font-size: 9pt; vertical-align: middle; border-left: #000000 1px solid; color: #000000; border-bottom: #000000 1px solid; font-family: Verdana; text-align: right">Club :</td>
            <td runat="server" ID="Club_cell" style="border-right: #000000 1px solid; border-top: #000000 1px solid; font-size: 9pt; border-left: #000000 1px solid; color: #000000; border-bottom: #000000 1px solid; font-family: Verdana; text-align: left;">
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #000000 1px solid; border-top: #000000 1px solid; font-size: 9pt; vertical-align: middle; border-left: #000000 1px solid; color: #000000; border-bottom: #000000 1px solid; font-family: Verdana; text-align: right">Password:</td>
            <td style=" border-right: #000000 1px solid; border-top: #000000 1px solid; font-size: 9pt; border-left: #000000 1px solid; color: #000000; border-bottom: #000000 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Password_TextBox" runat="server" BorderWidth="0px" Width="220px" TextMode="Password"></asp:TextBox>
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #000000 1px solid; border-top: #000000 1px solid; font-size: 9pt; vertical-align: middle; border-left: #000000 1px solid; color: #000000; border-bottom: #000000 1px solid; font-family: Verdana; text-align: right">Confirm password:</td>
            <td style=" border-right: #000000 1px solid; border-top: #000000 1px solid; font-size: 9pt; border-left: #000000 1px solid; color: #000000; border-bottom: #000000 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="ConfirmPassword_TextBox" runat="server" BorderWidth="0px" Width="220px" TextMode="Password"></asp:TextBox>
            </td>
        </tr>

    </table>
    <%--</div>--%>
    <input id="ClubID_Hidden" type="hidden" runat="server"/>

    <table style="width:auto; margin-left:auto; margin-right:auto;  border-top-width: thin; border-left-width: thin; font-size: 11pt; 
                  border-left-color: #006600; border-bottom-width: thin; border-bottom-color: #006600;
                  color: #006600; border-top-color: #006600; font-family: Verdana; border-right-width: thin; 
                  border-right-color: #006600;">
        <tr>
            <td colspan="2" style="width:480px;text-align:left;">
                <asp:Label ID="Status_Label" runat="server" 
                    Text=""
                    ForeColor="Blue"></asp:Label>
                <br /></td>
        </tr>
        <tr>
            <td style="text-align: center;">
                <asp:Button ID="Save_Button" runat="server" Text="Reset" Height="30px" Width="121px" />
            </td>
            <td style="text-align: center;">
                <asp:Button ID="Cancel_Button" runat="server" Text="Return" Height="30px" Width="121px" />
            </td>
        </tr>
    </table>

</asp:Content>
