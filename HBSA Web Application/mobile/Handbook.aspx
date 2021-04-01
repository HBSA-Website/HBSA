<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="Handbook.aspx.vb" Inherits="HBSA_Web_Application.Handbook1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <span style="font-weight: bold;">HBSA Handbook</span><br />
    <br />
    <asp:Label ID="Handbook_Label" runat="server" Text="Label"></asp:Label>
    <br />
    <asp:Button ID="DownLoadContent_Button" runat="server" Text="Get the handbook"  />
</asp:Content>
