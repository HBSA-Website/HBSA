<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="leagueTables.aspx.vb" Inherits="HBSA_Web_Application.leagueTables1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="pageDiv">
    <span style="font-weight:bold;">League Tables</span><br />
    <asp:Literal ID="Selection_Literal" runat="server" Text="Select a league and a section:"></asp:Literal>
    <br />
    <asp:DropDownList ID="Section_DropDownList" runat="server" CssClass="dropDown" AutoPostBack="True" ></asp:DropDownList>
    <br />
    <asp:GridView ID="LeagueTable_GridView" runat="server" CssClass="gridView" HorizontalAlign="Center" CellPadding="4">
            <HeaderStyle CssClass="gridViewHeader"/>
            <RowStyle CssClass="gridViewRow" />
            <AlternatingRowStyle CssClass="gridViewAlt" />
    </asp:GridView>

    </div>

</asp:Content>
