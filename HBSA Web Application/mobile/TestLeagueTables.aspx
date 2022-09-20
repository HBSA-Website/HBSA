<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="TestLeagueTables.aspx.vb" Inherits="HBSA_Web_Application.TestLeagueTables" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <script type="text/javascript">
        function PointsDetailDiv(PointsText) {
            document.getElementById("PointsDetailDiv").innerHTML=PointsText
            document.getElementById("PointsDetailDiv").style.display = "block";
        }
    </script>

    <div class="pageDiv">
    <span style="font-weight:bold;">League Tables</span><br />
    <asp:Literal ID="Selection_Literal" runat="server" Text="Select a league and a section:"></asp:Literal>
        <br /><br />
    <asp:DropDownList ID="Section_DropDownList" runat="server" CssClass="dropDown" AutoPostBack="True" ></asp:DropDownList>
        <br /><br />
    <span style='color: maroon; font-size: smaller'>Teams with points adjustment(s) are shown in red.<br/>
                                                    Touch/click a team to see the reason(s) for adjustments.</span>

    <asp:GridView ID="LeagueTable_GridView" runat="server" CssClass="gridView" HorizontalAlign="Center" CellPadding="4">
            <HeaderStyle CssClass="gridViewHeader"/>
            <RowStyle CssClass="gridViewRow" />
            <AlternatingRowStyle CssClass="gridViewAlt" />
    </asp:GridView>

    </div>

    <div id="PointsDetailDiv" class="infoDiv" style="top: 600px;" onclick="this.style.display='none';"></div>

</asp:Content>