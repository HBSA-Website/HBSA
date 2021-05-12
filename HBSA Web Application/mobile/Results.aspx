<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="Results.aspx.vb" Inherits="HBSA_Web_Application.Results1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
        <Services>
            <asp:ServiceReference Path="~/mobile/ActiveTableDetail.asmx" />
        </Services>
    </asp:ScriptManager>
    
    <span style="font-weight:bold">Match Results</span><br />

    <span style="font-size: smaller;color:black;font-style:italic"><asp:Literal ID="Selection_Literal" runat="server">Select a league and section, then optionally a date and/or a team then click Show Results.</asp:Literal></span><br /><br />
    <asp:DropDownList ID="Section_DropDownList" runat="server" AutoPostBack="True" /><br /><br />
   
    <asp:DropDownList ID="MatchDate_DropDownList" runat="server" />
    &nbsp;&nbsp;&nbsp;
    <asp:DropDownList ID="Team_DropDownList" runat="server" /><br />
    <br />
    <asp:Button ID="Get_Button" runat="server" Text="Show Results" /><br />
    <br />

    <span style='color: maroon; font-size: smaller'>Touch/click a match to see the score card.</span>
    <div id="Results_Div" runat="server"></div>
    <div id="ActiveDetailDiv" class="infoDiv" onclick="this.style.display='none';"></div>

    <div id="divResultCard" onclick="this.style.display='block';">


    </div>



</asp:Content>
