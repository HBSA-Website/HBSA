<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="Breaks.aspx.vb" Inherits="HBSA_Web_Application.Breaks1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

              <div>
            <b>Breaks over 25</b><br />
            <br />
              Click a link below and an appropriate set of breaks will be shown.<br />
              <br />
              <asp:Button ID="Open_Button" runat="server" Text="Open Snooker Leagues" CssClass="button" />
              <asp:Button ID="Vets_Button" runat="server" Text="Vets Snooker Leagues" CssClass="button" />
              <asp:Button ID="Billiards_Button" runat="server" Text="Billiards Leagues" CssClass="button" />
              <br />
              <br />
              <asp:GridView ID="Breaks_GridView" runat="server" CssClass="gridView" HorizontalAlign="Center" CellPadding="4">
                    <HeaderStyle CssClass="gridViewHeader"/>
                    <RowStyle CssClass="gridViewRow"/>
                    <AlternatingRowStyle CssClass="gridViewAlt" />
              </asp:GridView>

        </div>

</asp:Content>
