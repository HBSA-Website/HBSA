<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="ClubsPlayers.aspx.vb"
    Inherits="HBSA_Web_Application.ClubsPlayers" ClientIDMode="Static" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function checkAccessCode(AccessCode, msgSpan) {
            var elAccessCode = document.getElementById(AccessCode);
            HBSA_Web_Application.AccessCode.CheckAccessCode(elAccessCode.value, Completed, Errored, msgSpan); 
        }
        function Completed(outcome, msgSpan) {
            if (outcome != "good") {
                document.getElementById(msgSpan).innerHTML = "Incorrect access code";
                document.getElementById("ViewContactDetailsHidden").value = "";
            } else {
                document.getElementById("ViewContactDetailsHidden").value = "Accessible";
                var dd = document.getElementById("Club_DropDownList")
                if (dd.selectedIndex != 0) {  //need to force rebuild of players table
                    dd.selectedIndex = 0;     // restart the club dd
                    __doPostBack("Club_DropDownList"); //force code behind to build playerts table
                } else {
                    var panel = document.getElementById("AccessCode_Panel");
                    panel.style.display = "none"
                }
            }
        }
        function Errored(result) {
            alert("Error: " + result.get_message());
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <asp:ScriptManager ID="ScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="~/AccessCode.asmx" />
            </Services>
        </asp:ScriptManager>

       <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:440px;top:260px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

    <input id="ViewContactDetailsHidden" type="hidden" runat="server" />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server"> 
         <ContentTemplate>

          <div style="font-family: Verdana; color:Green; text-align:center; background-color:#ccffcc; font-size: 11pt;">
            <b>Clubs and Players</b><br />
            <br />
            
            <table style="font-size: 11pt; width: 100%; text-align: center;">
                <tr style="font-weight:bold;">
                    <td style="font-size: 11pt; color: black; font-style: italic;">Select a league and section</td>
                    <td rowspan="2" style="vertical-align: middle; font-size: 16px; font-weight: bold">&nbsp;&nbsp;&nbsp;OR&nbsp;&nbsp;&nbsp;</td>
                    <td style="font-size: 11pt;color:black; font-style: italic;">Select a Club</td>
                    <td rowspan="2" style="vertical-align:middle; font-size: 16px; font-weight: bold">&nbsp;&nbsp;&nbsp;OR&nbsp;&nbsp;&nbsp;</td>
                    <td style="font-size: 11pt; color: black; font-style: italic;">Find a Player</td>
                </tr>
                <tr>
                    <td><asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" ></asp:DropDownList></td>
                    <td><asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" ></asp:DropDownList></td>
                    <td>
                        <table style="text-align: left;">
                            <tr>
                                <td colspan="3" style="font-size: 10pt; color:black; font-style:italic;">Start entering a player&#39;s name then:</td>
                            </tr>
                            <tr>
                                <td style="text-align: right; font-size: 10pt;color:black; font-style: italic;">select a player and click GO</td>
                                <td>
                                    <asp:TextBox ID="Player_TextBox" runat="server" BackColor="#FFFFCC" Width="193px" Height="18px" AutoCompleteType="Disabled"></asp:TextBox>
                                    <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="Player_TextBox" DelimiterCharacters=""
                                        MinimumPrefixLength="1" EnableCaching="false" UseContextKey="true"
                                        ServiceMethod="SuggestPlayers" CompletionInterval="10"
                                        CompletionSetCount="20"
                                        CompletionListCssClass="completionList" CompletionListItemCssClass="completionLlistItem" CompletionListHighlightedItemCssClass="completionItemHighlighted">
                                    </ajaxToolkit:AutoCompleteExtender>


                                </td>
                                <td>
                                    <asp:Button ID="GetByName_Button" runat="server" Text="GO" /></td>
                            </tr>
                        </table>

                    </td>
                </tr>
            </table>

              <asp:Panel ID="AccessCode_Panel" style="text-align:left" runat="server" Visible="false" BorderWidth="1px" BorderStyle="Solid" BackColor="White">
                  <p style="color:red;font-weight:bold ">Access code required for Players' eMail addresses and telephone numbers</p>
                  <p>If you wish to view Players' eMail addresses and/or telephone numbers enter the required Access code and click Apply.<br/> 
                      Access code: 
                      <input id="AccessCode_Text" type="password" style="width: 180px;" autocomplete="new-password" />
                      &nbsp;&nbsp;&nbsp;&nbsp;<span id="ApplyCode" style="color: blue; text-decoration: underline"
                            onmouseover="this.style.cursor = 'pointer';" onclick="checkAccessCode('AccessCode_Text','AccessCodeMsg')">Apply </span>
                      &nbsp;&nbsp;<span id="AccessCodeMsg" style="color: red"></span>
                      <br />
                  </p>
                  <p>
                      If you don't know the access code contact your club representative or a team representative (who can enter match results) who will be able to log on and find this code.
                  </p>
                    <p>
                        If you wish, click cancel to proceed without seeing players' contact details:
                      &nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="CancelAccessCode_Button" runat="server" Text="Cancel" />
                    </p>
              </asp:Panel>

            <table style="width: auto; margin-left: auto; margin-right: auto;">
                <tr>
                    <td style="vertical-align:top;">
                        <asp:GridView ID="ClubsAndPlayers_GridView" runat="server" BackColor="White" 
                        BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" Font-Size="9pt" >
                        <AlternatingRowStyle BackColor="#F7F7F7" HorizontalAlign="Left" />
                        <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                        <RowStyle BackColor="White" ForeColor="#006600" HorizontalAlign="Left"  />
                    </asp:GridView></td>
                    <td style="vertical-align:top;">
                        <asp:GridView ID="Teams_GridView" runat="server" BackColor="White"
                        BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" 
                        EnableModelValidation="True" Font-Size="9pt" >
                        <AlternatingRowStyle BackColor="#F7F7F7" HorizontalAlign="Left" />
                        <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                        <RowStyle BackColor="White" ForeColor="#006600" HorizontalAlign="Left" />
                        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                    </asp:GridView></td>
                </tr>
                <tr>
                    <td colspan="2" style="vertical-align:top; text-align:center;">
                        <asp:GridView ID="Players_GridView" runat="server" BackColor="White"
                        BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" 
                        EnableModelValidation="True" Font-Size="9pt" >
                        <AlternatingRowStyle BackColor="#F7F7F7" HorizontalAlign="Left" />
                        <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                        <RowStyle BackColor="White" ForeColor="#006600" HorizontalAlign="Left" />
                        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                    </asp:GridView></td>
                    
                </tr>
            </table>
  
          </div>


        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
