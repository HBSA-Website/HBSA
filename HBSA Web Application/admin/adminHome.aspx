<%@ Page Language="VB" MasterPageFile="adminMasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.adminHome" title="HBSA Web Admin" Codebehind="adminHome.aspx.vb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <h2 style="text-align:left ">Home</h2>

    <asp:Panel ID="LoggedIn_Panel" runat="server" ForeColor="#000099">
        <table style="text-align:left">
            <tr>
                <td>
                    <asp:Literal ID="Welcome_Literal" runat="server"></asp:Literal></td>
            </tr>
            <tr>
                <td>Please select an operation from the menu.</td>
            </tr>
        </table>
        
        <br />
    </asp:Panel>

    <asp:Panel ID="LoggedOut_Panel" runat="server" BorderStyle="Solid" BorderWidth="1px" BorderColor="Blue" ForeColor="#000099">
        <br />
        <table style="text-align:left; color:#000099">
            <tr>
                <td colspan="2">Please log in:</td>
            </tr>
            <tr>
                <td style="text-align:right">Enter your user name: </td><td><asp:TextBox ID="UserName_TextBox" runat="server" Width="130px" ></asp:TextBox></td>
            </tr>
            <tr>
                <td style="text-align:right">Enter your password: </td><td><asp:TextBox ID="Password_TextBox" ClientIDMode="Static" runat="server" TextMode="Password" Width="130px"></asp:TextBox>
                                                  <img title="Click to show password" alt="Click to show password" src="../images/EyeClosed.jpg" style="height:15px"
                                                       onmouseover="this.style.cursor='hand'"
                                                       onclick="showHidePassword(this,'Password_TextBox'); " />
                                              </td>
            </tr>
            <tr>
                <td><asp:Literal ID="Status_Literal" runat="server"></asp:Literal></td>
                <td><asp:Button ID="Login_Button" runat="server" Text="Log in" Width="130px" /></td>
            </tr>
            <tr><td colspan="2">To register a new administrator please contact an existing administrator and ask him/her to do it for you.</td></tr>
            <tr><td colspan="2">If you've forgotten your password please contact an existing administrator and ask him/her to change your password and inform you of the new password.</td></tr>
            <tr><td colspan="2">To change any of your administrator details log on then go to Admin >> Administrators.</td></tr>
        </table>
        <br />
        

    </asp:Panel>

</asp:Content>

