<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="SiteMap.aspx.vb" Inherits="HBSA_Web_Application.SiteMap" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .auto-style3 {
            height: 20px;
        }
    </style>
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3>Site Map of available pages</h3>
  
    <asp:GridView ID="Menu_GridView" runat="server" ShowHeader="False" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None">
        <RowStyle  Font-Names="Calibri" Font-Size="11pt" />
        <Columns>
            <asp:BoundField DataField="1" HtmlEncode="False" />
            <asp:BoundField DataField="2" HtmlEncode="False" />
            <asp:BoundField DataField="3" HtmlEncode="False" />
            <asp:BoundField DataField="4" HtmlEncode="False" />
            <asp:BoundField DataField="5" HtmlEncode="False" />
        </Columns>
    </asp:GridView>
</asp:Content>
