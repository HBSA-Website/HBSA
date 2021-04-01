<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="YorkshireLeague.aspx.vb" Inherits="HBSA_Web_Application.YorkshireLeague" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <h3> Huddersfield in the Yorkshire Snooker League</h3>
    
    <a href="http://ybsa.leaguerepublic.com" target="_blank">
        Click here to see our results, fixtures, standing and more in the YBSA Snooker league web site
    </a>
        <br />
        <br />
    <a href="http://bsa-cuesports.com/yorkshire-league/" target="_blank">Click here to go to the Yorkshire League in the Bradford Billiards & Snooker Association web site.</a><br />
        <div style="width:99%; overflow:auto; border: 1px solid #000000" >    			
            <br /><asp:Literal ID="HTML_Literal" runat="server"></asp:Literal>	
 		</div>

 </asp:Content>
