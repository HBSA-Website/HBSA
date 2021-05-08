<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="Handicaps.aspx.vb" Inherits="HBSA_Web_Application.Handicaps" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="color: #006600;text-align:left">
    
        <table style="width:100%"><tr>
            <td style="width:20%">
                <h2>Handicaps</h2>
            </td>
            <td style="width:80%">
                    This page shows last season's playing record, with the last season&#39;s handicap(s), along with the current handicap in force.<br />
                    Note that there may be more than one playing record for tagged players showing each handicap used last season.<br /><br />
                    To see full playing records for previous seasons go to <a href="PlayerRecords.aspx">Historical Player Records</a>. <br />
                    To view any changes made to tagged players' handicaps during this season go to <a href="PlayingRecords.aspx">Playing Records</a>.
            </td>
        </tr></table>

        <hr />
        Selection criteria:

        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

        <asp:UpdateProgress runat="server" id="Update_Progress" DisplayAfter="10">
            <ProgressTemplate>
                <div id="Loading" style="position: fixed; left:440px;top:260px">
                    <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

    <script type = "text/javascript">

        function autoComplete1_OnClientPopulating(sender, args) {
            sender.set_contextKey(document.getElementById("<%=Section_DropDownList.ClientID%>").value + '|' + document.getElementById("<%=Club_DropDownList.ClientID%>").value);
        }

    </script>

                <div style="color: #006600;text-align:left">
                    <div style="text-align:center">
                        <asp:CheckBox ID="ChangesOnly_CheckBox" runat="server" Text="Tick this box to only show handicaps changed since last season" />
                    </div>
                    <table>
                        <tr>
                            <td style="text-align:right; padding:4px;">
                                <div style="border: 1px solid #0000FF; background-color: #CCFFCC">
                                    <table style="text-align:left">
                                        <tr>
                                            <td style="text-align:right; padding:4px;">Select a division/section or league:</td>
                                            <td style="padding:4px;">
                                                <asp:DropDownList ID="Section_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                                    <asp:ListItem Value="0" Text="ALL" Selected="True" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align:right; padding:4px;">Select a club: </td>
                                            <td style="padding:4px;">
                                                <asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                                                    <asp:ListItem Value="0" Text="ALL" Selected="True" />
                                                </asp:DropDownList>
                                            </td>
                                            <td style="padding:4px;">
                                                <asp:Button ID="GetByClub_Button" runat="server" Text="GO" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                            <td style="padding:4px; background:#ccffcc; font-size:larger; font-weight: bold;">AND/OR</td>
                            <td style="text-align:left; padding:4px;">
                                <div style="border: 1px solid #0000FF; background-color: #CCFFCC">
                       <table style="text-align:left">
                            <tr>
                                <td colspan="2">Enter the start of a player&#39;s surname and/or the start of a player&#39;s christian name: </td>
                            </tr>
                            <tr>
                                <td style="text-align:right">Select the required player, and click GO</td>
                                <td>
                                    <asp:TextBox ID="Player_TextBox" runat="server" BackColor="#FFFFCC" Width="193px" Height="18px"></asp:TextBox>
                                        <AjaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" 
                                            TargetControlID="Player_TextBox" DelimiterCharacters="" 
                                             MinimumPrefixLength="2" EnableCaching="false" UseContextKey="true"
                                              ServiceMethod="SuggestPlayers" CompletionInterval="10"
                                              OnClientPopulating="autoComplete1_OnClientPopulating"
                                              CompletionSetCount="20" 
                                             CompletionListCssClass="completionList" CompletionListItemCssClass="completionLlistItem" 
                                            CompletionListHighlightedItemCssClass="completionItemHighlighted"></AjaxToolkit:AutoCompleteExtender>


                                </td>
                                <td><asp:Button ID="GetByName_Button" runat="server" Text="GO" /></td>
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
                            EnableModelValidation="True" Font-Size="9pt" EmptyDataText="No records found the given selection criteria" >
                                    <AlternatingRowStyle BackColor="#F7F7F7" />
                                    <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                                    <RowStyle BackColor="White" ForeColor="#006600" />
                                    <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
</div>

</asp:Content>
