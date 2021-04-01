<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.Home" title="HBSA - Home" 
    Codebehind="Home.aspx.vb" ClientIDMode="Static" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
            .HandicapChanges
            {
                font-family: Verdana;
                color: darkred;
                font-size: 11pt;
                text-align:center;
            }
    </style>

</asp:Content>

<asp:Content ID="Content2" runat="server" contentplaceholderid="ContentPlaceHolder1">

    <div onmouseover="hideMenuDiv();">
    
        <div id="HandicapChangesDiv" runat="server" class="HandicapChanges" style="width:100%" onmouseover="hideMenuDiv();">
            <asp:Literal ID="HandicapChanges_Literal" runat="server">Handicap changes made during the last week.<br />Emails have been sent to all relevant persons that can be found In the system.</asp:Literal>
            <table style="width:auto;margin-left:auto;margin-right:auto;">
                <tr>
                    <td style="text-align:center">
                        <asp:GridView ID="HandicapChanges_GridView" runat="server" BackColor="White" BorderColor="DarkRed" BorderStyle="Solid" BorderWidth="1px" CellPadding="4">
                            <HeaderStyle BackColor="DarkRed" Font-Bold="True" ForeColor="#FFFFFF" Font-Size="8pt" />
                            <RowStyle BackColor="White" ForeColor="DarkRed" Font-Size="8pt"/>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>
        <div id="NewRegistrationsDiv" runat="server" class="HandicapChanges" style="width:100%" onmouseover="hideMenuDiv();">
            <asp:Literal ID="NewRegistrations_Literal" runat="server">New registrations made during the last week.</asp:Literal>
            <table style="width: auto; margin-left: auto; margin-right: auto;">
                <tr>
                    <td style="text-align:center">
                        <asp:GridView ID="NewRegistrations_GridView" runat="server" BackColor="White" BorderColor="DarkRed" BorderStyle="Solid" BorderWidth="1px" CellPadding="4">
                            <HeaderStyle BackColor="DarkRed" Font-Bold="True" ForeColor="#FFFFFF" Font-Size="8pt" />
                            <RowStyle BackColor="White" ForeColor="DarkRed" Font-Size="8pt"/>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </div>

<%--        <div id='TitleDiv000' style='width: 100%; font-size: 14px; font-weight: bold; background-color: #CCFFCC; border-style: solid; border-width: 1px;' onclick='swapDiv("ArticleDiv000","TitleImg000");'
            onmouseover='this.style.cursor="pointer";'>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img id='TitleImg000' height="24" src='Images/PointDownSmall.bmp' alt='Expand' />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;08 Jul 2020&nbsp;&nbsp;&nbsp;&nbsp;Further EPSB Guidance
        </div>
        <div style="border: 1px solid black; padding: 5px;">
            <div>Please see here for further guidance on opening up snooker facilities.   <a href="https://www.epsb.co.uk/epsb-re-opening-guidance/">https://www.epsb.co.uk/epsb-re-opening-guidance/</a></div>
        </div>
        <hr />--%>
      
<div style="width:100%;text-align:center;font-style:italic">Click or touch a title bar to see the article.</div>
             <asp:Literal ID="HomePage_Literal" runat="server">Date    Title<br />Content</asp:Literal>

</div>
        
</asp:Content>




