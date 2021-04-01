<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="BreaksCategories.aspx.vb" Inherits="HBSA_Web_Application.BreaksCategories" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3>Breaks Categories Maintenance (for High Breaks awards)</h3>

    <div>
        <table style="text-align:left" >
            <tr style="vertical-align:top;">
                <td style="text-align:right">Select a league:<br />
                </td>
                <td>
                    <asp:DropDownList ID="League_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" >
                        <asp:ListItem Value="0" Text="ALL" Selected="True" />
                    </asp:DropDownList>
                </td>
                <td>Notes:</td>
                <td rowspan="3">The Low Handicap cannot be set lower than the limit for this league.<br />
                    The High Handicap cannot be set higher than the limit for this league.<br />
                    To set either to the limit enter 'limit' into the relevant box.<br />
                    <span style="color:red">There is no 2nd chance. When a button is clicked, or a handicap changed the effect on the database is immediate.</span>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <table>
                        <tr>
                            <td>League Minimum Handicap = <asp:Literal ID="MinHCap" runat="server"></asp:Literal><br />
                                League Maximum Handicap = <asp:Literal ID="MaxHCap" runat="server"></asp:Literal>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

    </div>

    <asp:Literal ID="msg_Literal" runat="server"></asp:Literal><br />

    <asp:Table ID="Categories_Table" runat="server" Font-Size="10pt" ClientIDMode="Static" BorderWidth="1px" GridLines="Both">
        <asp:TableHeaderRow HorizontalAlign="center">
            <asp:TableHeaderCell>&nbsp;</asp:TableHeaderCell>
            <%--<asp:TableHeaderCell>ID</asp:TableHeaderCell>--%>
            <%--<asp:TableHeaderCell>League</asp:TableHeaderCell>--%>
            <asp:TableHeaderCell>Low Handicap</asp:TableHeaderCell>
            <asp:TableHeaderCell>High Handicap</asp:TableHeaderCell>
        </asp:TableHeaderRow>


    </asp:Table>
    
<%--    <table>
        <tr>
            <td style="text-align:center">
                <asp:Button ID="Submit_Button" runat="server" Text="Submit" />
            </td>
            <td style="text-align:center">
                <asp:Button ID="Cancel_Button" runat="server" Text="Cancel" />
            </td>
        </tr>
    </table>--%>

</asp:Content>
