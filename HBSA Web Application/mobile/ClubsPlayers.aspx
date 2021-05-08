<%@ Page Title="Clubs and Players" Language="vb" ClientIDMode="Static" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="ClubsPlayers.aspx.vb" Inherits="HBSA_Web_Application.ClubsPlayers1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="AjaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Services>
           <asp:ServiceReference Path="~/mobile/ActiveTableDetail.asmx" />
        </Services>
    </asp:ScriptManager>

    <span style="font-weight: bold;">Clubs and Players</span><br />
    Select a club: <asp:DropDownList ID="Club_DropDownList" runat="server" AutoPostBack="true"></asp:DropDownList>
    <hr />
    <div style="font-size: larger; font-weight: bold;">AND/OR</div>
    <hr />

    <span style="font-size:smaller;font-style:italic;">Start entering a player&#39;s name until you see the name you want then click/touch it:
    <br/>
    &nbsp;&nbsp;then click GO </span>
    <asp:TextBox ID="Player_TextBox" runat="server"></asp:TextBox>
                <ajaxToolkit:AutoCompleteExtender ID="AutoCompleteExtender1" runat="server" TargetControlID="Player_TextBox" 
                    MinimumPrefixLength="2" UseContextKey="True" ServiceMethod="SuggestPlayers" CompletionInterval="10" CompletionSetCount="20" 
                    CompletionListCssClass="mobileCompletionList" CompletionListItemCssClass="mobileCompletionLlistItem" 
                    CompletionListHighlightedItemCssClass="mobileCompletionItemHighlighted"></ajaxToolkit:AutoCompleteExtender>
   
    &nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Button ID="GetByName_Button" runat="server" Text="GO" />
    <hr />




    <div id="ClubsAndPlayers_Div" runat="server"></div>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Literal ID="Team_Literal" runat="server"></asp:Literal>
    <div id="Teams_Div" runat="server"></div>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Literal ID="Player_Literal" runat="server"></asp:Literal>
    <div id="Players_Div" runat="server"></div>

    <div id="ActiveDetailDiv" class="infoDiv" onclick="this.style.display='none';">

</div>

</asp:Content>
