<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="LoginConfirm.aspx.vb" Inherits="HBSA_Web_Application.LoginConfirm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="SmallHeader">
        Team Representative's Login Confirmation for:<br />
        <asp:Literal ID="nameLiteral" runat="server" Text="" /> of (
        <asp:Literal ID="EmailAddressLiteral" runat="server" Text="" />) of 
        <asp:Literal ID="teamLiteral" runat="server" Text="" /> in the
        <asp:Literal ID="leagueLiteral" runat="server" Text="" /> league.
    </div>

    <asp:Label ID="statusLabel" runat="server" ForeColor="Blue">
        <span style="font-size:smaller;font-style:italic;" >Enter your password and confirmation code (if not prefilled) then click Confirm:</span>
    </asp:Label>
    
 
    <table>
        <tr>
            <td>Password:</td>
            <td><asp:TextBox ID="passwordTextBox" runat="server" TextMode="Password"></asp:TextBox></td>
        </tr>
        <tr>
            <td>Confirmation&nbsp;Code:</td>
            <td><asp:TextBox ID="confirmTextBox" runat="server" ></asp:TextBox></td>
            
        </tr>
        <tr><td></td><td></td></tr>
        <tr> 
            <td><asp:Button ID="cancelButton" runat="server" Text="Cancel" /></td>
            <td><asp:Button ID="confirmButton" runat="server" Text="Confirm" /></td>
        </tr>

    </table>

    <span style="color:blue;font-style:italic;font-size:smaller;";>    NOTE: 
        <ul>
            <li>You will need a separate registration for each team in your club.</li> 
            <li>These can have the same email address but will need a different password for each team. </li>
            <li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Therefore, ensure you enter the correct team letter for the password.</li>
            <li>You cannot use the same email address more than once for a particular team.</li>
        </ul>
    </span>
</asp:Content>
