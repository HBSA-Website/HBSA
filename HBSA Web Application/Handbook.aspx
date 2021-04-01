<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="Handbook.aspx.vb" Inherits="HBSA_Web_Application.Handbook" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="font-family: Verdana; color:Green; text-align:center; font-size:10pt; background-color: #CCFFCC;";>
        <h3>HBSA - Handbook</h3>
        <br />
        <asp:Label ID="Handbook_Label" runat="server" Text="Label"></asp:Label>
        <p><asp:Button ID="DownLoadContent_Button" runat="server" Text="Get the handbook" /></p>
        <p>
              &nbsp;</p>
 
        </div>

</asp:Content>
