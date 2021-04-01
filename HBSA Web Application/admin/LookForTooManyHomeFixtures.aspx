<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/admin/adminMasterPage.master" CodeBehind="LookForTooManyHomeFixtures.aspx.vb" Inherits="HBSA_Web_Application.LookForTooManyHomeFixtures" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="text-align:left; width:100%">
        <h3>Look for too many home fixtures</h3>


        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
    
            <div style="text-align:left; width:100%">
 
                <table style="text-align:left" >
                    <tr>
                        <td style="text-align:right">Select a league:</td>
                        <td>
                            <asp:DropDownList ID="League_DropDownList" runat="server" BackColor="#FFFFCC" AutoPostBack="True" />
                        </td>
                    </tr>
                </table>
                                
           </div>
           <br />
                    <asp:GridView ID="HomeFixtures_GridView" runat="server"  
                        EnableModelValidation="True" Font-Size="9pt" BackColor="White" BorderColor="Black" 
                        BorderStyle="Solid" BorderWidth="1px" CellPadding="3"
                        AllowSorting="True" EmptyDataText="There are no home fixtures for which there are too many teams.">
                        <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                        <RowStyle Height="18px" BackColor="#E7E7FF" ForeColor="#000044" />
                        <AlternatingRowStyle Height="18px" BackColor="#F7F7F7" />
                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                    </asp:GridView>

            </ContentTemplate>
        </asp:UpdatePanel>

    </div>

</asp:Content>
