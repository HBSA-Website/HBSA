<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="Teams.aspx.vb" Inherits="HBSA_Web_Application.Teams" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="text-align:left; width:100%">
        <h3>Teams Maintenance</h3>
        
        <asp:ScriptManager ID="ScriptManager1" runat="server"> </asp:ScriptManager>
        <asp:UpdateProgress ID="UpdateProgress1" runat="server" DisplayAfter="1000">
                <ProgressTemplate>Processing, please wait a moment...</ProgressTemplate></asp:UpdateProgress>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div style="text-align:left;">
                     <table style="text-align:left" > 
                            <tr>
                                <td style="text-align:right">Select a division/section or league:</td>
                                <td>
                                    <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" />
                                </td>
                                <td> <span style="font-weight: bold; font-size: medium;">OR</span> </td>
                                <td><asp:Button ID="Add_Button" runat="server" Text="Add New Team" /></td>
                            </tr>
                         <tr>
                             <td></td>
                             <td>
                                 <asp:Button ID="SequenceTeams_Button" runat="server" Text="Sequence the teams" BackColor="White" BorderStyle="None" 
                                             CssClass="normal" Font-Underline="True" Visible="false" onmouseover="this.style.cursor='pointer';" /></td>
                             <td></td>
                             <td><a href="ArrangeTeamsInSections.aspx">Arrange Teams in Sections</a></td>
                         </tr>
                        </table>
                   <span style="color:red"><asp:Literal ID="Err_Literal" runat="server"></asp:Literal></span>
                    <asp:GridView ID="Teams_GridView" runat="server" Font-Size="9pt" BackColor="White" BorderColor="#E7E7FF" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3"
                        DataKeyNames="ID" EmptyDataText="No data found" HeaderStyle-HorizontalAlign="Left">
                        <Columns>
                            <asp:CommandField ShowDeleteButton="True" CausesValidation="False" InsertVisible="False" ShowCancelButton="False" ShowEditButton="True" DeleteText="Remove" />
                        </Columns>
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" HorizontalAlign="Left" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                    </asp:GridView>

      <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
            <div id="divEditTeam" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   top: 274px; left:100px;
                                   ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divEditTeam')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="EditPanel_Literal" runat="server" Text="Team&nbsp;Details"></asp:Literal></strong></td>
                    </tr>
                </table>
                <table 
                    style="font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td colspan="5">
                                <div id="Div1" style="display:block; text-align: left;">
                                <br />
                                    <div style="width:100%; text-align:center; font-size: 10pt; color: #000099;">
                                        <asp:Literal ID="Edit_Literal" runat="server"></asp:Literal><br/><br/>
                                    </div>
                                    <div style="width:100%;">
                                      <asp:TextBox ID="ID_TextBox" runat="server" Visible="false"></asp:TextBox>
                                  </div>  

                                  <div>
                                <table">
                                    <tr>
                                        <th style="text-align:right;">Club/Team</th>
                                        <td style="height:22px"><asp:DropDownList ID="Club_DropDownList"  CssClass="txtBox" runat="server" AutoPostBack="true" Height="20px" ></asp:DropDownList>
                                                                <asp:DropDownList ID="Team_DropDownList"  CssClass="txtBox" runat="server" AutoPostBack="true" Height="20px">
                                                                    <asp:ListItem Value=" "> </asp:ListItem>
                                                                    <asp:ListItem Value="A">A</asp:ListItem>
                                                                    <asp:ListItem Value="B">B</asp:ListItem>
                                                                    <asp:ListItem Value="C">C</asp:ListItem>
                                                                    <asp:ListItem Value="D">D</asp:ListItem>
                                                                    <asp:ListItem Value="E">E</asp:ListItem>
                                                                    <asp:ListItem Value="F">F</asp:ListItem>
                                                                </asp:DropDownList></td>
                                        <th style="text-align:right;">Captain</th><td><asp:DropDownList ID="Captain_DropDownList" runat="server" Width="300px"></asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <th style="text-align:right;">League/Section</th><td><asp:DropDownList ID="editSection_DropDownList" runat="server" AutoPostBack="true"></asp:DropDownList></td>
                                    </tr>
                                    <tr>
                                        <th style="text-align:right;">Fixture Number</th><td><asp:TextBox ID="FixtureNo_TextBox" runat="server" Width="20px" />(if left blank set to next available)</td>
                                    </tr>
                               </table>
                                      <br />
                              <table  style="width:100%;">
                                 <tr>
                                    <td style="text-align:center"><asp:Button ID="SubmitTeam_Button" runat="server" Text="Submit" /></td>
                                    <td style="text-align:center"><asp:Button ID="CancelTeam_Button" runat="server" Text="Cancel" /></td>
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
    </ContentTemplate>
        </asp:UpdatePanel>

    </div>


</asp:Content>
