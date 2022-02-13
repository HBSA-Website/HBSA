<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="WeeklyResultsReport.aspx.vb" Inherits="HBSA_Web_Application.WeeklyResultsReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="font-family: Verdana; color: Green; text-align: center; background-color: #ccffcc">
        <b>Weekly Results Reports</b><br />
        <br />
        Select a league and then a fixture date:
        <br /><br />
        &nbsp;&nbsp;&nbsp;
            <asp:DropDownList ID="League_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True"></asp:DropDownList>
        &nbsp;&nbsp;&nbsp;
            <asp:DropDownList ID="FixtureDate_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True"></asp:DropDownList>
        <br />
        <asp:Literal ID="Err_Literal" runat="server"></asp:Literal>
        <br />
<%--        <table style="width: auto; margin-left: auto; margin-right: auto;">
            <tr>
                <td>--%>
                    <asp:GridView ID="Results_GridView" runat="server" 
                        style="width: auto; margin-left: auto; margin-right: auto;"
                        BackColor="White" BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" Font-Size="9pt" AutoGenerateColumns="False" EmptyDataText="No results logged for this fixture date." ShowHeader="False">
                        <AlternatingRowStyle BackColor="#F7F7F7" />
                        <Columns>
                            <asp:BoundField DataField="Result" HeaderText="Scores" HtmlEncode="False" ReadOnly="True" />
                        </Columns>
                        <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                        <RowStyle BackColor="White" ForeColor="#006600" />
                        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                    </asp:GridView>
 <%--               </td>
            </tr>
        </table>--%>


    </div>

</asp:Content>
