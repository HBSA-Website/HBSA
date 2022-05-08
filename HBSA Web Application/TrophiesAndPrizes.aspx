<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="TrophiesAndPrizes.aspx.vb" Inherits="HBSA_Web_Application.TrophiesAndPrizes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
                    <asp:GridView ID="Awards_GridView" runat="server" Font-Size="9pt" Width="100%"
                        AllowSorting="True" EmptyDataText="<span style='color:red'>No data found</span>">
                        <RowStyle Height="18px" />
                        <AlternatingRowStyle Height="18px" />
                    </asp:GridView>

</asp:Content>