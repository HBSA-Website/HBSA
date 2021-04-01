<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="LogIn.aspx.vb" Inherits="HBSA_Web_Application.LogIn1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h2>Team Login (for entering match results, and viewing fines)</h2>

    <span style="color:red"><asp:Literal ID="status_Literal" runat="server" Mode="PassThrough"></asp:Literal></span>

    <asp:Panel ID="Request_Panel" runat="server" Visible="false">

        <strong><asp:Literal ID="Request_Literal" runat="server" Text="Request&nbsp;Password&nbsp;Reset"></asp:Literal></strong>

        <table>
            <tr>
                <td>
                    <div>
                        <asp:Literal ID="Instruction_Literal" runat="server" Text="Enter your email address, select your team and click Submit, or Cancel"></asp:Literal>
                                
                        <table>
                            <tr>
                                <th colspan="4">Email</th>
                            </tr>
                            <tr>
                                <td colspan="4"><asp:TextBox ID="RequestEmail_TextBox" runat="server" CssClass="textbox"></asp:TextBox></td>
                             </tr>
                             <tr id="RequestPasswordHeader" runat="server" visible="false">
                                 <th colspan="4">Password</th>
                             </tr>
                             <tr id="RequestPassword" runat="server" visible="false">
                                 <td colspan="4"><asp:TextBox ID="RequestPassword_TextBox" ClientIDMode="Static" runat="server" TextMode="Password" CssClass="textbox"></asp:TextBox>
                                 </td>
                             </tr>
                             <tr id="RequestTeamHeader" runat="server" visible="false">
                                 <th colspan="4">Select a Team</th>
                             </tr>
                             <tr id="RequestTeam" runat="server" visible="false">
                                 <td colspan="4"><asp:DropDownList ID="RequestTeam_DropDownList" CssClass="dropDown" runat="server" ></asp:DropDownList></td>
                             </tr>
                         </table>
                         <br />
                         <table>
                            <tr>
                                <td style="text-align:center">
                                    <asp:Button ID="SubmitRequest_Button" runat="server" Text="Submit" CssClass="button" />
                                </td>
                                <td style="text-align:center">
                                    <asp:Button ID="CancelRequest_Button" runat="server" Text="Cancel"  CssClass="button" />
                                </td>
                            </tr>
                                    
                        </table>

                    </div>
                </td>
            </tr>
        </table>
  
    </asp:Panel>

    <asp:Panel ID="Login_Panel" DefaultButton="Login_Button" runat="server">

    <table>
    <tr>
        <td>
        Enter your Team Login credentials:

       <table>
        <tr>
            <td>Your email address:</td>
            <td>
                <asp:TextBox ID="email_TextBox" runat="server" CssClass="textbox"></asp:TextBox></td>
        </tr>
        
        <tr>
            <td>Your Password:</td>
            <td>
                <asp:TextBox ID="password_TextBox" ClientIDMode="Static" runat="server" TextMode="Password"  CssClass="textbox"></asp:TextBox>
            </td>
        </tr>
        <tr>
        <td>&nbsp;</td>
        <td>
            <br />
            <asp:Button ID="Login_Button" runat="server" Text="Log in" cssclass="button" Width="374px"/></td>
        </tr>

        <tr><td><br /><asp:Button ID="Password_Button"  runat="server"  CssClass="button" Text="Forgotten password" /></td></tr>
        <tr><td><br /><asp:Button ID="Profile_Button" runat="server"  CssClass="button" Text="Change/Delete Registration" /></td></tr>
        <tr><td colspan="2"><br /><asp:Button ID="Register_Button" runat="server" CssClass="button" Text="Register a new login" /></td></tr>

    </table>

        </td>

    </tr>

</table> 

    </asp:Panel>

       

</asp:Content>
