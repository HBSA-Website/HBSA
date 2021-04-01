<%@ Page Title="Clubs and Players" Language="vb" ClientIDMode="Static" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="ClubsPlayers.aspx.vb" Inherits="HBSA_Web_Application.ClubsPlayers1" %>
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

    <div id="ClubsAndPlayers_Div" runat="server"></div>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Literal ID="Team_Literal" runat="server"></asp:Literal>
    <div id="Teams_Div" runat="server"></div>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Literal ID="Player_Literal" runat="server"></asp:Literal>
    <div id="Players_Div" runat="server"></div>

    <div id="ActiveDetailDiv" class="infoDiv" onclick="this.style.display='none';">

</div>

</asp:Content>
