<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="NewRegistrations.aspx.vb" Inherits="HBSA_Web_Application.NewRegistrations1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
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

        <h2>New Registrations</h2>
        This page shows players who have been registered since the start of the season.<br />
        <br />
        To see all players go to <a href="Handicaps.aspx">Handicaps</a>.
        <br />
        To view any changes made to tagged players' handicaps during this season go to <a href="PlayingRecords.aspx">Playing Records</a>.
    <hr />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

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
                    <td colspan="3">Enter the start of a player&#39;s surname and/or the start of a player&#39;s christian name: </td>
                </tr>
                <tr>
                    <td style="text-align: right;">Select the required player, and click GO</td>
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
            <asp:GridView ID="Handicaps_GridView" runat="server" CssClass="gridView" HorizontalAlign="Center" CellPadding="4"
                EmptyDataText="No records found for the given selection criteria">
                <HeaderStyle CssClass="gridViewHeader" />
                <RowStyle CssClass="gridViewRow" />
                <AlternatingRowStyle CssClass="gridViewAlt" />
            </asp:GridView>

        </ContentTemplate>
     </asp:UpdatePanel>

</asp:Content>
