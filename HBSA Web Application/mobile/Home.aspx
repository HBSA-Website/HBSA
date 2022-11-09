<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="mobileMaster.Master" CodeBehind="Home.aspx.vb" Inherits="HBSA_Web_Application.MobileHome" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" >
        function swapDiv(divID, imgID) {

            if (document.getElementById(imgID).src.search("PointUpSmall") != -1) {
                document.getElementById(divID).style.display = "none";
                document.getElementById(imgID).src = "../Images/PointDownSmall.bmp";
            }
            else {
                document.getElementById(divID).style.display = "block";
                document.getElementById(imgID).src = "../Images/PointUpSmall.bmp";
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="margin: 4px">
<%--     <div id='NewHandicapsTitleDiv' runat="server" style='width: 100%; font-size: 14px; font-weight: bold; background-color: #CCFFCC; border-style: solid; border-width: 1px;'                   													
                                onclick='swapDiv("HandicapChangesDiv","TitleImg001");' 
    						    onmouseover='this.style.cursor="pointer";'>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img id='HandicapsTitleImg' height="24" src='../Images/PointDownSmall.bmp' alt='Expand' />
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Touch/Click here to see this week's new handicaps.
    </div>--%>
  
        <div id="HandicapChangesDiv" runat="server" class="HandicapChanges" style="display: block;">
            <asp:Literal ID="HandicapChanges_Literal" runat="server" >Handicap changes made during the last week. Emails have been sent to all relevant persons that can be found in the system.</asp:Literal>
                        <asp:GridView ID="HandicapChanges_GridView" runat="server" HorizontalAlign="Center" CellPadding="4" >
                            <HeaderStyle CssClass="gridViewHeaderHcap" />
                            <RowStyle CssClass="gridViewRowHcap"/>
                            <AlternatingRowStyle CssClass="gridViewAltHcap" />
                        </asp:GridView>
        </div>
        <div id="NewRegistrationsDiv" runat="server" class="HandicapChanges" onmouseover="hideMenuDiv();">
            <asp:Literal ID="NewRegistrations_Literal" runat="server">New registrations made during the last week.</asp:Literal>
                        <asp:GridView ID="NewRegistrations_GridView" runat="server" HorizontalAlign="Center" CellPadding="4" >
                            <HeaderStyle CssClass="gridViewHeaderHcap"/>
                            <RowStyle CssClass="gridViewRowHcap" />
                            <AlternatingRowStyle CssClass="gridViewAltHcap" />
                        </asp:GridView>
        </div>

        <div style="width: 100%; text-align: center; font-style: italic; font-size:16px;color:black ">Click or touch a title bar to see the article.</div>
        <asp:Literal ID="HomePage_Literal" runat="server"></asp:Literal>

</div>
    
</asp:Content>
