<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="Fines.aspx.vb" Inherits="HBSA_Web_Application.Fines2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/mobile/ActiveTableDetail.asmx" />
        </Services>
    </asp:ScriptManager>

    <br /><span style="font-weight: bold;">Fines</span><br />
    <asp:CheckBox ID="Owing_CheckBox" runat="server"
        Text="Only show fines not fully paid:" TextAlign="Left" Checked="True" AutoPostBack="true" CssClass="BigCheckBox" />

    <br /><br /><span style='color: maroon;font-size:smaller'> Touch / click a fine for more detail</span>
    <div id="Fines_Div" runat="server"></div>
    <div id="ActiveDetailDiv" class="infoDiv" onclick="this.style.display='none';"></div>

</asp:Content>

