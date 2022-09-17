<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="Breaks.aspx.vb" Inherits="HBSA_Web_Application.Breaks1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

              <div>
            <b>Breaks over 25</b><br />
            <br />
              Select a league and an appropriate set of breaks will be shown.<br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:DropDownList ID="League_DropDownList" runat="server" AutoPostBack="true"></asp:DropDownList>
                  <br />
              <br />
              <asp:GridView ID="Breaks_GridView" runat="server" CssClass="gridView" HorizontalAlign="Center" CellPadding="4">
                    <HeaderStyle CssClass="gridViewHeader"/>
                    <RowStyle CssClass="gridViewRow"/>
                    <AlternatingRowStyle CssClass="gridViewAlt" />
              </asp:GridView>

        </div>

</asp:Content>
