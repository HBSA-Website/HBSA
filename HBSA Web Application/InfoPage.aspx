<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.InfoPage" title="Huddersfield Snooker Information" Codebehind="InfoPage.aspx.vb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   
   
    <strong><asp:Literal ID="Title_Literal" runat="server"></asp:Literal></strong><br /><br />
    
    			<div style="width:99%; overflow:auto; border: 1px solid #000000">
   		            <asp:Literal ID="HTML_Literal" runat="server"></asp:Literal>
                </div>

</asp:Content>

