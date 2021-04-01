<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="ClubLogin.aspx.vb" Inherits="HBSA_Web_Application.ClubLogin1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h2>Club representative&#39;s login for entry forms and viewing fines</h2>

    <span style="color:red"><asp:Literal ID="status_Literal" runat="server" Mode="PassThrough"></asp:Literal></span>

    <asp:Panel ID="Login_Panel" DefaultButton="Login_Button" runat="server">

        Enter your Club Login credentials:

       <table>
        <tr>
            <td>Select your club:</td>
            <td>
                <asp:DropDownList ID="Club_DropdownList" runat="server" CssClass="textbox" AutoPostBack="true" style="max-width:700px"></asp:DropDownList></td>
        </tr>
        
        <tr>
            <td>Your Password:</td>
            <td>
                <asp:TextBox ID="password_TextBox" ClientIDMode="Static" runat="server" TextMode="Password"  CssClass="textbox"></asp:TextBox>
            </td>
        </tr>
        <tr style="height:30px">
        <td>&nbsp;</td>
        <td>
            <asp:Button ID="Login_Button" runat="server" Text="Log in" cssclass="button" Width="374px"/></td>
        </tr>

    </table>
        <br />
        <asp:Button ID="Password_Button" runat="server" CssClass="button" Text="Forgotten password" />
    <br />
        <br />
    <asp:Button ID="Profile_Button" runat="server" CssClass="button" Text="Change/Delete Registration" Width="1065px" />
    <br />
        Not logged in before?
        <br />
    <asp:Button ID="Register_Button" runat="server" CssClass="button" Text="Click here to register" />

    </asp:Panel>

       

</asp:Content>
