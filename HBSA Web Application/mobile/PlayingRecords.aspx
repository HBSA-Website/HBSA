<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="PlayingRecords.aspx.vb" Inherits="HBSA_Web_Application.PlayingRecords1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
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
            sender.set_contextKey(document.getElementById("<%=Section_DropDownList.ClientID%>").value + '|' + document.getElementById("<%=Clubs_DropDownList.ClientID%>").value);
        }
    </script>

    <asp:UpdateProgress runat="server" ID="Update_Progress" DisplayAfter="10">
        <ProgressTemplate>
            <div id="Loading" style="position: fixed; left: 200px; top: 160px">
                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

    <h3>This season&#39;s playing records</h3>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <span style="font-size: smaller">Select a division/section, and/or a club and/or a team:</span><br />
            <asp:DropDownList ID="Section_DropDownList" runat="server" AutoPostBack="True" />
            <br />
            <br />
            <asp:DropDownList ID="Clubs_DropDownList" runat="server" AutoPostBack="True" />
            &nbsp;&nbsp;
            <asp:Literal ID="Team_Literal" runat="server">
            Team:            
            </asp:Literal>
            <asp:DropDownList ID="Team_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" />
            <br />
            <br />
            <span style="font-size: smaller"> and/or a player: </span>
            <asp:TextBox ID="Player_TextBox" runat="server"></asp:TextBox>
            <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="Player_TextBox" DelimiterCharacters=""
                MinimumPrefixLength="2" EnableCaching="true" UseContextKey="True"
                OnClientPopulating="autoComplete1_OnClientPopulating"
                ServiceMethod="SuggestPlayers" CompletionInterval="10"
                CompletionSetCount="20" CompletionListCssClass="mobileCompletionList" CompletionListItemCssClass="mobileCompletionLlistItem" CompletionListHighlightedItemCssClass="mobileCompletionItemHighlighted">
            </ajaxToolkit:AutoCompleteExtender>
            <br />
            <br />
            <asp:CheckBox ID="Tagged_CheckBox" CssClass="BigCheckBox" runat="server" Text="Tagged players." AutoPostBack="True" />
            <asp:CheckBox ID="Over70_CheckBox" CssClass="BigCheckBox" runat="server" Text="Players over80 (Vets)." AutoPostBack="True" />
            <br />
            <br />
            <asp:Button ID="Get_Button" runat="server" Text="Show selected records" />
            <hr />

            <span style='color: maroon; font-size: smaller'>Touch/click a player for more detail</span>
            <div id="PlayingRecords_Div" runat="server"></div>
            <div id="ActiveDetailDiv" class="infoDiv" style="top:1000px;" onclick="this.style.display='none';"></div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
