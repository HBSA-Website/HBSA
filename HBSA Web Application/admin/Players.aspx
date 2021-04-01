<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="Players.aspx.vb" Inherits="HBSA_Web_Application.Players" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="text-align:left; width:100%">
        <h3>Players maintenance</h3>
        Selection criteria:
        <asp:ScriptManager ID="ToolkitScriptManager1" runat="server" EnablePageMethods="true" ></asp:ScriptManager>

    <script type = "text/javascript">

        function autoComplete1_OnClientPopulating(sender, args) {
            sender.set_contextKey(document.getElementById("<%=Section_DropDownList.ClientID%>").value + '|' + document.getElementById("<%=Club_DropDownList.ClientID%>").value);
        }

    </script>

                    <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
                        <ProgressTemplate>
                            <div id="Loading" style="position: fixed; left:200px;top:160px">
                                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>

        <div style="text-align:left; width:100%">

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

    <%--preserve session variable as GoDaddy may kill the application after 5 minutes timeout--%>
    <input type="hidden" id="SessionUser" name = "SessionUser" runat="server" />

                <div style="text-align:left; width:100%">
                    <br />

                    <table><tr>
                        <td>
                            <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                        <table style="text-align:left" >
                            <tr>
                                <td style="text-align:right">Select a division/section or league:</td>
                                <td>
                                    <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                        <asp:ListItem Value="0" Text="ALL" Selected="True" />
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right">Select a club: </td>
                                <td>
                                    <asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                        <asp:ListItem Value="0" Text="ALL" Selected="True" />
                                    </asp:DropDownList>
                                </td>
                                <td><asp:Button ID="GetByClub_Button" runat="server" Text="GO" /></td>
                            </tr>
                        </table>
                    </div>
                        </td>
                        <td> <span style="font-weight: bold; font-size: larger;">AND/OR</span> </td>
                        <td>
                            <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                        <table style="text-align:left" >
                            <tr>
                                <td colspan="2">Enter the start of a player&#39;s surname and/or the start of a player&#39;s christian name: </td>
                            </tr>
                            <tr>
                                <td style="text-align:right">Select the required player, and click GO</td>
                                <td>
                                    <asp:TextBox ID="Player_TextBox" runat="server" BackColor="#FFFFCC" Width="193px" Height="18px"></asp:TextBox>
                                        <AjaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="Player_TextBox" DelimiterCharacters="" 
                                             MinimumPrefixLength="1" EnableCaching="true" UseContextKey="True"
                                              OnClientPopulating="autoComplete1_OnClientPopulating"
                                              ServiceMethod="SuggestPlayers" CompletionInterval="10"
                                              CompletionSetCount="20" CompletionListCssClass="completionList" CompletionListItemCssClass="completionLlistItem" CompletionListHighlightedItemCssClass="completionItemHighlighted"></AjaxToolkit:AutoCompleteExtender>


                                </td>
                                <td><asp:Button ID="GetByName_Button" runat="server" Text="GO" /></td>
                            </tr>
                        </table>

                    </div>
                        </td>
                    </tr></table>

                    <asp:Button ID="Add_Button" runat="server" Text="Add New Player" />
                    <br />
                    <asp:Literal ID="help_Literal" runat="server" Visible="false">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Note that this table can be sorted by clicking on a column heading, when the data will be shown in ascending or descending sequence of that column (first click is ascending, and subsequent clicks reverse the sequence).</asp:Literal><br />

       <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
            <div id="divRegisterPlayer" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   width:720px; top: 330px; 
                                   ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divRegisterPlayer')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>
                                <asp:Literal ID="EditPanel_Literal" runat="server" Text="Register&nbsp;New&nbsp;Player"></asp:Literal></strong></td>
                    </tr>
                </table>
                <table 
                    style="font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td>
                                <div id="Div1" style="font-size:10pt; display:block; text-align: left;">
                                <br />
                                    Enter player details here and submit them. These will be recorded in the system, and the 
                                    League secretary will receive an email with these details.<br />
                                    <br />
                                  <div style="width:100%; text-align:center">
                                      <asp:Literal ID="Status_Literal" runat="server" Text=""></asp:Literal>
                                      <asp:Label ID="PlayerID_Label" runat="server" Text="PlayerID" Visible="false"></asp:Label>
                                  </div>  

                                  <div>
                                <table>
                                 <tr>
                                     <th></th><th colspan="2">League</th><th colspan="2">Division/Section</th>
                                 </tr>
                                 <tr>
                                     <td></td>
                                     <td colspan="2" style="text-align:center"><asp:DropDownList ID="editLeague_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True"></asp:DropDownList></td>
                                     <td colspan="2" style="text-align: center"><asp:DropDownList ID="editSection_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True"></asp:DropDownList></td>
                                 </tr>
                                    <tr>
                                        <td colspan="1"></td>
                                        <td colspan="5" id="ErrorTeamRow" runat="server" visible="false"
                                            style="color: red; background: white;">
                                                <asp:Literal ID="ErrorTeam_Literal" runat="server"></asp:Literal>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>First Name</th><th>Inits</th><th>Surname</th><th>Handicap</th><th>Club</th><th>Team</th>
                                     </tr>
                                    <tr>
                                        <td><asp:TextBox ID="Forename_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="140px"></asp:TextBox></td>
                                        <td><asp:TextBox ID="Inits_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="32px"></asp:TextBox></td>
                                        <td><asp:TextBox ID="Surname_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="140px"></asp:TextBox></td>
                                        <td><asp:TextBox ID="Handicap_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="32px"></asp:TextBox></td>
                                        <td><asp:DropDownList ID="editClubs_DropDownList" runat="server" BackColor="#FFFFCC"  Width="140px" AutoPostBack="True"></asp:DropDownList></td>
                                        <td><asp:DropDownList ID="Team_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="true" >
                                                <asp:ListItem Value=" "> </asp:ListItem>
                                                <asp:ListItem>A</asp:ListItem>
                                                <asp:ListItem>B</asp:ListItem>
                                                <asp:ListItem>C</asp:ListItem>
                                                <asp:ListItem>D</asp:ListItem>
                                                <asp:ListItem>E</asp:ListItem>
                                                <asp:ListItem>F</asp:ListItem>
                                            </asp:DropDownList></td>
                                 </tr>
                                 <tr>
                                       <th colspan="4">Email</th><th colspan="2">Telephone</th>
                                 </tr>
                                 <tr>
                                        <td colspan="4"><asp:TextBox ID="email_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="380px"></asp:TextBox></td>
                                        <td colspan="2"><asp:TextBox ID="TelNo_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="200px"></asp:TextBox></td>
                                 </tr>
                                 <tr>
                                       <td colspan="2" style="text-align: center"><asp:CheckBox ID="Played_CheckBox" runat="server" Text="Played" Font-Bold="True" /></td>
                                       <td colspan="2" style="text-align: center;vertical-align: top;"><b>Tag</b><asp:DropDownList ID="Tagged_DropDownList" runat="server">
                                           <asp:ListItem Value="0">Seasoned</asp:ListItem>
                                           <asp:ListItem Value="1">1 Season to go</asp:ListItem>
                                           <asp:ListItem Value="2">2 Seasons to go</asp:ListItem>
                                           <asp:ListItem Value="3">Unseasoned</asp:ListItem>
                                           </asp:DropDownList></td>
                                       <td colspan="2" style="text-align: center"><asp:CheckBox ID="Over70_CheckBox" runat="server" Text="Over 70 (80 for Vets)" Font-Bold="True" /></td>

                                 </tr>
                               </table>
                                      <br />
                              <table  style="width:100%;">
                                 <tr>
                                    <td style="text-align:center">
                                        <asp:Button ID="SubmitPlayer_Button" runat="server" Text="Submit" />
                                    </td>
                                     <td><%-- style="text-align:center" runat="server" id="AddSameNameButton" visible="false">--%>
                                         <%--<asp:Button ID="AddSameName_Button" runat="server" Text="Add with same name" />--%>
                                     </td>
                                    <td style="text-align:center">
                                        <asp:Button ID="CancelPlayer_Button" runat="server" Text="Cancel" />
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

                     <br />
                    <asp:GridView ID="Players_GridView" runat="server"  
                        EnableModelValidation="True" Font-Size="9pt" Width="100%" BackColor="White" BorderColor="#E7E7FF" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3"
                        DataKeyNames="ID" AllowSorting="True" EmptyDataText="No data found">
                        <Columns>
                            <asp:CommandField ShowDeleteButton="True" CausesValidation="False" InsertVisible="False" ShowCancelButton="False" ShowEditButton="True" />
                        </Columns>
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />      
                    </asp:GridView>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>

    </div>
                        
    </div>
</asp:Content>
