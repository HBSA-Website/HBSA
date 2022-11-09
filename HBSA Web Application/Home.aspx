<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" Inherits="HBSA_Web_Application.Home" Title="HBSA - Home"
    CodeBehind="Home.aspx.vb" ClientIDMode="Static" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .HandicapChanges {
            font-family: Verdana;
            color: darkred;
            font-size: 11pt;
            text-align: center;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">

    <div onmouseover="hideMenuDiv();">
        <div>
<%--    <div id='NewHandicapsTitleDiv' runat="server" style='width: 100%; font-size: 14px; font-weight: bold; background-color: #CCFFCC; 
					            border-style: solid; border-width: 1px;'                   													
                                onclick='swapDiv("HandicapChangesDiv","TitleImg001");' 
    						    onmouseover='this.style.cursor="pointer";'>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img id='HandicapsTitleImg' height="24" src='Images/PointDownSmall.bmp' alt='Expand' />
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Click here to see this week's new handicaps.
    </div>--%>
            <div id="HandicapChangesDiv" runat="server" class="HandicapChanges" style="display: block; width: 100%" onmouseover="hideMenuDiv();">
                <asp:Literal ID="HandicapChanges_Literal" runat="server">Handicap changes made during the last week.<br />Emails have been sent to all relevant persons that can be found in the system.</asp:Literal>
                <table style="width: auto; margin-left: auto; margin-right: auto;">
                    <tr>
                        <td style="text-align: center">
                            <asp:GridView ID="HandicapChanges_GridView" runat="server" BackColor="White" BorderColor="DarkRed" BorderStyle="Solid" BorderWidth="1px" CellPadding="4">
                                <HeaderStyle BackColor="DarkRed" Font-Bold="True" ForeColor="#FFFFFF" Font-Size="8pt" />
                                <RowStyle BackColor="White" ForeColor="DarkRed" Font-Size="8pt" />
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="NewRegistrationsDiv" runat="server" class="HandicapChanges" style="width: 100%" onmouseover="hideMenuDiv();">
                <asp:Literal ID="NewRegistrations_Literal" runat="server">New registrations made during the last week.</asp:Literal>
                <table style="width: auto; margin-left: auto; margin-right: auto;">
                    <tr>
                        <td style="text-align: center">
                            <asp:GridView ID="NewRegistrations_GridView" runat="server" BackColor="White" BorderColor="DarkRed" BorderStyle="Solid" BorderWidth="1px" CellPadding="4">
                                <HeaderStyle BackColor="DarkRed" Font-Bold="True" ForeColor="#FFFFFF" Font-Size="8pt" />
                                <RowStyle BackColor="White" ForeColor="DarkRed" Font-Size="8pt" />
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </div>


            <div style="width: 100%; text-align: center; font-style: italic">Click or touch a title bar to see the article.</div>
            <asp:Literal ID="HomePage_Literal" runat="server">Date    Title<br />Content</asp:Literal>

        </div>
    </div>
</asp:Content>




