<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="EntryFees.aspx.vb" Inherits="HBSA_Web_Application.EntryFees" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h3>Maintain Entry Fees</h3>

    <asp:Button ID="Insert_Button" runat="server" Text="New Fee Entity" /><br />

    <br />

    <asp:Panel ID="Edit_Panel" runat="server" Visible="false">
        <div style="padding: 4px; margin: 4px; width: 650px; border-style: solid; border-width: 2px; border-color: blue;">
            <asp:Literal ID="Edit_Literal" runat="server">Enter the new details</asp:Literal>&nbsp;then click Submit.
        <table>
            <tr>
                <th style="width: 150px; text-align: right;">Entity: </th>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td>
                    <asp:TextBox ID="Entity_TextBox" runat="server" CssClass="txtBox" MaxLength="16"></asp:TextBox></td>
            </tr>
            <tr>
                <th style="width: 150px; text-align: right;">League:</th>
                <td></td>
                <td>
                    <asp:DropDownList ID="League_DropDownList" runat="server"></asp:DropDownList></td>
            </tr>
            <tr>
                <th style="width: 150px; text-align: right;">Fee: £</th>
                <td></td>
                <td>
                    <asp:TextBox ID="Fee_TextBox" runat="server" CssClass="txtBox" MaxLength="7"
                        onkeyup="this.value=this.value.replace(/[^1234567890.£]/g,'')"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 150px; text-align: right;">
                    <asp:Button ID="Submit_button" runat="server" Text="Submit" /></td>
                <td></td>
                <td style="text-align: center;">
                    <asp:Button ID="Cancel_Button" runat="server" Text="Cancel" /></td>
            </tr>
        </table>
        </div>

    </asp:Panel>
    .
    <span style="color: red">
        <asp:Literal ID="Error_Literal" runat="server"></asp:Literal></span>

    <br />

    <asp:GridView ID="Fees_GridView" runat="server"
        AllowPaging="True" ForeColor="#333333" GridLines="None">
        <AlternatingRowStyle BackColor="White" />
        <Columns>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
        </Columns>

        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
        <RowStyle BackColor="#EFF3FB" />
    </asp:GridView>


</asp:Content>
