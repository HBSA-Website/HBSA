<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/MasterPage.master" CodeBehind="JuniorsComp2.aspx.vb" Inherits="HBSA_Web_Application.JuniorsComp2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="font-family: Verdana; font-size:10pt; color:Green; text-align:center; background-color:#ccffcc;width:100%;">
        <b>Juniors Competition<br /></b>
        <br />
        <table style="width:100%">
            <tr>
                <td style="text-align:left; vertical-align:top;width:75%">
                    <asp:Literal ID="juniorContentLiteral1" runat="server"></asp:Literal>
                </td>
                <td style="vertical-align:top; text-align:left;width:25%;">
                    <table style="text-align:left;border:solid;border-width:1px;">
                        <tr>
                            <td><b>Entrants&nbsp;and&nbsp;Tables</b></td>
                        </tr>
                        <tr><td><asp:GridView ID="Table1_GridView" runat="server"></asp:GridView></td></tr>
                        <tr><td><asp:GridView ID="Table2_GridView" runat="server"></asp:GridView></td></tr>
                        <tr><td><asp:GridView ID="Table3_GridView" runat="server"></asp:GridView></td></tr>
                        <tr><td><asp:GridView ID="Table4_GridView" runat="server"></asp:GridView></td></tr>
                    </table>
                </td>
            </tr>
        </table>

        <hr />
        
        <h3>Results</h3>
        <table style="width:100%">
            <tr><td><b>Division&nbsp;1</b></td></tr>
            <tr><td style="text-align:center"><asp:GridView ID="Results1_Gridview" runat="server"></asp:GridView></td></tr>
            <tr id="Div2Head" runat="server"><td><b>Division&nbsp;2</b></td></tr>
            <tr><td style="text-align:center"><asp:GridView ID="Results2_Gridview" runat="server"></asp:GridView></td></tr>
            <tr id="Div3Head" runat="server"><td><b>Division&nbsp;3</b></td></tr>
            <tr><td style="text-align:center"><asp:GridView ID="Results3_Gridview" runat="server"></asp:GridView></td></tr>
            <tr id="Div4Head" runat="server"><td><b>Division&nbsp;4</b></td></tr>
            <tr><td style="text-align:center"><asp:GridView ID="Results4_Gridview" runat="server"></asp:GridView></td></tr>
        </table>
    </div>

</asp:Content>
