<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="AGMVotesReports.aspx.vb" Inherits="HBSA_Web_Application.AGMVotesReports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="text-align: left; width: 100%">
        <h3>AGM Votes reports</h3>

        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <div style="text-align: left; width: 100%">
                    <table>
                        <tr>
                            <td>
                                <div style="border: 1px solid #0000FF; color: #0000FF; background-color: #99CCFF">
                                    <table style="text-align: left">
                                        <tr>
                                            <td>Select Club(s)</td>
                                            <td>
                                                <asp:DropDownList ID="Club_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="true">
                                                    <asp:ListItem Value="0" Text="All Clubs" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Select a report</td>
                                            <td>
                                                <asp:DropDownList ID="Report_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True">
                                                    <asp:ListItem Value="0" Text="AGM Votes per resolution" />
                                                    <asp:ListItem Value="1" Text="Full Report of Votes cast" />
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                    </table>
                                </div>

                        </tr>
                    </table>

                    <span style="color: red">
                        <asp:Literal ID="Err_Literal" runat="server"></asp:Literal></span>
                </div>
                
                <asp:GridView ID="AGMvoteReport_GridView" runat="server"
                    Font-Size="9pt" BackColor="White" BorderColor="Black"
                    BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                    EmptyDataText="No data found" ShowHeader="false">
                    <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                    <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                    <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                </asp:GridView>

            </ContentTemplate>
        </asp:UpdatePanel>

    </div>

</asp:Content>
