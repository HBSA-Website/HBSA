<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="Handicaps.aspx.vb" Inherits="HBSA_Web_Application.Handicaps1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        <Services>
            <asp:ServiceReference Path="~/mobile/ActiveTableDetail.asmx" />
        </Services>
    </asp:ScriptManager>
    <script type="text/javascript">
        function autoComplete1_OnClientPopulating(sender, args) {
            sender.set_contextKey(document.getElementById("<%=Section_DropDownList.ClientID%>").value + '|' + document.getElementById("<%=Club_DropDownList.ClientID%>").value);
        }
    </script>

    <asp:UpdateProgress runat="server" ID="Update_Progress" DisplayAfter="10">
        <ProgressTemplate>
            <div id="Loading" style="position: fixed; left: 200px; top: 160px">
                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <h3>Handicaps</h3>
    <span style="font-size:smaller">This page shows last season's playing record, with the last season&#39;s handicap(s), along with the current handicap in force.<br />
    Note that there may be more than one playing record for tagged players showing each handicap used last season.<br />
    <br />
    To see full playing records for previous seasons go to <a href="PlayerRecords.aspx">Historical Player Records</a>.
    <br />
    To view any changes made to tagged players' handicaps during this season go to <a href="PlayingRecords.aspx">Playing Records</a>.
    </span>
        <hr />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:CheckBox ID="ChangesOnly_CheckBox" CssClass="BigCheckBox" runat="server" Text="Tick this box to only show handicaps changed since last season" />
            <hr />
            <table class="formatTable">
                <tr>
                    <td style="text-align: right;">Select a division/section or league:</td>
                    <td colspan="2">
                        <asp:DropDownList ID="Section_DropDownList" runat="server" AutoPostBack="True">
                            <asp:ListItem Value="0" Text="ALL" Selected="True" />
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right;">Select a club: </td>
                    <td>
                        <asp:DropDownList ID="Club_DropDownList" runat="server" AutoPostBack="True">
                            <asp:ListItem Value="0" Text="ALL" Selected="True" />
                        </asp:DropDownList>
                    </td>
                    <td style="padding: 4px;">
                        <asp:Button ID="GetByClub_Button" runat="server" Text="GO" /></td>
                </tr>
            </table>
            <hr />

            <div style="font-size: larger; font-weight: bold;">AND/OR</div>
            <hr />

            <table class="formatTable">
                <tr>
                    <td colspan="3">Start entering a player&#39;s name until you see the name you want then click/touch it: </td>
                </tr>
                <tr>
                    <td style="text-align: right;">and click GO</td>
                    <td>
                        <asp:TextBox ID="Player_TextBox" runat="server"></asp:TextBox>
                        <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="Player_TextBox" DelimiterCharacters=""
                            MinimumPrefixLength="2" EnableCaching="true" UseContextKey="True"
                            OnClientPopulating="autoComplete1_OnClientPopulating"
                            ServiceMethod="SuggestPlayers" CompletionInterval="10"
                            CompletionSetCount="20" CompletionListCssClass="mobileCompletionList" CompletionListItemCssClass="mobileCompletionLlistItem" CompletionListHighlightedItemCssClass="mobileCompletionItemHighlighted">
                        </ajaxToolkit:AutoCompleteExtender>
                    </td>
                    <td style="padding: 4px;">
                        <asp:Button ID="GetByName_Button" runat="server" Text="GO" /></td>
                </tr>
            </table>
            <hr />
            <span style='color: maroon; font-size: smaller'>Touch/click a player for more detail</span>
            <div id="Handicaps_Div" runat="server"></div>
            <div id="ActiveDetailDiv" class="infoDiv" onclick="this.style.display='none';"></div>

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
