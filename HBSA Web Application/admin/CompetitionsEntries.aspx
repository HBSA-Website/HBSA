<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="CompetitionsEntries.aspx.vb" Inherits="HBSA_Web_Application.CompetitionsEntries" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style1 {
            height: 43px;
        }
        .auto-style2 {
            height: 19px;
        }
        .auto-style3 {
            width: 20px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    
    <div style="text-align:left; ">
        <h3>Competition Entries</h3>
        <br />
        <asp:ScriptManager ID="ToolkitScriptManager1" runat="server" EnablePageMethods="true" ></asp:ScriptManager>

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

    <script type = "text/javascript">

        function autoComplete_OnClientPopulating(sender, args) {
            sender.set_contextKey(document.getElementById("<%=Competitions_DropDownList.ClientID%>").value);
        }
    </script>

            <%--<asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
                        <ProgressTemplate>
                            <div id="Loading" style="position: fixed; left:200px;top:160px">
                                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                            </div>
                        </ProgressTemplate>
                    </asp:UpdateProgress>--%>

<div id="MainPage" runat="server">
        <asp:Button ID="ApplyEntryForms_Button" runat="server" Text="Apply Entry Forms" />

    <table>
            <tr>
                <td>
                    <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                        <table style="text-align:left" >
                            <tr>
                                <td style="text-align:right">Choose a competition:</td>
                                <td>
                                    <asp:DropDownList ID="Competitions_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="true" ></asp:DropDownList>
                                </td>
                                <td style="text-align:right">select this competition:</td>
                                <td>
                                    <asp:Button ID="SelectCompetition_Button" runat="server" Text="Select Competition" />
                                </td>
                                <td style="vertical-align:top;">
                                    <asp:Button ID="MakeDraw_Button" runat="server" Text="Make the Draw" Visible="false"/>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>

            <tr>
                <td><asp:Literal ID="Status_Literal" runat="server"></asp:Literal></td>
            </tr>

        </table>

        <table>
            <tr>
                <td>NOTE:</td>
                <td>To change an entrant without changing the draw click Replace to choose a different entrant for that slot.  The next selected entrant(s) will replace the one shown.</td> 
           </tr>
            <tr>
                <td></td>
                <td>If you wish to re-arrange the existing entrants go to the <a href='ArrangeEntrantsInCompetition.aspx'>Arrange Entrants in Competitions</a> page.</td> 
           </tr>
            <tr>
                <td>
                    <asp:Button ID="AddEntry_Button" runat="server" Text="Add another Entry" /></td> 
           </tr>
      </table>

     <table>
           <tr>
                <td style="text-align:left; vertical-align:top;">
                    <asp:GridView ID="Entrants_GridView" runat="server" Font-Size="9pt" Width="100%" BackColor="White" BorderColor="#E7E7FF" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3" EmptyDataRowStyle-ForeColor="Red" EmptyDataRowStyle-Font-Bold="true">
                        <Columns>
                            <asp:CommandField DeleteText="Remove" ShowCancelButton="False" ShowDeleteButton="True" EditText="" SelectText="Replace" ShowSelectButton="True">
                            <ControlStyle BackColor="#FFFF99" BorderStyle="Ridge" BorderWidth="1px" />
                            </asp:CommandField>
                        </Columns>
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                    </asp:GridView>

                </td>
               <td id="Juniors_SetUp" runat="server" style="text-align:center" visible="false">
                   <asp:DropDownList ID="JuniorsMiniLeagues_DropDownList" runat="server">
                       <asp:ListItem Text="**Choose the number of Mini leagues to set up**" Value="0" Selected="True" />
                       <asp:ListItem Text="One league" Value="1" />
                       <asp:ListItem Text="Two leagues" Value="2" />
                       <asp:ListItem Text="Four leagues" Value="4" />
                   </asp:DropDownList><br /><br />
                   <asp:Button ID="Juniors_SetUp_Button" runat="server" Text="Set up juniors into mini leagues" /><br/>
                   <asp:Literal ID="Juniors_SetUp_Literal" runat="server"></asp:Literal>
               </td>
        </table> 
 
</div>
                    
    <asp:Panel ID="Replace_Panel" runat="server" Visible="false">
            <div id="divReplacePanel" style="padding: 4px; border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   top: 180px; left:150px; ">
                <table style="width: 100%;">
                    <tr>
                        <td onmousedown="dragStart(event, 'divReplacePanel')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>Add / Replace entrant in competition</strong></td>
                    </tr>
                </table>

        <table id="Add_Table" runat="server">
            <tr>
                <td style="color: #FF0000">
                    This competition has already been drawn.<br />
                    To add more entries it will be necessary to clear the draw, add entries then make the draw again.<br /><br />
                    <span style="font-weight:bold;"">This will rearrange all the entries and invalidate any matches recorded.<br />
                    If this is really what you want to do, click the 'Clear the Draw' button:</span><br />
                    Otherwise click Cancel<br /> <br />
                </td>
                <td>
                    <asp:Button ID="ClearDraw_Button" runat="server" Text="Clear the Draw" Width="116px" /><br /><br /><br />
                    <asp:Button ID="CancelAddEntry_Button" runat="server" Text="Cancel" Width="116px" />
                </td>
            </tr>
        </table>
        
        <table id="Replace_Table" runat="server">

            <tr style="vertical-align:top;">
                <td style="vertical-align:top;">
                    <br />
                    <asp:DropDownList ID="Entrants_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True"></asp:DropDownList>
                    <br /><br />
                    <asp:DropDownList ID="Entrant2_DropDownList" runat="server" BackColor="#FFFFCC" Visible="false"></asp:DropDownList>
                </td>
                <td  style="vertical-align:top; text-align:center" class="auto-style3" ><br /> <span style="font-weight: bold; font-size: larger;">OR</span> </td>
                <td>
                    <div>
                        <table style="text-align:left" >
                            <tr style="vertical-align:top;">
                                <td colspan="3" class="auto-style2">Enter the start of an entrant&#39;s name(s): Then</td>
                            </tr>
                            <tr style="vertical-align:top;">
                                <td style="text-align:right">select the required Entrant
                                                            <asp:Literal ID="Entrant2_Literal" runat="server" Visible="false"><br /><br /> select the 2nd Entrant</asp:Literal>
                                </td>
                                <td>
                                    <asp:TextBox ID="Entrant_TextBox" runat="server" BackColor="#FFFFCC" Width="193px" Height="18px" AutoPostBack="true"></asp:TextBox>
                                        <AjaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="Entrant_TextBox" DelimiterCharacters="" 
                                             MinimumPrefixLength="2" EnableCaching="true" UseContextKey="True"
                                              OnClientPopulating="autoComplete_OnClientPopulating"
                                              ServiceMethod="SuggestEntrants" CompletionInterval="100"
                                              CompletionSetCount="20" CompletionListCssClass="completionList" CompletionListItemCssClass="completionLlistItem" CompletionListHighlightedItemCssClass="completionItemHighlighted"></AjaxToolkit:AutoCompleteExtender>

                                    <br />
                                    <asp:TextBox ID="Entrant2_TextBox" runat="server" BackColor="#FFFFCC" Width="193px" Height="18px" Visible="false" AutoPostBack="true"></asp:TextBox>
                                        <AjaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender2" runat="server" TargetControlID="Entrant2_TextBox" DelimiterCharacters="" 
                                             MinimumPrefixLength="2" EnableCaching="true" UseContextKey="True"
                                              OnClientPopulating="autoComplete_OnClientPopulating"
                                              ServiceMethod="SuggestEntrants" CompletionInterval="100"
                                              CompletionSetCount="20" CompletionListCssClass="completionList" CompletionListItemCssClass="completionLlistItem" CompletionListHighlightedItemCssClass="completionItemHighlighted"></AjaxToolkit:AutoCompleteExtender>

                                </td>
                            </tr>
                            </table>
                        </div>
                    </td>

            </tr>
            <tr>
                <td>
                    <asp:Literal ID="ReplaceStatus_Literal" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr style="vertical-align:bottom">
                <td colspan="3" class="auto-style1">
                    <asp:Textbox ID="Literal1" runat="server" BackColor="#99CCFF" BorderStyle="None" ForeColor="#000099" Height="19px" Width="296px">Click the Submit button to add/replace the entry</asp:Textbox>
                    <asp:Button ID="Submit_Button" runat="server" Text="Submit" />
                    <asp:Textbox ID="Literal2" runat="server" BackColor="#99CCFF" BorderStyle="None" ForeColor="#000099" Height="19px" Width="115px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;or click Cancel: </asp:Textbox><asp:Button ID="CancelReplace_Button" runat="server" Text="Cancel" /><br /><br /></td>
            </tr>

        </table>

          </div>
        </asp:Panel>

      <asp:Panel ID="Confirm_Panel" runat="server" Visible="false">
            <div id="divConfirmCompetition" style="border: 1px solid #000080; font-family: Arial, Helvetica, sans-serif; font-size: 8Pt; display:block; vertical-align: top; 
                                   text-align: left; position: fixed; background-color: #99CCFF;
                                   width:540px; top: 200px; left:100px; 
                                   ">
                <table style="width: 100%; height: 100%">
                    <tr>
                        <td onmousedown="dragStart(event, 'divConfirmCompetition')" 
                            onmouseover="this.style.cursor='pointer';" 
                            style="height: 8px; border-right: #000080 1px solid; border-top: #000080 1px solid; border-left: #000080 1px solid; border-bottom: #000080 1px solid; background-image: url('../images/menuBarBG.gif');">
                            <strong>Confirm</strong></td>
                    </tr>
                </table>

                <table style="font-size:9pt; width:100%; vertical-align: top;">
                    <tr>
                        <td>
                            <div id="Div1" style="display:block; text-align: left;">
                                <asp:Literal ID="Confirm_Literal" runat="server"></asp:Literal>
                                <br/><br/>

                              <div>
                              <table  style="width:100%;">
                                 <tr>
                                    <td style="text-align:center">
                                        <asp:Button ID="ConfirmCompetition_Button" runat="server" Text="Confirm" />
                                    </td>
                                    <td style="text-align:center">
                                        <asp:Button ID="CancelConfirm_Button" runat="server" Text="Cancel" />
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

   <asp:Panel ID="ClubsWithoutPrivacyAccepted_Panel" runat="server" Visible="false">

        <div style="padding: 8px; border: thin solid #0000FF; background-color: #CCFFFF; position:absolute; top:140px; left:10%; width:60%; display:none">
            <br />
            <span style="color:red;">The following clubs have competitions entries and have not accepted the Privacy Policy, therefore any teams and players registered with them have not been entered 
            into the competitions.</span>
            <br /><br />
            You should contact them and explain the situation.  It you wish to allow any one to revisit an entry fom in order to accept the policy it will be necessary to go to the 
            <a href="CompetitionsMaintenance.aspx">Competitions >> Set up and Maintenance page</a> and click Allow Competitions Entry Forms.  You can then ask them to go online and 
            accept the policy.  
            <br /><br />
                   <asp:GridView ID="ClubsWithoutPrivacyAccepted_GridView" runat="server"  
                        Font-Size="9pt" BackColor="White" BorderColor="#E7E7FF" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3"
                        EmptyDataText="None" HeaderStyle-HorizontalAlign="Left">
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" HorizontalAlign="Left" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                    </asp:GridView>
            <br />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="ClubsWithoutPrivacyAccepted_Button" runat="server" Text="OK close this dialogue" />
            <br /><br />
        </div>

    </asp:Panel>
        </ContentTemplate>
     </asp:UpdatePanel>
        
    </div>
</asp:Content>
