<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="Leagues.aspx.vb" Inherits="HBSA_Web_Application.Leagues" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
           <div style="text-align:left; width:100%">
        <h3>Leagues Maintenance</h3>
               <%--        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="1000">
                <ProgressTemplate>Processing, please wait a moment...</ProgressTemplate></asp:UpdateProgress>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>--%>
                <div style="text-align:left;">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="Add_Button" runat="server" Text="Add New League" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <a href="BreaksCategories.aspx">Click here to maintain Breaks Categories for High Breaks awards.</a>
                    <br />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <span style="color:red"><asp:Literal ID="Err_Literal" runat="server"></asp:Literal></span>
                     <br />
                    &nbsp;
                    <asp:GridView ID="Leagues_GridView" runat="server"  
                        Font-Size="9pt" BackColor="White" BorderColor="#E7E7FF" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3"
                        EmptyDataText="No Leagues found" HeaderStyle-HorizontalAlign="Center">
                        <Columns>
                            <asp:CommandField ShowDeleteButton="True"
                                              ShowCancelButton="False" 
                                              ShowEditButton="True" />
                        </Columns>
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" HorizontalAlign="Left" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                    </asp:GridView>

      <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
            <div id="divEditClub" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   width:440px; top: 160px; left:100px;
                                   ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divEditClub')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="EditPanel_Literal" runat="server" Text="League&nbsp;Details"></asp:Literal></strong></td>
                    </tr>
                </table>
                <table 
                    style="font-size:9pt; vertical-align: top;">
                    <tr>
                        <td colspan="5">
                                <div id="Div1" style="display:block; text-align: left;">
                                <br />
                                    <div style="text-align:center; font-size: 10pt; color: #000099;">
                                        <asp:Literal ID="Edit_Literal" runat="server"></asp:Literal><br/><br/>
                                    </div>
                                    <div style="width:100%; font-style:italic">
                                      <asp:TextBox ID="ID_TextBox" runat="server" width="0" Visible="false"></asp:TextBox>
                                        Note:  enter 'No Limit' (or just 'no') in a handicap box if there is no limit
                                  </div>  

                                  <div>
                                <table style="text-align:center">
                                    <tr>
                                        <th>League&nbsp;Name</th><th>Max Handicap</th><th>Min Handicap</th>
                                    </tr>
                                    <tr>
                                        <td><asp:TextBox ID="LeagueName_TextBox" runat="server" CssClass="txtBox" style="text-align:center;"></asp:TextBox></td>
                                        <td><asp:TextBox ID="MaxHandicapTextBox" runat="server" CssClass="txtBox" style="text-align:center;" Width="80px" /></td>
                                        <td><asp:TextBox ID="MinHandicapTextBox" runat="server" CssClass="txtBox" style="text-align:center;" Width="80px" /></td>
                                    </tr>

                               </table>
                                      <br />
                              <table  style="width:100%;">
                                 <tr>
                                    <td style="text-align:center">
                                        <asp:Button ID="Submit_Button" runat="server" Text="Submit" />
                                    </td>
                                    <td style="text-align:center">
                                        <asp:Button ID="Cancel_Button" runat="server" Text="Cancel" />
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
               <%--    </ContentTemplate>
        </asp:UpdatePanel>--%>

    </div>

</asp:Content>
