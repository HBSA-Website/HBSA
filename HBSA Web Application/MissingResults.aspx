<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="MissingResults.aspx.vb" Inherits="HBSA_Web_Application.MissingResults" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <div style="color: #006600;text-align:left">
    
        <table style="width:100%"><tr>
            <td style="width:20%">
                <h2>Missing Results</h2>
            </td>
            <td style="width:80%">
                    The table below shows matches which have been played, and for which no result has been submitted.
                    <br />
                    <br />
                    Unless the match has been re-arranged the Home team is liable to a fine if the result is deemed to have been submitted late, 
                      or is overdue.<br /><br />
            </td>
        </tr>
        <tr>
            <td>
            </td>
            <td>
                        <asp:GridView ID="MissingResults_GridView" runat="server" BackColor="White" 
                            BorderColor="#CC9966" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" 
                            EnableModelValidation="True" Font-Size="9pt" EmptyDataText="No records found the given selection criteria" >
                            <AlternatingRowStyle BackColor="#F7F7F7" />
                            <HeaderStyle BackColor="#006600" Font-Bold="True" ForeColor="#FFFFCC" />
                            <RowStyle BackColor="White" ForeColor="#006600" />
                            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                        </asp:GridView>
                    </td>
                </tr>
            </table>
</div>


</asp:Content>
