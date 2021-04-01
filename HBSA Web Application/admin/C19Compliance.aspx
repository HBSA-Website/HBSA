<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="C19Compliance.aspx.vb" Inherits="HBSA_Web_Application.C19Compliance" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .gridviewMaxWidth {
            max-width:600px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="text-align: left; width: 100%">
        <h3>Covid 19 Compliance report</h3>

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
                                    </table>
                                </div>

                        </tr>
                    </table>

                    <span style="color: red">
                        <asp:Literal ID="Err_Literal" runat="server"></asp:Literal></span>
                </div>

                <asp:GridView ID="C19ComplianceReport_GridView" runat="server"
                    Font-Size="10pt" BackColor="White" BorderColor="Black"
                    BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                    EmptyDataText="No data found for the selected club(s)" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="Club Name" HeaderText="Club"></asp:BoundField>
                        <asp:BoundField DataField="Check1" HeaderText="Confirmation 1"></asp:BoundField>
                        <asp:BoundField DataField="Check2" HeaderText="Confirmation 2"></asp:BoundField>
                        <asp:BoundField DataField="Check3" HeaderText="Confirmation 3"></asp:BoundField>
                        <asp:BoundField DataField="Text3" HeaderText="Excluded teams"><ItemStyle CssClass="gridviewMaxWidth" /></asp:BoundField>
                        <asp:BoundField DataField="Check4" HeaderText="Confirmation 4"></asp:BoundField>
                        <asp:BoundField DataField="Text4" HeaderText="Concerns"><ItemStyle CssClass="gridviewMaxWidth" /></asp:BoundField>
                        <asp:BoundField DataField="Text5" HeaderText="Other comment"><ItemStyle CssClass="gridviewMaxWidth" /></asp:BoundField>
                        <asp:BoundField DataField="dtLodged" HeaderText="Date/Time entered" ></asp:BoundField>

                    </Columns>
                    <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                    <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                    <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                </asp:GridView>

            </ContentTemplate>
        </asp:UpdatePanel>

    </div>

</asp:Content>
