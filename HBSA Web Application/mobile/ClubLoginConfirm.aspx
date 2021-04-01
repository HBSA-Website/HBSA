<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="ClubLoginConfirm.aspx.vb" Inherits="HBSA_Web_Application.ClubLoginConfirm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:HiddenField ID="clubIdHidden" runat="server" Visible="False"/>

    <h3>Registered Club login confirmation</h3>
     <asp:Label ID="statusLabel" runat="server" ForeColor="Blue">
        Enter your password, and if not prefilled, the confirmation code and click Confirm:<br />
            NOTE: There can only be one registration per club.</asp:Label>
    <br />

     <table>
        <tr>
            <td>Club name:</td>
            <td><asp:literal ID="clubNameLiteral" runat="server" ></asp:literal></td>
            <td><asp:Button ID="cancelButton" runat="server" Text="Cancel" /></td>
        </tr>
        <tr>
            <td>Email address:</td>
            <td><asp:Literal ID="email_Literal" runat="server"></asp:Literal></td>
        </tr>
        <tr>
            <td>Password:</td>
            <td><asp:TextBox ID="passwordTextBox" runat="server" TextMode="Password"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Confirmation Code:</td>
            <td><asp:TextBox ID="confirmTextBox" runat="server" ></asp:TextBox></td>
            <td><asp:Button ID="confirmButton" runat="server" Text="Confirm" /></td>
        </tr>
    </table>

</asp:Content>
