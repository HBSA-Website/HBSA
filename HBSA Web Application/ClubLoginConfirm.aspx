<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="ClubLoginConfirm.aspx.vb" Inherits="HBSA_Web_Application.ClubLoginConfirm" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:Label ID="ClubID_Label" runat="server" Text=" " Visible="false"/>

    <div style="background-color:white">
    
    <h3>Registered Club login confirmation</h3>
    <span style="font-family: Verdana; color:DarkGrey; font-size:11pt" >
        Enter your password, and if not prefilled, the confirmation code and click Confirm:<br />
            NOTE: There can only be one registration per club.<br /></span>
           </div>
    <br />

    <table style="width:auto; margin-left:auto; margin-right:auto; border-top-width: thin; border-left-width: thin; font-size: 11pt; 
                  border-left-color: #333333; border-bottom-width: thin; border-bottom-color: #333333;
                  color: #333333; border-top-color: #333333; font-family: Verdana; border-right-width: thin; 
                  border-right-color: #333333;">
        <tr style="height:30px">
            <td style="border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; vertical-align: middle; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: right">
               Club name:</td>
            <td style=" border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: left;">
                <asp:literal ID="ClubName_Literal" runat="server" ></asp:literal></td>
            <td><asp:Button ID="Cancel_Button" runat="server" Text="Cancel" Height="25px" Width="121px" /></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; vertical-align: middle; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: right">
                Email address:</td>
            <td style=" border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: left;">
                <asp:Literal ID="email_Literal" runat="server"></asp:Literal></td>
        </tr>
        <tr id="PasswordRow" runat="server" style="height:30px">
            <td style="border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; vertical-align: middle; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: right">
                Password:</td>
            <td style=" border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Password_TextBox" runat="server" BorderWidth="0px" Width="220px" TextMode="Password"></asp:TextBox></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; vertical-align: middle; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: right">
                Confirmation Code:</td>
            <td style="border-right: #333333 1px solid; border-top: #333333 1px solid; font-size: 9pt; border-left: #333333 1px solid; color: #333333; border-bottom: #333333 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Confirm_TextBox" runat="server" BorderWidth="0px" 
                    Width="220px" ></asp:TextBox></td>
        <td>
            <asp:Button ID="Confirm_Button" runat="server" Text="Confirm" Height="25px" Width="121px" /></td>
        </tr>
        <tr>
        <td colspan="3" style="text-align:center; width:480px">
            <asp:Label ID="Status_Label" runat="server" 
                       ForeColor="Blue"></asp:Label></td>
        </tr>
    </table>


</asp:Content>
