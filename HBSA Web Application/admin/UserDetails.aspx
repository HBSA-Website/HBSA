<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="UserDetails.aspx.vb" Inherits="HBSA_Web_Application.UserDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="text-align:left; width:100%">
        <h3>User Details</h3>


        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
    
            <div style="text-align:left; width:100%">
 
                  <table>
                      <tr>
                        <td>
                            <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                                <table style="text-align:left" >
                                    <tr>
                                        <td style="text-align:right">Select a user type:</td>
                                        <td>
                                            <asp:DropDownList ID="Type_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" Font-Bold="True" ForeColor="#CC0000" Font-Size="10pt">
                                                <asp:ListItem Value="Team" Text="Team" Selected="True" />
                                                <asp:ListItem Value="Club" Text="Club" />
                                            </asp:DropDownList>
                                        </td>
                                        <td style="text-align:right">Select a club:</td>
                                        <td>
                                            <asp:DropDownList ID="Clubs_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                            <asp:ListItem Value="0" Text="Any" Selected="True" /></asp:DropDownList>
                                        </td>
                                        <td style="text-align:right">Confirmed?:</td>
                                        <td>
                                            <asp:DropDownList ID="Confirmed_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                                <asp:ListItem Value="Both" Text="Both" Selected="True" />
                                                <asp:ListItem Value="Confirmed" Text="Confirmed only" />
                                                <asp:ListItem Value="UnConfirmed" Text="Un-confirmed only" />
                                            </asp:DropDownList>
                                        </td>

                                        <td>
                                            <asp:Button ID="GetReport_Button" runat="server" Text="Report" />
                                        </td>

                                        <td>
                                            <asp:Button ID="NewUser_Button" runat="server" Text="New User" />
                                        </td>
                                    </tr>
                                <tr id="Team_Row" runat="server" visible="true">
                                    <td style="text-align:right">Select a league:</td>
                                    <td>
                                        <asp:DropDownList ID="Leagues_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                        <asp:ListItem Value="0" Text="Any" Selected="True" /></asp:DropDownList>
                                    </td>
                                                                            <td style="text-align:right">Select a team:</td>
                                        <td>
                                            <asp:DropDownList ID="Team_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                                <asp:ListItem Value="" Text="Any" Selected="True" />
                                                <asp:ListItem Value="x" Text="(No team Letter)" />
                                                <asp:ListItem Value="A" Text="A" />
                                                <asp:ListItem Value="B" Text="B" />
                                                <asp:ListItem Value="C" Text="C" />
                                                <asp:ListItem Value="D" Text="D" />
                                                <asp:ListItem Value="E" Text="E" />
                                                <asp:ListItem Value="F" Text="F" />
                                            </asp:DropDownList>
                                        </td>
                                </tr>
                            </table>
                        </div>
                        </td>
                            </tr>
                        </table>
                    </div>

                     <br />
                               <asp:GridView ID="Users_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                        BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                        EmptyDataText="No users found that match the selected items">
                                    <Columns>
                                        <asp:CommandField InsertText="" NewText="" SelectText="" ShowDeleteButton="True" ShowEditButton="True" />
                                    </Columns>
                                    <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                                    <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                                    <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                              </asp:GridView>
    </div>

            </ContentTemplate>
        </asp:UpdatePanel>

        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>

   <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
            <div id="divEditUser" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF; top: 230px; ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divEditUser')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style= "font-size:11pt;
                                    border-right: #000080 1px solid; border-top: #000080 1px solid; 
                                    border-left: #000080 1px solid; border-bottom: #000080 1px solid; 
                                    background-image: url('../images/menuBarBG.gif');">
                            <strong><asp:Literal ID="EditPanel_Literal" runat="server" Text="Maintain&nbsp;|user type|&nbsp;User"></asp:Literal></strong></td>
                    </tr>
                </table>
                <input id="Password_Hidden" type="hidden" runat="server"/>
                <input id="UserID_Hidden" type="hidden" runat="server"/>
                <table 
                    style="font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td>
                            <div id="Div1" style="font-size:10pt; display:block; text-align: center;">
                                <br />
                                <asp:Literal ID="EditType_Literal" runat="server"><span style='color:red'>Change required details then click Submit or Cancel</span></asp:Literal>
                                <br />
                                    <br />
                                  <div style="width:100%; text-align:center;color:red;">
                                      <asp:Literal ID="Status_Literal" runat="server" Text=""></asp:Literal>
                                  </div>  

                                  <div>
                                <table>
                                 <tr>
                                     <th>Email</th><th>Password</th><th id="EditClubTeamHeader" runat="server">Club/Team</th>
                                 </tr>
                                 <tr>
                                     <td><asp:Textbox ID="EditEmail_Textbox" runat="server" BackColor="#FFFFCC" Width="186px"></asp:Textbox></td>
                                     <td style="text-align:center"><asp:Textbox ID="editPassword_textbox" ClientIDMode="Static" runat="server" BackColor="#FFFFCC" TextMode="Password"></asp:Textbox>
                                                        <img title="Click to show password" alt="Click to show password" src="../images/EyeClosed.jpg" height="15"
                                                             onclick="showHidePassword(this,'editPassword_textbox'); " />

                                     </td>
                                     <td style="text-align: center"><asp:DropdownList ID="editClubTeam_DropdownList" runat="server" BackColor="#FFFFCC"></asp:DropdownList></td>
                                 </tr>
                                 <tr>
                                     <td colspan="3" style="font-size:10pt;color:darkblue"><asp:CheckBox ID="editConfirmed_CheckBox" runat="server" Text="Confirmed?" Font-Bold="True" TextAlign="Left" /></td>

                                 </tr>
                                    <tr>
                                        <th>First Name</th><th>Surname</th><th>Telephone</th>
                                     </tr>
                                    <tr>
                                        <td><asp:TextBox ID="editForename_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="173px"></asp:TextBox></td>
                                        <td><asp:TextBox ID="editSurname_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="140px"></asp:TextBox></td>
                                        <td><asp:Textbox ID="editTelephone_Textbox" runat="server" BackColor="#FFFFCC"></asp:Textbox></td>
                                 </tr>
                               </table>
                                      <br />
                              <table  style="width:100%;">
                                 <tr>
                                    <td style="text-align:center">
                                        <asp:Button ID="editUser_Button" runat="server" Text="Submit" />
                                    </td>
                                    <td style="text-align:center">
                                        <asp:Button ID="CancelEdit_Button" runat="server" Text="Cancel" />
                                    </td>
                                 </tr>
                                    
                                </table>
                              </div>
                            </div>
                        </td>
                    </tr>
                </table>
        </div>
    </asp:Panel>


            </ContentTemplate>
        </asp:UpdatePanel>

    </div>
</asp:Content>
