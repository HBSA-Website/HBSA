<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="Administrators.aspx.vb" Inherits="HBSA_Web_Application.Administrators" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h3>Maintain Administrators</h3>


        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
    
            <div style="text-align:left; width:100%">
 
                  <table>
                      <tr>
                        <td>
                            <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                                            <asp:Button ID="NewAdministrator_Button" runat="server" Text="New Administrator" />
                        </div>
                        </td>
                            </tr>
                        </table>
                    </div>

                     <br />
                               <asp:GridView ID="Administrators_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                                        BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                                        EmptyDataText="No Administrators found that match the selected items">
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

   <%--<asp:Panel ID="Edit_Panel" runat="server" Visible="false">--%>
            <div id="divEditAdministrator" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF; left: 200px; top: 230px; 
                                   display:none;" runat="server">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divEditAdministrator')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style= "font-size:11pt;
                                    border-right: #000080 1px solid; border-top: #000080 1px solid; 
                                    border-left: #000080 1px solid; border-bottom: #000080 1px solid; 
                                    background-image: url('../images/menuBarBG.gif');">
                            <strong><asp:Literal ID="EditPanel_Literal" runat="server" Text="Maintain&nbsp;Administrator"></asp:Literal></strong></td>
                    </tr>
                </table>

                <input id="editPassword_Hidden" type="hidden" runat="server"/>

                <table style="padding:4px; border-spacing:4px; font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td>
                            <div id="Div1" style="font-size:10pt; display:block; text-align: center;">
                                <br />
                                <asp:Literal ID="editType_Literal" runat="server"><span style='color:red'>Change required details then click Submit or Cancel</span></asp:Literal>
                                <br />
                                    <br />
                                  <div style="width:100%; text-align:center;color:red;">
                                      <asp:Literal ID="editStatus_Literal" runat="server" Text=""></asp:Literal>
                                  </div>  

                                  <div>
                                <table>
                                 <tr>
                                     <th>User name</th><th>Password</th><th>Function</th>
                                 </tr>
                                 <tr>
                                     <td><asp:Textbox ID="editUsername_textbox" runat="server" BackColor="#FFFFCC" Width="186px"></asp:Textbox></td>
                                     <td><asp:Textbox ID="editPassword_textbox" ClientIDMode="Static" runat="server" TextMode="Password" BackColor="#FFFFCC" Width="186px"></asp:Textbox>
                                                        <img title="Click to show password" alt="Click to show password" src="../images/EyeClosed.jpg" height="15"
                                                             onclick="showHidePassword(this,'editPassword_textbox'); " />

                                     </td>
                                     <td><asp:Textbox ID="editFunction_Textbox" runat="server" BackColor="#FFFFCC" Width="186px"></asp:Textbox></td>
                                 </tr>
                                    <tr>
                                        <th>First Name</th><th>Surname</th><th>Email</th>
                                     </tr>
                                    <tr>
                                        <td><asp:TextBox ID="editForename_TextBox" runat="server" BackColor="#FFFFCC" Width="186px"></asp:TextBox></td>
                                        <td><asp:TextBox ID="editSurname_TextBox" runat="server" BackColor="#FFFFCC" Width="186px"></asp:TextBox></td>
                                        <td><asp:Textbox ID="editEmail_Textbox" runat="server" BackColor="#FFFFCC" Width="186px"></asp:Textbox></td>
                                 </tr>
                                 <tr><td></td></tr>
                                 <tr>
                                    <td style="text-align:center" colspan="2">
                                        <asp:Button ID="editAdministrator_Button" runat="server" Text="Submit" />
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
    <%--</asp:Panel>--%>


            </ContentTemplate>
        </asp:UpdatePanel>


</asp:Content>
