<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="DownloadData.aspx.vb" Inherits="HBSA_Web_Application.DownloadData" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <%--<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <asp:UpdateProgress runat="server" ID="Update_Progress" DisplayAfter="10">
        <ProgressTemplate>
            <div id="Loading" style="position: fixed; left: 440px; top: 260px">
                <asp:Image ID="loadingImage" runat="server" ImageUrl="~/images/AjaxLoading.gif" Width="100px" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>--%>

    <h3>Data Downloads</h3>

  <%--  <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>--%>

        <asp:Literal ID="Status_Literal" runat="server"></asp:Literal>

            <table>
                <tr><td style="text-align:right">Contacts Report: </td><td><asp:Button ID="DownloadContactsReport_Button" runat="server" Text="Download Contacts Report" Width="212px" /></td></tr>
                <tr><td style="text-align:right">Match Results: </td><td><asp:Button ID="MatchResults_Button" runat="server" Text="Download Match Results" Width="212px" /></td></tr>
                <tr><td style="text-align:right">Handicaps: </td><td><asp:Button ID="Handicaps_Button" runat="server" Text="End of season handicaps" Width="212px" /></td>                </tr>
            </table>

  <%--      </ContentTemplate>
    </asp:UpdatePanel>--%>

</asp:Content>
