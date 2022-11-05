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
    <div>
        <div style="margin-left:auto;margin-right:auto; width:100%; font-weight:bold; text-align:center;">Important website update.</div>
        <div style="padding: 4px; margin: 4px; border: thin solid #008000;">
            1. We have been forced to revert to our own contingency backup due to a problem with our website host.
            <br />
            <br />
            2. UNFORTUNATELY, SOME RECENT RESULTS HAVE BEEN LOST (entered after 5pm 28th Oct).

            <br />
            <br />
            3. PLEASE COULD YOU CHECK HERE <a href="https://huddersfieldsnooker.com/MissingResults.aspx">https://huddersfieldsnooker.com/MissingResults.aspx</a>
<strong>AND RE-INPUT THE MISSING RESULTS FOR YOUR TEAM.</strong> Please note that if the card has been lost or destroyed, the person registered to enter results will have been sent an email with a copy of the full results card.
            <br />
            <br />
            4. The results from the Open League games on 3rd Nov can now be input as normal.
            <br />
            <br />
            5. Competition entry forms submitted after 5pm Oct 28th have also been lost. The Competition Sec will issue a separate update on this in the next day or two. <strong>IN THE MEANTIME, IF YOU HAVE ARRANGED ANY GAMES PLEASE DO NOT PLAY THEM YET, AS THE DRAWS MAY HAVE TO BE REDONE. </strong>
            <br />
            <br />
            Please accept our sincerest apologies and thanks for your support.

            <br />

        </div>
        <div id="HandicapChangesDiv" runat="server" class="HandicapChanges" style="width:100%" onmouseover="hideMenuDiv();">
            <asp:Literal ID="HandicapChanges_Literal" runat="server">Handicap changes made during the last week.<br />Emails have been sent to all relevant persons that can be found in the system.</asp:Literal>
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
    </div>    
</asp:Content>




