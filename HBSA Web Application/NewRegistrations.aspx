<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="NewRegistrations.aspx.vb" Inherits="HBSA_Web_Application.NewRegistrations" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" ></asp:ScriptManager>
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

   <div style="color: #006600;text-align:left">
    
       <table style="width:100%">
            <tr>
            <td style="width:20%">
                <h2>New Registrations</h2>
                <h4>Selection criteria:</h4>
            </td>
            <td style="width:80%">
                    This page shows players who have been registered since the start of the season.<br />
                    <%--<asp:Button ID="Register_Button" runat="server" Text="To register a new player click here." onmouseover="this.style.cursor='pointer';" BorderStyle="None" ForeColor="#0033CC" 
                        style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11pt;" Width="265px" Font-Underline="True"/>--%>
                    <br />
                    To see all players go to <a href="Handicaps.aspx">Handicaps</a>. <br />
                    To view any changes made to tagged players' handicaps during this season go to <a href="PlayingRecords.aspx">Playing Records</a>.
            </td>
        </tr>

        </table>

       <asp:UpdatePanel ID="UpdatePanel1" runat="server">
       <ContentTemplate>

        <table>
            <tr>
                <td style="text-align:right">
                    <div style="border: 1px solid #0000FF; background-color: #CCFFCC">
                        <table style="text-align:left">
                            <tr>
                                <td style="text-align:right;padding:4px;">Select a division/section or league:</td>
                                <td style="padding:4px;">
                                    <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                        <asp:ListItem Value="0" Text="ALL" Selected="True" />
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right;padding:4px;">Select a club: </td>
                                <td style="padding:4px;">
                                    <asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                        <asp:ListItem Value="0" Text="ALL" Selected="True" />
                                    </asp:DropDownList>
                                </td>
                                <td style="padding:4px;"><asp:Button ID="GetByClub_Button" runat="server" Text="GO" /></td>
                            </tr>
                        </table>
                    </div>
                        </td>
                        <td style="font-size:larger; font-weight: bold;background:#ccffcc">
                            <div style="border: none; background-color: #CCFFCC">AND/OR</div></td>
                        <td style="border: 1px solid #0000FF; background-color: #CCFFCC">
                            <div >
                        <table style="text-align:left">
                            <tr>
                                <td colspan="2" style="padding:4px;">Enter the start of a player&#39;s surname and/or the start of a player&#39;s christian name: </td>
                            </tr>
                            <tr>
                                <td style="text-align:right;padding:4px;">Select the required player, and click GO</td>
                                <td style="padding:4px;">
                                    <asp:TextBox ID="Player_TextBox" runat="server" BackColor="#FFFFCC" Width="193px" Height="18px"></asp:TextBox>
                                        <AjaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="Player_TextBox" DelimiterCharacters="" 
                                             MinimumPrefixLength="1" EnableCaching="true" UseContextKey="True"
                                              OnClientPopulating="autoComplete1_OnClientPopulating"
                                              ServiceMethod="SuggestPlayers" CompletionInterval="10"
                                              CompletionSetCount="20" CompletionListCssClass="completionList" CompletionListItemCssClass="completionLlistItem" CompletionListHighlightedItemCssClass="completionItemHighlighted"></AjaxToolkit:AutoCompleteExtender>


                                </td>
                                <td style="padding:4px;"><asp:Button ID="GetByName_Button" runat="server" Text="GO" /></td>
                            </tr>
                        </table>
                    </div>
                        </td>
                    </tr>

        </table>
            <table>
                <tr>
                    <td style="vertical-align:top; text-align:center">
                        <asp:GridView ID="Handicaps_GridView" runat="server" BackColor="White" 
                            BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" 
                            EnableModelValidation="True" Font-Size="9pt" EmptyDataText="No records found for the given selection criteria" >
                            <AlternatingRowStyle BackColor="#F7F7F7" />
                            <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                            <RowStyle BackColor="White" ForeColor="#006600" />
                            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                        </asp:GridView>
                        <span style="color: #FF0000"><asp:Literal ID="NeedLogin_Literal" runat="server"></asp:Literal></span>
                    </td>
                </tr>
            </table>

<%--      <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
            <div id="divRegisterPlayer" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; 
                                   display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #FFFFFF;
                                   width:640px; top: 330px; left: 300px;
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
                <table cellpadding="4" cellspacing="4" 
                    style="font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td>
                                <div ID="Div1" style="font-size:10pt; display:block; text-align: left;">
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
                                     <th></th><th colspan="2">League</th><th colspan="2">Section</th>
                                 </tr>
                                 <tr>
                                     <td></td>
                                     <td colspan="2" align="center"><asp:DropDownList ID="editLeague_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True"></asp:DropDownList></td>
                                     <td colspan="2" align="center"><asp:DropDownList ID="editSection_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True"></asp:DropDownList></td>
                                 </tr>
                                    <tr>
                                        <th>First Name</th><th>Inits</th><th>Surname</th><th>Handicap</th><th>Club</th><th>Team</th>
                                     </tr>
                                    <tr>
                                        <td><asp:TextBox ID="Forename_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="140px"></asp:TextBox></td>
                                        <td><asp:TextBox ID="Inits_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="32px"></asp:TextBox></td>
                                        <td><asp:TextBox ID="Surname_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="140px"></asp:TextBox></td>
                                        <td><asp:TextBox ID="Handicap_TextBox" runat="server" BackColor="#FFFFCC" style="text-align:center;" Width="32px"></asp:TextBox></td>
                                        <td><asp:DropDownList ID="editClubs_DropDownList" runat="server" BackColor="#FFFFCC"  Width="140px"></asp:DropDownList></td>
                                        <td><asp:DropDownList ID="Team_DropDownList" runat="server" BackColor="#FFFFCC" >
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
                                       <td colspan="2" align="center"><asp:CheckBox ID="Played_CheckBox" runat="server" Text="Played" Font-Bold="True" /></td>
                                       <td colspan="2" align="center" valign="top"><b>Tag</b><asp:DropDownList ID="Tagged_DropDownList" runat="server">
                                           <asp:ListItem Value="0">Seasoned</asp:ListItem>
                                           <asp:ListItem Value="1">1 Season to go</asp:ListItem>
                                           <asp:ListItem Value="2">2 Seasons to go</asp:ListItem>
                                           <asp:ListItem Value="3">Unseasoned</asp:ListItem>
                                           </asp:DropDownList></td>
                                       <td colspan="2" align="center"><asp:CheckBox ID="Over70_CheckBox" runat="server" Text="Over 70 (80 for Vets)" Font-Bold="True" /></td>

                                 </tr>
                               </table>
                                      <br />
                               <table width="100%">
                                 <tr>
                                    <td style="text-align:center">
                                        <asp:Button ID="SubmitPlayer_Button" runat="server" Text="Submit" />
                                        &nbsp;&nbsp;
                                        <asp:Button ID="Transfer_Button" runat="server" Text="Transfer this player from" Visible="false" />
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
        </asp:Panel>--%>

        </ContentTemplate>
        </asp:UpdatePanel>
    
   </div>




</asp:Content>
