<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="FixtureLists.aspx.vb" Inherits="HBSA_Web_Application.Fixtures" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="text-align:center">
        <asp:Literal ID="Selection_Literal" runat="server" Text="Select a league and a section, then optionally a match date and/or team, then Click Show Fixtures."></asp:Literal>
        <br />
        &nbsp;&nbsp;&nbsp;
        <asp:DropDownList ID="Section_DropDownList" runat="server" CssClass="dropDown" AutoPostBack="true"></asp:DropDownList>
        &nbsp;&nbsp;&nbsp;
        <asp:DropDownList ID="Fixture_Date_DropDownList" runat="server" CssClass="dropDown" ></asp:DropDownList>
        &nbsp;&nbsp;&nbsp;
        <asp:DropDownList ID="Team_DropDownList" runat="server" CssClass="dropDown" ></asp:DropDownList>
        &nbsp;&nbsp;&nbsp;
        <asp:Button ID="Get_Button" runat="server" Text="Show Fixtures" CssClass="button" />

        <asp:GridView ID="Fixtures_GridView" runat="server" CssClass="gridView" HorizontalAlign="Center" CellPadding="4"> 
            <HeaderStyle CssClass="gridViewHeader"/>
            <RowStyle CssClass="gridViewRow"/>
            <AlternatingRowStyle CssClass="gridViewAlt" />
        </asp:GridView>

    </div>

</asp:Content>
