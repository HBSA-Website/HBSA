<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="EntryFormsNewPlayers.aspx.vb" Inherits="HBSA_Web_Application.EntryFormsNewPlayers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h3>Entry Forms - New players</h3>

    <asp:GridView ID="EntryFormsNewPlayers_GridView" runat="server" Font-Size="10pt" CellPadding="4" 
        EmptyDataText="No new players in entry forms" ForeColor="#333333" GridLines="Both">

        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <RowStyle Height="18px" BackColor="#EFF3FB" />
        <AlternatingRowStyle Height="18px" BackColor="White" />

    </asp:GridView>

</asp:Content>
