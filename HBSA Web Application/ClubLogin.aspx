<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="ClubLogin.aspx.vb" Inherits="HBSA_Web_Application.ClubLogin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <asp:UpdateProgress runat="server" ID="loadingDiv">
        <ProgressTemplate>
            <div style="position: fixed; z-index: 1000; left: 46%; margin-top: 100px;">
                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
<ContentTemplate>

<asp:Panel DefaultButton="Login_Button" runat="server">

    <table style="width: auto; margin-left: auto; margin-right: auto;">
        <tr>
            <td style="text-align: center">
                <div style="font-family: Verdana; font-size: 12pt; color: DarkGrey; background-color: white;">
                    <h3>Club representative&#39;s login for entry forms and viewing fines</h3>
                </div>
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
                <div style="font-family: Verdana; font-size: 12pt; color: DarkGrey; background-color: white;">
                    <br />
                    Enter your Club Login credentials:<br />
                    <i><span style="font-size: smaller">NOTE: this is different from the team login, and is required for entry forms and paying fines.</span></i>
                    <br />
                    <br />

                    <table style="width: auto; margin-left: auto; margin-right: auto; color: #333333; vertical-align: middle; border-collapse: collapse;">
                        <tr>
                            <td style="font-size: 11pt; text-align: right;">Select your club:</td>
                            <td style="font-size: 11pt; text-align: left;" colspan="2">
                                <asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" Font-Size="12pt" AutoPostBack="true"></asp:DropDownList>
                                <%--<asp:TextBox ID="email_TextBox" runat="server" Width="220px" BackColor="#FFFFCC" Font-Size="12pt"></asp:TextBox>--%>
                            </td>
                        </tr>
                        <tr id="detailRow" runat="server" visible="false">
                            <td></td>
                            <td colspan="2" style="color: GrayText; font-style: italic; text-align: left;font-size:10pt;">
                                <asp:Literal ID="ClubDetail_Literal" runat="server"></asp:Literal>
                            </td>
                        </tr>
                        <tr id="passwordRow" runat="server" visible="false">
                            <td style="font-size: 11pt; text-align: right;">your password:</td>
                            <td style="font-size: 11pt; text-align: left;" colspan="2">
                                <asp:TextBox ID="password_TextBox" ClientIDMode="Static" runat="server" Width="230px" TextMode="Password" BackColor="#FFFFCC" Font-Size="12pt"></asp:TextBox>
                                <img title="Click to show password" alt="Click to show password" src="../images/EyeClosed.jpg" height="15"
                                    onclick="showHidePassword(this,'password_TextBox'); " />
                            </td>
                        </tr>
                        <tr id="loginRow" runat="server" visible="false" style="height: 30px">
                            <td></td>
                            <td style="text-align: left" colspan="2">
                                <asp:Button ID="Login_Button" runat="server" Text="Log in" Width="235px" Font-Size="12pt" Font-Bold="true" /></td>
                        </tr>
                        <tr>
                            <td style="text-align: center; font-size: 11pt;" colspan="2">
                                <asp:Literal ID="status_Literal" runat="server" Mode="PassThrough"></asp:Literal>
                            </td>
                        </tr>

                        <tr id="profileRow" runat="server" visible="false">
                            <td colspan="2" style="text-align:center;">
                                <asp:Button ID="Password_Button" runat="server" Text="Forgotten password"
                                    BorderStyle="None" Font-Underline="True"
                                    onmouseover="this.style.cursor='pointer'" Font-Size="11pt" ForeColor="Blue" BackColor="White" Width="300" />
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                                <asp:Button ID="Profile_Button" runat="server" BorderStyle="None" Font-Underline="True"
                                    onmouseover="this.style.cursor='pointer'" Text="Change/Delete Login" Font-Size="11pt" ForeColor="Blue" BackColor="White" Width="300" />
                            </td>
                        </tr>
                        <tr><td colspan="2">&nbsp;</td></tr>
                        <tr>
                            <td style="text-align:center; font-size:11pt;" colspan="2">
                                Not logged in before?  
                                <a href="ClubLoginRegistration.aspx" onmouseover="this.style.cursor='pointer'">Click here to register</a>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
    <br />
</asp:Panel>

</ContentTemplate>

    </asp:UpdatePanel>
</asp:Content>
