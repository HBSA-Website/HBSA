<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="ClubsWithoutClubLogin.aspx.vb" Inherits="HBSA_Web_Application.ClubsWithoutClubLogin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h3>Clubs without Club Login</h3>

    <asp:GridView ID="ClubsWithoutLogin_GridView" runat="server" Font-Size="10pt" CellPadding="4"
        EmptyDataText="No clubs without a login" ForeColor="#333333" GridLines="Both">
        
        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <RowStyle Height="18px" BackColor="#EFF3FB" />
        <AlternatingRowStyle Height="18px" BackColor="White" />

    </asp:GridView>

</asp:Content>
