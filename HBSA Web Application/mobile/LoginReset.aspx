<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="LoginReset.aspx.vb" Inherits="HBSA_Web_Application.LoginReset1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <u><b>Team Login Password Reset</b></u><br />
        <br />Enter a new password, and again to confirm the password<br />
        then
        Click Reset (or Cancel to ignore this request).<br /><br />

    <table border="1">
        <tr>
            <td>Your&nbsp;email&nbsp;address:</td>
            <td runat="server" id="Email_cell">            </td>
        </tr>
       <tr>
            <td>Team :</td>
            <td runat="server" id="team_cell" >            </td>
        </tr>
        <tr>
            <td>Password:</td>
            <td>
                <asp:TextBox ID="Password_TextBox" runat="server" TextMode="Password"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>Confirm&nbsp;password:</td>
            <td>
                <asp:TextBox ID="ConfirmPassword_TextBox" runat="server" TextMode="Password"></asp:TextBox>
            </td>
        </tr>

    </table>

    <input id="UserID_Hidden" type="hidden" runat="server"/>

    <table>
        <tr>
            <td colspan="3">
                <asp:Label ID="Status_Label" runat="server" Text="" ForeColor="Blue"></asp:Label>
                <br /></td>
        </tr>
        <tr>
            <td style="text-align:right">
                <asp:Button ID="Save_Button" runat="server" Text="Reset" />
            </td>
            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td>
                <asp:Button ID="Cancel_Button" runat="server" Text="Return" />
            </td>
        </tr>
    </table>

</asp:Content>
