<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/mobile/mobileMaster.Master" CodeBehind="MissingResults.aspx.vb" Inherits="HBSA_Web_Application.MissingResults1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Missing Results</h2>
    The table below shows matches which should have been played, and for which no result has been submitted.
                    <br />
    <br />
    Unless the match has been re-arranged the Home team is liable to a fine if the result is deemed to have been submitted late, 
                      or is overdue.<br />
    <br />
    <br />
    <asp:GridView ID="MissingResults_GridView" runat="server" CssClass="gridView" HorizontalAlign="Center" CellPadding="4"
                  EmptyDataText="No records found the given selection criteria">
        <HeaderStyle CssClass="gridViewHeader" />
        <RowStyle CssClass="gridViewRow" />
        <AlternatingRowStyle CssClass="gridViewAlt" />
    </asp:GridView>

</asp:Content>
