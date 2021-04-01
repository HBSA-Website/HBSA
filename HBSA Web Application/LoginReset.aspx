<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="LoginReset.aspx.vb" Inherits="HBSA_Web_Application.LoginReset" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="background-color: #CCFFCC; width:100%; text-align: center;" >
        <span style="font-family: Verdana; color:Green; font-size:12pt;font-weight:600" >
        <br /><u>Team Login Password Reset</u><br />
        <br />
        Enter a new password, and again to confirm the password<br />
        then
        Click Reset (or Cancel to ignore this request).<br /></span>
    </div>
    <br />
    <table style=" border: thin solid #006600; font-size: 11pt; color: #006600; background:#CCFFCC; width:auto; margin-left:auto; margin-right:auto; " >
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">Your email address:</td>
            <td runat="server" ID="Email_cell" style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">            </td>
        </tr>
       <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">Team :</td>
            <td runat="server" ID="team_cell" style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">Password:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Password_TextBox" runat="server" BorderWidth="0px" Width="220px" TextMode="Password"></asp:TextBox>
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">Confirm password:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="ConfirmPassword_TextBox" runat="server" BorderWidth="0px" Width="220px" TextMode="Password"></asp:TextBox>
            </td>
        </tr>

    </table>
    
    <input id="UserID_Hidden" type="hidden" runat="server"/>

    <table style="width:auto; margin-left:auto; margin-right:auto;">
        <tr>
            <td colspan="2" style="width:480px;">
                <asp:Label ID="Status_Label" runat="server" Text="" ForeColor="Blue"></asp:Label>
                <br /></td>
        </tr>
        <tr>
            <td style="text-align:center">
                <asp:Button ID="Save_Button" runat="server" Text="Reset" Height="30px" Width="121px" />
            </td>
            <td style="text-align:center">
                <asp:Button ID="Cancel_Button" runat="server" Text="Return" Height="30px" Width="121px" />
            </td>
        </tr>
    </table>

</asp:Content>
