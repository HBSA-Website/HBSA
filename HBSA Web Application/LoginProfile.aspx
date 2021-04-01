<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.LoginProfile" Codebehind="LoginProfile.aspx.vb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

           <div style="background-color: #CCFFCC; width:100%">
                <span style="font-family: Verdana; color:Green; font-size:9pt" >
                <br />
                <span style="color:red;">NOTE:</span> 
                    There may be a separate registration for each team in your club.
                    These can have the same email address but will have a different password for each team.<br /></span>
           </div>
    <br />
             <table style="width:auto; margin-right:auto; margin-left:auto; border:thin solid #006600; color: #006600; background:#CCFFCC">
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                League:</td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:DropDownList ID="League_DropDownList" runat="server" AutoPostBack="True">
                   
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                League section:</td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:DropDownList ID="Section_DropDownList" runat="server" Visible="False" 
                    AutoPostBack="True">
                    
                </asp:DropDownList>
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
               Club name:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:DropDownList ID="Club_DropDownList" runat="server" AutoPostBack="True" 
                    Visible="False">
                   
                </asp:DropDownList>
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Team Letter:</td>
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:DropDownList ID="Team_DropDownList" runat="server" Visible="False">
                </asp:DropDownList>
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Your first/preferred name:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="FirstName_TextBox" runat="server" BorderWidth="0px" Width="220px"></asp:TextBox></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Surname:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Surname_TextBox" runat="server" BorderWidth="0px" Width="220px"></asp:TextBox></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Telephone:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Telephone_TextBox" runat="server" BorderWidth="0px" Width="220px"></asp:TextBox></td>
        </tr>
                
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Your email address:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="email_TextBox" runat="server" BorderWidth="0px" Width="220px" Enabled="false"></asp:TextBox></td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
                Password:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="Password_TextBox" ClientIDMode="Static" runat="server" BorderWidth="0px" Width="220px" TextMode="Password"></asp:TextBox>
                <img title="Click to show password" alt="Click to show password" src="../images/EyeClosed.jpg" height="15"
                                                             onclick="showHidePassword(this,'Password_TextBox'); " />
            </td>
        </tr>
        <tr style="height:30px">
            <td style="border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; vertical-align: middle; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: right">
               Confirm password:</td>
            <td style=" border-right: #006600 1px solid; border-top: #006600 1px solid; font-size: 9pt; border-left: #006600 1px solid; color: #006600; border-bottom: #006600 1px solid; font-family: Verdana; text-align: left;">
                <asp:TextBox ID="ConfirmPassword_TextBox" ClientIDMode="Static" runat="server" BorderWidth="0px" Width="220px" TextMode="Password"></asp:TextBox>
                <img title="Click to show password" alt="Click to show password" src="../images/EyeClosed.jpg" height="15"
                                                             onclick="showHidePassword(this,'ConfirmPassword_TextBox'); " />

            </td>
        </tr>
        </table>

        <table style="width:auto; margin-right:auto; margin-left:auto;">

        <tr>
            <td colspan="3" style="width:480px">
                <asp:Label ID="Status_Label" runat="server" Text="" ForeColor="Blue"></asp:Label>
                <br />
            </td>
        </tr>
        <tr>
            <td><asp:Button ID="Return_Button" runat="server" Text="Return" Height="30px" Width="140px" /></td>
            <td><asp:Button ID="Register_Button" runat="server" Text="Save" Height="30px" Width="140px" /></td>
            <td><asp:Button ID="Delete_Button" runat="server" Text="Remove" Height="30px" Width="140px" /></td>
        </tr>
    </table>

</asp:Content>

