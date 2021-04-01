<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="NotePad.aspx.vb" Inherits="HBSA_Web_Application.NotePad" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h3><asp:Literal ID="Administrator_Literal" runat="server"></asp:Literal>'s NotePad</h3>
    <asp:Button ID="Save_Button" runat="server" Text="Save" Width="122px" />
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Click save when finished or select another function.<br />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Literal ID="Notes_Literal" runat="server"></asp:Literal><br />
       
     <asp:TextBox ID="Notes_TextBox" runat="server" TextMode="MultiLine" rows="40" Width="99%"></asp:TextBox>

</asp:Content>
