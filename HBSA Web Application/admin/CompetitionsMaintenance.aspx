<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="CompetitionsMaintenance.aspx.vb" Inherits="HBSA_Web_Application.CompetitionsMaintenance" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input type="hidden" name="_ButtonClicked" id="_ButtonClicked" value="" />

    <div style="text-align:left; ">
        <h3>Competitions</h3>
        <br />
        <table>
            <tr>
                <td>
                     <asp:Button ID="Add_Button" runat="server" Text="Add New Competition" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="ClearAll_Button" runat="server" Text="Clear all Competitions" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="AllowEntryForms_Button" runat="server" Text="Allow Competitions Entry Forms" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:GridView ID="Competitions_GridView" runat="server"  
                        EnableModelValidation="True" Font-Size="9pt" Width="100%" BackColor="White" BorderColor="#E7E7FF" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3"
                        DataKeyNames="ID" AllowSorting="True" EmptyDataText="No data found">
                        <Columns>
                            <asp:TemplateField></asp:TemplateField>
                        </Columns>
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                    </asp:GridView>

                </td>
            </tr>
        </table>

        <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
            <div id="divEditCompetition" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   top: 180px; left:50px; 
                                   ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divEditCompetition')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="EditPanel_Literal" runat="server" Text="Competition"></asp:Literal></strong></td>
                    </tr>
                </table>
                <table style="font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td>
                            <div id="Div1" style="display:block; text-align: left;">
                                <asp:Literal ID="Edit_Literal" runat="server">Enter competition details here and submit them. These will be recorded in the system.</asp:Literal><br/><br/>

                              <div>
                                <table>
                                    <tr>
                                        <th>ID</th><th>Competition Name</th><th>League</th><th>Type</th><th>Comment</th>
                                     </tr>
                                    <tr style="vertical-align:top;">
                                        <td><asp:TextBox ID="ID_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="32px"></asp:TextBox></td>
                                        <td><asp:TextBox ID="Name_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:left;" Width="180px"></asp:TextBox></td>
                                        <td><asp:DropDownList ID="League_DropDownList" runat="server" BackColor="#FFFFCC" style="text-align:left;" Width="140px"></asp:DropDownList></td>
                                        <td><asp:DropDownList ID="Type_DropDownList" runat="server" BackColor="#FFFFCC" style="text-align:left;" Width="140px">
                                                    <asp:ListItem Value="0">**Select**</asp:ListItem>
                                                    <asp:ListItem Value="1">Open</asp:ListItem>
                                                    <asp:ListItem Value="2">Handicaps</asp:ListItem>
                                                    <asp:ListItem Value="3">Pairs</asp:ListItem>
                                                    <asp:ListItem Value="4">Teams</asp:ListItem>
                                            </asp:DropDownList>
                                            <br /><br />
                                            <asp:CheckBox ID="EntryForm_CheckBox" runat="server" Text="EntryForm Required?" TextAlign="Left" />
                                            &nbsp;&nbsp;&nbsp;&nbsp;Entry Fee £ <asp:TextBox ID="EntryFee_TextBox" runat="server" Width="30px" MaxLength="5" />&nbsp;&nbsp;&nbsp;&nbsp;

                                        </td>
                                        <td><asp:TextBox ID="Comment_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:left;" Width="267px" Height="64px" TextMode="MultiLine"></asp:TextBox></td>
                                 </tr>
                               </table>
                                      <br />
                              <table  style="width:100%;">
                                 <tr>
                                    <td style="text-align:center">
                                        <asp:Button ID="CancelCompetition_Button" runat="server" Text="Cancel" />
                                    </td>
                                    <td style="text-align:center">
                                        <asp:Button ID="SubmitCompetition_Button" runat="server" Text="Submit" />
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

        <asp:Panel ID="Delete_Panel" runat="server" Visible="false">
            <div id="divDeleteCompetition" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   width:540px; top: 180px; left:50px; 
                                   ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divDeleteCompetition')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="DeletePanel_Literal" runat="server" Text="Remove&nbsp;Competition"></asp:Literal></strong></td>
                    </tr>
                </table>
                <table style="font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td>
                            <div id="Div3" style="display:block; text-align: left;">
                                <asp:Literal ID="Delete_Literal" runat="server"></asp:Literal><br/><br/>

                              <div>
                                      <br />
                              <table  style="width:100%;">
                                 <tr>
                                    <td style="text-align:center">
                                        <asp:Button ID="Delete_Button" runat="server" Text="Remove" />
                                    </td>
                                    <td style="text-align:center">
                                        <asp:Button ID="CancelDelete_Button" runat="server" Text="Cancel" />
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
    
    </div>

</asp:Content>
